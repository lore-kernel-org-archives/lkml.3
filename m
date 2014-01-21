Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbaAUXYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 18:24:16 -0500
Received: from mail-gg0-f182.google.com ([209.85.161.182]:38970 "EHLO
	mail-gg0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbaAUXYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 18:24:12 -0500
Date: Tue, 21 Jan 2014 15:24:08 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alex Thorlton <athorlton@sgi.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-mm@kvack.org
Subject: Re: [BUG] mm: thp: hugepage_vma_check has a blind spot
In-Reply-To: <1390345671-136133-1-git-send-email-athorlton@sgi.com>
Message-ID: <alpine.DEB.2.02.1401211519530.15306@chino.kir.corp.google.com>
References: <1390345671-136133-1-git-send-email-athorlton@sgi.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jan 2014, Alex Thorlton wrote:

> hugepage_vma_check is called during khugepaged_scan_mm_slot to ensure
> that khugepaged doesn't try to allocate THPs in vmas where they are
> disallowed, either due to THPs being disabled system-wide, or through
> MADV_NOHUGEPAGE.
> 
> The logic that hugepage_vma_check uses doesn't seem to cover all cases,
> in my opinion.  Looking at the original code:
> 
>        if ((!(vma->vm_flags & VM_HUGEPAGE) && !khugepaged_always()) ||
> 	   (vma->vm_flags & VM_NOHUGEPAGE))
> 
> We can see that it's possible to have THP disabled system-wide, but still
> receive THPs in this vma.  It seems that it's assumed that just because
> khugepaged_always == false, TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG must be
> set, which is not the case.  We could have VM_HUGEPAGE set, but have THP
> set to "never" system-wide, in which case, the condition presented in the
> if will evaluate to false, and (provided the other checks pass) we can
> end up giving out a THP even though the behavior is set to "never."
> 

You should be able to add a

	BUG_ON(current != khugepaged_thread);

here since khugepaged is supposed to be the only caller to the function.

> While we do properly check these flags in khugepaged_has_work, it looks
> like it's possible to sleep after we check khugepaged_hask_work, but
> before hugepage_vma_check, during which time, hugepages could have been
> disabled system-wide, in which case, we could hand out THPs when we
> shouldn't be.
> 

You're talking about when thp is set to "never" and before khugepaged has 
stopped, correct?

That doesn't seem like a bug to me or anything that needs to be fixed, the 
sysfs knob could be switched even after hugepage_vma_check() is called and 
before a hugepage is actually collapsed so you have the same race.

The only thing that's guaranteed is that, upon writing "never" to 
/sys/kernel/mm/transparent_hugepage/enabled, no more thp memory will be 
collapsed after khugepaged has stopped.
