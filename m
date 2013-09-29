Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab3I2PkF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 11:40:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38819 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473Ab3I2Pjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 11:39:42 -0400
From: John Johansen <john.johansen@canonical.com>
To: jmorris@namei.org
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
Subject: [PATCH 2/2] apparmor: fix suspicious RCU usage warning in policy.c/policy.h
Date: Sun, 29 Sep 2013 08:39:22 -0700
Message-Id: <1380469162-18604-3-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380469162-18604-1-git-send-email-john.johansen@canonical.com>
References: <1380469162-18604-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent 3.12 pull request for apparmor was missing a couple rcu _protected
access modifiers. Resulting in the follow suspicious RCU usage

 [   29.804534] [ INFO: suspicious RCU usage. ]
 [   29.804539] 3.11.0+ #5 Not tainted
 [   29.804541] -------------------------------
 [   29.804545] security/apparmor/include/policy.h:363 suspicious rcu_dereference_check() usage!
 [   29.804548]
 [   29.804548] other info that might help us debug this:
 [   29.804548]
 [   29.804553]
 [   29.804553] rcu_scheduler_active = 1, debug_locks = 1
 [   29.804558] 2 locks held by apparmor_parser/1268:
 [   29.804560]  #0:  (sb_writers#9){.+.+.+}, at: [<ffffffff81120a4c>] file_start_write+0x27/0x29
 [   29.804576]  #1:  (&ns->lock){+.+.+.}, at: [<ffffffff811f5d88>] aa_replace_profiles+0x166/0x57c
 [   29.804589]
 [   29.804589] stack backtrace:
 [   29.804595] CPU: 0 PID: 1268 Comm: apparmor_parser Not tainted 3.11.0+ #5
 [   29.804599] Hardware name: ASUSTeK Computer Inc.         UL50VT          /UL50VT    , BIOS 217     03/01/2010
 [   29.804602]  0000000000000000 ffff8800b95a1d90 ffffffff8144eb9b ffff8800b94db540
 [   29.804611]  ffff8800b95a1dc0 ffffffff81087439 ffff880138cc3a18 ffff880138cc3a18
 [   29.804619]  ffff8800b9464a90 ffff880138cc3a38 ffff8800b95a1df0 ffffffff811f5084
 [   29.804628] Call Trace:
 [   29.804636]  [<ffffffff8144eb9b>] dump_stack+0x4e/0x82
 [   29.804642]  [<ffffffff81087439>] lockdep_rcu_suspicious+0xfc/0x105
 [   29.804649]  [<ffffffff811f5084>] __aa_update_replacedby+0x53/0x7f
 [   29.804655]  [<ffffffff811f5408>] __replace_profile+0x11f/0x1ed
 [   29.804661]  [<ffffffff811f6032>] aa_replace_profiles+0x410/0x57c
 [   29.804668]  [<ffffffff811f16d4>] profile_replace+0x35/0x4c
 [   29.804674]  [<ffffffff81120fa3>] vfs_write+0xad/0x113
 [   29.804680]  [<ffffffff81121609>] SyS_write+0x44/0x7a
 [   29.804687]  [<ffffffff8145bfd2>] system_call_fastpath+0x16/0x1b
 [   29.804691]
 [   29.804694] ===============================
 [   29.804697] [ INFO: suspicious RCU usage. ]
 [   29.804700] 3.11.0+ #5 Not tainted
 [   29.804703] -------------------------------
 [   29.804706] security/apparmor/policy.c:566 suspicious rcu_dereference_check() usage!
 [   29.804709]
 [   29.804709] other info that might help us debug this:
 [   29.804709]
 [   29.804714]
 [   29.804714] rcu_scheduler_active = 1, debug_locks = 1
 [   29.804718] 2 locks held by apparmor_parser/1268:
 [   29.804721]  #0:  (sb_writers#9){.+.+.+}, at: [<ffffffff81120a4c>] file_start_write+0x27/0x29
 [   29.804733]  #1:  (&ns->lock){+.+.+.}, at: [<ffffffff811f5d88>] aa_replace_profiles+0x166/0x57c
 [   29.804744]
 [   29.804744] stack backtrace:
 [   29.804750] CPU: 0 PID: 1268 Comm: apparmor_parser Not tainted 3.11.0+ #5
 [   29.804753] Hardware name: ASUSTeK Computer Inc.         UL50VT          /UL50VT    , BIOS 217     03/01/2010
 [   29.804756]  0000000000000000 ffff8800b95a1d80 ffffffff8144eb9b ffff8800b94db540
 [   29.804764]  ffff8800b95a1db0 ffffffff81087439 ffff8800b95b02b0 0000000000000000
 [   29.804772]  ffff8800b9efba08 ffff880138cc3a38 ffff8800b95a1dd0 ffffffff811f4f94
 [   29.804779] Call Trace:
 [   29.804786]  [<ffffffff8144eb9b>] dump_stack+0x4e/0x82
 [   29.804791]  [<ffffffff81087439>] lockdep_rcu_suspicious+0xfc/0x105
 [   29.804798]  [<ffffffff811f4f94>] aa_free_replacedby_kref+0x4d/0x62
 [   29.804804]  [<ffffffff811f4f47>] ? aa_put_namespace+0x17/0x17
 [   29.804810]  [<ffffffff811f4f0b>] kref_put+0x36/0x40
 [   29.804816]  [<ffffffff811f5423>] __replace_profile+0x13a/0x1ed
 [   29.804822]  [<ffffffff811f6032>] aa_replace_profiles+0x410/0x57c
 [   29.804829]  [<ffffffff811f16d4>] profile_replace+0x35/0x4c
 [   29.804835]  [<ffffffff81120fa3>] vfs_write+0xad/0x113
 [   29.804840]  [<ffffffff81121609>] SyS_write+0x44/0x7a
 [   29.804847]  [<ffffffff8145bfd2>] system_call_fastpath+0x16/0x1b

Reported-by: miles.lane@gmail.com
CC: paulmck@linux.vnet.ibm.com
Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/include/policy.h | 4 +++-
 security/apparmor/policy.c         | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/include/policy.h b/security/apparmor/include/policy.h
index f2d4b63..c28b0f2 100644
--- a/security/apparmor/include/policy.h
+++ b/security/apparmor/include/policy.h
@@ -360,7 +360,9 @@ static inline void aa_put_replacedby(struct aa_replacedby *p)
 static inline void __aa_update_replacedby(struct aa_profile *orig,
 					  struct aa_profile *new)
 {
-	struct aa_profile *tmp = rcu_dereference(orig->replacedby->profile);
+	struct aa_profile *tmp;
+	tmp = rcu_dereference_protected(orig->replacedby->profile,
+					mutex_is_locked(&orig->ns->lock));
 	rcu_assign_pointer(orig->replacedby->profile, aa_get_profile(new));
 	orig->flags |= PFLAG_INVALID;
 	aa_put_profile(tmp);
diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index 6172509..345bec0 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -563,7 +563,8 @@ void __init aa_free_root_ns(void)
 static void free_replacedby(struct aa_replacedby *r)
 {
 	if (r) {
-		aa_put_profile(rcu_dereference(r->profile));
+		/* r->profile will not be updated any more as r is dead */
+		aa_put_profile(rcu_dereference_protected(r->profile, true));
 		kzfree(r);
 	}
 }
-- 
1.8.3.2

