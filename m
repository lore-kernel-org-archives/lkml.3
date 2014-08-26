Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380AbaHZGt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 02:49:56 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:44389 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617AbaHZGtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 02:49:55 -0400
Date: Tue, 26 Aug 2014 10:49:52 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: Peter Feiner <pfeiner@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Pavel Emelyanov <xemul@parallels.com>, Jamie Liu <jamieliu@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH v5] mm: softdirty: enable write notifications on VMAs
 after VM_SOFTDIRTY cleared
Message-ID: <20140826064952.GR25918@moon>
References: <1408571182-28750-1-git-send-email-pfeiner@google.com>
 <1408937681-1472-1-git-send-email-pfeiner@google.com>
 <alpine.LSU.2.11.1408252142380.2073@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1408252142380.2073@eggly.anvils>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 09:45:34PM -0700, Hugh Dickins wrote:
> > +static int clear_refs(struct mm_struct *mm, enum clear_refs_types type,
> > +                      int write)
> > +{
...
> > +
> > +	if (write)
> > +		down_write(&mm->mmap_sem);
> > +	else
> > +		down_read(&mm->mmap_sem);
> > +
> > +	if (type == CLEAR_REFS_SOFT_DIRTY)
> > +		mmu_notifier_invalidate_range_start(mm, 0, -1);
> > +
> > +	for (vma = mm->mmap; vma; vma = vma->vm_next) {
> > +		cp.vma = vma;
> > +		if (is_vm_hugetlb_page(vma))
> > +			continue;
...
> > +		if (type == CLEAR_REFS_ANON && vma->vm_file)
> > +			continue;
> > +		if (type == CLEAR_REFS_MAPPED && !vma->vm_file)
> > +			continue;
> > +		if (type == CLEAR_REFS_SOFT_DIRTY &&
> > +		    (vma->vm_flags & VM_SOFTDIRTY)) {
> > +			if (!write) {
> > +				r = -EAGAIN;
> > +				break;
> 
> Hmm.  For a long time I thought you were fixing another important bug
> with down_write, since we "always" use down_write to modify vm_flags.
> 
> But now I'm realizing that if this is the _only_ place which modifies
> vm_flags with down_read, then it's "probably" safe.  I've a vague
> feeling that this was discussed before - is that so, Cyrill?

Well, as far as I remember we were not talking before about vm_flags
and read-lock in this function, maybe it was on some unrelated lkml thread
without me CC'ed? Until I miss something obvious using read-lock here
for vm_flags modification should be safe, since the only thing which is
important (in context of vma-softdirty) is the vma's presence. Hugh,
mind to refresh my memory, how long ago the discussion took place?
