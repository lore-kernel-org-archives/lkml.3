Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694AbaAUTmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 14:42:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44044 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbaAUTmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 14:42:20 -0500
Date: Tue, 21 Jan 2014 11:42:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Greg Thelen <gthelen@google.com>, <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 2/2] memcg: fix css reference leak and endless loop
 in mem_cgroup_iter
Message-Id: <20140121114219.8c34256dfbe7c2470b36ced8@linux-foundation.org>
In-Reply-To: <1390301143-9541-2-git-send-email-mhocko@suse.cz>
References: <20140121083454.GA1894@dhcp22.suse.cz>
	<1390301143-9541-1-git-send-email-mhocko@suse.cz>
	<1390301143-9541-2-git-send-email-mhocko@suse.cz>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jan 2014 11:45:43 +0100 Michal Hocko <mhocko@suse.cz> wrote:

> 19f39402864e (memcg: simplify mem_cgroup_iter) has reorganized
> mem_cgroup_iter code in order to simplify it. A part of that change was
> dropping an optimization which didn't call css_tryget on the root of
> the walked tree. The patch however didn't change the css_put part in
> mem_cgroup_iter which excludes root.
> This wasn't an issue at the time because __mem_cgroup_iter_next bailed
> out for root early without taking a reference as cgroup iterators
> (css_next_descendant_pre) didn't visit root themselves.
> 
> Nevertheless cgroup iterators have been reworked to visit root by
> bd8815a6d802 (cgroup: make css_for_each_descendant() and friends include
> the origin css in the iteration) when the root bypass have been dropped
> in __mem_cgroup_iter_next. This means that css_put is not called for
> root and so css along with mem_cgroup and other cgroup internal object
> tied by css lifetime are never freed.
> 
> Fix the issue by reintroducing root check in __mem_cgroup_iter_next
> and do not take css reference for it.
> 
> This reference counting magic protects us also from another issue, an
> endless loop reported by Hugh Dickins when reclaim races with root
> removal and css_tryget called by iterator internally would fail. There
> would be no other nodes to visit so __mem_cgroup_iter_next would return
> NULL and mem_cgroup_iter would interpret it as "start looping from root
> again" and so mem_cgroup_iter would loop forever internally.

I grabbed these two patches but I will sit on them for a week or so,
pending review-n-test.

> Cc: stable@vger.kernel.org # mem_leak part 3.12+

What does this mean?
