Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbaCKWHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 18:07:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718AbaCKWHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 18:07:34 -0400
Date: Tue, 11 Mar 2014 16:57:01 -0400
From: Dave Jones <davej@redhat.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm: mmap_sem lock assertion failure in __mlock_vma_pages_range
Message-ID: <20140311205701.GA16658@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Davidlohr Bueso <davidlohr@hp.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Michel Lespinasse <walken@google.com>,
	Rik van Riel <riel@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
	LKML <linux-kernel@vger.kernel.org>
References: <531F6689.60307@oracle.com>
 <1394568453.2786.28.camel@buesod1.americas.hpqcorp.net>
 <20140311133051.bf5ca716ef189746ebcff431@linux-foundation.org>
 <531F75D1.3060909@oracle.com>
 <1394570844.2786.42.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394570844.2786.42.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 01:47:24PM -0700, Davidlohr Bueso wrote:
 > On Tue, 2014-03-11 at 16:45 -0400, Sasha Levin wrote:
 > > On 03/11/2014 04:30 PM, Andrew Morton wrote:
 > > > All I can think is that find_vma() went and returned a vma from a
 > > > different mm, which would be odd.  How about I toss this in there?
 > > >
 > > > --- a/mm/vmacache.c~a
 > > > +++ a/mm/vmacache.c
 > > > @@ -72,8 +72,10 @@ struct vm_area_struct *vmacache_find(str
 > > >   	for (i = 0; i < VMACACHE_SIZE; i++) {
 > > >   		struct vm_area_struct *vma = current->vmacache[i];
 > > >
 > > > -		if (vma && vma->vm_start <= addr && vma->vm_end > addr)
 > > > +		if (vma && vma->vm_start <= addr && vma->vm_end > addr) {
 > > > +			BUG_ON(vma->vm_mm != mm);
 > > >   			return vma;
 > > > +		}
 > > >   	}
 > > 
 > > [  243.565794] kernel BUG at mm/vmacache.c:76!
 > 
 > and this is also part of the DEBUG_PAGEALLOC + trinity combo! I suspect
 > the root cause it the same as Fengguang's report.

btw, I added a (ugly) script to trinity.git this afternoon:
https://github.com/kernelslacker/trinity/commit/b6cfe63ea5b205a34bc6c5698e5b766dfcddad1d
which should make reproducing VM related bugs happen a lot faster.

While chasing one particular issue, that script has hit 2-3 others in my
testing so far today (All already known).

It would be really good if people other than me & Sasha started running stuff like this occasionally
to try and get some of the more annoying things fixed up faster. Though it's only really
useful with debug kernels, and I know from past experience that asking people to try running things
with debug options enabled is like pulling teeth..

	Dave

