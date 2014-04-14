Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbaDNVsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:48:24 -0400
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:36953 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339AbaDNVsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:48:21 -0400
Date: Mon, 14 Apr 2014 18:48:07 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: stefani@seibold.net
Cc: Benjamin Herrenschmidt <benh@au1.ibm.com>,
        linux-usb <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
        sarah.a.sharp@linux.intel.com
Subject: Re: Missing USB XHCI and EHCI reset for kexec
Message-ID: <20140414214807.GA32141@oc0268524204.ibm.com>
References: <1397416959.1555.30.camel@vger.seibold.net>
 <1397468521.9258.28.camel@pasglop>
 <20140414174458.Horde.ieyRX8PcZ0lg3nY1QFE2DA4@webmail.your-server.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140414174458.Horde.ieyRX8PcZ0lg3nY1QFE2DA4@webmail.your-server.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041421-1820-0000-0000-00000058CB72
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 05:44:58PM +0200, stefani@seibold.net wrote:
> 
> Zitat von Benjamin Herrenschmidt <benh@au1.ibm.com>:
> 
> >On Sun, 2014-04-13 at 21:22 +0200, Stefani Seibold wrote:
> >>When executing a kexec kernel on a PowerPC board the new started kernel
> >>will not find already enumerated USB devices due a missing reset on the
> >>USB bus.
> >>
> >>As a work around a
> >>
> >>echo 1 >/sys/bus/pci/drivers/[ex]hci-pci/BUS-ADDRESS-OF-THE-HCD/reset
> >>
> >>will solve this. But this is far from beauty.
> >>
> >>My latest kernel without this issue was for EHCI kernel 2.6.39 and for
> >>XHCI kernel 3.4, but i have no idea when exactly this behavior was
> >>introduced.
> >>
> >>For X86 all is fine.
> >
> >I don't know about EHCI specifically but this is a known issue with
> >XHCI, I observe similar issues on other powerpc platforms (servers)
> >and this isn't architecture specific (looks more like actualy xhc
> >implementation specific).
> >
> >Thadeu Cascardo (on CC) has been the one investigating that on our side,
> >he might have more to add including patches.
> >
> 
> I have now a kernel 3.14 dmesg log of the problem. After a kexec the
> kexeced 3.14 kernel shows:
> 
> [    1.170029] xhci_hcd 0001:03:00.0: xHCI Host Controller
> [    1.175306] xhci_hcd 0001:03:00.0: new USB bus registered,
> assigned bus number 1
> [    1.212561] xhci_hcd 0001:03:00.0: Host not halted after 16000
> microseconds.
> [    1.219621] xhci_hcd 0001:03:00.0: can't setup: -110
> [    1.224597] xhci_hcd 0001:03:00.0: USB bus 1 deregistered
> [    1.230021] xhci_hcd 0001:03:00.0: init 0001:03:00.0 fail, -110
> [    1.235955] xhci_hcd: probe of 0001:03:00.0 failed with error -110
> 
> Any idea?
> 
> - Stefani
> 
> 

What is your controller vendor and device IDs? Is that a TI chip?

Can you check if the patch I sent a month ago fixes it? [1] There's the
whole story there. In fact, you will also need something like the patch
below. Can you apply only the first one, verify, and, then, the other
one as well, and report what worked for you?

[1] http://marc.info/?l=linux-usb&m=139483181809062&w=2

Thanks.
Cascardo.
---
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 47390e3..232574f 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -392,7 +392,7 @@ static struct pci_driver xhci_pci_driver = {
 	.remove =	xhci_pci_remove,
 	/* suspend and resume implemented later */
 
-	.shutdown = 	usb_hcd_pci_shutdown,
+	.shutdown =	xhci_pci_remove,
 #ifdef CONFIG_PM
 	.driver = {
 		.pm = &usb_hcd_pci_pm_ops

