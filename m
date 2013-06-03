Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759432Ab3FCQs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 12:48:56 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:53798 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758785Ab3FCQsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 12:48:54 -0400
Date: Mon, 3 Jun 2013 18:48:47 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] kdump/mmap: Fix mmap of /proc/vmcore for s390
Message-ID: <20130603184847.4434c7ea@holzheu>
In-Reply-To: <20130603155940.GA6714@redhat.com>
References: <51A006CF.90105@gmail.com>
	<87k3mnahkf.fsf@xmission.com>
	<51A076FE.3060604@gmail.com>
	<20130525145217.0549138a@holzheu>
	<20130528135500.GC7088@redhat.com>
	<20130529135144.7f95c4c0@holzheu>
	<20130530203847.GB5968@redhat.com>
	<20130531162127.6d512233@holzheu>
	<20130531160158.GC13057@redhat.com>
	<20130603152718.5ba4d05f@holzheu>
	<20130603155940.GA6714@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060316-0342-0000-0000-00000535F922
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Jun 2013 11:59:40 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Mon, Jun 03, 2013 at 03:27:18PM +0200, Michael Holzheu wrote:
> 
> [..]
> > > If not, how would remap_pfn_range() work with HSA region when
> > > /proc/vmcore is mmaped()?
> > 
> > I am no memory management expert, so I discussed that with Martin
> > Schwidefsky (s390 architecture maintainer). Perhaps something like
> > the following could work:
> > 
> > After vmcore_mmap() is called the HSA pages are not initially
> > mapped in the page tables. So when user space accesses those parts
> > of /proc/vmcore, a fault will be generated. We implement a mechanism
> > that in this case the HSA is copied to a new page in the page cache
> > and a mapping is created for it. Since the page is allocated in the
> > page cache, it can be released afterwards by the kernel when we get
> > memory pressure.
> > 
> > Our current idea for such an implementation:
> > 
> > * Create new address space (struct address_space) for /proc/vmcore.
> > * Implement new vm_operations_struct "vmcore_mmap_ops" with
> >   new vmcore_fault() ".fault" callback for /proc/vmcore.
> > * Set vma->vm_ops to vmcore_mmap_ops in mmap_vmcore().
> > * The vmcore_fault() function will get a new page cache page,
> >   copy HSA page to page cache page add it to vmcore address space.
> >   To see how this could work, we looked into the functions
> >   filemap_fault() in "mm/filemap.c" and relay_buf_fault() in
> >   "kernel/relay.c".
> > 
> > What do you think?
> 
> I am not mm expert either but above proposal sounds reasonable to me.
> 
> So remap_pfn_range() call will go in arch dependent code so that arch
> can decide which range can be mapped right away and which ranges will
> be filed in when fault happens? I am assuming that s390 will map
> everything except for pfn between 0 and HSA_SIZE.

Yes, for [0 - HSA_SIZE] the fault handler will be called and for
the rest we establish a mapping with remap_pfn_range() as it is
currently done. Therefore no fault handler will be called for that part
of /proc/vmcore.

I will try to find out if it is doable that way.

> And regular s390 kdump will map everyting right away and will not
> have to rely on fault mechanism?

Yes, as kdump on the other archs.

Thanks
Michael

