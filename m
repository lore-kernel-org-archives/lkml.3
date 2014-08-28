Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbaH1Stf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:49:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32876 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151AbaH1ShA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:37:00 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 70/97] include/linux/jump_label.h: expose the reference count
Date: Thu, 28 Aug 2014 19:35:18 +0100
Message-Id: <1409250945-30874-71-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit ea5e9539abf1258f23e725cb9cb25aa74efa29eb upstream.

This patch exposes the jump_label reference count in preparation for the
next patch.  cpusets cares about both the jump_label being enabled and how
many users of the cpusets there currently are.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 include/linux/jump_label.h | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index a507907..9216e46 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -62,6 +62,10 @@ struct static_key {
 
 # include <asm/jump_label.h>
 # define HAVE_JUMP_LABEL
+#else
+struct static_key {
+	atomic_t enabled;
+};
 #endif	/* CC_HAVE_ASM_GOTO && CONFIG_JUMP_LABEL */
 
 enum jump_label_type {
@@ -72,6 +76,12 @@ enum jump_label_type {
 struct module;
 
 #include <linux/atomic.h>
+
+static inline int static_key_count(struct static_key *key)
+{
+	return atomic_read(&key->enabled);
+}
+
 #ifdef HAVE_JUMP_LABEL
 
 #define JUMP_LABEL_TRUE_BRANCH 1UL
@@ -122,24 +132,20 @@ extern void jump_label_apply_nops(struct module *mod);
 
 #else  /* !HAVE_JUMP_LABEL */
 
-struct static_key {
-	atomic_t enabled;
-};
-
 static __always_inline void jump_label_init(void)
 {
 }
 
 static __always_inline bool static_key_false(struct static_key *key)
 {
-	if (unlikely(atomic_read(&key->enabled)) > 0)
+	if (unlikely(static_key_count(key) > 0))
 		return true;
 	return false;
 }
 
 static __always_inline bool static_key_true(struct static_key *key)
 {
-	if (likely(atomic_read(&key->enabled)) > 0)
+	if (likely(static_key_count(key) > 0))
 		return true;
 	return false;
 }
@@ -179,7 +185,7 @@ static inline int jump_label_apply_nops(struct module *mod)
 
 static inline bool static_key_enabled(struct static_key *key)
 {
-	return (atomic_read(&key->enabled) > 0);
+	return static_key_count(key) > 0;
 }
 
 #endif	/* _LINUX_JUMP_LABEL_H */
-- 
1.8.4.5

