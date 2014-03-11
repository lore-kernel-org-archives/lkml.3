Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbaCKUr1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 16:47:27 -0400
Received: from g5t1626.atlanta.hp.com ([15.192.137.9]:40671 "EHLO
	g5t1626.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336AbaCKUrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 16:47:25 -0400
Message-ID: <1394570844.2786.42.camel@buesod1.americas.hpqcorp.net>
Subject: Re: mm: mmap_sem lock assertion failure in __mlock_vma_pages_range
From: Davidlohr Bueso <davidlohr@hp.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 11 Mar 2014 13:47:24 -0700
In-Reply-To: <531F75D1.3060909@oracle.com>
References: <531F6689.60307@oracle.com>
		<1394568453.2786.28.camel@buesod1.americas.hpqcorp.net>
	 <20140311133051.bf5ca716ef189746ebcff431@linux-foundation.org>
	 <531F75D1.3060909@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-11 at 16:45 -0400, Sasha Levin wrote:
> On 03/11/2014 04:30 PM, Andrew Morton wrote:
> > All I can think is that find_vma() went and returned a vma from a
> > different mm, which would be odd.  How about I toss this in there?
> >
> > --- a/mm/vmacache.c~a
> > +++ a/mm/vmacache.c
> > @@ -72,8 +72,10 @@ struct vm_area_struct *vmacache_find(str
> >   	for (i = 0; i < VMACACHE_SIZE; i++) {
> >   		struct vm_area_struct *vma = current->vmacache[i];
> >
> > -		if (vma && vma->vm_start <= addr && vma->vm_end > addr)
> > +		if (vma && vma->vm_start <= addr && vma->vm_end > addr) {
> > +			BUG_ON(vma->vm_mm != mm);
> >   			return vma;
> > +		}
> >   	}
> >
> >   	return NULL;
> 
> Bingo! With the above patch:
> 
> [  243.565794] kernel BUG at mm/vmacache.c:76!
> [  243.566720] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [  243.568048] Dumping ftrace buffer:
> [  243.568740]    (ftrace buffer empty)
> [  243.569481] Modules linked in:
> [  243.570203] CPU: 10 PID: 10073 Comm: trinity-c332 Tainted: G        W    3.14.0-rc5-next-20140307-sasha-00010-g1f812cb-dirty #143

and this is also part of the DEBUG_PAGEALLOC + trinity combo! I suspect
the root cause it the same as Fengguang's report.

