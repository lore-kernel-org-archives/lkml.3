Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbaDOMUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:20:41 -0400
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:59227 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbaDOMUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:20:39 -0400
Date: Tue, 15 Apr 2014 09:20:14 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: stefani@seibold.net
Cc: Benjamin Herrenschmidt <benh@au1.ibm.com>,
        linux-usb <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
        sarah.a.sharp@linux.intel.com
Subject: Re: Missing USB XHCI and EHCI reset for kexec
Message-ID: <20140415122013.GA21101@oc0268524204.ibm.com>
References: <1397416959.1555.30.camel@vger.seibold.net>
 <1397468521.9258.28.camel@pasglop>
 <20140414174458.Horde.ieyRX8PcZ0lg3nY1QFE2DA4@webmail.your-server.de>
 <20140414214807.GA32141@oc0268524204.ibm.com>
 <20140415120417.Horde.2gdC8Woe64OQXOq_cVqtkg6@webmail.your-server.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140415120417.Horde.2gdC8Woe64OQXOq_cVqtkg6@webmail.your-server.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041512-9564-0000-0000-000000967446
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 12:04:17PM +0200, stefani@seibold.net wrote:
> 
> Zitat von Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>:
> 
> >On Mon, Apr 14, 2014 at 05:44:58PM +0200, stefani@seibold.net wrote:
> >>
> >>Zitat von Benjamin Herrenschmidt <benh@au1.ibm.com>:
> >>
> >>>I don't know about EHCI specifically but this is a known issue with
> >>>XHCI, I observe similar issues on other powerpc platforms (servers)
> >>>and this isn't architecture specific (looks more like actualy xhc
> >>>implementation specific).
> >>>
> >>>Thadeu Cascardo (on CC) has been the one investigating that on our side,
> >>>he might have more to add including patches.
> >>>
> >>
> >>I have now a kernel 3.14 dmesg log of the problem. After a kexec the
> >>kexeced 3.14 kernel shows:
> >>
> >>[    1.170029] xhci_hcd 0001:03:00.0: xHCI Host Controller
> >>[    1.175306] xhci_hcd 0001:03:00.0: new USB bus registered,
> >>assigned bus number 1
> >>[    1.212561] xhci_hcd 0001:03:00.0: Host not halted after 16000
> >>microseconds.
> >>[    1.219621] xhci_hcd 0001:03:00.0: can't setup: -110
> >>[    1.224597] xhci_hcd 0001:03:00.0: USB bus 1 deregistered
> >>[    1.230021] xhci_hcd 0001:03:00.0: init 0001:03:00.0 fail, -110
> >>[    1.235955] xhci_hcd: probe of 0001:03:00.0 failed with error -110
> >>
> >
> >What is your controller vendor and device IDs? Is that a TI chip?
> >
> 
> Yes it is a TI chip, vendor ID 104c and product ID 8241.
> 
> >Can you check if the patch I sent a month ago fixes it? [1] There's the
> >whole story there. In fact, you will also need something like the patch
> >below. Can you apply only the first one, verify, and, then, the other
> >one as well, and report what worked for you?
> >
> >[1] http://marc.info/?l=linux-usb&m=139483181809062&w=2
> >
> 
> I tried the attach patch and it did not help. This is what i
> expected because this is a fix in the shutdown path, which will
> never called when doing a forced kexec.

Hi, Stefani.

Did you try with both patches applied? How do you evoke the forced
kexec? Is that a kexec on panic? Does it really need to be forced? With
no clean shutdown, platform and drivers would need to issue resets, like
you mentioned below, to get the system into a clean state.

> 
> I have a running a 3.10.23 kernel. This kernel do a kexec for a
> kernel 3.14. Since the kernel 3.10.23 did not performe a clean
> shutdown, the state of the XHCI Controller is undefined. So when

And the clean shutdown requires both of my patches, for TI chips, as far
as I know. It looks like the problem is issuing a halt when there are
pending URBs.

> kernel 3.14 will probe XHCI it will find a XHCI controller which was
> not performed a reset.
> 

The problem is not that a reset hasn't been issued. A PCI function reset
should fix most of the problems with a bad device state, when the reset
works. However, the problem is that it was not cleanly shut down. URBs
should have been canceled and removed from the controller queue, and it
should have halted after that.

> So i think it is necessary to reset the XHCI controller and all
> devices on this bus. This is what i do with a "echo 1
> >/sys/bus/pci/drivers/xhci_hcd/0001:03:00.0/reset" before the kexec.
> 

One way to look at that is making the PCI code issue resets to all buses
before doing any other access. That will make booting more slow, and
there are a lot of other corner cases where this might not be enough.
It's probably more sane to try to get the 3.10.23 kernel to do a clean
shutdown, if possible.

Regards.
Cascardo.

> - Stefani
> 
> 

