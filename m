Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965430Ab3BMSQD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:16:03 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:56661 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965004Ab3BMR5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:57:54 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Wed, 13 Feb 2013 09:51:41 -0800
Message-Id: <1360777934-5663-52-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1+3DN4VVWCish/eI2aJqWLgx1GNx/+JhAA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ******;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 52/85] sunrpc: Properly encode kuids and kgids in auth.unix.gid rpc pipe upcalls.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

When a new rpc connection is established with an in-kernel server, the
traffic passes through svc_process_common, and svc_set_client and down
into svcauth_unix_set_client if it is of type RPC_AUTH_NULL or
RPC_AUTH_UNIX.

svcauth_unix_set_client then looks at the uid of the credential we
have assigned to the incomming client and if we don't have the groups
already cached makes an upcall to get a list of groups that the client
can use.

The upcall encodes send a rpc message to user space encoding the uid
of the user whose groups we want to know.  Encode the kuid of the user
in the initial user namespace as nfs mounts can only happen today in
the initial user namespace.

When a reply to an upcall comes in convert interpret the uid and gid values
from the rpc pipe as uids and gids in the initial user namespace and convert
them into kuids and kgids before processing them further.

When reading proc files listing the uid to gid list cache convert the
kuids and kgids from into uids and gids the initial user namespace.  As we are
displaying server internal details it makes sense to display these values
from the servers perspective.

Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 net/sunrpc/svcauth_unix.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/sunrpc/svcauth_unix.c b/net/sunrpc/svcauth_unix.c
index faf1719..bdea0a1 100644
--- a/net/sunrpc/svcauth_unix.c
+++ b/net/sunrpc/svcauth_unix.c
@@ -470,7 +470,7 @@ static void unix_gid_request(struct cache_detail *cd,
 	char tuid[20];
 	struct unix_gid *ug = container_of(h, struct unix_gid, h);
 
-	snprintf(tuid, 20, "%u", ug->uid);
+	snprintf(tuid, 20, "%u", from_kuid(&init_user_ns, ug->uid));
 	qword_add(bpp, blen, tuid);
 	(*bpp)[-1] = '\n';
 }
@@ -486,7 +486,8 @@ static int unix_gid_parse(struct cache_detail *cd,
 			char *mesg, int mlen)
 {
 	/* uid expiry Ngid gid0 gid1 ... gidN-1 */
-	int uid;
+	int id;
+	kuid_t uid;
 	int gids;
 	int rv;
 	int i;
@@ -498,9 +499,12 @@ static int unix_gid_parse(struct cache_detail *cd,
 		return -EINVAL;
 	mesg[mlen-1] = 0;
 
-	rv = get_int(&mesg, &uid);
+	rv = get_int(&mesg, &id);
 	if (rv)
 		return -EINVAL;
+	uid = make_kuid(&init_user_ns, id);
+	if (!uid_valid(uid))
+		return -EINVAL;
 	ug.uid = uid;
 
 	expiry = get_expiry(&mesg);
@@ -554,7 +558,7 @@ static int unix_gid_show(struct seq_file *m,
 			 struct cache_detail *cd,
 			 struct cache_head *h)
 {
-	struct user_namespace *user_ns = current_user_ns();
+	struct user_namespace *user_ns = &init_user_ns;
 	struct unix_gid *ug;
 	int i;
 	int glen;
@@ -570,7 +574,7 @@ static int unix_gid_show(struct seq_file *m,
 	else
 		glen = 0;
 
-	seq_printf(m, "%u %d:", ug->uid, glen);
+	seq_printf(m, "%u %d:", from_kuid_munged(user_ns, ug->uid), glen);
 	for (i = 0; i < glen; i++)
 		seq_printf(m, " %d", from_kgid_munged(user_ns, GROUP_AT(ug->gi, i)));
 	seq_printf(m, "\n");
-- 
1.7.5.4

