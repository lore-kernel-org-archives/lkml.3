Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015AbaBEQp6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 11:45:58 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:57710 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbaBEQp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 11:45:57 -0500
Date: Wed, 5 Feb 2014 11:45:43 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH -v2 4/6] memcg: make sure that memcg is not offline when
 charging
Message-ID: <20140205164543.GZ6963@cmpxchg.org>
References: <1391520540-17436-1-git-send-email-mhocko@suse.cz>
 <1391520540-17436-5-git-send-email-mhocko@suse.cz>
 <20140204162939.GP6963@cmpxchg.org>
 <20140205133834.GB2425@dhcp22.suse.cz>
 <20140205152821.GY6963@cmpxchg.org>
 <20140205161940.GE2425@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140205161940.GE2425@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 05, 2014 at 05:19:40PM +0100, Michal Hocko wrote:
> On Wed 05-02-14 10:28:21, Johannes Weiner wrote:
> > Here is the only exception to the above: swapout records maintain
> > permanent css references, so they prevent css_free() from running.
> > For that reason alone we should run one optimistic reparenting in
> > css_offline() to make sure one swap record does not pin gigabytes of
> > pages in an offlined cgroup, which is unreachable for reclaim.  But
> 
> How can reparenting help for swapped out pages? Or did you mean to at
> least get rid of swapcache pages?

I was thinking primarily of page cache.  There could be a lot of it
left in the group and once css_tryget() is disabled we can't reclaim
it anymore.  So we'd clean that out at offline time optimistically and
at css_free() we catch any charges raced that showed up afterwards.
