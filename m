Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab3BFIT2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 03:19:28 -0500
Received: from ozlabs.org ([203.10.76.45]:49933 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab3BFIT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 03:19:26 -0500
From: Michael Ellerman <michael@ellerman.id.au>
To: <penberg@kernel.org>
Cc: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/6] kvm tools: Rework stdio/stdout handling to support redirection
Date: Wed,  6 Feb 2013 19:19:13 +1100
Message-Id: <1360138756-1991-3-git-send-email-michael@ellerman.id.au>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360138756-1991-1-git-send-email-michael@ellerman.id.au>
References: <1360138756-1991-1-git-send-email-michael@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently if you redirect the output from "lkvm run" to a file then
term_init() will fail, because it can't call the terminal ioctls.

So check if stdin and stdout are ttys, if either is not then skip the
rest of the terminal setup. Redirecting one but not the other is a
little odd, but does work.

Note that we skip registering the cleanup routines, so we don't need to
modify them.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 tools/kvm/term.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/tools/kvm/term.c b/tools/kvm/term.c
index 4413450..fa85e4a 100644
--- a/tools/kvm/term.c
+++ b/tools/kvm/term.c
@@ -140,6 +140,15 @@ int term_init(struct kvm *kvm)
 	struct termios term;
 	int i, r;
 
+	for (i = 0; i < 4; i++)
+		if (term_fds[i][TERM_FD_IN] == 0) {
+			term_fds[i][TERM_FD_IN] = STDIN_FILENO;
+			term_fds[i][TERM_FD_OUT] = STDOUT_FILENO;
+		}
+
+	if (!isatty(STDIN_FILENO) || !isatty(STDOUT_FILENO))
+		return 0;
+
 	r = tcgetattr(STDIN_FILENO, &orig_term);
 	if (r < 0) {
 		pr_warning("unable to save initial standard input settings");
@@ -151,12 +160,6 @@ int term_init(struct kvm *kvm)
 	term.c_lflag &= ~(ICANON | ECHO | ISIG);
 	tcsetattr(STDIN_FILENO, TCSANOW, &term);
 
-	for (i = 0; i < 4; i++)
-		if (term_fds[i][TERM_FD_IN] == 0) {
-			term_fds[i][TERM_FD_IN] = STDIN_FILENO;
-			term_fds[i][TERM_FD_OUT] = STDOUT_FILENO;
-		}
-
 	signal(SIGTERM, term_sig_cleanup);
 	atexit(term_cleanup);
 
-- 
1.7.10.4

