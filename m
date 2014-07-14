Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbaGNRje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:39:34 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:44860 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756358AbaGNRj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:39:26 -0400
Date: Mon, 14 Jul 2014 13:39:19 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Subject: Re: [PATCH v5] Fixes to Xen pciback for 3.17.
Message-ID: <20140714173919.GC12920@laptop.dumpdata.com>
References: <1405354736-7358-1-git-send-email-konrad.wilk@oracle.com>
 <20140714174042.GB6166@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140714174042.GB6166@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 10:40:42AM -0700, Greg KH wrote:
> On Mon, Jul 14, 2014 at 12:18:50PM -0400, Konrad Rzeszutek Wilk wrote:
> > Greg: goto GHK
> > 
> > This is v5 version of patches to fix some issues in Xen PCIback.
> > 
> > One of the issues Xen PCI back has that patch:
> > 
> > is fixing is that a deadlock can happen if the PCI device is
> > assigned to a guest and we try to 'unbind' it from Xen 'pciback' driver.
> > The issue is rather simple - the SysFS mechanism for the 'unbind' path
> > takes a device lock and the code in Xen PCI uses the pci_reset_function
> > which also takes the same lock. Solution is to use the lock-less version
> > and mandate that callers of said function in Xen pciback take the lock.
> > Easy enough.
> > 
> > GHK:
> > To guard against this happening in the future we also add an assert in the
> > form of lockdep assertion. That is OK except that it looks ugly as we take
> > it straight from the 'struct device' instead of using an appropriate macro.
> > See:
> > 
> > +       lockdep_assert_held(&dev->dev.mutex);
> > 
> > (in [PATCH v5 2/6] xen/pciback: Don't deadlock when unbinding).
> > 
> > The patch: [PATCH v5 3/6] driver core: Provide an wrapper around the mutex
> > to do.
> > 
> > introduces a nice wrapper so it is bit cleaner. Greg, if you are OK with
> > it could you kindly Ack it as I would prefer to put this patchset
> > via the Xen tree. It would look now as:
> > 
> > -       lockdep_assert_held(&dev->dev.mutex);
> > +       device_lock_assert(&dev->dev);
> > 
> > I can also squash it in "[PATCH v5 2/6] xen/pciback: Don't deadlock when
> >  unbinding." but since that one is going through the stable tree I wasn't
> > sure whether you (Greg KH) would be OK with that.
> 
> You have my ack now, and feel free to squash it into patch 2/6 if you
> want, I don't mind having that in the stable trees.

Fantastic! Thank you.
> 
> thanks,
> 
> greg k-h
