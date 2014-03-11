Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbaCKUHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 16:07:49 -0400
Received: from g2t2353.austin.hp.com ([15.217.128.52]:23438 "EHLO
	g2t2353.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257AbaCKUHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 16:07:44 -0400
Message-ID: <1394568453.2786.28.camel@buesod1.americas.hpqcorp.net>
Subject: Re: mm: mmap_sem lock assertion failure in __mlock_vma_pages_range
From: Davidlohr Bueso <davidlohr@hp.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 11 Mar 2014 13:07:33 -0700
In-Reply-To: <531F6689.60307@oracle.com>
References: <531F6689.60307@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-11 at 15:39 -0400, Sasha Levin wrote:
> Hi all,
> 
> I've ended up deleting the log file by mistake, but this bug does seem to be important
> so I'd rather not wait before the same issue is triggered again.
> 
> The call chain is:
> 
> 	mlock (mm/mlock.c:745)
> 		__mm_populate (mm/mlock.c:700)
> 			__mlock_vma_pages_range (mm/mlock.c:229)
> 				VM_BUG_ON(!rwsem_is_locked(&mm->mmap_sem));

So __mm_populate() is only called by mlock(2) and this VM_BUG_ON seems
wrong as we call it without the lock held:

	up_write(&current->mm->mmap_sem);
	if (!error)
		error = __mm_populate(start, len, 0);
	return error;
}

> 
> It seems to be a rather simple trace triggered from userspace. The only recent patch
> in the area (that I've noticed) was "mm/mlock: prepare params outside critical region".
> I've reverted it and trying to testing without it.

Odd, this patch should definitely *not* cause this. In any case every
operation removed from the critical region is local to the function:

	lock_limit = rlimit(RLIMIT_MEMLOCK);
	lock_limit >>= PAGE_SHIFT;
	locked = len >> PAGE_SHIFT;

	down_write(&current->mm->mmap_sem);

