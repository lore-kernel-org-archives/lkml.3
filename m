Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668AbaCKUax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 16:30:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44864 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422AbaCKUaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 16:30:52 -0400
Date: Tue, 11 Mar 2014 13:30:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm: mmap_sem lock assertion failure in __mlock_vma_pages_range
Message-Id: <20140311133051.bf5ca716ef189746ebcff431@linux-foundation.org>
In-Reply-To: <1394568453.2786.28.camel@buesod1.americas.hpqcorp.net>
References: <531F6689.60307@oracle.com>
	<1394568453.2786.28.camel@buesod1.americas.hpqcorp.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2014 13:07:33 -0700 Davidlohr Bueso <davidlohr@hp.com> wrote:

> On Tue, 2014-03-11 at 15:39 -0400, Sasha Levin wrote:
> > Hi all,
> > 
> > I've ended up deleting the log file by mistake, but this bug does seem to be important
> > so I'd rather not wait before the same issue is triggered again.
> > 
> > The call chain is:
> > 
> > 	mlock (mm/mlock.c:745)
> > 		__mm_populate (mm/mlock.c:700)
> > 			__mlock_vma_pages_range (mm/mlock.c:229)
> > 				VM_BUG_ON(!rwsem_is_locked(&mm->mmap_sem));
> 
> So __mm_populate() is only called by mlock(2) and this VM_BUG_ON seems
> wrong as we call it without the lock held:
> 
> 	up_write(&current->mm->mmap_sem);
> 	if (!error)
> 		error = __mm_populate(start, len, 0);
> 	return error;
> }

__mm_populate() pretty clearly calls __mlock_vma_pages_range() under
down_read(mm->mmap_sem).

I worry about what happens if __get_user_pages decides to do

				if (ret & VM_FAULT_RETRY) {
					if (nonblocking)
						*nonblocking = 0;
					return i;
				}

uh-oh, that just cleared __mm_populate()'s `locked' variable and we'll
forget to undo mmap_sem.  That won't explain this result, but it's a
potential problem.


All I can think is that find_vma() went and returned a vma from a
different mm, which would be odd.  How about I toss this in there?

--- a/mm/vmacache.c~a
+++ a/mm/vmacache.c
@@ -72,8 +72,10 @@ struct vm_area_struct *vmacache_find(str
 	for (i = 0; i < VMACACHE_SIZE; i++) {
 		struct vm_area_struct *vma = current->vmacache[i];
 
-		if (vma && vma->vm_start <= addr && vma->vm_end > addr)
+		if (vma && vma->vm_start <= addr && vma->vm_end > addr) {
+			BUG_ON(vma->vm_mm != mm);
 			return vma;
+		}
 	}
 
 	return NULL;
_

