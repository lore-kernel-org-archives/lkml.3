Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab3I2Xxc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 19:53:32 -0400
Received: from tundra.namei.org ([65.99.196.166]:58893 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210Ab3I2Xxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 19:53:30 -0400
Date: Mon, 30 Sep 2013 09:55:56 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Johansen <john.johansen@canonical.com>
Subject: [GIT] Apparmor fixes for 3.12
Message-ID: <alpine.LRH.2.02.1309300954330.19399@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull these bugfixes for the Apparmor code, for regressions 
introduced in the 3.12 pull request.

The following changes since commit 15c03dd4859ab16f9212238f29dd315654aa94f6:

  Linux 3.12-rc3 (2013-09-29 15:02:38 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

John Johansen (1):
      apparmor: fix suspicious RCU usage warning in policy.c/policy.h

Tyler Hicks (1):
      apparmor: Use shash crypto API interface for profile hashes

 security/apparmor/crypto.c         |   34 ++++++++++++++++------------------
 security/apparmor/include/policy.h |    4 +++-
 security/apparmor/policy.c         |    3 ++-
 3 files changed, 21 insertions(+), 20 deletions(-)


commit 4cd4fc77032dca46fe7475d81461e29145db247a
Author: John Johansen <john.johansen@canonical.com>
Date:   Sun Sep 29 08:39:22 2013 -0700

    apparmor: fix suspicious RCU usage warning in policy.c/policy.h
    
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
    Signed-off-by: James Morris <james.l.morris@oracle.com>

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

commit 71ac7f6255c560716c20da8ee2c964bbd96e941f
Author: Tyler Hicks <tyhicks@canonical.com>
Date:   Sun Sep 29 08:39:21 2013 -0700

    apparmor: Use shash crypto API interface for profile hashes
    
    Use the shash interface, rather than the hash interface, when hashing
    AppArmor profiles. The shash interface does not use scatterlists and it
    is a better fit for what AppArmor needs.
    
    This fixes a kernel paging BUG when aa_calc_profile_hash() is passed a
    buffer from vmalloc(). The hash interface requires callers to handle
    vmalloc() buffers differently than what AppArmor was doing. Due to
    vmalloc() memory not being physically contiguous, each individual page
    behind the buffer must be assigned to a scatterlist with sg_set_page()
    and then the scatterlist passed to crypto_hash_update().
    
    The shash interface does not have that limitation and allows vmalloc()
    and kmalloc() buffers to be handled in the same manner.
    
    BugLink: https://launchpad.net/bugs/1216294/
    BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=62261
    
    Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
    Acked-by: Seth Arnold <seth.arnold@canonical.com>
    Signed-off-by: John Johansen <john.johansen@canonical.com>
    Signed-off-by: James Morris <james.l.morris@oracle.com>

diff --git a/security/apparmor/crypto.c b/security/apparmor/crypto.c
index d6222ba..532471d 100644
--- a/security/apparmor/crypto.c
+++ b/security/apparmor/crypto.c
@@ -15,14 +15,14 @@
  * it should be.
  */
 
-#include <linux/crypto.h>
+#include <crypto/hash.h>
 
 #include "include/apparmor.h"
 #include "include/crypto.h"
 
 static unsigned int apparmor_hash_size;
 
-static struct crypto_hash *apparmor_tfm;
+static struct crypto_shash *apparmor_tfm;
 
 unsigned int aa_hash_size(void)
 {
@@ -32,35 +32,33 @@ unsigned int aa_hash_size(void)
 int aa_calc_profile_hash(struct aa_profile *profile, u32 version, void *start,
 			 size_t len)
 {
-	struct scatterlist sg[2];
-	struct hash_desc desc = {
-		.tfm = apparmor_tfm,
-		.flags = 0
-	};
+	struct {
+		struct shash_desc shash;
+		char ctx[crypto_shash_descsize(apparmor_tfm)];
+	} desc;
 	int error = -ENOMEM;
 	u32 le32_version = cpu_to_le32(version);
 
 	if (!apparmor_tfm)
 		return 0;
 
-	sg_init_table(sg, 2);
-	sg_set_buf(&sg[0], &le32_version, 4);
-	sg_set_buf(&sg[1], (u8 *) start, len);
-
 	profile->hash = kzalloc(apparmor_hash_size, GFP_KERNEL);
 	if (!profile->hash)
 		goto fail;
 
-	error = crypto_hash_init(&desc);
+	desc.shash.tfm = apparmor_tfm;
+	desc.shash.flags = 0;
+
+	error = crypto_shash_init(&desc.shash);
 	if (error)
 		goto fail;
-	error = crypto_hash_update(&desc, &sg[0], 4);
+	error = crypto_shash_update(&desc.shash, (u8 *) &le32_version, 4);
 	if (error)
 		goto fail;
-	error = crypto_hash_update(&desc, &sg[1], len);
+	error = crypto_shash_update(&desc.shash, (u8 *) start, len);
 	if (error)
 		goto fail;
-	error = crypto_hash_final(&desc, profile->hash);
+	error = crypto_shash_final(&desc.shash, profile->hash);
 	if (error)
 		goto fail;
 
@@ -75,19 +73,19 @@ fail:
 
 static int __init init_profile_hash(void)
 {
-	struct crypto_hash *tfm;
+	struct crypto_shash *tfm;
 
 	if (!apparmor_initialized)
 		return 0;
 
-	tfm = crypto_alloc_hash("sha1", 0, CRYPTO_ALG_ASYNC);
+	tfm = crypto_alloc_shash("sha1", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(tfm)) {
 		int error = PTR_ERR(tfm);
 		AA_ERROR("failed to setup profile sha1 hashing: %d\n", error);
 		return error;
 	}
 	apparmor_tfm = tfm;
-	apparmor_hash_size = crypto_hash_digestsize(apparmor_tfm);
+	apparmor_hash_size = crypto_shash_digestsize(apparmor_tfm);
 
 	aa_info_message("AppArmor sha1 policy hashing enabled");
 
