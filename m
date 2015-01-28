Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933513AbbA1BzU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:55:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41450 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933289AbbA1Bi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:38:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave.hansen@intel.com>,
        Theodore Tso <tytso@mit.edu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 48/77] include/linux/jump_label.h: expose the reference count
Date: Tue, 27 Jan 2015 17:27:26 -0800
Message-Id: <20150128012747.405238808@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012745.971137091@linuxfoundation.org>
References: <20150128012745.971137091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/jump_label.h |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -69,6 +69,10 @@ struct static_key {
 
 # include <asm/jump_label.h>
 # define HAVE_JUMP_LABEL
+#else
+struct static_key {
+	atomic_t enabled;
+};
 #endif	/* CC_HAVE_ASM_GOTO && CONFIG_JUMP_LABEL */
 
 enum jump_label_type {
@@ -79,6 +83,12 @@ enum jump_label_type {
 struct module;
 
 #include <linux/atomic.h>
+
+static inline int static_key_count(struct static_key *key)
+{
+	return atomic_read(&key->enabled);
+}
+
 #ifdef HAVE_JUMP_LABEL
 
 #define JUMP_LABEL_TYPE_FALSE_BRANCH	0UL
@@ -134,10 +144,6 @@ extern void jump_label_apply_nops(struct
 
 #else  /* !HAVE_JUMP_LABEL */
 
-struct static_key {
-	atomic_t enabled;
-};
-
 static __always_inline void jump_label_init(void)
 {
 	static_key_initialized = true;
@@ -145,14 +151,14 @@ static __always_inline void jump_label_i
 
 static __always_inline bool static_key_false(struct static_key *key)
 {
-	if (unlikely(atomic_read(&key->enabled) > 0))
+	if (unlikely(static_key_count(key) > 0))
 		return true;
 	return false;
 }
 
 static __always_inline bool static_key_true(struct static_key *key)
 {
-	if (likely(atomic_read(&key->enabled) > 0))
+	if (likely(static_key_count(key) > 0))
 		return true;
 	return false;
 }
@@ -194,7 +200,7 @@ static inline int jump_label_apply_nops(
 
 static inline bool static_key_enabled(struct static_key *key)
 {
-	return (atomic_read(&key->enabled) > 0);
+	return static_key_count(key) > 0;
 }
 
 #endif	/* _LINUX_JUMP_LABEL_H */


