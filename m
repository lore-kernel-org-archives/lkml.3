Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab3HKRYp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 13:24:45 -0400
Received: from charon.rus.uni-stuttgart.de ([129.69.1.54]:46420 "EHLO
	charon.rus.uni-stuttgart.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754258Ab3HKRYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 13:24:43 -0400
Message-ID: <5207C8D4.1040609@rus.uni-stuttgart.de>
Date: Sun, 11 Aug 2013 19:24:36 +0200
From: Thomas Richter <richter@rus.uni-stuttgart.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: linux-kernel@vger.kernel.org, Josep Lladonosa <jlladono@gmail.com>,
        dahinds@users.sourceforge.net, linux-pcmcia@lists.infradead.org
Subject: [PCMCIA] Solved: No USB 2.0 (ehci) in PCMCIA slot on E7110
References: <Pine.LNX.4.44L0.1308102140420.10834-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1308102140420.10834-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Alan, Josep, David, dear PCMCIA maintainers,

this is on followup of a hang I reported earlier when using a delock 
(NEC-based) PCMCIA card in a O2Micro slot of an oldish E7110 Fujitsu 
laptop. The phenomenon is that read accesses through the ehci interface 
of the USB host adapter are unreliable, and write accesses are outright 
impossible and create hangs and bad data being transmitted. The 
miscommunication on the USB port is so bad that it erased the super 
block of an external hard drive I have, thus causing loss of files on 
this drive. BUMMER!

While I searched for a long time in the usb subsystem, I found that this 
is actually innocent of the hang, and the trouble is rather in the 
pcmcia system.

The error was introduced in kernel 2.6.32, 2.6.31 worked fine. After a 
lot of bisection work, I finally found the source of the error.
The trouble is in drivers/pcmcia/o2micro.h, line 137 as of the linux 
3.10.5 kernel. It's likely in the close vicinity for the current 
development kernel:

		case PCI_DEVICE_ID_O2_6729:
		case PCI_DEVICE_ID_O2_6730:
		case PCI_DEVICE_ID_O2_6812:
		case PCI_DEVICE_ID_O2_6832:
		case PCI_DEVICE_ID_O2_6836:
		case PCI_DEVICE_ID_O2_6933: /* <--- this one! */
			use_speedup = false;
			break;

This line disables read prefetch and write bursting of the O2 pcmcia 
bridge chip found in this laptop, thus pcmcia communication is then 
entirely CPU-based, and simply too slow to generate signals to be 
conforming to the ehci protocol. ohci (USB 1.0) works. Note that this is 
only a 1.7Ghz Pentium-4-M dinosaur.

I understand the care necessary to disable this for some broken 
machines, but on the other hand on my machine write bursting does work, 
apparently, and *not* enabling it broke the communications so badly that 
it harmed data integrity on an external disk.

Thus, unconditionally disabling write bursts on the mentioned O2 bridge 
is not the right action. Probably the bridge should allow users of this 
bridge to query which speeds are available, and either disable the 
higher speed protocols like ehci, or include some kind of yet to be 
determined test that would allow to check whether the chip *is* actually 
broken. As said, it isn't here.

As a shorter time resolution, I would recommend to expose this as a 
configuration item in the kernel configuration dialog so I could build 
my kernel in the correct way, without running into the risk of ruining
data on external devices. (-;

For your information, this is the lspci output of the (un-)affected O2 card:
02:0a.0 CardBus bridge: O2 Micro, Inc. OZ6933/711E1 CardBus/SmartCardBus 
Controller (rev 02)
02:0a.1 CardBus bridge: O2 Micro, Inc. OZ6933/711E1 CardBus/SmartCardBus 
Controller (rev 02)

or numeric:

02:0a.0 0607: 1217:6933 (rev 02)
02:0a.1 0607: 1217:6933 (rev 02)

What is also probably helpful is the output of dmidecode to identify the 
product:

Handle 0x0001, DMI type 1, 25 bytes
System Information
         Manufacturer: FUJITSU SIEMENS
         Product Name: LIFEBOOK E Series
         Version:
         Serial Number: YBSN003702
         UUID: D1552D78-AB36-11D6-8B14-00E000AE4E45
         Wake-up Type: Power Switch

Handle 0x0002, DMI type 2, 8 bytes
Base Board Information
         Manufacturer: FUJITSU
         Product Name: FJNB15C
         Version:
         Serial Number:

Handle 0x0021, DMI type 9, 13 bytes
System Slot Information
         Designation: CardBus-1
         Type: 32-bit PC Card (PCMCIA)
         Current Usage: Unknown
         Length: Other
         ID: Adapter 0, Socket 0
         Characteristics:
                 5.0 V is provided
                 3.3 V is provided
                 PC Card-16 is supported
                 Cardbus is supported
                 Modem ring resume is supported
                 PME signal is supported

Handle 0x0022, DMI type 9, 13 bytes
System Slot Information
         Designation: CardBus-2
         Type: 32-bit PC Card (PCMCIA)
         Current Usage: Unknown
         Length: Other
         ID: Adapter 1, Socket 0
         Characteristics:
                 5.0 V is provided
                 3.3 V is provided
                 PC Card-16 is supported
                 Cardbus is supported
                 Modem ring resume is supported
                 PME signal is supported

(yes, there are two pcmcia slots here)

Maybe that helps as an identification, too, before turning 
write-bursting off.

Thanks, and please let me know if I can be of any further help to 
resolve the problem. It's currently successfully patched away for my 
kernel, but that's not a good solution.

Greetings,
	Thomas
