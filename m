Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab3AXThg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 14:37:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33741 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab3AXThe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 14:37:34 -0500
Date: Thu, 24 Jan 2013 11:37:14 -0800
From: tip-bot for Jovi Zhang <bookjovi@gmail.com>
Message-ID: <tip-d24d7dbf3cc49b00a152e55e24f0eeb173c7a971@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, srikar@linux.vnet.ibm.com, tglx@linutronix.de,
        namhyung@kernel.org, bookjovi@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, srikar@linux.vnet.ibm.com, tglx@linutronix.de,
        namhyung@kernel.org, bookjovi@gmail.com
In-Reply-To: <20130103004212.690763002@goodmis.org>
References: <20130103004212.690763002@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing:
  Verify target file before registering a uprobe event
Git-Commit-ID: d24d7dbf3cc49b00a152e55e24f0eeb173c7a971
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 11:37:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d24d7dbf3cc49b00a152e55e24f0eeb173c7a971
Gitweb:     http://git.kernel.org/tip/d24d7dbf3cc49b00a152e55e24f0eeb173c7a971
Author:     Jovi Zhang <bookjovi@gmail.com>
AuthorDate: Wed, 18 Jul 2012 18:16:44 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 21 Jan 2013 13:22:31 -0500

tracing: Verify target file before registering a uprobe event

Without this patch, we can register a uprobe event for a directory.
Enabling such a uprobe event would anyway fail.

Example:
$ echo 'p /bin:0x4245c0' > /sys/kernel/debug/tracing/uprobe_events

However dirctories cannot be valid targets for uprobe.
Hence verify if the target is a regular file during the probe
registration.

Link: http://lkml.kernel.org/r/20130103004212.690763002@goodmis.org

Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
[ cleaned up whitespace and removed redundant IS_DIR() check ]
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_uprobe.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index c86e6d4..87b6db4 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -258,6 +258,10 @@ static int create_trace_uprobe(int argc, char **argv)
 		goto fail_address_parse;
 
 	inode = igrab(path.dentry->d_inode);
+	if (!S_ISREG(inode->i_mode)) {
+		ret = -EINVAL;
+		goto fail_address_parse;
+	}
 
 	argc -= 2;
 	argv += 2;
@@ -356,7 +360,7 @@ fail_address_parse:
 	if (inode)
 		iput(inode);
 
-	pr_info("Failed to parse address.\n");
+	pr_info("Failed to parse address or file.\n");
 
 	return ret;
 }
