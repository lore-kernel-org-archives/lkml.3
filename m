Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbbAUHlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 02:41:22 -0500
Received: from ozlabs.org ([103.22.144.67]:34869 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbbAUHlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 02:41:14 -0500
From: Michael Ellerman <mpe@ellerman.id.au>
To: <linux-kernel@vger.kernel.org>
Cc: linux-api@vger.kernel.org, geert@linux-m68k.org, drysdale@google.com,
        shuahkh@osg.samsung.com, davej@codemonkey.org.uk
Subject: [PATCH] selftests/exec: Check if the syscall exists and bail if not
Date: Wed, 21 Jan 2015 18:41:00 +1100
Message-Id: <1421826060-2237-1-git-send-email-mpe@ellerman.id.au>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On systems which don't implement sys_execveat(), this test produces a
lot of output.

Add a check at the beginning to see if the syscall is present, and if
not just note one error and return.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 tools/testing/selftests/exec/execveat.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/exec/execveat.c b/tools/testing/selftests/exec/execveat.c
index e238c9559caf..b87e4a843bea 100644
--- a/tools/testing/selftests/exec/execveat.c
+++ b/tools/testing/selftests/exec/execveat.c
@@ -234,6 +234,14 @@ static int run_tests(void)
 	int fd_cloexec = open_or_die("execveat", O_RDONLY|O_CLOEXEC);
 	int fd_script_cloexec = open_or_die("script", O_RDONLY|O_CLOEXEC);
 
+	/* Check if we have execveat at all, and bail early if not */
+	errno = 0;
+	execveat_(-1, NULL, NULL, NULL, 0);
+	if (errno == -ENOSYS) {
+		printf("[FAIL] ENOSYS calling execveat - no kernel support?\n");
+		return 1;
+	}
+
 	/* Change file position to confirm it doesn't affect anything */
 	lseek(fd, 10, SEEK_SET);
 
-- 
2.1.0

