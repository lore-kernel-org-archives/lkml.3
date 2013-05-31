Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab3EaVPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 17:15:50 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:55737 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301Ab3EaVPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 17:15:43 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] kprobes: handle empty/invalid input to debugfs "enabled" file
Date: Fri, 31 May 2013 23:15:10 +0200
Message-Id: <1370034910-16268-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When writing invalid input to 'debug/kprobes/enabled' it'll silently
be ignored. Even worse, when writing an empty string to this file,
the outcome is purely random as the switch statement will make its
decision based on the value of an uninitialized stack variable.

Fix this by handling invalid/empty input as error returning -EINVAL.

Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 kernel/kprobes.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 3fed7f0..948b597 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2322,6 +2322,7 @@ static ssize_t write_enabled_file_bool(struct file *file,
 	if (copy_from_user(buf, user_buf, buf_size))
 		return -EFAULT;
 
+	buf[buf_size] = '\0';
 	switch (buf[0]) {
 	case 'y':
 	case 'Y':
@@ -2333,6 +2334,8 @@ static ssize_t write_enabled_file_bool(struct file *file,
 	case '0':
 		disarm_all_kprobes();
 		break;
+	default:
+		return -EINVAL;
 	}
 
 	return count;
-- 
1.7.10.4

