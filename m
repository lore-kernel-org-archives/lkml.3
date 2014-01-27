Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbaA0VoO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 16:44:14 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:9855 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbaA0VoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 16:44:13 -0500
Message-ID: <1390859042.27421.4.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 3/8] mm, hugetlb: fix race in region tracking
From: Davidlohr Bueso <davidlohr@hp.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, riel@redhat.com,
        mgorman@suse.de, mhocko@suse.cz, aneesh.kumar@linux.vnet.ibm.com,
        kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com,
        david@gibson.dropbear.id.au, js1304@gmail.com,
        liwanp@linux.vnet.ibm.com, dhillf@gmail.com, rientjes@google.com,
        aswin@hp.com, scott.norton@hp.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date: Mon, 27 Jan 2014 13:44:02 -0800
In-Reply-To: <1390856576-ud1qp3fm-mutt-n-horiguchi@ah.jp.nec.com>
References: <1390794746-16755-1-git-send-email-davidlohr@hp.com>
	 <1390794746-16755-4-git-send-email-davidlohr@hp.com>
	 <1390856576-ud1qp3fm-mutt-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-27 at 16:02 -0500, Naoya Horiguchi wrote:
> On Sun, Jan 26, 2014 at 07:52:21PM -0800, Davidlohr Bueso wrote:
> > From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > 
> > There is a race condition if we map a same file on different processes.
> > Region tracking is protected by mmap_sem and hugetlb_instantiation_mutex.
> > When we do mmap, we don't grab a hugetlb_instantiation_mutex, but only the,
> > mmap_sem (exclusively). This doesn't prevent other tasks from modifying the
> > region structure, so it can be modified by two processes concurrently.
> > 
> > To solve this, introduce a spinlock to resv_map and make region manipulation
> > function grab it before they do actual work.
> > 
> > Acked-by: David Gibson <david@gibson.dropbear.id.au>
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > [Updated changelog]
> > Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> > ---
> ...
> > @@ -203,15 +200,23 @@ static long region_chg(struct resv_map *resv, long f, long t)
> >  	 * Subtle, allocate a new region at the position but make it zero
> >  	 * size such that we can guarantee to record the reservation. */
> >  	if (&rg->link == head || t < rg->from) {
> > -		nrg = kmalloc(sizeof(*nrg), GFP_KERNEL);
> > -		if (!nrg)
> > -			return -ENOMEM;
> > +		if (!nrg) {
> > +			spin_unlock(&resv->lock);
> 
> I think that doing kmalloc() inside the lock is simpler.
> Why do you unlock and retry here?

This is a spinlock, no can do -- we've previously debated this and since
the critical region is quite small, a non blocking lock is better suited
here. We do the retry so we don't race once the new region is allocated
after the lock is dropped.

Thanks,
Davidlohr

