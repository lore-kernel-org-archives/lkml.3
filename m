Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389AbaCDUFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:05:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41814 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932365AbaCDUFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:05:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>,
        Paul Moore <pmoore@redhat.com>
Subject: [PATCH 3.10 80/97] SELinux: bigendian problems with filename trans rules
Date: Tue,  4 Mar 2014 12:04:33 -0800
Message-Id: <20140304200348.624354666@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200345.895517495@linuxfoundation.org>
References: <20140304200345.895517495@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/selinux/ss/policydb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -3258,10 +3258,10 @@ static int filename_write_helper(void *k
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


