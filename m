Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537Ab3D1VH1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 17:07:27 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:36431 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab3D1VHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 17:07:25 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 28 Apr 2013 23:07:09 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] firewire: Fix 'failed to read phy reg' on FW643 rev8
Message-ID: <20130428230709.39a3ca06@stein>
In-Reply-To: <1364307560-27601-1-git-send-email-peter@hurleysoftware.com>
References: <1364306830.12229.14.camel@thor.lan>
 <1364307560-27601-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 26 Peter Hurley wrote:
> --- a/drivers/firewire/ohci.c
> +++ b/drivers/firewire/ohci.c
> @@ -2268,8 +2268,8 @@ static int ohci_enable(struct fw_card *card,
>  		  OHCI1394_HCControl_postedWriteEnable);
>  	flush_writes(ohci);
>  
> -	for (lps = 0, i = 0; !lps && i < 3; i++) {
> -		msleep(50);
> +	for (lps = 0, i = 0; !lps && i < 150; i++) {
> +		msleep(1);
>  		lps = reg_read(ohci, OHCI1394_HCControlSet) &
>  		      OHCI1394_HCControl_LPS;
>  	}

Unfortunately, this introduced a regression with a CardBus card based on TI
TSB82AA2 [104c:8025] (rev 01) + TSB81BA3(A) [080028:831304]... actually
two cards from different brands with PCI subsystem IDs [9710:6500] and
[104c:8025] respectively, but probably same hardware under the covers.

Apr 28 20:49:43 stein kernel: pcmcia_socket pcmcia_socket0: pccard: CardBus card inserted into slot 0
Apr 28 20:49:43 stein kernel: pci 0000:0d:00.0: [104c:8025] type 00 class 0x0c0010
Apr 28 20:49:43 stein kernel: pci 0000:0d:00.0: reg 10: [mem 0x00000000-0x000007ff]
Apr 28 20:49:43 stein kernel: pci 0000:0d:00.0: reg 14: [mem 0x00000000-0x00003fff]
Apr 28 20:49:43 stein kernel: pci 0000:0d:00.0: supports D1 D2
Apr 28 20:49:43 stein kernel: pci 0000:0d:00.0: PME# supported from D0 D1 D2 D3hot
Apr 28 20:49:43 stein kernel: pci 0000:0d:00.0: BAR 1: assigned [mem 0xfb800000-0xfb803fff]
Apr 28 20:49:43 stein kernel: pci 0000:0d:00.0: BAR 0: assigned [mem 0xfb804000-0xfb8047ff]
Apr 28 20:49:43 stein kernel: firewire_ohci 0000:0d:00.0: enabling device (0000 -> 0002)
Apr 28 20:49:43 stein kernel: firewire_ohci 0000:0d:00.0: setting latency timer to 64
Apr 28 20:49:43 stein kernel: firewire_ohci 0000:0d:00.0: failed to read phy reg
Apr 28 20:49:43 stein kernel: firewire_ohci: probe of 0000:0d:00.0 failed with error -16

The same with your patch for more verbose logging:

Apr 28 19:01:59 stein kernel: pcmcia_socket pcmcia_socket0: pccard: CardBus card inserted into slot 0
Apr 28 19:01:59 stein kernel: pci 0000:0d:00.0: [104c:8025] type 00 class 0x0c0010
Apr 28 19:01:59 stein kernel: pci 0000:0d:00.0: reg 10: [mem 0x00000000-0x000007ff]
Apr 28 19:01:59 stein kernel: pci 0000:0d:00.0: reg 14: [mem 0x00000000-0x00003fff]
Apr 28 19:01:59 stein kernel: pci 0000:0d:00.0: reg 18: [mem 0x00000000-0x000007ff]
Apr 28 19:01:59 stein kernel: pci 0000:0d:00.0: supports D1 D2
Apr 28 19:01:59 stein kernel: pci 0000:0d:00.0: PME# supported from D0 D1 D2 D3hot
Apr 28 19:01:59 stein kernel: pci 0000:0d:00.0: BAR 1: assigned [mem 0xfb800000-0xfb803fff]
Apr 28 19:01:59 stein kernel: pci 0000:0d:00.0: BAR 0: assigned [mem 0xfb804000-0xfb8047ff]
Apr 28 19:01:59 stein kernel: pci 0000:0d:00.0: BAR 2: assigned [mem 0xfb804800-0xfb804fff]
Apr 28 19:01:59 stein kernel: firewire_ohci 0000:0d:00.0: enabling device (0000 -> 0002)
Apr 28 19:01:59 stein kernel: firewire_ohci 0000:0d:00.0: setting latency timer to 64
Apr 28 19:01:59 stein kernel: firewire_ohci 0000:0d:00.0: failed to read phy reg 2
Apr 28 19:01:59 stein kernel: Pid: 1117, comm: pccardd Not tainted 3.8.0-rc7 #3
Apr 28 19:01:59 stein kernel: Call Trace:
Apr 28 19:01:59 stein kernel: [<ffffffffa0179e1d>] read_phy_reg+0x7b/0x90 [firewire_ohci]
Apr 28 19:01:59 stein kernel: [<ffffffffa0179fbb>] ohci_enable+0xb5/0x569 [firewire_ohci]
Apr 28 19:01:59 stein kernel: [<ffffffffa016993f>] fw_card_add+0x46/0x8d [firewire_core]
Apr 28 19:01:59 stein kernel: [<ffffffffa0178832>] pci_probe+0x556/0x6b7 [firewire_ohci]
Apr 28 19:01:59 stein kernel: [<ffffffff810fd14a>] ? sysfs_do_create_link+0x155/0x1a7
Apr 28 19:01:59 stein kernel: [<ffffffff81192cfe>] pci_device_probe+0x5a/0x8d
Apr 28 19:01:59 stein kernel: [<ffffffff81298418>] ? driver_sysfs_add+0x6b/0x91
Apr 28 19:01:59 stein kernel: [<ffffffff8129869a>] driver_probe_device+0xa5/0x1b3
Apr 28 19:01:59 stein kernel: [<ffffffff81298857>] __device_attach+0x35/0x3a
Apr 28 19:01:59 stein kernel: [<ffffffff81298822>] ? __driver_attach+0x7a/0x7a
Apr 28 19:01:59 stein kernel: [<ffffffff81296f5b>] bus_for_each_drv+0x51/0x87
Apr 28 19:01:59 stein kernel: [<ffffffff812985c3>] device_attach+0x72/0x88
Apr 28 19:01:59 stein kernel: [<ffffffff81297c4e>] bus_probe_device+0x2d/0x98
Apr 28 19:01:59 stein kernel: [<ffffffff81296505>] device_add+0x3d8/0x54d
Apr 28 19:01:59 stein kernel: [<ffffffff8118cc85>] pci_bus_add_device+0x32/0x58
Apr 28 19:01:59 stein kernel: [<ffffffff8118ce68>] pci_bus_add_devices+0x29/0xed
Apr 28 19:01:59 stein kernel: [<ffffffffa007a410>] cb_alloc+0xba/0xcaa [pcmcia_core]
Apr 28 19:01:59 stein kernel: [<ffffffffa0079a18>] socket_insert+0xa1/0xe5 [pcmcia_core]
Apr 28 19:01:59 stein kernel: [<ffffffffa0079c70>] pccardd+0x1a8/0x440 [pcmcia_core]
Apr 28 19:01:59 stein kernel: [<ffffffffa0079ac8>] ? pcmcia_get_socket+0x21/0x21 [pcmcia_core]
Apr 28 19:01:59 stein kernel: [<ffffffff8103f898>] kthread+0xb5/0xbd
Apr 28 19:01:59 stein kernel: [<ffffffff8103f7e3>] ? __kthread_parkme+0x67/0x67
Apr 28 19:01:59 stein kernel: [<ffffffff8138d8ac>] ret_from_fork+0x7c/0xb0
Apr 28 19:01:59 stein kernel: [<ffffffff8103f7e3>] ? __kthread_parkme+0x67/0x67
Apr 28 19:01:59 stein kernel: firewire_ohci: probe of 0000:0d:00.0 failed with error -16

At the moment, these two CardBus cards are my only ones with discrete phy.
All my other controllers have got an integrated link and phy.

I could try a PCI card with TSB82AA2 + TSB81BA3(A) in the next few days,
furthermore a PCI card with ALi M5271 + TI TSB41AB3 (which did not work
with firewire-ohci when I tried it last a long time ago,
https://bugzilla.kernel.org/show_bug.cgi?id=10935).

The following fixup worked for the said two CardBus cards during quite a
few tries...

--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -2268,8 +2268,11 @@ static int ohci_enable(struct fw_card *c
 		  OHCI1394_HCControl_postedWriteEnable);
 	flush_writes(ohci);
 
+	if (ohci->quirks & QUIRK_TI_SLLZ059)
+		usleep_range(4000, 4200);
+
 	for (lps = 0, i = 0; !lps && i < 150; i++) {
-		msleep(1);
+		usleep_range(1000, 1200);
 		lps = reg_read(ohci, OHCI1394_HCControlSet) &
 		      OHCI1394_HCControl_LPS;
 	}

...whereas usleep_range(3800, 4000) exhibited a notable percentage of
failures.  Even lower ranges let the failure occur more often or always.

However, when I rewrote the fixup to...

--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -2280,6 +2280,7 @@ static int ohci_enable(struct fw_card *c
 	}
 
 	if (ohci->quirks & QUIRK_TI_SLLZ059) {
+		msleep(10);
 		ret = probe_tsb41ba3d(ohci);
 		if (ret < 0)
 			return ret;

...I still got one failure among several successful tries.  So I
changed msleep(10) to msleep(50) and started a two tests to call it a
day but suddenly noticed that I got one /dev/fw* too few.  The reason
was that my onboard JMicron JMB381 [197b:2380] with internal phy
[001b8c:038100] had at one point started to fail with

Apr 28 22:05:17 stein kernel: firewire_ohci 0000:0a:00.0: failed to read phy reg
Apr 28 22:05:17 stein kernel: firewire_ohci: probe of 0000:0a:00.0 failed with error -16

too.  And unlike the TSB82AA2 cards, unloading firewire-ohci and
reloading a good version of firewire-ohci did not cure the JMB381;
I had to reboot in order to bring it back.

There is a small possibility that the reduction of sleep time before
the first phy reg access wasn't the real cause for the JMB381 to act up.
There is so much more which can upset this little POS.  However, this
failure started during a time when I had nothing connected to the JMB381
at all; I was only doing the unload/reload cycles with firewire-ohci in
order to debug the TSB82AA2 cards.

So I believe we should white-list the shorter wait after LPS write
only for Agere/LSI cards.  I will be replying with a respective patch
shortly.
-- 
Stefan Richter
-=====-===-= -=-- ===--
http://arcgraph.de/sr/
