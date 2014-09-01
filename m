Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbaIARJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 13:09:25 -0400
Received: from mail-yk0-f170.google.com ([209.85.160.170]:34514 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbaIARJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 13:09:23 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        David Herrmann <dh.herrmann@gmail.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] memfd_test: Make it work on 32-bit systems
Date: Mon,  1 Sep 2014 13:08:59 -0400
Message-Id: <1409591342-16193-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This test currently fails on 32-bit systems since we use u64 type to pass the
flags to fcntl.

This commit changes this to use 'unsigned int' type for flags to fcntl making it
work on 32-bit systems.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
v2: use 'unsigned int' instead of u32

 tools/testing/selftests/memfd/memfd_test.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/memfd/memfd_test.c b/tools/testing/selftests/memfd/memfd_test.c
index 3634c90..6f1385a 100644
--- a/tools/testing/selftests/memfd/memfd_test.c
+++ b/tools/testing/selftests/memfd/memfd_test.c
@@ -59,9 +59,9 @@ static void mfd_fail_new(const char *name, unsigned int flags)
 	}
 }
 
-static __u64 mfd_assert_get_seals(int fd)
+static int mfd_assert_get_seals(int fd)
 {
-	long r;
+	int r;
 
 	r = fcntl(fd, F_GET_SEALS);
 	if (r < 0) {
@@ -72,36 +72,34 @@ static __u64 mfd_assert_get_seals(int fd)
 	return r;
 }
 
-static void mfd_assert_has_seals(int fd, __u64 seals)
+static void mfd_assert_has_seals(int fd, unsigned int seals)
 {
-	__u64 s;
+	int s;
 
 	s = mfd_assert_get_seals(fd);
 	if (s != seals) {
-		printf("%llu != %llu = GET_SEALS(%d)\n",
-		       (unsigned long long)seals, (unsigned long long)s, fd);
+		printf("%u != %u = GET_SEALS(%d)\n",
+				seals, (unsigned int)s, fd);
 		abort();
 	}
 }
 
-static void mfd_assert_add_seals(int fd, __u64 seals)
+static void mfd_assert_add_seals(int fd, unsigned int seals)
 {
-	long r;
-	__u64 s;
+	int r, s;
 
 	s = mfd_assert_get_seals(fd);
 	r = fcntl(fd, F_ADD_SEALS, seals);
 	if (r < 0) {
-		printf("ADD_SEALS(%d, %llu -> %llu) failed: %m\n",
-		       fd, (unsigned long long)s, (unsigned long long)seals);
+		printf("ADD_SEALS(%d, %u -> %u) failed: %m\n",
+				fd, (unsigned int)s, seals);
 		abort();
 	}
 }
 
-static void mfd_fail_add_seals(int fd, __u64 seals)
+static void mfd_fail_add_seals(int fd, unsigned int seals)
 {
-	long r;
-	__u64 s;
+	int r, s;
 
 	r = fcntl(fd, F_GET_SEALS);
 	if (r < 0)
@@ -111,8 +109,8 @@ static void mfd_fail_add_seals(int fd, __u64 seals)
 
 	r = fcntl(fd, F_ADD_SEALS, seals);
 	if (r >= 0) {
-		printf("ADD_SEALS(%d, %llu -> %llu) didn't fail as expected\n",
-		       fd, (unsigned long long)s, (unsigned long long)seals);
+		printf("ADD_SEALS(%d, %u -> %u) didn't fail as expected\n",
+				fd, (unsigned int)s, seals);
 		abort();
 	}
 }
-- 
2.1.0

