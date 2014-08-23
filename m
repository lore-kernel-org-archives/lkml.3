Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaHWXQB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 19:16:01 -0400
Received: from mail-oa0-f73.google.com ([209.85.219.73]:61760 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbaHWXP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 19:15:59 -0400
Date: Sat, 23 Aug 2014 19:15:57 -0400
From: Peter Feiner <pfeiner@google.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>, Jamie Liu <jamieliu@google.com>,
        Hugh Dickins <hughd@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 1/3] mm: softdirty: enable write notifications on VMAs
 after VM_SOFTDIRTY cleared
Message-ID: <20140823231557.GA12184@google.com>
References: <1408571182-28750-1-git-send-email-pfeiner@google.com>
 <1408831921-10168-1-git-send-email-pfeiner@google.com>
 <1408831921-10168-2-git-send-email-pfeiner@google.com>
 <20140823230011.GA26483@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140823230011.GA26483@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2014 at 02:00:11AM +0300, Kirill A. Shutemov wrote:
> On Sat, Aug 23, 2014 at 06:11:59PM -0400, Peter Feiner wrote:
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index dfc791c..f1a5382 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -851,8 +851,23 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
> >  			if (type == CLEAR_REFS_MAPPED && !vma->vm_file)
> >  				continue;
> >  			if (type == CLEAR_REFS_SOFT_DIRTY) {
> > -				if (vma->vm_flags & VM_SOFTDIRTY)
> > +				if (vma->vm_flags & VM_SOFTDIRTY) {
> 
> Why do we need the branch here. Does it save us anything?
> Looks like we can update vm_flags and enable writenotify unconditionally.
> Indentation level is high enough already.

You're right, we don't need the branch here. I'll change for v3.

> >  					vma->vm_flags &= ~VM_SOFTDIRTY;
> > +					/*
> > +					 * We don't have a write lock on
> > +					 * mm->mmap_sem, so we race with the
> > +					 * fault handler reading vm_page_prot.
> > +					 * Therefore writable PTEs (that won't
> > +					 * have soft-dirty set) can be created
> > +					 * for read faults. However, since the
> > +					 * PTE lock is held while vm_page_prot
> > +					 * is read and while we write protect
> > +					 * PTEs during our walk, any writable
> > +					 * PTEs that slipped through will be
> > +					 * write protected.
> > +					 */
> 
> Hm.. Isn't this yet another bug?
> Updating vma->vm_flags without down_write(&mm->mmap_sem) looks troublesome
> to me. Am I wrong?

As I said in the comment, it looks fishy but we're still fixing the bug. That
is, no writable PTEs will sneak by that don't have soft-dirty set.

I was originally going to submit something that dropped the mmap_sem and
re-took it in write mode before manipulating vm_page_prot. The control flow was
slightly hairy, so I convinced myself that the race is benign :-)

If I'm right and the race is benign, it still might be worth having the more
straightforward & obviously correct implementation since this isn't performance
critical code.

> > +/* Enable write notifications without blowing away special flags. */
> > +static inline void vma_enable_writenotify(struct vm_area_struct *vma)
> > +{
> > +	vma->vm_page_prot = pgprot_modify(vma->vm_page_prot,
> > +	                                  vm_get_page_prot(vma->vm_flags &
> > +					                   ~VM_SHARED));
> 
> I think this way is more readable:
> 
> 	pgprot_t newprot;
> 	newprot = vm_get_page_prot(vma->vm_flags & ~VM_SHARED);
> 	vma->vm_page_prot = pgprot_modify(vma->vm_page_prot, newprot);
> 

Looks good. I'll update.

> > +}
> > +
> > +/* Disable write notifications without blowing away special flags. */
> > +static inline void vma_disable_writenotify(struct vm_area_struct *vma)
> > +{
> > +	vma->vm_page_prot = pgprot_modify(vma->vm_page_prot,
> > +	                                  vm_get_page_prot(vma->vm_flags));
> 
> ditto.

I'll change this too.

Peter
