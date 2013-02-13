Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965384Ab3BMSSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:18:40 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:49105 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964899Ab3BMR5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:57:51 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Wed, 13 Feb 2013 09:51:39 -0800
Message-Id: <1360777934-5663-50-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX19q6uo5zFCyHDA3OXvWxTXegYcXEj2q19s=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 50/85] sunrpc: Hash uids by first computing their value in the initial userns
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

In svcauth_unix introduce a helper unix_gid_hash as otherwise the
expresion to generate the hash value is just too long.

Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 net/sunrpc/auth.c         |    2 +-
 net/sunrpc/svcauth_unix.c |    9 +++++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/sunrpc/auth.c b/net/sunrpc/auth.c
index 4cd0ecf..392adc4 100644
--- a/net/sunrpc/auth.c
+++ b/net/sunrpc/auth.c
@@ -412,7 +412,7 @@ rpcauth_lookup_credcache(struct rpc_auth *auth, struct auth_cred * acred,
 			*entry, *new;
 	unsigned int nr;
 
-	nr = hash_long(acred->uid, cache->hashbits);
+	nr = hash_long(from_kuid(&init_user_ns, acred->uid), cache->hashbits);
 
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(entry, pos, &cache->hashtable[nr], cr_hash) {
diff --git a/net/sunrpc/svcauth_unix.c b/net/sunrpc/svcauth_unix.c
index 92166b5..faf1719 100644
--- a/net/sunrpc/svcauth_unix.c
+++ b/net/sunrpc/svcauth_unix.c
@@ -419,6 +419,11 @@ struct unix_gid {
 	struct group_info	*gi;
 };
 
+static int unix_gid_hash(kuid_t uid)
+{
+	return hash_long(from_kuid(&init_user_ns, uid), GID_HASHBITS);
+}
+
 static void unix_gid_put(struct kref *kref)
 {
 	struct cache_head *item = container_of(kref, struct cache_head, ref);
@@ -530,7 +535,7 @@ static int unix_gid_parse(struct cache_detail *cd,
 		ug.h.expiry_time = expiry;
 		ch = sunrpc_cache_update(cd,
 					 &ug.h, &ugp->h,
-					 hash_long(uid, GID_HASHBITS));
+					 unix_gid_hash(uid));
 		if (!ch)
 			err = -ENOMEM;
 		else {
@@ -621,7 +626,7 @@ static struct unix_gid *unix_gid_lookup(struct cache_detail *cd, kuid_t uid)
 	struct cache_head *ch;
 
 	ug.uid = uid;
-	ch = sunrpc_cache_lookup(cd, &ug.h, hash_long(uid, GID_HASHBITS));
+	ch = sunrpc_cache_lookup(cd, &ug.h, unix_gid_hash(uid));
 	if (ch)
 		return container_of(ch, struct unix_gid, h);
 	else
-- 
1.7.5.4

