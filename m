Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964904Ab3BMRwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:52:51 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:53488 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934544Ab3BMRws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:52:48 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sage Weil <sage@inktank.com>
Date: Wed, 13 Feb 2013 09:50:53 -0800
Message-Id: <1360777934-5663-4-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1+a+W+AZEwZzCoZxZmQV36WdAZB7GgezBQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3165]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 04/85] ceph: Convert struct ceph_mds_request to use kuid_t and kgid_t
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Hold the uid and gid for a pending ceph mds request using the types
kuid_t and kgid_t.  When a request message is finally created convert
the kuid_t and kgid_t values into uids and gids in the initial user
namespace.

Cc: Sage Weil <sage@inktank.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/ceph/mds_client.c |    4 ++--
 fs/ceph/mds_client.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 9165eb8..7a3dfe0 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1658,8 +1658,8 @@ static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
 
 	head->mdsmap_epoch = cpu_to_le32(mdsc->mdsmap->m_epoch);
 	head->op = cpu_to_le32(req->r_op);
-	head->caller_uid = cpu_to_le32(req->r_uid);
-	head->caller_gid = cpu_to_le32(req->r_gid);
+	head->caller_uid = cpu_to_le32(from_kuid(&init_user_ns, req->r_uid));
+	head->caller_gid = cpu_to_le32(from_kgid(&init_user_ns, req->r_gid));
 	head->args = req->r_args;
 
 	ceph_encode_filepath(&p, end, ino1, path1);
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index dd26846..ff4188b 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -184,8 +184,8 @@ struct ceph_mds_request {
 
 	union ceph_mds_request_args r_args;
 	int r_fmode;        /* file mode, if expecting cap */
-	uid_t r_uid;
-	gid_t r_gid;
+	kuid_t r_uid;
+	kgid_t r_gid;
 
 	/* for choosing which mds to send this request to */
 	int r_direct_mode;
-- 
1.7.5.4

