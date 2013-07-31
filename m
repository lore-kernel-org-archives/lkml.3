Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab3GaQKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 12:10:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130Ab3GaQKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 12:10:21 -0400
Date: Wed, 31 Jul 2013 12:09:45 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Takao Indoh <indou.takao@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "ishii.hironobu@jp.fujitsu.com" <ishii.hironobu@jp.fujitsu.com>,
        Don Dutile <ddutile@redhat.com>,
        "Sumner, William" <bill.sumner@hp.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Haren Myneni <hbabu@us.ibm.com>
Subject: Re: [PATCH v2] PCI: Reset PCIe devices to stop ongoing DMA
Message-ID: <20130731160944.GA1577@redhat.com>
References: <CAErSpo4t_2Xw76p3Z9FVzyyK-MBovavDu9D=pYoPMjESSxgT=w@mail.gmail.com>
 <51B19DF3.2070009@jp.fujitsu.com>
 <CAErSpo6dfEnzriHD_aWZB_3E-kSzauhNRHPd+VuFX5HONVKgqw@mail.gmail.com>
 <51B6BEDB.3000509@jp.fujitsu.com>
 <CAErSpo5u8qGALt6C+tuPYXdd2YgyMH6fnPnA+afUteEZ7kY0iw@mail.gmail.com>
 <51B93221.2040505@jp.fujitsu.com>
 <CAErSpo5tVK-Z3aOdMTzab-S8o5zLVtDOFQ8-LSYpUgbrJSsxuw@mail.gmail.com>
 <51BA7BB6.1080104@jp.fujitsu.com>
 <51EF7466.20703@jp.fujitsu.com>
 <CAErSpo5B7NzVfxwW3bQnfK+iK+DrRsWQd2Cm14z5PWNnRHWL5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo5B7NzVfxwW3bQnfK+iK+DrRsWQd2Cm14z5PWNnRHWL5w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 11:00:46AM -0600, Bjorn Helgaas wrote:
> On Wed, Jul 24, 2013 at 12:29 AM, Takao Indoh
> <indou.takao@jp.fujitsu.com> wrote:
> > Sorry for letting this discussion slide, I was busy on other works:-(
> > Anyway, the summary of previous discussion is:
> > - My patch adds new initcall(fs_initcall) to reset all PCIe endpoints on
> >   boot. This expects PCI enumeration is done before IOMMU
> >   initialization as follows.
> >     (1) PCI enumeration
> >     (2) fs_initcall ---> device reset
> >     (3) IOMMU initialization
> > - This works on x86, but does not work on other architecture because
> >   IOMMU is initialized before PCI enumeration on some architectures. So,
> >   device reset should be done where IOMMU is initialized instead of
> >   initcall.
> > - Or, as another idea, we can reset devices in first kernel(panic kernel)
> >
> > Resetting devices in panic kernel is against kdump policy and seems not to
> > be good idea. So I think adding reset code into iommu initialization is
> > better. I'll post patches for that.
> 
> Of course nobody *wants* to do anything in the panic kernel.  But
> simply saying "it's against kdump policy and seems not to be a good
> idea" is not a technical argument.  There are things that are
> impractical to do in the kdump kernel, so they have to be done in the
> panic kernel even though we know the kernel is unreliable and the
> attempt may fail.

I think resetting all devices in crashed kernel is really a lot of
code. If there is a small piece of code, it can still be considered.

I don't know much about IOMMU or PCI or PCIE. But I am taking one step
back and discuss again the idea of not resetting the IOMMU in second
kernel.

I think resetting the bus is a good idea but just resetting PCIE
will solve only part of the problem and we will same issues with
devices on other buses.

So what sounds more appealing if we could fix this particular
problem at IOMMU level first (and continue to develp patches for
resetting various buses).

In the past also these ideas have been proposed that continue to
use translation table from first kernel. Retain those mappings and
don't reset IOMMU. Reserve some space for kdump mappings in first
kernel and use that reserved mapping space in second kernel. It
never got implemented though.

Bjorn, so what's the fundamental problem with this idea?

Also, what's wrong with DMAR error. If some device tried to do DMA,
and DMA was blocked because IOMMU got reset and mappings are no more
there, why does it lead to failure. Shouldn't we just reate limit 
error messages in such case and if device is needed, anyway driver
will reset it.

Other problem mentioned in this thread is PCI SERR. What is it? Is
it some kind of error device reports if it can't do DMA successfully.
Can these errors be simply ignored kdump kernel? This problem sounds
similar to a device keeping interrupt asserted in second kernel and
kernel simply disables the interrupt line if nobody claims the
interrupt.

IOW, it feels to me that we should handle the issue (DMAR error) at
IOMMU level first (instead of trying to make sure that by the time
we get to initialize IOMMU(), all devices in system have been quiesced
and nobody is doing DMA).

Thanks
Vivek
