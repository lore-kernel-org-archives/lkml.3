Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab3EXOtI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 10:49:08 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.145]:6885 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751337Ab3EXOtH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 10:49:07 -0400
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 May 2013 10:49:06 EDT
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-15.tower-180.messagelabs.com!1369406567!26826270!1
X-Originating-IP: [83.171.138.125]
X-StarScan-Received: 
X-StarScan-Version: 6.9.6; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Fri, 24 May 2013 16:42:48 +0200
From: "Thumshirn, Johannes Tobias" <Johannes.Thumshirn@men.de>
To: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Freescale P1022 SoC hangs when initializing USB
Thread-Topic: Freescale P1022 SoC hangs when initializing USB
Thread-Index: Ac5Yiav6I+2AGvzgSC60Xd9zUMXBtA==
Date: Fri, 24 May 2013 14:42:46 +0000
Message-ID: <42A09AAC7DAAF64ABE4E4C1AD5F5E295094C5B5F@MEN-EX1.intra.men.de>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.6.58]
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 24 May 2013 14:42:47.0424 (UTC) FILETIME=[F549C000:01CE588C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

I'm experiencing problems while booting on a Freescale P1013 based board. It hangs on USB initialization:
[    3.763584] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.770519] ehci-pci: EHCI PCI platform driver
[    3.775116] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.781972] fsl-ehci fsl-ehci.0: Freescale On-Chip EHCI Host Controller
[    3.788812] fsl-ehci fsl-ehci.0: new USB bus registered, assigned bus number 1

The corresponding device-tree:
usb@22000 {
                     #address-cells = <1>;
                     #size-cells = <0>;
                     compatible = "fsl-usb2-dr";
                     reg = <0x22000 0x1000>;
                     interrupt-parent = <&mpic>;
                     interrupts = <28 0x2 0 0>;
                     phy_type = "ulpi";
};

usb@23000 {
                      #address-cells = <1>;
                      #size-cells = <0>;
                      compatible = "fsl-usb2-dr";
                      reg = <0x23000 0x1000>;
                      interrupt-parent = <&mpic>;
                      interrupts = <46 0x2 0 0>;
                      phy_type = "ulpi";
};

It also seems I'm not the only one having this problem: 
https://lists.ozlabs.org/pipermail/linuxppc-dev/2013-January/103344.html
though my configuration uses ULPI instead of UTMI mode and a warm reset doesn't
get it up as well.

I can verify that the 1st write to ehci->regs->port_status[0] in ehci_fsl_setup_phy()
causes the hang and the P1022 Datasheet  states:
"A write to registers in the USB controller memory map may cause the
system to hang if PORTSC[PHCD]=0 when no USB PHY clock is applied."
- (Ch. 18.2 - p. 1098).
Setting PORTSC[PHCD]=1 solves the hang for exactly one write.
I can verify it on 3.4.18 as well as on 3.10-rc2.

A hardware problem can be eliminated as U-Boot and VxWorks have no trouble initializing the EHCI.
Does anyone have similar problems or a solution to this?

Copying U-Boot's PHY initialization routine to enable the ULPI clock did not get it up either.

Thanks in advance,
Johannes
