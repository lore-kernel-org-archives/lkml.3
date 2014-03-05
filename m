Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111AbaCEOhA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:37:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41225 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757595AbaCEO0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:26:53 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Paris <eparis@redhat.com>, Paul Moore <pmoore@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 104/131] SELinux: bigendian problems with filename trans rules
Date: Wed,  5 Mar 2014 14:23:48 +0000
Message-Id: <1394029455-23128-105-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

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
index 7e5bced..4d35eb7 100644
--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -3261,10 +3261,10 @@ static int filename_write_helper(void *key, void *data, void *ptr)
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

