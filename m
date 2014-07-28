Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbaG1Nb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:31:28 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:63558 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbaG1N3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:29:22 -0400
From: Alex Elder <elder@linaro.org>
To: akpm@linux-foundation.org
Cc: kay@vrfy.org, pmladek@suse.cz, john.stultz@linaro.org, jack@suse.cz,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 2/7] printk: insert newline for truncated records
Date: Mon, 28 Jul 2014 08:29:15 -0500
Message-Id: <1406554160-9562-3-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406554160-9562-1-git-send-email-elder@linaro.org>
References: <1406554160-9562-1-git-send-email-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a log record has LOG_PREFIX set, its predecessor record should be
terminated if it was marked LOG_CONT.

In msg_print_text(), this condition was being ignored, which would
lead to such records showing up combined when reading /dev/kmsg.
Fix this oversight.

Suggested-by: Petr Mládek <pmladek@suse.cz>
Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Petr Mládek <pmladek@suse.cz>
---
 kernel/printk/printk.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index ffc9928..7dfa658 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1013,6 +1013,12 @@ static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
 			newline = false;
 	}
 
+	if ((prev & LOG_CONT) && (msg->flags & LOG_PREFIX) && len < size) {
+		if (buf)
+			buf[len++] = '\n';
+		else
+			len++;
+	}
 	do {
 		const char *next = memchr(text, '\n', text_size);
 		size_t text_len;
-- 
1.9.1

