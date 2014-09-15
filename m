Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202AbaIOWoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:44:22 -0400
Received: from qmta07.westchester.pa.mail.comcast.net ([76.96.62.64]:33210
	"EHLO qmta07.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759257AbaIOWk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:40:27 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        colin.king@canonical.com, dbueso@suse.de, ebiederm@xmission.com,
        serge.hallyn@ubuntu.com, thierry@linux.vnet.ibm.com,
        felipensp@gmail.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] selftests/ipc: change ipc test to use kselftest exit codes
Date: Mon, 15 Sep 2014 16:33:58 -0600
Message-Id: <1410820442-8774-4-git-send-email-shuahkh@osg.samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410820442-8774-1-git-send-email-shuahkh@osg.samsung.com>
References: <1410820442-8774-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change ipc test to use kselftest exit codes in kselftest.h
to report test results. With this change this test exits with
EXIT_FAIL instead of -errno. Changed print errno in test fail
messages to not loose that information.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 tools/testing/selftests/ipc/msgque.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/ipc/msgque.c b/tools/testing/selftests/ipc/msgque.c
index 552f081..2812017 100644
--- a/tools/testing/selftests/ipc/msgque.c
+++ b/tools/testing/selftests/ipc/msgque.c
@@ -5,6 +5,8 @@
 #include <linux/msg.h>
 #include <fcntl.h>
 
+#include "../kselftest.h"
+
 #define MAX_MSG_SIZE		32
 
 struct msg1 {
@@ -195,58 +197,58 @@ int main(int argc, char **argv)
 
 	if (getuid() != 0) {
 		printf("Please run the test as root - Exiting.\n");
-		exit(1);
+		exit(EXIT_FAIL);
 	}
 
 	msgque.key = ftok(argv[0], 822155650);
 	if (msgque.key == -1) {
-		printf("Can't make key\n");
-		return -errno;
+		printf("Can't make key: %d\n", -errno);
+		return EXIT_FAIL;
 	}
 
 	msgque.msq_id = msgget(msgque.key, IPC_CREAT | IPC_EXCL | 0666);
 	if (msgque.msq_id == -1) {
 		err = -errno;
-		printf("Can't create queue\n");
+		printf("Can't create queue: %d\n", err);
 		goto err_out;
 	}
 
 	err = fill_msgque(&msgque);
 	if (err) {
-		printf("Failed to fill queue\n");
+		printf("Failed to fill queue: %d\n", err);
 		goto err_destroy;
 	}
 
 	err = dump_queue(&msgque);
 	if (err) {
-		printf("Failed to dump queue\n");
+		printf("Failed to dump queue: %d\n", err);
 		goto err_destroy;
 	}
 
 	err = check_and_destroy_queue(&msgque);
 	if (err) {
-		printf("Failed to check and destroy queue\n");
+		printf("Failed to check and destroy queue: %d\n", err);
 		goto err_out;
 	}
 
 	err = restore_queue(&msgque);
 	if (err) {
-		printf("Failed to restore queue\n");
+		printf("Failed to restore queue: %d\n", err);
 		goto err_destroy;
 	}
 
 	err = check_and_destroy_queue(&msgque);
 	if (err) {
-		printf("Failed to test queue\n");
+		printf("Failed to test queue: %d\n", err);
 		goto err_out;
 	}
-	return 0;
+	return EXIT_PASS;
 
 err_destroy:
 	if (msgctl(msgque.msq_id, IPC_RMID, 0)) {
 		printf("Failed to destroy queue: %d\n", -errno);
-		return -errno;
+		return EXIT_FAIL;
 	}
 err_out:
-	return err;
+	return EXIT_FAIL;
 }
-- 
1.9.1

