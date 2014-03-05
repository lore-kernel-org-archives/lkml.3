Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085AbaCEOpO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:45:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41764 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932473AbaCEOiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:38:18 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Paris <eparis@redhat.com>, Paul Moore <pmoore@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 46/62] SELinux: bigendian problems with filename trans rules
Date: Wed,  5 Mar 2014 14:36:50 +0000
Message-Id: <1394030226-26652-47-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
References: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.32 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Paris <eparis@redhat.com>

commit 9085a6422900092886da8c404e1c5340c4ff1cbf upstream.

When writing policy via /sys/fs/selinux/policy I wrote the type and class
of filename trans rules in CPU endian instead of little endian.  On
x86_64 this works just fine, but it means that on big endian arch's like
ppc64 and s390 userspace reads the policy and converts it from
le32_to_cpu.  So the values are all screwed up.  Write the values in le
format like it should have been to start.

Signed-off-by: Eric Paris <eparis@redhat.com>
Acked-by:  Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Paul Moore <pmoore@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 security/selinux/ss/policydb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/security/selinux/ss/policydb.c b/security/selinux/ss/policydb.c
index 142a59f..bcdca73 100644
--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -3258,10 +3258,10 @@ static int filename_write_helper(void *key, void *data, void *ptr)
 	if (rc)
 		return rc;
 
-	buf[0] = ft->stype;
-	buf[1] = ft->ttype;
-	buf[2] = ft->tclass;
-	buf[3] = otype->otype;
+	buf[0] = cpu_to_le32(ft->stype);
+	buf[1] = cpu_to_le32(ft->ttype);
+	buf[2] = cpu_to_le32(ft->tclass);
+	buf[3] = cpu_to_le32(otype->otype);
 
 	rc = put_entry(buf, sizeof(u32), 4, fp);
 	if (rc)
-- 
1.9.0

