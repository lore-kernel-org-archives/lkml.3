Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaFFOrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 10:47:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55284 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbaFFOrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 10:47:24 -0400
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, Tejun Heo <tj@kernel.org>,
        Roman Gushchin <klamm@yandex-team.ru>,
        LKML <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH 1/2] mm, memcg: allow OOM if no memcg is eligible during direct reclaim
Date: Fri,  6 Jun 2014 16:46:49 +0200
Message-Id: <1402066010-25901-1-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140606144421.GE26253@dhcp22.suse.cz>
References: <20140606144421.GE26253@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there is no memcg eligible for reclaim because all groups under the
reclaimed hierarchy are within their guarantee then the global direct
reclaim would end up in the endless loop because zones in the zonelists
are not considered unreclaimable (as per all_unreclaimable) and so the
OOM killer would never fire and direct reclaim would be triggered
without no chance to reclaim anything.

This is not possible yet because reclaim falls back to ignore low_limit
when nobody is eligible for reclaim. Following patch will allow to set
the fallback mode to hard guarantee, though, so this is a preparatory
patch.

Memcg reclaim doesn't suffer from this because the OOM killer is
triggered after few unsuccessful attempts of the reclaim.

Fix this by checking the number of scanned pages which is obviously 0 if
nobody is eligible and also check that the whole tree hierarchy is not
eligible and tell OOM it can go ahead.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/vmscan.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8041b0667673..99137aecd95f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2570,6 +2570,13 @@ out:
 	if (aborted_reclaim)
 		return 1;
 
+	/*
+	 * If the target memcg is not eligible for reclaim then we have no option
+	 * but OOM
+	 */
+	if (!sc->nr_scanned && mem_cgroup_all_within_guarantee(sc->target_mem_cgroup))
+		return 0;
+
 	/* top priority shrink_zones still had more to do? don't OOM, then */
 	if (global_reclaim(sc) && !all_unreclaimable(zonelist, sc))
 		return 1;
-- 
2.0.0

