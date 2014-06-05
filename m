Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbaFETgm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 15:36:42 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:43077 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbaFETgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 15:36:40 -0400
Date: Thu, 5 Jun 2014 15:36:37 -0400
From: Tejun Heo <tj@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>,
        Roman Gushchin <klamm@yandex-team.ru>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v2 0/4] memcg: Low-limit reclaim
Message-ID: <20140605193637.GA31654@mtj.dyndns.org>
References: <20140528134905.GF2878@cmpxchg.org>
 <20140528142144.GL9895@dhcp22.suse.cz>
 <20140528152854.GG2878@cmpxchg.org>
 <20140528155414.GN9895@dhcp22.suse.cz>
 <20140528163335.GI2878@cmpxchg.org>
 <20140603110743.GD1321@dhcp22.suse.cz>
 <20140603142249.GP2878@cmpxchg.org>
 <20140604144658.GB17612@dhcp22.suse.cz>
 <20140604154408.GT2878@cmpxchg.org>
 <alpine.LSU.2.11.1406041218080.9583@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1406041218080.9583@eggly.anvils>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

On Wed, Jun 04, 2014 at 12:18:59PM -0700, Hugh Dickins wrote:
> that it is more comfortable with OOMing as the default.  Okay.  But I
> would expect there to be many who want the attempt towards isolation that
> low limit offers, without a collapse to OOM at the first misjudgement.

Ignoring all the mm details about NUMA, zones, overcommit or whatnot,
solely focusing on the core feature provided by the interface, which
BTW is what should guide the interface design anyway, I'm curious
about how this would end up.

The first thing which strikes me is that it's not symmetric with the
limits.  We have two of them - soft and hard limits.  A hard limit
provides the absolute boundary which can't be exceeded while a soft
limit, in principle, gives a guideline on memory usage of the group to
the kernel so that its behavior can be better suited to the purpose of
the system.

We still seem to have a number of issues with the semantics of
softlimit but its principle role makes sense to me.  It allows
userland to provide additional information or hints on how resource
allocation should be managed across different groups and as such can
be used for rule-of-thumb, this-will-prolly-work kind of easy /
automatic configuration, which is a very useful thing.  Can be a lot
more widely useful than hard limits in the long term.

It seems that the main suggested use case for soft guarantee is
"reasonable" isolation, which seems symmetric to the role of soft
limit; however, if I think about it more, I'm not sure whether such
usage would make sense.

The thing with softlimit is that it doesn't affect resource allocation
until the limit is hit.  The system keeps memory distribution balanced
and useful through reclaiming less useful stuff and that part isn't
adversely affected by softlimit.  This means that softlimit
configuration is relaxed in both directions.  It doesn't have to be
completely accurate.  It can be good enough or "reasonable" and still
useful without affecting the whole system adversely.

However, soft guarantee isn't like that.  Because it disables reclaim
completely until the guaranteed amount is reached which many workloads
wouldn't have trouble filling up over time, the configuration isn't
relaxed downwards.  Any configured value adversely affects the overall
efficiency of the system, which in turn breaks the "reasonable"
isolation use case because such usages require the configuration to be
not punishing by default.

So, that's where I think the symmetry breaks.  The direction of the
pressure the guarantee exerts makes it punishing for the system by
default, which means that it can't be a generally useful thing which
can be widely configured with should-be-good-enough values.  It
inherently is something which requires a lot more attention and thus a
lot less useful (at least its usefulness is a lot narrower).

As soft limit has been misused to provide guarantee, I think it's a
healthy thing to separate it out and implement it properly and I
probably am not very qualified to make calls on mm decisions; however,
I strongly think that we should think through the actual use cases
before deciding which features and interface we expose to userland.
They better make sense and are actually useful.  I strongly believe
that failure to do so had been one of the main reasons why we got
burned so badly with cgroup in general.  Let's please not repeat that.
If this is useful, let's find out why and how and crystailize the
interface for those usages.

Thanks.

-- 
tejun
