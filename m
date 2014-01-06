Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbaAFVSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 16:18:54 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:51708 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523AbaAFVSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 16:18:52 -0500
From: Kent Overstreet <kmo@daterainc.com>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH] percpu-refcount: Add a WARN() for ref going negative
Date: Mon,  6 Jan 2014 13:13:26 -0800
Message-Id: <1389042806-23967-1-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AIO had a missing get, which led to an ioctx leak - after percpu_ref_kill() the
ref was 0 so percpu_ref_put() never saw it hit 0.

This wasn't noticed at the time because it all happened completely silently,
this adds a WARN() which would've caught the aio bug.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Tejun Heo <tj@kernel.org>
---
 lib/percpu-refcount.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
index 1a53d497a8..32538f12f8 100644
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -120,6 +120,9 @@ static void percpu_ref_kill_rcu(struct rcu_head *rcu)
 
 	atomic_add((int) count - PCPU_COUNT_BIAS, &ref->count);
 
+	WARN(atomic_read(&ref->count) <= 0,
+	     "percpu ref <= 0 (%i)", atomic_read(&ref->count));
+
 	/* @ref is viewed as dead on all CPUs, send out kill confirmation */
 	if (ref->confirm_kill)
 		ref->confirm_kill(ref);
-- 
1.8.5.2

