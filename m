Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab3KBV2A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 17:28:00 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:55085 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489Ab3KBV1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 17:27:45 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Pax Team <pageexec@freemail.hu>,
        Brad Spengler <spender@grsecurity.net>, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 2/2] ipc, msg: forbid negative values for "msgmax"
Date: Sat,  2 Nov 2013 22:26:39 +0100
Message-Id: <1383427599-1980-3-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1383427599-1980-1-git-send-email-minipli@googlemail.com>
References: <1383427599-1980-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Negative message lengths make no sense, prevent them from being set.
They do more harm than gain.

In case a user wants to have "unlimited" message sizes she should
just use INT_MAX instead.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 ipc/ipc_sysctl.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/ipc/ipc_sysctl.c b/ipc/ipc_sysctl.c
index 130dfec..76823b8 100644
--- a/ipc/ipc_sysctl.c
+++ b/ipc/ipc_sysctl.c
@@ -158,9 +158,7 @@ static int proc_ipcauto_dointvec_minmax(ctl_table *table, int write,
 
 static int zero;
 static int one = 1;
-#ifdef CONFIG_CHECKPOINT_RESTORE
 static int int_max = INT_MAX;
-#endif
 
 static struct ctl_table ipc_kern_table[] = {
 	{
@@ -198,7 +196,9 @@ static struct ctl_table ipc_kern_table[] = {
 		.data		= &init_ipc_ns.msg_ctlmax,
 		.maxlen		= sizeof (init_ipc_ns.msg_ctlmax),
 		.mode		= 0644,
-		.proc_handler	= proc_ipc_dointvec,
+		.proc_handler	= proc_ipc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &int_max,
 	},
 	{
 		.procname	= "msgmni",
-- 
1.7.10.4

