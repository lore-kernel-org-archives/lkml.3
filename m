Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbaFYFwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 01:52:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36354 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaFYFwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 01:52:42 -0400
Date: Tue, 24 Jun 2014 22:52:22 -0700
From: tip-bot for Davidlohr Bueso <tipbot@zytor.com>
Message-ID: <tip-ecdac96899e3db3f428e4d2e978f25e3f8d35a6c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@kernel.org, mitake@dcl.info.waseda.ac.jp,
        tglx@linutronix.de, davidlohr@hp.com, aswin@hp.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, jolsa@kernel.org, mitake@dcl.info.waseda.ac.jp,
        tglx@linutronix.de, davidlohr@hp.com, aswin@hp.com
In-Reply-To: <1402942467-10671-9-git-send-email-davidlohr@hp.com>
References: <1402942467-10671-9-git-send-email-davidlohr@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf bench sched-messaging: Drop barf()
Git-Commit-ID: ecdac96899e3db3f428e4d2e978f25e3f8d35a6c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ecdac96899e3db3f428e4d2e978f25e3f8d35a6c
Gitweb:     http://git.kernel.org/tip/ecdac96899e3db3f428e4d2e978f25e3f8d35a6c
Author:     Davidlohr Bueso <davidlohr@hp.com>
AuthorDate: Mon, 16 Jun 2014 11:14:26 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Jun 2014 16:13:17 -0300

perf bench sched-messaging: Drop barf()

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
index fc4fe91..52a5659 100644
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
