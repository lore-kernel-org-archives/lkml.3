Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaEBLWd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 07:22:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50008 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbaEBLWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 07:22:32 -0400
Date: Fri, 2 May 2014 13:22:29 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, Tejun Heo <tj@kernel.org>,
        Hugh Dickins <hughd@google.com>, Roman Gushchin <klamm@yandex-team.ru>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH v2 0/4] memcg: Low-limit reclaim
Message-ID: <20140502112229.GF3446@dhcp22.suse.cz>
References: <1398688005-26207-1-git-send-email-mhocko@suse.cz>
 <20140430145910.c080164bc198485730d82ee0@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140430145910.c080164bc198485730d82ee0@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 30-04-14 14:59:10, Andrew Morton wrote:
> On Mon, 28 Apr 2014 14:26:41 +0200 Michal Hocko <mhocko@suse.cz> wrote:
> 
> > The series is based on top of the current mmotm tree. Once the series
> > gets accepted I will post a patch which will mark the soft limit as
> > deprecated with a note that it will be eventually dropped. Let me know
> > if you would prefer to have such a patch a part of the series.
> 
> Yes please, we may as well get it all in there.
---
>From 01d74f2034b871e591b238ce1652c9f5ef7c1bd2 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Fri, 2 May 2014 13:16:57 +0200
Subject: [PATCH] memcg: mark soft limit as deprecated

Now that we have low limit reclaim the soft limit reclaim should be
deprecated and not longer used. Print an information about this into the
log and mention it also in the memcg documentation.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 Documentation/cgroups/memory.txt | 7 +++++++
 mm/memcontrol.c                  | 9 +++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index 9bc3325e99ce..7f3a7414bdf2 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -652,6 +652,13 @@ heavily contended for, memory is allocated based on the soft limit
 hints/setup. Currently soft limit based reclaim is set up such that
 it gets invoked from balance_pgdat (kswapd).
 
+NOTE:
+Soft limit is considered deprecated and will be removed later.
+low_limit_in_bytes should be used instead. The main difference between
+the two is that the soft limit hammers groups over the selected limit to
+prevent reclaiming from other groups while low_limit excludes groups under
+the limit from reclaim and reclaim others.
+
 7.1 Interface
 
 Soft limits can be setup by using the following commands (in this example we
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 53193fec8c50..7a276c0d141e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5162,10 +5162,15 @@ static int mem_cgroup_write(struct cgroup_subsys_state *css, struct cftype *cft,
 		 * of semantics, for now, we support soft limits for
 		 * control without swap
 		 */
-		if (type == _MEM)
+		if (type == _MEM) {
+			pr_info("soft_limit_in_bytes is deprecated and should ");
+			pr_cont("be replaced by low_limit_in_bytes. Please let ");
+			pr_cont("us know if that doesn't work for you at ");
+			pr_cont("linux-mm@kvack.org\n");
 			ret = res_counter_set_soft_limit(&memcg->res, val);
-		else
+		} else {
 			ret = -EINVAL;
+		}
 		break;
 	default:
 		ret = -EINVAL; /* should be BUG() ? */
-- 
2.0.0.rc0

-- 
Michal Hocko
SUSE Labs
