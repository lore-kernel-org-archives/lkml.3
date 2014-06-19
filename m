Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965886AbaFSVO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:14:58 -0400
Received: from mail.kernel.org ([198.145.19.201]:34250 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965835AbaFSVOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:14:47 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/11] perf bench sched-messaging: Drop barf()
Date: Thu, 19 Jun 2014 18:13:53 -0300
Message-Id: <1403212433-2714-12-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403212433-2714-1-git-send-email-acme@kernel.org>
References: <1403212433-2714-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <davidlohr@hp.com>

Instead of reinventing the wheel, we can use err(2) when dealing with
fatal errors. Exit code is now always EXIT_FAILURE (1).

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Jiri Olsa <jolsa@kernel.org>
Link: http://lkml.kernel.org/r/1402942467-10671-9-git-send-email-davidlohr@hp.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bench/sched-messaging.c | 45 ++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 26 deletions(-)

diff --git a/tools/perf/bench/sched-messaging.c b/tools/perf/bench/sched-messaging.c
index fc4fe91ee098..52a56599a543 100644
--- a/tools/perf/bench/sched-messaging.c
+++ b/tools/perf/bench/sched-messaging.c
@@ -28,6 +28,7 @@
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
@@ -281,7 +274,7 @@ int bench_sched_messaging(int argc, const char **argv,
 
 	pth_tab = malloc(num_fds * 2 * num_groups * sizeof(pthread_t));
 	if (!pth_tab)
-		barf("main:malloc()");
+		err(EXIT_FAILURE, "main:malloc()");
 
 	fdpair(readyfds);
 	fdpair(wakefds);
@@ -294,13 +287,13 @@ int bench_sched_messaging(int argc, const char **argv,
 	/* Wait for everyone to be ready */
 	for (i = 0; i < total_children; i++)
 		if (read(readyfds[0], &dummy, 1) != 1)
-			barf("Reading for readyfds");
+			err(EXIT_FAILURE, "Reading for readyfds");
 
 	gettimeofday(&start, NULL);
 
 	/* Kick them off */
 	if (write(wakefds[1], &dummy, 1) != 1)
-		barf("Writing to start them");
+		err(EXIT_FAILURE, "Writing to start them");
 
 	/* Reap them all */
 	for (i = 0; i < total_children; i++)
-- 
1.9.3

