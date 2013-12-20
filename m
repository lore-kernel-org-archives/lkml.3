Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418Ab3LTJlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 04:41:45 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:56182 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547Ab3LTJlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 04:41:40 -0500
X-AuditID: 85900ec0-d3b2cb9000001514-c1-52b410d1be90
Subject: [PATCH 1/2] printk: Add dictionary information in structure cont
To: linux-kernel@vger.kernel.org
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Eiichi Tsukata <eiichi.tsukata.xh@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Tejun Heo <tj@kernel.org>, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Date: Fri, 20 Dec 2013 18:41:37 +0900
Message-ID: <20131220094137.24233.46216.stgit@yunodevel>
In-Reply-To: <20131220094134.24233.2969.stgit@yunodevel>
References: <20131220094134.24233.2969.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dictionary information in structure cont.
Dictionary information is added when a driver uses structured printk, and the
information is shown in /dev/kmsg. Current kernel directly stores the
information to log_buf. This patch stores the dict information in structure cont
first, then the information in cont is stored to log_buf.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org
---
 kernel/printk/printk.c |   70 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 47 insertions(+), 23 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index be7c86b..c3662e6 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1391,8 +1391,10 @@ static inline void printk_delay(void)
  * reached the console in case of a kernel crash.
  */
 static struct cont {
-	char buf[LOG_LINE_MAX];
-	size_t len;			/* length == 0 means unused buffer */
+	char text[LOG_LINE_MAX];
+	size_t text_len;		/* length == 0 means unused buffer */
+	char dict[LOG_LINE_MAX];	/* stores dict */
+	size_t dict_len;		/* 0 means dict is unstored */
 	size_t cons;			/* bytes written to console */
 	struct task_struct *owner;	/* task of first print*/
 	u64 ts_nsec;			/* time of first print */
@@ -1406,7 +1408,7 @@ static void cont_flush(enum log_flags flags)
 {
 	if (cont.flushed)
 		return;
-	if (cont.len == 0)
+	if (cont.text_len == 0)
 		return;
 
 	if (cont.cons) {
@@ -1416,7 +1418,7 @@ static void cont_flush(enum log_flags flags)
 		 * line. LOG_NOCONS suppresses a duplicated output.
 		 */
 		log_store(cont.facility, cont.level, flags | LOG_NOCONS,
-			  cont.ts_nsec, NULL, 0, cont.buf, cont.len);
+			  cont.ts_nsec, NULL, 0, cont.text, cont.text_len);
 		cont.flags = flags;
 		cont.flushed = true;
 	} else {
@@ -1425,23 +1427,32 @@ static void cont_flush(enum log_flags flags)
 		 * just submit it to the store and free the buffer.
 		 */
 		log_store(cont.facility, cont.level, flags, 0,
-			  NULL, 0, cont.buf, cont.len);
-		cont.len = 0;
+			  NULL, 0, cont.text, cont.text_len);
+		cont.text_len = 0;
 	}
 }
 
-static bool cont_add(int facility, int level, const char *text, size_t len)
+static void cont_dict_add(const char *dict, size_t dict_len)
 {
-	if (cont.len && cont.flushed)
+	if (cont.dict_len + dict_len > sizeof(cont.dict))
+		return;
+
+	memcpy(cont.dict + cont.dict_len, dict, dict_len);
+	cont.dict_len += dict_len;
+}
+
+static bool cont_add(int facility, int level, const char *text, size_t text_len)
+{
+	if (cont.text_len && cont.flushed)
 		return false;
 
-	if (cont.len + len > sizeof(cont.buf)) {
+	if (cont.text_len + text_len > sizeof(cont.text)) {
 		/* the line gets too long, split it up in separate records */
 		cont_flush(LOG_CONT);
 		return false;
 	}
 
-	if (!cont.len) {
+	if (!cont.text_len) {
 		cont.facility = facility;
 		cont.level = level;
 		cont.owner = current;
@@ -1451,10 +1462,10 @@ static bool cont_add(int facility, int level, const char *text, size_t len)
 		cont.flushed = false;
 	}
 
-	memcpy(cont.buf + cont.len, text, len);
-	cont.len += len;
+	memcpy(cont.text + cont.text_len, text, text_len);
+	cont.text_len += text_len;
 
-	if (cont.len > (sizeof(cont.buf) * 80) / 100)
+	if (cont.text_len > (sizeof(cont.text) * 80) / 100)
 		cont_flush(LOG_CONT);
 
 	return true;
@@ -1470,20 +1481,20 @@ static size_t cont_print_text(char *text, size_t size)
 		size -= textlen;
 	}
 
-	len = cont.len - cont.cons;
+	len = cont.text_len - cont.cons;
 	if (len > 0) {
 		if (len+1 > size)
 			len = size-1;
-		memcpy(text + textlen, cont.buf + cont.cons, len);
+		memcpy(text + textlen, cont.text + cont.cons, len);
 		textlen += len;
-		cont.cons = cont.len;
+		cont.cons = cont.text_len;
 	}
 
 	if (cont.flushed) {
 		if (cont.flags & LOG_NEWLINE)
 			text[textlen++] = '\n';
 		/* got everything, release buffer */
-		cont.len = 0;
+		cont.text_len = 0;
 	}
 	return textlen;
 }
@@ -1576,21 +1587,29 @@ asmlinkage int vprintk_emit(int facility, int level,
 	if (level == -1)
 		level = default_message_loglevel;
 
-	if (dict)
+	if (dict) {
 		lflags |= LOG_PREFIX|LOG_NEWLINE;
 
+		/* Another task is trying to output a message */
+		if (cont.text_len && cont.owner != current)
+			cont_flush(LOG_NEWLINE);
+
+		cont_dict_add(dict, dictlen);
+	}
+
 	if (!(lflags & LOG_NEWLINE)) {
 		/*
 		 * Flush the conflicting buffer. An earlier newline was missing,
 		 * or another task also prints continuation lines.
 		 */
-		if (cont.len && (lflags & LOG_PREFIX || cont.owner != current))
+		if (cont.text_len &&
+		    (lflags & LOG_PREFIX || cont.owner != current))
 			cont_flush(LOG_NEWLINE);
 
 		/* buffer line if possible, otherwise store it right away */
 		if (!cont_add(facility, level, text, text_len))
 			log_store(facility, level, lflags | LOG_CONT, 0,
-				  dict, dictlen, text, text_len);
+				  NULL, 0, text, text_len);
 	} else {
 		bool stored = false;
 
@@ -1600,7 +1619,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 		 * there was a race with interrupts (prefix == true) then just
 		 * flush it out and store this line separately.
 		 */
-		if (cont.len && cont.owner == current) {
+		if (cont.text_len && cont.owner == current) {
 			if (!(lflags & LOG_PREFIX))
 				stored = cont_add(facility, level, text, text_len);
 			cont_flush(LOG_NEWLINE);
@@ -1608,7 +1627,12 @@ asmlinkage int vprintk_emit(int facility, int level,
 
 		if (!stored)
 			log_store(facility, level, lflags, 0,
-				  dict, dictlen, text, text_len);
+				  cont.dict, cont.dict_len, text, text_len);
+		/*
+		 * Structured printk always starts a new line now, so clear
+		 * current dictionary information for next structured printk.
+		 */
+		cont.dict_len = 0;
 	}
 	printed_len += text_len;
 
@@ -1974,7 +1998,7 @@ static void console_cont_flush(char *text, size_t size)
 
 	raw_spin_lock_irqsave(&logbuf_lock, flags);
 
-	if (!cont.len)
+	if (!cont.text_len)
 		goto out;
 
 	/*

