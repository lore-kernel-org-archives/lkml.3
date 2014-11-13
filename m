Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934161AbaKMT1N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 14:27:13 -0500
Received: from mail-yk0-f176.google.com ([209.85.160.176]:58447 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934046AbaKMTZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 14:25:27 -0500
From: Pranith Kumar <bobby.prani@gmail.com>
To: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org (open list)
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH 11/16] seccomp: Replace smp_read_barrier_depends() with lockless_dereference()
Date: Thu, 13 Nov 2014 14:24:17 -0500
Message-Id: <1415906662-4576-12-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
References: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently lockless_dereference() was added which can be used in place of
hard-coding smp_read_barrier_depends(). The following PATCH makes the change.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/seccomp.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 4ef9687..3729b06 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -175,17 +175,16 @@ static int seccomp_check_filter(struct sock_filter *filter, unsigned int flen)
  */
 static u32 seccomp_run_filters(struct seccomp_data *sd)
 {
-	struct seccomp_filter *f = ACCESS_ONCE(current->seccomp.filter);
 	struct seccomp_data sd_local;
 	u32 ret = SECCOMP_RET_ALLOW;
+	/* Make sure cross-thread synced filter points somewhere sane. */
+	struct seccomp_filter *f =
+			lockless_dereference(current->seccomp.filter);
 
 	/* Ensure unexpected behavior doesn't result in failing open. */
 	if (unlikely(WARN_ON(f == NULL)))
 		return SECCOMP_RET_KILL;
 
-	/* Make sure cross-thread synced filter points somewhere sane. */
-	smp_read_barrier_depends();
-
 	if (!sd) {
 		populate_seccomp_data(&sd_local);
 		sd = &sd_local;
-- 
1.9.1

