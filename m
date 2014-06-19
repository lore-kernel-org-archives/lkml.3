Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934412AbaFSUN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 16:13:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51186 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071AbaFSUNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 16:13:24 -0400
Date: Thu, 19 Jun 2014 13:13:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Chen Yucong <slaoub@gmail.com>, mgorman@suse.de, hannes@cmpxchg.org,
        mhocko@suse.cz, riel@redhat.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan.c: fix an implementation flaw in proportional
 scanning
Message-Id: <20140619131322.1ab89e3380bf2eed477f9030@linux-foundation.org>
In-Reply-To: <20140619010239.GA2071@bbox>
References: <1402980902-6345-1-git-send-email-slaoub@gmail.com>
	<20140618152751.283deda95257cc32ccea8f20@linux-foundation.org>
	<1403136272.12954.4.camel@debian>
	<20140618174001.a5de7668.akpm@linux-foundation.org>
	<20140619010239.GA2071@bbox>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014 10:02:39 +0900 Minchan Kim <minchan@kernel.org> wrote:

> > > @@ -2057,8 +2057,7 @@ out:
> > >  static void shrink_lruvec(struct lruvec *lruvec, struct scan_control
> > > *sc)
> > >  {
> > >         unsigned long nr[NR_LRU_LISTS];
> > > -       unsigned long targets[NR_LRU_LISTS];
> > > -       unsigned long nr_to_scan;
> > > +       unsigned long file_target, anon_target;
> > > 
> > > >From the above snippet, we can know that the "percent" locals come from
> > > targets[NR_LRU_LISTS]. So this fix does not increase the stack.
> > 
> > OK.  But I expect the stack use could be decreased by using more
> > complex expressions.
> 
> I didn't look at this patch yet but want to say.
> 
> The expression is not easy to follow since several people already
> confused/discuss/fixed a bit so I'd like to put more concern to clarity
> rather than stack footprint.

That code is absolutely awful :( It's terribly difficult to work out
what the design is - what the code is actually setting out to achieve. 
One is reduced to trying to reverse-engineer the intent from the
implementation and that becomes near impossible when the
implementation has bugs!

Look at this miserable comment:

		/*
		 * For kswapd and memcg, reclaim at least the number of pages
		 * requested. Ensure that the anon and file LRUs are scanned
		 * proportionally what was requested by get_scan_count(). We
		 * stop reclaiming one LRU and reduce the amount scanning
		 * proportional to the original scan target.
		 */


> For kswapd and memcg, reclaim at least the number of pages
> requested.

*why*?

> Ensure that the anon and file LRUs are scanned
> proportionally what was requested by get_scan_count().

Ungramattical.  Lacks specificity.  Fails to explain *why*.

> We stop reclaiming one LRU and reduce the amount scanning
> proportional to the original scan target.

Ungramattical.  Lacks specificity.  Fails to explain *why*.


The only way we're going to fix all this up is to stop looking at the
code altogether.  Write down the design and the intentions in English. 
Review that.  Then implement that design in C.

So review and understanding of this code then is a two-stage thing. 
First, we review and understand the *design*, as written in English. 
Secondly, we check that the code faithfully implements that design. 
This second step becomes quite trivial.


That may all sound excessively long-winded and formal, but
shrink_lruvec() of all places needs such treatment.  I am completely
fed up with peering at the code trying to work out what on earth people
were thinking when they typed it in :(


So my suggestion is: let's stop fiddling with the code.  Someone please
prepare a patch which fully documents the design and let's get down and
review that.  Once that patch is complete, let's then start looking at
the implementation.

