Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804Ab3GPPhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 11:37:17 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:35844 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab3GPPhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 11:37:15 -0400
Date: Tue, 16 Jul 2013 17:37:09 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH v6 3/5] vmcore: Introduce remap_oldmem_pfn_range()
Message-ID: <20130716173709.3fed4c42@holzheu>
In-Reply-To: <20130716140418.GB4005@redhat.com>
References: <1372707159-10425-1-git-send-email-holzheu@linux.vnet.ibm.com>
	<1372707159-10425-4-git-send-email-holzheu@linux.vnet.ibm.com>
	<20130702154214.GC22603@redhat.com>
	<20130715154451.02a3a767@holzheu>
	<20130715142708.GB23772@redhat.com>
	<20130716112527.35decf17@holzheu>
	<20130716140418.GB4005@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071615-3548-0000-0000-000005F36CC0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jul 2013 10:04:18 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Tue, Jul 16, 2013 at 11:25:27AM +0200, Michael Holzheu wrote:
> 
> [..]
> > > > Hello Vivek and Andrew,
> > > > 
> > > > We just realized that Hatayama's mmap patches went into v3.11-rc1. This currently
> > > > breaks s390 kdump because of the following two issues:
> > > > 
> > > > 1) The copy_oldmem_page() is now used for copying to vmalloc memory
> > > > 2) The mmap() implementation is not compatible with the current
> > > >    s390 crashkernel swap:
> > > >    See: http://marc.info/?l=kexec&m=136940802511603&w=2
> > > > 
> > > > The "kdump: Introduce ELF header in new memory feature" patch series will
> > > > fix both issues for s390.
> > > > 
> > > > There is the one small open discussion left:
> > > > 
> > > > http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg464856.html
> > > > 
> > > > But once we have finished that, would it be possible to get the
> > > > patches in 3.11?
> > > 
> > > How about taking mmap() fault handler patches in 3.12. And in 3.11, deny
> > > mmap() on s390 forcing makedumpfile to fall back on read() interface. That
> > > way there will be no regression and mmap() related speedup will show up
> > > in next release on s390.
> > 
> > Hello Vivek and Hatayama,
> > 
> > But then we still would have to somehow fix the copy_oldmem_page() issue (1).
> > 
> > We would prefer to add the current patch series with "#ifndef CONFIG_S390" in
> > the fault handler.
> > 
> > @Vivek:
> > 
> > Since you are the kdump maintainer, could you tell us which of the both
> > variants you would like to have?
> > 
> > static int mmap_vmcore_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
> > {
> > ...
> > 
> > #ifndef CONFIG_S390
> > 	return VM_FAULT_SIGBUS;
> > #endif
> 
> I think let us use this one. Kill the process on non-s390 arch if it goes
> into mmap() fault handler.
> 
> copy_oldmem_page() using real mode in s390 is an issue for vmalloc region.
> I think post the series again and let us see if Andrew is comfortable
> with it.

Ok great, I will send Andrew the current patch series.
Let's see what happens...

> I suspect it is late.
> IIUC, we do copying in real mode only to cope with HSA region in zfcpdump
> case.

The problem is that with the mmap patches we now use copy_oldmem_page()
to copy the notes from oldmem into the notes_buf which has been allocated
with vmalloc. The s390 version of copy_oldmem_page() bypasses the page
tables and uses real copy. And this does not work on vmalloc memory.

Best Regards,
Michael

