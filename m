Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbbARPvG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 10:51:06 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:34419 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbbARPvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 10:51:03 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Davidlohr Bueso <dave@stgolabs.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        David Rientjes <rientjes@google.com>, Vlastimil Babka <vbabka@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] mm/thp: Allocate transparent hugepages on local node
In-Reply-To: <1421478959.4903.1.camel@stgolabs.net>
References: <1421393196-20915-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20150116160204.544e2bcf9627f5a4043ebf8d@linux-foundation.org> <1421478959.4903.1.camel@stgolabs.net>
User-Agent: Notmuch/0.19+2~g32855b9 (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-pc-linux-gnu)
Date: Sun, 18 Jan 2015 21:20:58 +0530
Message-ID: <87y4p02il9.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011815-0005-0000-0000-0000036F10E8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davidlohr Bueso <dave@stgolabs.net> writes:

> On Fri, 2015-01-16 at 16:02 -0800, Andrew Morton wrote:
>> On Fri, 16 Jan 2015 12:56:36 +0530 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
>> 
>> > This make sure that we try to allocate hugepages from local node if
>> > allowed by mempolicy. If we can't, we fallback to small page allocation
>> > based on mempolicy. This is based on the observation that allocating pages
>> > on local node is more beneficial than allocating hugepages on remote node.
>> 
>> The changelog is a bit incomplete.  It doesn't describe the current
>> behaviour, nor what is wrong with it.  What are the before-and-after
>> effects of this change?
>> 
>> And what might be the user-visible effects?
>
> I'd be interested in any performance data. I'll run this by a 4 node box
> next week.


Thanks.

>
>> 
>> > --- a/mm/mempolicy.c
>> > +++ b/mm/mempolicy.c
>> > @@ -2030,6 +2030,46 @@ retry_cpuset:
>> >  	return page;
>> >  }
>> >  
>> > +struct page *alloc_hugepage_vma(gfp_t gfp, struct vm_area_struct *vma,
>> > +				unsigned long addr, int order)
>> 
>> alloc_pages_vma() is nicely documented.  alloc_hugepage_vma() is not
>> documented at all.  This makes it a bit had for readers to work out the
>> difference!
>> 
>> Is it possible to scrunch them both into the same function?  Probably
>> too messy?
>> 
>> > +{
>> > +	struct page *page;
>> > +	nodemask_t *nmask;
>> > +	struct mempolicy *pol;
>> > +	int node = numa_node_id();
>> > +	unsigned int cpuset_mems_cookie;
>> > +
>> > +retry_cpuset:
>> > +	pol = get_vma_policy(vma, addr);
>> > +	cpuset_mems_cookie = read_mems_allowed_begin();
>> > +
>> > +	if (pol->mode != MPOL_INTERLEAVE) {
>> > +		/*
>> > +		 * For interleave policy, we don't worry about
>> > +		 * current node. Otherwise if current node is
>> > +		 * in nodemask, try to allocate hugepage from
>> > +		 * current node. Don't fall back to other nodes
>> > +		 * for THP.
>> > +		 */
>> 
>> This code isn't "interleave policy".  It's everything *but* interleave
>> policy.  Comment makes no sense!
>
> May I add that, while a nit, this indentation is quite ugly:

I updated that and replied here
http://article.gmane.org/gmane.linux.kernel/1868545. Let me know what you think.
>
>> 
>> > +		nmask = policy_nodemask(gfp, pol);
>> > +		if (!nmask || node_isset(node, *nmask)) {
>> > +			mpol_cond_put(pol);
>> > +			page = alloc_pages_exact_node(node, gfp, order);
>> > +			if (unlikely(!page &&
>> > +				     read_mems_allowed_retry(cpuset_mems_cookie)))
>> > +				goto retry_cpuset;
>> > +			return page;
>> > +		}
>> > +	}
>
> Improving it makes the code visually easier on the eye. So this should
> be considered if another re-spin of the patch is to be done anyway. Just
> jump to the mpol refcounting and be done when 'pol->mode ==
> MPOL_INTERLEAVE'.
>


-aneesh

