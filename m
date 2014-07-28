Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375AbaG1JcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 05:32:12 -0400
Received: from mx2.parallels.com ([199.115.105.18]:38361 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbaG1JcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 05:32:05 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <hannes@cmpxchg.org>, <mhocko@suse.cz>, <glommer@gmail.com>,
        <david@fromorbit.com>, <viro@zeniv.linux.org.uk>, <gthelen@google.com>,
        <mgorman@suse.de>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm 6/6] memcg: iterator: do not skip offline css
Date: Mon, 28 Jul 2014 13:31:28 +0400
Message-ID: <8406fefb5d1d05c775ff27613c49e104ecd7f409.1406536261.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1406536261.git.vdavydov@parallels.com>
References: <cover.1406536261.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After offline, memcg may still host kmem objects, which must be shrinked
on memory pressure.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 mm/memcontrol.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1030bba4b94f..bf55088f0152 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1100,8 +1100,7 @@ skip_node:
 	 */
 	if (next_css) {
 		if ((next_css == &root->css) ||
-		    ((next_css->flags & CSS_ONLINE) &&
-		     css_tryget_online(next_css)))
+		    css_tryget(next_css))
 			return mem_cgroup_from_css(next_css);
 
 		prev_css = next_css;
@@ -1147,7 +1146,7 @@ mem_cgroup_iter_load(struct mem_cgroup_reclaim_iter *iter,
 		 * would be returned all the time.
 		 */
 		if (position && position != root &&
-		    !css_tryget_online(&position->css))
+		    !css_tryget(&position->css))
 			position = NULL;
 	}
 	return position;
-- 
1.7.10.4

