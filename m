Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbbAPIce (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 03:32:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747AbbAPIcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 03:32:33 -0500
Message-ID: <1421397146.21318.16.camel@nilsson.home.kraxel.org>
Subject: Re: [PATCH v3 00/16] virtio-pci: towards virtio 1.0 guest support
From: Gerd Hoffmann <kraxel@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Date: Fri, 16 Jan 2015 09:32:26 +0100
In-Reply-To: <20150115213256.GA4813@redhat.com>
References: <1421256142-11512-1-git-send-email-mst@redhat.com>
	 <1421356698.3933.18.camel@nilsson.home.kraxel.org>
	 <20150115213256.GA4813@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

> >  * I'd like to see some more flexibility in the pci bar layout.  Stuff
> >    I have in mind:
> >     - New devices which don't need a legacy bar can use bar 0 for
> >       modern.
> >     - One MMIO bar is enough, we can place both virtio regions and
> >       msi-x regions there.  I'd suggest to add msi-x sub-regions to
> >       the modern bar.
> 
> Why exactly? It seems simpler to separate things, extra BARs
> have no cost.

Well, there are only six BARs.  legacy bar, modern mmio bar, msi-x bar,
modern io bar (for fast isr).  That already four out of six ...

We have a mmio bar, which we partition into subregions for virtio-1.0
anyway.  Also placing msi-x there is a single msix_init() call.  xhci is
doing that too:

    00000000febf0000-00000000febf3fff (prio 1, RW): xhci
      00000000febf0000-00000000febf003f (prio 0, RW): capabilities
      00000000febf0040-00000000febf043f (prio 0, RW): operational
      00000000febf0440-00000000febf044f (prio 0, RW): usb3 port #1
      00000000febf0450-00000000febf045f (prio 0, RW): usb3 port #2
      00000000febf0460-00000000febf046f (prio 0, RW): usb3 port #3
      00000000febf0470-00000000febf047f (prio 0, RW): usb3 port #4
      00000000febf0480-00000000febf048f (prio 0, RW): usb2 port #1
      00000000febf0490-00000000febf049f (prio 0, RW): usb2 port #2
      00000000febf04a0-00000000febf04af (prio 0, RW): usb2 port #3
      00000000febf04b0-00000000febf04bf (prio 0, RW): usb2 port #4
      00000000febf1000-00000000febf121f (prio 0, RW): runtime
      00000000febf2000-00000000febf281f (prio 0, RW): doorbell
      00000000febf3000-00000000febf30ff (prio 0, RW): msix-table
      00000000febf3800-00000000febf3807 (prio 0, RW): msix-pba


> >  * What is the reason for making the modern bar 8M in size?  Looks a bit
> >    excessive, given that only 64k or so of that are actually used ...
> 
> I use a page per VQ for architectures that can locate the offset of the
> accessed page that triggered EPT violation faster than the offset within
> page.  I think this is the case for SVM.

8M still looks excessive, given that we typically have a small number of
queues per device.  Do you allocate address space for the maximum
possible number of queues unconditionally?

> > virtio-scsi seems to be broken, at least my usual fedora guest didn't
> > boot up from virtio-scsi disk when using a guest kernel with this patch
> > series applied.
> 
> I'll re-test. Do other devices work for you? Thanks!

Didn't came very far yet in my testing due to the guest not booting.  I
plan to try other storage for the image, but didn't found the time yet.

I've tried to boot a F21 live iso with virtio-net (legacy guest driver
obviously), which seems to work ok in light testing.

BTW: is there a tool (or pciutils patch) which can decode the virtio
capabilities?

cheers,
  Gerd


