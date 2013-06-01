Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab3FAHUo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 03:20:44 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:59110 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab3FAHUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 03:20:35 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Subject: [PATCH 2/2] f2fs: reorganise the function get_victim_by_default
Date: Sat,  1 Jun 2013 16:20:26 +0900
Message-Id: <1370071226-7749-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Fix the function get_victim_by_default, where it checks
for the condition  that p.min_segno != NULL_SEGNO as
shown:

if (p.min_segno != NULL_SEGNO)
           goto got_it;

and if above condition is true then

got_it:
        if (p.min_segno != NULL_SEGNO) {

So this condition is being checked twice. Hence move the goto
statement after the if condition so that duplication of condition
check is avoided.

Also this function makes a call to get_max_cost() to compute
the max cost based on the f2fs_sbi_info and victim policy. Since
get_max_cost depends on on three parameters of victim_sel_policy
=> alloc_mode, gc_mode & ofs_unit, once this victim policy is
initialised, these value will not change till the execution
time of get_victim_by_default() & also f2fs_sbi_info structure
parameters will not change.

Hence making calls to get_max_cost() in while loop does not seems to
be a good point. Instead we can call it once in begining and store
the results in local variable, which later can serve our purpose
for comparing the cost with max cost inside the while loop.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
---
 fs/f2fs/gc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index ddc2c67..3a9df36 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -241,14 +241,14 @@ static int get_victim_by_default(struct f2fs_sb_info *sbi,
 {
 	struct dirty_seglist_info *dirty_i = DIRTY_I(sbi);
 	struct victim_sel_policy p;
-	unsigned int secno;
+	unsigned int secno, max_cost;
 	int nsearched = 0;
 
 	p.alloc_mode = alloc_mode;
 	select_policy(sbi, gc_type, type, &p);
 
 	p.min_segno = NULL_SEGNO;
-	p.min_cost = get_max_cost(sbi, &p);
+	p.min_cost = max_cost = get_max_cost(sbi, &p);
 
 	mutex_lock(&dirty_i->seglist_lock);
 
@@ -287,7 +287,7 @@ static int get_victim_by_default(struct f2fs_sb_info *sbi,
 			p.min_cost = cost;
 		}
 
-		if (cost == get_max_cost(sbi, &p))
+		if (cost == max_cost)
 			continue;
 
 		if (nsearched++ >= MAX_VICTIM_SEARCH) {
@@ -295,8 +295,8 @@ static int get_victim_by_default(struct f2fs_sb_info *sbi,
 			break;
 		}
 	}
-got_it:
 	if (p.min_segno != NULL_SEGNO) {
+got_it:
 		if (p.alloc_mode == LFS) {
 			secno = GET_SECNO(sbi, p.min_segno);
 			if (gc_type == FG_GC)
-- 
1.7.9.5

