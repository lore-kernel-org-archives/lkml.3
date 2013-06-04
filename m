Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab3FDPi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 11:38:57 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56073 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813Ab3FDPiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 11:38:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC 2/2] USB: host: make USB_ARCH_HAS_?HCI obsolete
Date: Tue, 04 Jun 2013 17:38:45 +0200
Message-ID: <1624672.VBbVgzJXAH@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1306041107520.1093-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1306041107520.1093-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:sk4sGel3w8iC91DDWuQJ9a7q2mSThl32TnubuTmiBJV
 f9pMT+z3cgxMmtacd60oqrJKQUzSMUNxE68oWt0d2AI5NCb/lW
 ReqQiyB/bSezJ1ppnL/8ahwtG+zR4ytNcb+5a3IFads+3lHykt
 iaHO3MtWMpB0r6b43/Sq8tHsZ4KRFuDdbVoAY0tpFswT7npOLG
 /4UPXyaBpqTmPmKw7LCwgMq06KjasKxTSAbbly8ouM2rCpbVI7
 A40VrsU84tqXJVH7hPb5weX3609P1oMYTkXVBeg8LHau4sj/JA
 2MK8wacQhfL2z+a2C69S9SY4N3RKn+jl6IJB+LK1rQ7oO2yDm/
 S9ysHc+2qpfqKIBMOjYI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 June 2013 11:22:01 Alan Stern wrote:
> 
> Instead of doing this, it makes more sense to enable USB_ARCH_HAS_HCD
> whenever host-side USB is enabled.  In other words,
> 
>         def_bool USB

The problem with this is that a lot of drivers (24 to be exact) are defined
like

config INPUT_ATI_REMOTE2
        tristate "ATI / Philips USB RF remote control"
        depends on USB_ARCH_HAS_HCD
        select USB

so that would create a circular dependency unless we change all of them
at once. I did that when creating this patch, but then decided to
revert it for now and do smaller steps.

We could do

config USB_ARCH_HAS_HCD
	def_bool USB_SUPPORT

or

config USB_ARCH_HAS_HCD
	def_bool y

which would both have the exact same behavior as 'def_bool HAS_IOMEM'.
 
> The HAS_IOMEM won't matter, because USB is defined only when 
> USB_SUPPORT is enabled, and USB_SUPPORT already depends on HAS_IOMEM.

Right.

> Of course, it will then be necessary to remove the dependency on 
> USB_ARCH_HAS_HCD from the "config USB" entry.  Which is exactly what 
> you're trying to accomplish, anyway.

That dependency is redundant already, and should certainly be
removed now.

> > diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
> > index e060ecf..045f9d27 100644
> > --- a/drivers/usb/host/Kconfig
> > +++ b/drivers/usb/host/Kconfig
> > @@ -17,7 +17,7 @@ config USB_C67X00_HCD
> >  
> >  config USB_XHCI_HCD
> >       tristate "xHCI HCD (USB 3.0) support"
> > -     depends on USB_ARCH_HAS_XHCI
> > +     depends on PCI
> 
> You probably don't want to add this dependency.  After all, one of the
> comments removed above points out that there are non-PCI xHCI
> controllers.

Yes, that was a mistake. I noticed this myself but forgot to edit
the file again.

	Arnd
