Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab3GKDDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 23:03:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57220 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229Ab3GKDDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 23:03:04 -0400
Date: Wed, 10 Jul 2013 20:03:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Michal Hocko <mhocko@suse.cz>, Glauber Costa <glommer@gmail.com>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: slab shrinkers: BUG at mm/list_lru.c:92
Message-Id: <20130710200337.cd9a05d6.akpm@linux-foundation.org>
In-Reply-To: <20130711022634.GZ3438@dastard>
References: <20130701075005.GA28765@dhcp22.suse.cz>
	<20130701081056.GA4072@dastard>
	<20130702092200.GB16815@dhcp22.suse.cz>
	<20130702121947.GE14996@dastard>
	<20130702124427.GG16815@dhcp22.suse.cz>
	<20130703112403.GP14996@dastard>
	<20130704163643.GF7833@dhcp22.suse.cz>
	<20130708125352.GC20149@dhcp22.suse.cz>
	<20130710023138.GO3438@dastard>
	<20130710080605.GC4437@dhcp22.suse.cz>
	<20130711022634.GZ3438@dastard>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jul 2013 12:26:34 +1000 Dave Chinner <david@fromorbit.com> wrote:

> > Just for reference. wait_on_page_writeback is issued only for memcg
> > reclaim because there is no other throttling mechanism to prevent from
> > too many dirty pages on the list, thus pre-mature OOM killer. See
> > e62e384e9d (memcg: prevent OOM with too many dirty pages) for more
> > details. The original patch relied on may_enter_fs but that check
> > disappeared by later changes by c3b94f44fc (memcg: further prevent OOM
> > with too many dirty pages).
> 
> Aye. That's the exact code I was looking at yesterday and wondering
> "how the hell is waiting on page writeback valid in GFP_NOFS
> context?". It seems that memcg reclaim is intentionally ignoring
> GFP_NOFS to avoid OOM issues.  That's a memcg implementation problem,
> not a filesystem or LRU infrastructure problem....

Yup, c3b94f44fc shouldn't have done that.

Throttling by waiting on a specific page is indeed prone to deadlocks
and has a number of efficiency problems as well: if 1,000,000 pages
came clean while you're waiting for *this* page to come clean, you're
left looking pretty stupid.

Hence congestion_wait(), which perhaps can save us here.  I'm not sure
how the wait_on_page_writeback() got back in there - I must have been
asleep at the time.
