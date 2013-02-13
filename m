Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965117Ab3BMR7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:59:41 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:49254 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965065Ab3BMR6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:58:06 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Date: Wed, 13 Feb 2013 09:51:19 -0800
Message-Id: <1360777934-5663-30-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX19QDBUtj1wybbGX4Wy+L2NnaLFfWqMqRb4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 30/85] gfs2: Introduce qd2index
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Both qd_alloc and qd2offset perform the exact same computation
to get an index from a gfs2_quota_data.   Make life a little
simpler and factor out this index computation.

Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/gfs2/quota.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index f8279ee..0e7c982 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -120,11 +120,17 @@ out:
 	return (atomic_read(&qd_lru_count) * sysctl_vfs_cache_pressure) / 100;
 }
 
+static u64 qd2index(struct gfs2_quota_data *qd)
+{
+	return (2 * (u64)qd->qd_id) +
+		test_bit(QDF_USER, &qd->qd_flags) ? 0 : 1;
+}
+
 static u64 qd2offset(struct gfs2_quota_data *qd)
 {
 	u64 offset;
 
-	offset = 2 * (u64)qd->qd_id + !test_bit(QDF_USER, &qd->qd_flags);
+	offset = qd2index(qd);
 	offset *= sizeof(struct gfs2_quota);
 
 	return offset;
@@ -147,7 +153,7 @@ static int qd_alloc(struct gfs2_sbd *sdp, int user, u32 id,
 	qd->qd_slot = -1;
 	INIT_LIST_HEAD(&qd->qd_reclaim);
 
-	error = gfs2_glock_get(sdp, 2 * (u64)id + !user,
+	error = gfs2_glock_get(sdp, qd2index(qd),
 			      &gfs2_quota_glops, CREATE, &qd->qd_gl);
 	if (error)
 		goto fail;
-- 
1.7.5.4

