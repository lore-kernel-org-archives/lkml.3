Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbaFKX7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 19:59:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:36075 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154AbaFKX7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 19:59:30 -0400
Message-Id: <20140611234607.775273584@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 11 Jun 2014 23:59:19 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        linux-security-module@vger.kernel.org
Subject: [patch 13/13] tomoyo: Use sensible time interface
References: <20140611234024.103571777@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=tomoyo-use-sensible-time-interface.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no point in calling gettimeofday if only the seconds part of
the timespec is used. Use get_seconds() instead. It's not only the
proper interface it's also faster.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: linux-security-module@vger.kernel.org
---
 security/tomoyo/audit.c  |    8 +++-----
 security/tomoyo/common.c |    4 +---
 2 files changed, 4 insertions(+), 8 deletions(-)

Index: linux/security/tomoyo/audit.c
===================================================================
--- linux.orig/security/tomoyo/audit.c
+++ linux/security/tomoyo/audit.c
@@ -155,11 +155,9 @@ static char *tomoyo_print_header(struct
 	u8 i;
 	if (!buffer)
 		return NULL;
-	{
-		struct timeval tv;
-		do_gettimeofday(&tv);
-		tomoyo_convert_time(tv.tv_sec, &stamp);
-	}
+
+	tomoyo_convert_time(get_seconds(), &stamp);
+
 	pos = snprintf(buffer, tomoyo_buffer_len - 1,
 		       "#%04u/%02u/%02u %02u:%02u:%02u# profile=%u mode=%s "
 		       "granted=%s (global-pid=%u) task={ pid=%u ppid=%u "
Index: linux/security/tomoyo/common.c
===================================================================
--- linux.orig/security/tomoyo/common.c
+++ linux/security/tomoyo/common.c
@@ -2267,13 +2267,11 @@ static unsigned int tomoyo_stat_modified
  */
 void tomoyo_update_stat(const u8 index)
 {
-	struct timeval tv;
-	do_gettimeofday(&tv);
 	/*
 	 * I don't use atomic operations because race condition is not fatal.
 	 */
 	tomoyo_stat_updated[index]++;
-	tomoyo_stat_modified[index] = tv.tv_sec;
+	tomoyo_stat_modified[index] = get_seconds();
 }
 
 /**


