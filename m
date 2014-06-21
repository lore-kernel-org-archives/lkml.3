Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261AbaFUUi5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 16:38:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35127 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869AbaFUUiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 16:38:55 -0400
Date: Sat, 21 Jun 2014 13:37:52 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-77f4fa089c724adc3a87c10eb031bca91b144ac0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        takedakn@nttdata.co.jp, peterz@infradead.org,
        penguin-kernel@I-love.SAKURA.ne.jp, john.stultz@linaro.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        takedakn@nttdata.co.jp, penguin-kernel@I-love.SAKURA.ne.jp,
        peterz@infradead.org, john.stultz@linaro.org, tglx@linutronix.de
In-Reply-To: <20140611234607.775273584@linutronix.de>
References: <20140611234607.775273584@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] tomoyo: Use sensible time interface
Git-Commit-ID: 77f4fa089c724adc3a87c10eb031bca91b144ac0
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

Commit-ID:  77f4fa089c724adc3a87c10eb031bca91b144ac0
Gitweb:     http://git.kernel.org/tip/77f4fa089c724adc3a87c10eb031bca91b144ac0
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 11 Jun 2014 23:59:19 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 12 Jun 2014 16:18:45 +0200

tomoyo: Use sensible time interface

There is no point in calling gettimeofday if only the seconds part of
the timespec is used. Use get_seconds() instead. It's not only the
proper interface it's also faster.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: linux-security-module@vger.kernel.org
Link: http://lkml.kernel.org/r/20140611234607.775273584@linutronix.de
---
 security/tomoyo/audit.c  | 8 +++-----
 security/tomoyo/common.c | 4 +---
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/security/tomoyo/audit.c b/security/tomoyo/audit.c
index c1b0037..3ffa4f5 100644
--- a/security/tomoyo/audit.c
+++ b/security/tomoyo/audit.c
@@ -155,11 +155,9 @@ static char *tomoyo_print_header(struct tomoyo_request_info *r)
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
diff --git a/security/tomoyo/common.c b/security/tomoyo/common.c
index 283862a..e0fb750 100644
--- a/security/tomoyo/common.c
+++ b/security/tomoyo/common.c
@@ -2267,13 +2267,11 @@ static unsigned int tomoyo_stat_modified[TOMOYO_MAX_POLICY_STAT];
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
