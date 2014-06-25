Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387AbaFYQDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 12:03:38 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:43406 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756887AbaFYQDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 12:03:37 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] tools: fix mq_open_tests compile warnings
Date: Wed, 25 Jun 2014 10:03:33 -0600
Message-Id: <1403712213-6529-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix several compile warnings - these are repeats like the ones
below:

gcc -O2 -lrt mq_open_tests.c -o mq_open_tests
mq_open_tests.c: In function ‘main’:
mq_open_tests.c:295:2: warning: format ‘%d’ expects argument of type ‘int’, but argument 2 has type ‘rlim_t’ [-Wformat=]
  printf("\tRLIMIT_MSGQUEUE(soft):\t\t%d\n", saved_limits.rlim_cur);
  ^
mq_open_tests.c: In function ‘shutdown’:
mq_open_tests.c:83:9: warning: ignoring return value of ‘seteuid’, declared with attribute warn_unused_result [-Wunused-result]
  seteuid(0);

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 tools/testing/selftests/mqueue/mq_open_tests.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/mqueue/mq_open_tests.c b/tools/testing/selftests/mqueue/mq_open_tests.c
index 711cc29..9c1a5d3 100644
--- a/tools/testing/selftests/mqueue/mq_open_tests.c
+++ b/tools/testing/selftests/mqueue/mq_open_tests.c
@@ -80,7 +80,8 @@ void shutdown(int exit_val, char *err_cause, int line_no)
 	if (in_shutdown++)
 		return;
 
-	seteuid(0);
+	if (seteuid(0) == -1)
+		perror("seteuid() failed");
 
 	if (queue != -1)
 		if (mq_close(queue))
@@ -292,8 +293,10 @@ int main(int argc, char *argv[])
 	/* Tell the user our initial state */
 	printf("\nInitial system state:\n");
 	printf("\tUsing queue path:\t\t%s\n", queue_path);
-	printf("\tRLIMIT_MSGQUEUE(soft):\t\t%d\n", saved_limits.rlim_cur);
-	printf("\tRLIMIT_MSGQUEUE(hard):\t\t%d\n", saved_limits.rlim_max);
+	printf("\tRLIMIT_MSGQUEUE(soft):\t\t%ld\n",
+		(long) saved_limits.rlim_cur);
+	printf("\tRLIMIT_MSGQUEUE(hard):\t\t%ld\n",
+		(long) saved_limits.rlim_max);
 	printf("\tMaximum Message Size:\t\t%d\n", saved_max_msgsize);
 	printf("\tMaximum Queue Size:\t\t%d\n", saved_max_msgs);
 	if (default_settings) {
@@ -308,8 +311,8 @@ int main(int argc, char *argv[])
 	validate_current_settings();
 
 	printf("Adjusted system state for testing:\n");
-	printf("\tRLIMIT_MSGQUEUE(soft):\t\t%d\n", cur_limits.rlim_cur);
-	printf("\tRLIMIT_MSGQUEUE(hard):\t\t%d\n", cur_limits.rlim_max);
+	printf("\tRLIMIT_MSGQUEUE(soft):\t\t%ld\n", (long) cur_limits.rlim_cur);
+	printf("\tRLIMIT_MSGQUEUE(hard):\t\t%ld\n", (long) cur_limits.rlim_max);
 	printf("\tMaximum Message Size:\t\t%d\n", cur_max_msgsize);
 	printf("\tMaximum Queue Size:\t\t%d\n", cur_max_msgs);
 	if (default_settings) {
@@ -454,7 +457,12 @@ int main(int argc, char *argv[])
 	else
 		printf("Queue open with total size > 2GB when euid = 0 "
 		       "failed:\t\t\tPASS\n");
-	seteuid(99);
+
+	if (seteuid(99) == -1) {
+		perror("seteuid() failed");
+		exit(1);
+	}
+
 	attr.mq_maxmsg = cur_max_msgs;
 	attr.mq_msgsize = cur_max_msgsize;
 	if (test_queue_fail(&attr, &result))
-- 
1.9.1

