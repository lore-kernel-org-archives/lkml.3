Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab3AKKjL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 05:39:11 -0500
Received: from bar.sig21.net ([80.81.252.164]:51089 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133Ab3AKKjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 05:39:09 -0500
X-Greylist: delayed 1408 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Jan 2013 05:39:09 EST
Message-ID: <50EFE644.3000904@linuxtv.org>
Date: Fri, 11 Jan 2013 11:15:32 +0100
From: Michael Hunold <hunold@linuxtv.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: andi@lisas.de, linux@rainbow-software.org, myxal.mxl@gmail.com,
        florian@mickler.org
Subject: Link state change detection problem on Moschip MCS7832 again
Content-Type: multipart/mixed;
 boundary="------------040105030907090707080009"
X-Spam-21-Score: -2.9 (--)
X-Spam-21-Report: No, score=-2.9 required=8.0 tests=ALL_TRUSTED=-1,BAYES_00=-1.9 autolearn=ham
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040105030907090707080009
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I have a no-name Moschip MCS7832-based adapter shows a strange behaviour 
in my system after a system upgrade. "lsusb -vv" for that device is 
attached to the end of the mail.

I am using the adapter for embedded systems development, where it serves 
kernels via TFTP and root filesystems via NFS.

I have recently upgrade my system to Kubuntu 12.10 which uses a 3.5.0-21 
kernel. Before that upgrade the device was working fine with Xubuntu 10.10.

I have used the network-manager applet that comes with Kubuntu to assign 
a static IP address to that interface.

The symptom is that when the remote system's bootloader (u-boot in my 
case) starts to fetch the kernel via TFTP, it usually starts fine (a 
couple of "#" are shown to indicate progress), then timeouts are 
happening ("T" is shown), then progress continues, then more timeouts 
and so on.

I can see the following messages getting repeated in /var/log/syslog:

[...]
Jan 11 11:01:04 elmc-teemhu NetworkManager[1250]: <info> (eth1): carrier 
now OFF (device state 100, deferring action for 4 seconds)
Jan 11 11:01:04 elmc-teemhu NetworkManager[1250]: <info> (eth1): carrier 
now ON (device state 100)
[...]

I found the following bug report and this got me going:
https://bugzilla.kernel.org/show_bug.cgi?id=28532

Here is what I investigated so far.

1. I noticed that the patch dabdaf0caa3af520dbc1df87b2fb4e77224037bd 
from Ondrej Zary is missing in the kernel Kubuntu is serving, so I 
downloaded the most-recent mcs7830.c from kernel.org and recompiled the 
module. The problem stays the same, there is no improvement.

2. I undid both commits dabdaf0caa3af520dbc1df87b2fb4e77224037bd and 
b1ff4f96fd1c63890d78d8939c6e0f2b44ce3113 which added the "mcs7830: 
Implement link state detection" in the first place. Without that 
"feature" my adapter is now working reliably again.

3. Commit dabdaf0caa3af520dbc1df87b2fb4e77224037bd had the following 
comment:

"The device had an undocumented "feature": it can provide a sequence of
spurious link-down status data even if the link is up all the time.
A sequence of 10 was seen so update the link state only after the device
reports the same link state 20 times."

I tried to increase the number from 20 gradually, but it did not help to 
fix the problem. In my desparation I tried 100 as well, but this only 
postponed the

4. In my desparation, I went back to the most recent driver and added 
the following code to mcs7830_status() in order to track after how many 
calls to that function the link state changes.

[...]
{
	static int xxx_counter = 0;
	static int xxx_link = -1;
	if (link != xxx_link) {
		printk("counter %4d -> link %d\n", xxx_counter, link);
		xxx_link = link;
		xxx_counter = 0;
	} else {
		xxx_counter++;
	}
}
[...]

This resulted in the following output:

Jan 11 11:01:04 elmc-teemhu kernel: [11627.025109] counter  105 -> link 0
Jan 11 11:01:04 elmc-teemhu kernel: [11627.101840] counter   76 -> link 1
Jan 11 11:01:04 elmc-teemhu kernel: [11627.207724] counter  105 -> link 0
Jan 11 11:01:04 elmc-teemhu kernel: [11627.285582] counter   77 -> link 1
Jan 11 11:01:04 elmc-teemhu kernel: [11627.392416] counter  106 -> link 0
Jan 11 11:01:04 elmc-teemhu kernel: [11627.468149] counter   75 -> link 1
Jan 11 11:01:04 elmc-teemhu kernel: [11627.574036] counter  105 -> link 0
Jan 11 11:01:04 elmc-teemhu kernel: [11627.651893] counter   77 -> link 1
Jan 11 11:01:04 elmc-teemhu kernel: [11627.757719] counter  105 -> link 0
Jan 11 11:01:04 elmc-teemhu NetworkManager[1250]: <info> (eth1): carrier 
now OFF (device state 100, deferring action for 4 seconds)
Jan 11 11:01:04 elmc-teemhu kernel: [11627.834546] counter   76 -> link 1
Jan 11 11:01:04 elmc-teemhu NetworkManager[1250]: <info> (eth1): carrier 
now ON (device state 100)
Jan 11 11:01:05 elmc-teemhu kernel: [11627.939259] counter  104 -> link 0
Jan 11 11:01:05 elmc-teemhu kernel: [11628.018204] counter   78 -> link 1

So it seems the link state is constantly toggling and the network 
manager eventually picks that up and does some reconfiguratation to the 
network interface which disturbs both TFTP and NFS.

As I already said above, when I undo both commits then everything is 
working fine again. Network manager is not complaining any more and TFTP 
and NFS is working fine.

Any idea what is wrong with that adapter? Is it unable to report link 
state changes correctly at all?

How to make the current driver work correctly without reverting the two 
commit completly?

Best regards
Michael.

--------------040105030907090707080009
Content-Type: text/plain; charset=UTF-8;
 name="lsusb-vv-moschip.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lsusb-vv-moschip.txt"

Bus 003 Device 016: ID 9710:7830 MosChip Semiconductor MCS7830 10/100 Mbps Ethernet adapter
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          255 Vendor Specific Class
  bDeviceSubClass         0 
  bDeviceProtocol       255 
  bMaxPacketSize0        64
  idVendor           0x9710 MosChip Semiconductor
  idProduct          0x7830 MCS7830 10/100 Mbps Ethernet adapter
  bcdDevice            1.00
  iManufacturer           1 Moschip Semiconductor
  iProduct                2 USB-MAC Controller   
  iSerial                 3 3b000021
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           39
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol    255 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval             255
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval             255
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0010  1x 16 bytes
        bInterval               1
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass          255 Vendor Specific Class
  bDeviceSubClass         0 
  bDeviceProtocol       255 
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

--------------040105030907090707080009--
