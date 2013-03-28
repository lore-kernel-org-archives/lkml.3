Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab3C1QtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:49:25 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:38484 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536Ab3C1QtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:49:23 -0400
Date: Thu, 28 Mar 2013 12:49:19 -0400
From: Andrew Shewmaker <agshew@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        simon.jeons@gmail.com, ric.masonn@gmail.com
Subject: Re: [PATCH v6 1/2] mm: limit growth of 3% hardcoded other user
 reserve
Message-ID: <20130328164919.GA1459@localhost.localdomain>
References: <20130318214442.GA1441@localhost.localdomain>
 <20130327142832.8505be7276064bf4b1daab5c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130327142832.8505be7276064bf4b1daab5c@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 02:28:32PM -0700, Andrew Morton wrote:
> On Mon, 18 Mar 2013 17:44:42 -0400 Andrew Shewmaker <agshew@gmail.com> wrote:
> 
> > Add user_reserve_kbytes knob.
> > 
> > Limit the growth of the memory reserved for other user
> > processes to min(3% current process size, user_reserve_pages).
> > 
> > user_reserve_pages defaults to min(3% free pages, 128MB)
> 
> That was an epic changelog ;)

I didn't want to err on the side of brevity again :)
But I definitely don't want to be annoying, so I'll work 
on being concise without sacrificing important detail.
 
> >
> > ...
> >
> > +int __meminit init_user_reserve(void)
> > +{
> > +	unsigned long free_kbytes;
> > +
> > +	free_kbytes = global_page_state(NR_FREE_PAGES) << (PAGE_SHIFT - 10);
> > +
> > +	sysctl_user_reserve_kbytes = min(free_kbytes / 32, 1UL << 17);
> > +	return 0;
> > +}
> > +module_init(init_user_reserve)
> 
> Problem is, the initial default values will become wrong if memory if
> hot-added or hot-removed.
> 
> That could be fixed up by appropriate use of
> register_memory_notifier(), but what would the notification handler do
> if the operator has modified the value?  Proportionally scale it?

If the operator changed it to a greater value, then I imagine that would
be because the applications they use to recover require a bigger reserve 
to function. Then proportionally scaling down the value on hot-removal 
might mean that the operator can't recover when they expected to be able 
to. Maybe the best thing would be to leave it be in that case, or 
print a message telling them they need to re-evaluate the reserve size?

I won't be able to look at this again until next week, but I'll work on a 
version that handles hot-addition and hot-removal.

Thanks,

Andrew
