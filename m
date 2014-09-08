Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbaIHCMi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 22:12:38 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:46571 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbaIHCMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 22:12:32 -0400
From: Tejun Heo <tj@kernel.org>
To: cl@linux-foundation.org, kmo@daterainc.com
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/3] percpu-refcount: improve WARN messages
Date: Mon,  8 Sep 2014 11:12:20 +0900
Message-Id: <1410142342-8185-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410142342-8185-1-git-send-email-tj@kernel.org>
References: <1410142342-8185-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

percpu_ref's WARN messages can be a lot more helpful by indicating
who's the culprit.  Make them report the release function that the
offending percpu-refcount is associated with.  This should make it a
lot easier to track down the reported invalid refcnting operations.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <kmo@daterainc.com>
---
 lib/percpu-refcount.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
index ff99032..70d28c9 100644
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -145,8 +145,9 @@ static void percpu_ref_kill_rcu(struct rcu_head *rcu)
 
 	atomic_add((int) count - PCPU_COUNT_BIAS, &ref->count);
 
-	WARN_ONCE(atomic_read(&ref->count) <= 0, "percpu ref <= 0 (%i)",
-		  atomic_read(&ref->count));
+	WARN_ONCE(atomic_read(&ref->count) <= 0,
+		  "percpu ref (%pf) <= 0 (%i) after killed",
+		  ref->release, atomic_read(&ref->count));
 
 	/* @ref is viewed as dead on all CPUs, send out kill confirmation */
 	if (ref->confirm_kill)
@@ -178,7 +179,8 @@ void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
 				 percpu_ref_func_t *confirm_kill)
 {
 	WARN_ONCE(ref->pcpu_count_ptr & PCPU_REF_DEAD,
-		  "percpu_ref_kill() called more than once!\n");
+		  "percpu_ref_kill() called more than once on %pf!",
+		  ref->release);
 
 	ref->pcpu_count_ptr |= PCPU_REF_DEAD;
 	ref->confirm_kill = confirm_kill;
-- 
1.9.3

