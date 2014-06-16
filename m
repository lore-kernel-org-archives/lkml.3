Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932867AbaFPSPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:15:43 -0400
Received: from g6t1524.atlanta.hp.com ([15.193.200.67]:51150 "EHLO
	g6t1524.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932852AbaFPSPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:15:41 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: acme@kernel.org, jolsa@kernel.org
Cc: mitake@dcl.info.waseda.ac.jp, davidlohr@hp.com, aswin@hp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8/9] perf bench: sched-messaging: Drop barf()
Date: Mon, 16 Jun 2014 11:14:26 -0700
Message-Id: <1402942467-10671-9-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1402942467-10671-1-git-send-email-davidlohr@hp.com>
References: <1402942467-10671-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of reinventing the wheel, we can use err(2) when dealing
with fatal errors. Exit code is now always EXIT_FAILURE (1).

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 tools/perf/bench/sched-messaging.c | 45 ++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 26 deletions(-)

diff --git a/tools/perf/bench/sched-messaging.c b/tools/perf/bench/sched-messaging.c
index b519ba4..bf5645e 100644
--- a/tools/perf/bench/sched-messaging.c
+++ b/tools/perf/bench/sched-messaging.c
@@ -27,6 +27,7 @@
 #include <sys/time.h>
 #include <sys/poll.h>
 #include <limits.h>
+#include <err.h>
 
 #define DATASIZE 100
 
@@ -50,12 +51,6 @@ struct receiver_context {
 	int wakefd;
 };
 
-static void barf(const char *msg)
-{
-	fprintf(stderr, "%s (error: %s)\n", msg, strerror(errno));
-	exit(1);
-}
-
 static void fdpair(int fds[2])
 {
 	if (use_pipes) {
@@ -66,7 +61,7 @@ static void fdpair(int fds[2])
 			return;
 	}
 
-	barf(use_pipes ? "pipe()" : "socketpair()");
+	err(EXIT_FAILURE, use_pipes ? "pipe()" : "socketpair()");
 }
 
 /* Block until we're ready to go */
@@ -77,11 +72,11 @@ static void ready(int ready_out, int wakefd)
 
 	/* Tell them we're ready. */
 	if (write(ready_out, &dummy, 1) != 1)
-		barf("CLIENT: ready write");
+		err(EXIT_FAILURE, "CLIENT: ready write");
 
 	/* Wait for "GO" signal */
 	if (poll(&pollfd, 1, -1) != 1)
-		barf("poll");
+		err(EXIT_FAILURE, "poll");
 }
 
 /* Sender sprays loops messages down each file descriptor */
@@ -101,7 +96,7 @@ again:
 			ret = write(ctx->out_fds[j], data + done,
 				    sizeof(data)-done);
 			if (ret < 0)
-				barf("SENDER: write");
+				err(EXIT_FAILURE, "SENDER: write");
 			done += ret;
 			if (done < DATASIZE)
 				goto again;
@@ -131,7 +126,7 @@ static void *receiver(struct receiver_context* ctx)
 again:
 		ret = read(ctx->in_fds[0], data + done, DATASIZE - done);
 		if (ret < 0)
-			barf("SERVER: read");
+			err(EXIT_FAILURE, "SERVER: read");
 		done += ret;
 		if (done < DATASIZE)
 			goto again;
@@ -144,14 +139,14 @@ static pthread_t create_worker(void *ctx, void *(*func)(void *))
 {
 	pthread_attr_t attr;
 	pthread_t childid;
-	int err;
+	int ret;
 
 	if (!thread_mode) {
 		/* process mode */
 		/* Fork the receiver. */
 		switch (fork()) {
 		case -1:
-			barf("fork()");
+			err(EXIT_FAILURE, "fork()");
 			break;
 		case 0:
 			(*func) (ctx);
@@ -165,19 +160,17 @@ static pthread_t create_worker(void *ctx, void *(*func)(void *))
 	}
 
 	if (pthread_attr_init(&attr) != 0)
-		barf("pthread_attr_init:");
+		err(EXIT_FAILURE, "pthread_attr_init:");
 
 #ifndef __ia64__
 	if (pthread_attr_setstacksize(&attr, PTHREAD_STACK_MIN) != 0)
-		barf("pthread_attr_setstacksize");
+		err(EXIT_FAILURE, "pthread_attr_setstacksize");
 #endif
 
-	err = pthread_create(&childid, &attr, func, ctx);
-	if (err != 0) {
-		fprintf(stderr, "pthread_create failed: %s (%d)\n",
-			strerror(err), err);
-		exit(-1);
-	}
+	ret = pthread_create(&childid, &attr, func, ctx);
+	if (ret != 0)
+		err(EXIT_FAILURE, "pthread_create failed");
+
 	return childid;
 }
 
@@ -207,14 +200,14 @@ static unsigned int group(pthread_t *pth,
 			+ num_fds * sizeof(int));
 
 	if (!snd_ctx)
-		barf("malloc()");
+		err(EXIT_FAILURE, "malloc()");
 
 	for (i = 0; i < num_fds; i++) {
 		int fds[2];
 		struct receiver_context *ctx = malloc(sizeof(*ctx));
 
 		if (!ctx)
-			barf("malloc()");
+			err(EXIT_FAILURE, "malloc()");
 
 
 		/* Create the pipe between client and server */
@@ -303,7 +296,7 @@ int bench_sched_messaging(int argc, const char **argv,
 
 	pth_tab = malloc(num_fds * 2 * num_groups * sizeof(pthread_t));
 	if (!pth_tab)
-		barf("main:malloc()");
+		err(EXIT_FAILURE, "main:malloc()");
 
 	if (bench_format == BENCH_FORMAT_DEFAULT) {
 		printf("# %d sender and receiver %s per group\n",
@@ -327,13 +320,13 @@ int bench_sched_messaging(int argc, const char **argv,
 		/* Wait for everyone to be ready */
 		for (i = 0; i < total_children; i++)
 			if (read(readyfds[0], &dummy, 1) != 1)
-				barf("Reading for readyfds");
+				err(EXIT_FAILURE, "Reading for readyfds");
 
 		gettimeofday(&start, NULL);
 
 		/* Kick them off */
 		if (write(wakefds[1], &dummy, 1) != 1)
-			barf("Writing to start them");
+			err(EXIT_FAILURE, "Writing to start them");
 
 		/* Reap them all */
 		for (i = 0; i < total_children; i++)
-- 
1.8.1.4

