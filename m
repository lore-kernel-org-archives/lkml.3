Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815AbaICObZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 10:31:25 -0400
Received: from mail-yk0-f169.google.com ([209.85.160.169]:44865 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932536AbaICObY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 10:31:24 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Shuah Khan <shuahkh@osg.samsung.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-api@vger.kernel.org (open list:KERNEL SELFTEST F...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3] memfd_test: Make it work on 32-bit systems
Date: Wed,  3 Sep 2014 10:31:16 -0400
Message-Id: <1409754679-22667-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This test currently fails on 32-bit systems since we use u64 type to pass the
flags to fcntl.

This commit changes this to use 'unsigned int' type for flags to fcntl making it
work on 32-bit systems.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
---
 tools/testing/selftests/memfd/memfd_test.c | 34 ++++++++++++++----------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/memfd/memfd_test.c b/tools/testing/selftests/memfd/memfd_test.c
index 3634c90..cb5001b 100644
--- a/tools/testing/selftests/memfd/memfd_test.c
+++ b/tools/testing/selftests/memfd/memfd_test.c
@@ -59,9 +59,9 @@ static void mfd_fail_new(const char *name, unsigned int flags)
 	}
 }
 
-static __u64 mfd_assert_get_seals(int fd)
+static unsigned int mfd_assert_get_seals(int fd)
 {
-	long r;
+	int r;
 
 	r = fcntl(fd, F_GET_SEALS);
 	if (r < 0) {
@@ -69,50 +69,48 @@ static __u64 mfd_assert_get_seals(int fd)
 		abort();
 	}
 
-	return r;
+	return (unsigned int)r;
 }
 
-static void mfd_assert_has_seals(int fd, __u64 seals)
+static void mfd_assert_has_seals(int fd, unsigned int seals)
 {
-	__u64 s;
+	unsigned int s;
 
 	s = mfd_assert_get_seals(fd);
 	if (s != seals) {
-		printf("%llu != %llu = GET_SEALS(%d)\n",
-		       (unsigned long long)seals, (unsigned long long)s, fd);
+		printf("%u != %u = GET_SEALS(%d)\n", seals, s, fd);
 		abort();
 	}
 }
 
-static void mfd_assert_add_seals(int fd, __u64 seals)
+static void mfd_assert_add_seals(int fd, unsigned int seals)
 {
-	long r;
-	__u64 s;
+	int r;
+	unsigned int s;
 
 	s = mfd_assert_get_seals(fd);
 	r = fcntl(fd, F_ADD_SEALS, seals);
 	if (r < 0) {
-		printf("ADD_SEALS(%d, %llu -> %llu) failed: %m\n",
-		       fd, (unsigned long long)s, (unsigned long long)seals);
+		printf("ADD_SEALS(%d, %u -> %u) failed: %m\n", fd, s, seals);
 		abort();
 	}
 }
 
-static void mfd_fail_add_seals(int fd, __u64 seals)
+static void mfd_fail_add_seals(int fd, unsigned int seals)
 {
-	long r;
-	__u64 s;
+	int r;
+	unsigned int s;
 
 	r = fcntl(fd, F_GET_SEALS);
 	if (r < 0)
 		s = 0;
 	else
-		s = r;
+		s = (unsigned int)r;
 
 	r = fcntl(fd, F_ADD_SEALS, seals);
 	if (r >= 0) {
-		printf("ADD_SEALS(%d, %llu -> %llu) didn't fail as expected\n",
-		       fd, (unsigned long long)s, (unsigned long long)seals);
+		printf("ADD_SEALS(%d, %u -> %u) didn't fail as expected\n",
+				fd, s, seals);
 		abort();
 	}
 }
-- 
2.1.0

