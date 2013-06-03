Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909Ab3FCN1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 09:27:30 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:50332 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757501Ab3FCN12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 09:27:28 -0400
Date: Mon, 3 Jun 2013 15:27:18 +0200
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
Message-ID: <20130603152718.5ba4d05f@holzheu>
In-Reply-To: <20130531160158.GC13057@redhat.com>
References: <20130524152849.GF18218@redhat.com>
	<87mwrkatgu.fsf@xmission.com>
	<51A006CF.90105@gmail.com>
	<87k3mnahkf.fsf@xmission.com>
	<51A076FE.3060604@gmail.com>
	<20130525145217.0549138a@holzheu>
	<20130528135500.GC7088@redhat.com>
	<20130529135144.7f95c4c0@holzheu>
	<20130530203847.GB5968@redhat.com>
	<20130531162127.6d512233@holzheu>
	<20130531160158.GC13057@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060313-0542-0000-0000-0000056F1986
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 May 2013 12:01:58 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Fri, May 31, 2013 at 04:21:27PM +0200, Michael Holzheu wrote:
> > On Thu, 30 May 2013 16:38:47 -0400
> > Vivek Goyal <vgoyal@redhat.com> wrote:
> > 
> > > On Wed, May 29, 2013 at 01:51:44PM +0200, Michael Holzheu wrote:
> > > 

[...]

> > For zfcpdump currently we add a load from [0, HSA_SIZE] where
> > p_offset equals p_paddr. Therefore we can't distinguish in
> > copy_oldmem_page() if we read from oldmem (HSA) or newmem. The
> > range [0, HSA_SIZE] is used twice. As a workaroun we could use an
> > artificial p_offset for the HSA memory chunk that is not used by
> > the 1st kernel physical memory. This is not really beautiful, but
> > probably doable.
> 
> Ok, zfcpdump is a problem because HSA memory region is in addition to
> regular memory address space. 

Right and the HSA memory is accessed with a read() interface and can't
be directly mapped.

[...]

> If you decide not to do that, agreed that copy_oldmem_page() need to
> differentiate between reference to HSA memory and reference to new
> memory. I guess in that case we will have to go with original proposal
> of using arch functions to access and read headers.

Let me think about that a bit more ...

[...]

> > If copy_oldmem_page() now also must be able to copy to vmalloc
> > memory, we would have to add new code for that:
> > 
> > * oldmem -> newmem (real): Use direct memcpy_real()
> > * oldmem -> newmem (vmalloc): Use intermediate buffer with
> > memcpy_real()
> > * newmem -> newmem: Use memcpy()
> > 
> > What do you think?
> 
> Yep, looks like you will have to do something like that.
> 
> Can't we map HSA frames temporarily, copy data and tear down the
> mapping?

Yes, we would have to create a *temporarily* mapping (see suggestion
below). We do not have enough memory to copy the complete HSA.
 
> If not, how would remap_pfn_range() work with HSA region when
> /proc/vmcore is mmaped()?

I am no memory management expert, so I discussed that with Martin
Schwidefsky (s390 architecture maintainer). Perhaps something like
the following could work:

After vmcore_mmap() is called the HSA pages are not initially mapped in
the page tables. So when user space accesses those parts
of /proc/vmcore, a fault will be generated. We implement a mechanism
that in this case the HSA is copied to a new page in the page cache and
a mapping is created for it. Since the page is allocated in the page
cache, it can be released afterwards by the kernel when we get memory
pressure.

Our current idea for such an implementation:

* Create new address space (struct address_space) for /proc/vmcore.
* Implement new vm_operations_struct "vmcore_mmap_ops" with
  new vmcore_fault() ".fault" callback for /proc/vmcore.
* Set vma->vm_ops to vmcore_mmap_ops in mmap_vmcore().
* The vmcore_fault() function will get a new page cache page,
  copy HSA page to page cache page add it to vmcore address space.
  To see how this could work, we looked into the functions
  filemap_fault() in "mm/filemap.c" and relay_buf_fault() in
  "kernel/relay.c".

What do you think?

Michael

