Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965277Ab3BMSUH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:20:07 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:56575 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964931Ab3BMR5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:57:49 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>
Date: Wed, 13 Feb 2013 09:51:10 -0800
Message-Id: <1360777934-5663-21-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1/0KVfkfg5Uy2h5mjSkbj5AIhsBN3T4h+Y=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0028]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 21/85] ocfs2: Handle kuids and kgids in acl/xattr conversions.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Explicitly deal with the different kinds of acls because they need
different conversions.

Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/ocfs2/acl.c |   31 +++++++++++++++++++++++++++++--
 1 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
index 260b162..8a40457 100644
--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -65,7 +65,20 @@ static struct posix_acl *ocfs2_acl_from_xattr(const void *value, size_t size)
 
 		acl->a_entries[n].e_tag  = le16_to_cpu(entry->e_tag);
 		acl->a_entries[n].e_perm = le16_to_cpu(entry->e_perm);
-		acl->a_entries[n].e_id   = le32_to_cpu(entry->e_id);
+		switch(acl->a_entries[n].e_tag) {
+		case ACL_USER:
+			acl->a_entries[n].e_uid =
+				make_kuid(&init_user_ns,
+					  le32_to_cpu(entry->e_id));
+			break;
+		case ACL_GROUP:
+			acl->a_entries[n].e_gid =
+				make_kgid(&init_user_ns,
+					  le32_to_cpu(entry->e_id));
+			break;
+		default:
+			break;
+		}
 		value += sizeof(struct posix_acl_entry);
 
 	}
@@ -91,7 +104,21 @@ static void *ocfs2_acl_to_xattr(const struct posix_acl *acl, size_t *size)
 	for (n = 0; n < acl->a_count; n++, entry++) {
 		entry->e_tag  = cpu_to_le16(acl->a_entries[n].e_tag);
 		entry->e_perm = cpu_to_le16(acl->a_entries[n].e_perm);
-		entry->e_id   = cpu_to_le32(acl->a_entries[n].e_id);
+		switch(acl->a_entries[n].e_tag) {
+		case ACL_USER:
+			entry->e_id = cpu_to_le32(
+				from_kuid(&init_user_ns,
+					  acl->a_entries[n].e_uid));
+			break;
+		case ACL_GROUP:
+			entry->e_id = cpu_to_le32(
+				from_kgid(&init_user_ns,
+					  acl->a_entries[n].e_gid));
+			break;
+		default:
+			entry->e_id = cpu_to_le32(ACL_UNDEFINED_ID);
+			break;
+		}
 	}
 	return ocfs2_acl;
 }
-- 
1.7.5.4

