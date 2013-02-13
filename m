Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965122Ab3BMR77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:59:59 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:59515 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760574Ab3BMR6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:58:06 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Wed, 13 Feb 2013 09:51:30 -0800
Message-Id: <1360777934-5663-41-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX18TaxCESqV2m1JEMmUU+sNVvkRyWqnTN28=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0170]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 41/85] nfs_common: Update the translation between nfsv3 acls linux posix acls
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

- Use kuid_t and kgit in struct nfsacl_encode_desc.
- Convert from kuids and kgids when generating on the wire values.
- Convert on the wire values to kuids and kgids when read.
- Modify cmp_acl_entry to be type safe comparison on posix acls.
  Only acls with type ACL_USER and ACL_GROUP can appear more
  than once and as such need to compare more than their tag.
- The e_id field is being removed from posix acls so don't initialize it.

Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/nfs_common/nfsacl.c |   41 ++++++++++++++++++++++++++---------------
 1 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/fs/nfs_common/nfsacl.c b/fs/nfs_common/nfsacl.c
index 6940439..ed628f7 100644
--- a/fs/nfs_common/nfsacl.c
+++ b/fs/nfs_common/nfsacl.c
@@ -38,8 +38,8 @@ struct nfsacl_encode_desc {
 	unsigned int count;
 	struct posix_acl *acl;
 	int typeflag;
-	uid_t uid;
-	gid_t gid;
+	kuid_t uid;
+	kgid_t gid;
 };
 
 struct nfsacl_simple_acl {
@@ -60,14 +60,16 @@ xdr_nfsace_encode(struct xdr_array2_desc *desc, void *elem)
 	*p++ = htonl(entry->e_tag | nfsacl_desc->typeflag);
 	switch(entry->e_tag) {
 		case ACL_USER_OBJ:
-			*p++ = htonl(nfsacl_desc->uid);
+			*p++ = htonl(from_kuid(&init_user_ns, nfsacl_desc->uid));
 			break;
 		case ACL_GROUP_OBJ:
-			*p++ = htonl(nfsacl_desc->gid);
+			*p++ = htonl(from_kgid(&init_user_ns, nfsacl_desc->gid));
 			break;
 		case ACL_USER:
+			*p++ = htonl(from_kuid(&init_user_ns, entry->e_uid));
+			break;
 		case ACL_GROUP:
-			*p++ = htonl(entry->e_id);
+			*p++ = htonl(from_kgid(&init_user_ns, entry->e_gid));
 			break;
 		default:  /* Solaris depends on that! */
 			*p++ = 0;
@@ -148,6 +150,7 @@ xdr_nfsace_decode(struct xdr_array2_desc *desc, void *elem)
 		(struct nfsacl_decode_desc *) desc;
 	__be32 *p = elem;
 	struct posix_acl_entry *entry;
+	unsigned int id;
 
 	if (!nfsacl_desc->acl) {
 		if (desc->array_len > NFS_ACL_MAX_ENTRIES)
@@ -160,14 +163,22 @@ xdr_nfsace_decode(struct xdr_array2_desc *desc, void *elem)
 
 	entry = &nfsacl_desc->acl->a_entries[nfsacl_desc->count++];
 	entry->e_tag = ntohl(*p++) & ~NFS_ACL_DEFAULT;
-	entry->e_id = ntohl(*p++);
+	id = ntohl(*p++);
 	entry->e_perm = ntohl(*p++);
 
 	switch(entry->e_tag) {
-		case ACL_USER_OBJ:
 		case ACL_USER:
-		case ACL_GROUP_OBJ:
+			entry->e_uid = make_kuid(&init_user_ns, id);
+			if (!uid_valid(entry->e_uid))
+				return -EINVAL;
+			break;
 		case ACL_GROUP:
+			entry->e_gid = make_kgid(&init_user_ns, id);
+			if (!gid_valid(entry->e_gid))
+				return -EINVAL;
+			break;
+		case ACL_USER_OBJ:
+		case ACL_GROUP_OBJ:
 		case ACL_OTHER:
 			if (entry->e_perm & ~S_IRWXO)
 				return -EINVAL;
@@ -190,9 +201,13 @@ cmp_acl_entry(const void *x, const void *y)
 
 	if (a->e_tag != b->e_tag)
 		return a->e_tag - b->e_tag;
-	else if (a->e_id > b->e_id)
+	else if ((a->e_tag == ACL_USER) && uid_gt(a->e_uid, b->e_uid))
+		return 1;
+	else if ((a->e_tag == ACL_USER) && uid_lt(a->e_uid, b->e_uid))
+		return -1;
+	else if ((a->e_tag == ACL_GROUP) && gid_gt(a->e_gid, b->e_gid))
 		return 1;
-	else if (a->e_id < b->e_id)
+	else if ((a->e_tag == ACL_GROUP) && gid_lt(a->e_gid, b->e_gid))
 		return -1;
 	else
 		return 0;
@@ -213,22 +228,18 @@ posix_acl_from_nfsacl(struct posix_acl *acl)
 	sort(acl->a_entries, acl->a_count, sizeof(struct posix_acl_entry),
 	     cmp_acl_entry, NULL);
 
-	/* Clear undefined identifier fields and find the ACL_GROUP_OBJ
-	   and ACL_MASK entries. */
+	/* Find the ACL_GROUP_OBJ and ACL_MASK entries. */
 	FOREACH_ACL_ENTRY(pa, acl, pe) {
 		switch(pa->e_tag) {
 			case ACL_USER_OBJ:
-				pa->e_id = ACL_UNDEFINED_ID;
 				break;
 			case ACL_GROUP_OBJ:
-				pa->e_id = ACL_UNDEFINED_ID;
 				group_obj = pa;
 				break;
 			case ACL_MASK:
 				mask = pa;
 				/* fall through */
 			case ACL_OTHER:
-				pa->e_id = ACL_UNDEFINED_ID;
 				break;
 		}
 	}
-- 
1.7.5.4

