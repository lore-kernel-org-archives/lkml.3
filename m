Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638Ab3EBAkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 20:40:20 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:64261 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758527Ab3EBAkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 20:40:00 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        vgoyal@redhat.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/31] blkcg: fix error return path in blkg_create()
Date: Wed,  1 May 2013 17:39:19 -0700
Message-Id: <1367455189-6957-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1367455189-6957-1-git-send-email-tj@kernel.org>
References: <1367455189-6957-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In blkg_create(), after lookup of parent fails, the control jumps to
error path with the error code encoded into @blkg.  The error path
doesn't use @blkg for the return value.  It returns ERR_PTR(ret).
Make lookup fail path set @ret instead of @blkg.

Note that the parent lookup is guaranteed to succeed at that point and
the condition check is purely for sanity and triggers WARN when fails.
As such, I don't think it's necessary to mark it for -stable.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index b2b9837..0ab211a 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -238,7 +238,7 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
 	if (blkcg_parent(blkcg)) {
 		blkg->parent = __blkg_lookup(blkcg_parent(blkcg), q, false);
 		if (WARN_ON_ONCE(!blkg->parent)) {
-			blkg = ERR_PTR(-EINVAL);
+			ret = -EINVAL;
 			goto err_put_css;
 		}
 		blkg_get(blkg->parent);
-- 
1.8.1.4

