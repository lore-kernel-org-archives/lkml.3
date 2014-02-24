Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbaBXDdu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 22:33:50 -0500
Received: from tundra.namei.org ([65.99.196.166]:39365 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422AbaBXDdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 22:33:49 -0500
Date: Mon, 24 Feb 2014 14:41:31 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] SELinux bugfix for current
Message-ID: <alpine.LRH.2.02.1402241440250.19008@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull this fix for the SELinux code.

The following changes since commit cfbf8d4857c26a8a307fb7cd258074c9dcd8c691:

  Linux 3.14-rc4 (2014-02-23 17:40:03 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

Eric Paris (1):
      SELinux: bigendian problems with filename trans rules

James Morris (1):
      Merge branch 'stable-3.14' of git://git.infradead.org/users/pcmoore/selinux into for-linus


---

 security/selinux/ss/policydb.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)
commit e4e027ea2d7a59819a0384c2d1031aafc5833903
Merge: cfbf8d4 9085a64
Author: James Morris <james.l.morris@oracle.com>
Date:   Mon Feb 24 14:40:16 2014 +1100

    Merge branch 'stable-3.14' of git://git.infradead.org/users/pcmoore/selinux into for-linus


commit 9085a6422900092886da8c404e1c5340c4ff1cbf
Author: Eric Paris <eparis@redhat.com>
Date:   Thu Feb 20 10:56:45 2014 -0500

    SELinux: bigendian problems with filename trans rules
    
    When writing policy via /sys/fs/selinux/policy I wrote the type and class
    of filename trans rules in CPU endian instead of little endian.  On
    x86_64 this works just fine, but it means that on big endian arch's like
    ppc64 and s390 userspace reads the policy and converts it from
    le32_to_cpu.  So the values are all screwed up.  Write the values in le
    format like it should have been to start.
    
    Signed-off-by: Eric Paris <eparis@redhat.com>
    Acked-by:  Stephen Smalley <sds@tycho.nsa.gov>
    Cc: stable@vger.kernel.org
    Signed-off-by: Paul Moore <pmoore@redhat.com>

diff --git a/security/selinux/ss/policydb.c b/security/selinux/ss/policydb.c
index c0f4988..9c5cdc2 100644
--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -3338,10 +3338,10 @@ static int filename_write_helper(void *key, void *data, void *ptr)
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
