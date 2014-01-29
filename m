Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732AbaA2BUB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 20:20:01 -0500
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:33592 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708AbaA2BUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 20:20:00 -0500
Message-ID: <1390958378.11839.37.camel@buesod1.americas.hpqcorp.net>
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
Date: Tue, 28 Jan 2014 17:19:38 -0800
In-Reply-To: <1390955806-ljm7w9nq-mutt-n-horiguchi@ah.jp.nec.com>
References: <1390794746-16755-1-git-send-email-davidlohr@hp.com>
	 <1390794746-16755-4-git-send-email-davidlohr@hp.com>
	 <1390856576-ud1qp3fm-mutt-n-horiguchi@ah.jp.nec.com>
	 <1390859042.27421.4.camel@buesod1.americas.hpqcorp.net>
	 <1390874021-48f5mo0m-mutt-n-horiguchi@ah.jp.nec.com>
	 <1390876457.27421.19.camel@buesod1.americas.hpqcorp.net>
	 <1390955806-ljm7w9nq-mutt-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-28 at 19:36 -0500, Naoya Horiguchi wrote:
> On Mon, Jan 27, 2014 at 06:34:17PM -0800, Davidlohr Bueso wrote:
[...]
> > > If this retry is really essential for the fix, please comment the reason
> > > both in patch description and inline comment. It's very important for
> > > future code maintenance.
> > 
> > So we locate the corresponding region in the reserve map, and if we are
> > below the current region, then we allocate a new one. Since we dropped
> > the lock to allocate memory, we have to make sure that we still need the
> > new region and that we don't race with the new status of the reservation
> > map. This is the whole point of the retry, and I don't see it being
> > suboptimal.
> 
> I'm afraid that you don't explain why you need drop the lock for memory
> allocation. Are you saying that this unlocking comes from the difference
> between rwsem and spin lock?

Because you cannot go to sleep while holding a spinlock, which is
exactly what kmalloc(GFP_KERNEL) can do. We *might* get a way with it
with GFP_ATOMIC, I dunno, but I certainly prefer this approach better.

Thanks,
Davidlohr

