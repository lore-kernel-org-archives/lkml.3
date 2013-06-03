Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241Ab3FCXCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 19:02:45 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:44373 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758645Ab3FCXCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 19:02:39 -0400
From: Kent Overstreet <koverstreet@google.com>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH] percpu-refcount: Don't use silly cmpxchg()
Date: Mon,  3 Jun 2013 16:02:29 -0700
Message-Id: <1370300549-2177-1-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1370039205-14071-1-git-send-email-koverstreet@google.com>
References: <1370039205-14071-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cmpxcgh() was just to ensure the debug check didn't race, which was
a bit excessive. The caller is supposed to do the appropriate
synchronization, which means percpu_ref_kill() can just do a simple
store.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 lib/percpu-refcount.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
index e65820a..04be7ea 100644
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -107,22 +107,11 @@ static void percpu_ref_kill_rcu(struct rcu_head *rcu)
  */
 void percpu_ref_kill(struct percpu_ref *ref)
 {
-	unsigned __percpu *pcpu_count, *old, *new;
+	WARN_ONCE(REF_STATUS(ref->pcpu_count) == PCPU_REF_DEAD,
+		  "percpu_ref_kill() called more than once!\n");
 
-	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
-
-	do {
-		if (REF_STATUS(pcpu_count) == PCPU_REF_DEAD) {
-			WARN(1, "percpu_ref_kill() called more than once!\n");
-			return;
-		}
-
-		old = pcpu_count;
-		new = (unsigned __percpu *)
-			(((unsigned long) pcpu_count)|PCPU_REF_DEAD);
-
-		pcpu_count = cmpxchg(&ref->pcpu_count, old, new);
-	} while (pcpu_count != old);
+	ref->pcpu_count = (unsigned __percpu *)
+		(((unsigned long) ref->pcpu_count)|PCPU_REF_DEAD);
 
 	call_rcu(&ref->rcu, percpu_ref_kill_rcu);
 }
-- 
1.8.2.1

