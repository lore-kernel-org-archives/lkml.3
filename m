Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbaBDASY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 19:18:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47568 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbaBDASX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 19:18:23 -0500
Date: Mon, 3 Feb 2014 16:18:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, iamjoonsoo.kim@lge.com,
        riel@redhat.com, mgorman@suse.de, mhocko@suse.cz,
        aneesh.kumar@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com,
        hughd@google.com, david@gibson.dropbear.id.au, js1304@gmail.com,
        liwanp@linux.vnet.ibm.com, dhillf@gmail.com, rientjes@google.com,
        aswin@hp.com, scott.norton@hp.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] mm, hugetlb: fix race in region tracking
Message-Id: <20140203161821.85b6754226ce7feaadc37810@linux-foundation.org>
In-Reply-To: <1390958378.11839.37.camel@buesod1.americas.hpqcorp.net>
References: <1390794746-16755-1-git-send-email-davidlohr@hp.com>
	<1390794746-16755-4-git-send-email-davidlohr@hp.com>
	<1390856576-ud1qp3fm-mutt-n-horiguchi@ah.jp.nec.com>
	<1390859042.27421.4.camel@buesod1.americas.hpqcorp.net>
	<1390874021-48f5mo0m-mutt-n-horiguchi@ah.jp.nec.com>
	<1390876457.27421.19.camel@buesod1.americas.hpqcorp.net>
	<1390955806-ljm7w9nq-mutt-n-horiguchi@ah.jp.nec.com>
	<1390958378.11839.37.camel@buesod1.americas.hpqcorp.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jan 2014 17:19:38 -0800 Davidlohr Bueso <davidlohr@hp.com> wrote:

> On Tue, 2014-01-28 at 19:36 -0500, Naoya Horiguchi wrote:
> > On Mon, Jan 27, 2014 at 06:34:17PM -0800, Davidlohr Bueso wrote:
> [...]
> > > > If this retry is really essential for the fix, please comment the reason
> > > > both in patch description and inline comment. It's very important for
> > > > future code maintenance.
> > > 
> > > So we locate the corresponding region in the reserve map, and if we are
> > > below the current region, then we allocate a new one. Since we dropped
> > > the lock to allocate memory, we have to make sure that we still need the
> > > new region and that we don't race with the new status of the reservation
> > > map. This is the whole point of the retry, and I don't see it being
> > > suboptimal.
> > 
> > I'm afraid that you don't explain why you need drop the lock for memory
> > allocation. Are you saying that this unlocking comes from the difference
> > between rwsem and spin lock?
> 
> Because you cannot go to sleep while holding a spinlock, which is
> exactly what kmalloc(GFP_KERNEL) can do. We *might* get a way with it
> with GFP_ATOMIC, I dunno, but I certainly prefer this approach better.

yup.  You could do

	foo = kmalloc(size, GFP_NOWAIT);
	if (!foo) {
		spin_unlock(...);
		foo = kmalloc(size, GFP_KERNEL);
		if (!foo)
			...
		spin_lock(...);
	}

that avoids the lock/unlock once per allocation.  But it also increases
the lock's average hold times....

		
