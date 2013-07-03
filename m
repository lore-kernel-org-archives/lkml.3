Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933592Ab3GCTlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:41:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933249Ab3GCTjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:39:07 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH] Change SIGPIPE's siginfo.si_code from SI_USER to SI_KERNEL.
Date: Wed,  3 Jul 2013 21:38:55 +0200
Message-Id: <1372880335-23755-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SI_USER means that this signal is sent by another process
via kill(2) et al.

Other cases when kernel sends signals, such as ^C,
SIGHUP on tty close, SIGXCPU when time limit is up,
SIGALRM from alarm(2) etc, we set si_code to SI_KERNEL.

SIGPIPE seems to be inconsistent here.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: Oleg Nesterov <oleg@redhat.com>
---
 fs/fuse/dev.c | 2 +-
 fs/pipe.c     | 4 ++--
 fs/splice.c   | 8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 1d55f94..de55774 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1340,7 +1340,7 @@ static ssize_t fuse_dev_splice_read(struct file *in, loff_t *ppos,
 	pipe_lock(pipe);
 
 	if (!pipe->readers) {
-		send_sig(SIGPIPE, current, 0);
+		send_sig(SIGPIPE, current, 1);
 		if (!ret)
 			ret = -EPIPE;
 		goto out_unlock;
diff --git a/fs/pipe.c b/fs/pipe.c
index d2c45e1..ddd777e 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -514,7 +514,7 @@ pipe_write(struct kiocb *iocb, const struct iovec *_iov,
 	__pipe_lock(pipe);
 
 	if (!pipe->readers) {
-		send_sig(SIGPIPE, current, 0);
+		send_sig(SIGPIPE, current, 1);
 		ret = -EPIPE;
 		goto out;
 	}
@@ -563,7 +563,7 @@ redo1:
 		int bufs;
 
 		if (!pipe->readers) {
-			send_sig(SIGPIPE, current, 0);
+			send_sig(SIGPIPE, current, 1);
 			if (!ret)
 				ret = -EPIPE;
 			break;
diff --git a/fs/splice.c b/fs/splice.c
index 3b7ee65..1eb18da 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -197,7 +197,7 @@ ssize_t splice_to_pipe(struct pipe_inode_info *pipe,
 
 	for (;;) {
 		if (!pipe->readers) {
-			send_sig(SIGPIPE, current, 0);
+			send_sig(SIGPIPE, current, 1);
 			if (!ret)
 				ret = -EPIPE;
 			break;
@@ -1812,7 +1812,7 @@ static int opipe_prep(struct pipe_inode_info *pipe, unsigned int flags)
 
 	while (pipe->nrbufs >= pipe->buffers) {
 		if (!pipe->readers) {
-			send_sig(SIGPIPE, current, 0);
+			send_sig(SIGPIPE, current, 1);
 			ret = -EPIPE;
 			break;
 		}
@@ -1863,7 +1863,7 @@ retry:
 
 	do {
 		if (!opipe->readers) {
-			send_sig(SIGPIPE, current, 0);
+			send_sig(SIGPIPE, current, 1);
 			if (!ret)
 				ret = -EPIPE;
 			break;
@@ -1967,7 +1967,7 @@ static int link_pipe(struct pipe_inode_info *ipipe,
 
 	do {
 		if (!opipe->readers) {
-			send_sig(SIGPIPE, current, 0);
+			send_sig(SIGPIPE, current, 1);
 			if (!ret)
 				ret = -EPIPE;
 			break;
-- 
1.8.1.4

