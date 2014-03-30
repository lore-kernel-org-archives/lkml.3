Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbaC3Xyv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:54:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754530AbaC3Xn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:43:29 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Eric Paris" <eparis@redhat.com>,
        "Stephen Smalley" <sds@tycho.nsa.gov>,
        "Paul Moore" <pmoore@redhat.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.104240467@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 135/200] SELinux: bigendian problems with filename
 trans rules
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 security/selinux/ss/policydb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -3214,10 +3214,10 @@ static int filename_write_helper(void *k
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

