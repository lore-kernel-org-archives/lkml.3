Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab3F1PNa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 11:13:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44171 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619Ab3F1PN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 11:13:28 -0400
Date: Fri, 28 Jun 2013 08:12:35 -0700
From: tip-bot for Bart Van Assche <tipbot@zytor.com>
Message-ID: <tip-9e04d3804d3ac97d8c03a41d78d0f0674b5d01e1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        arjan@infradead.org, bvanassche@acm.org, tglx@linutronix.de,
        sfr@canb.auug.org.au, bart.vanassche@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        arjan@infradead.org, bvanassche@acm.org, tglx@linutronix.de,
        sfr@canb.auug.org.au, bart.vanassche@gmail.com
In-Reply-To: <519BC066.5080600@acm.org>
References: <519BC066.5080600@acm.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] timer:
  Fix jiffies wrap behavior of round_jiffies_common()
Git-Commit-ID: 9e04d3804d3ac97d8c03a41d78d0f0674b5d01e1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 28 Jun 2013 08:12:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9e04d3804d3ac97d8c03a41d78d0f0674b5d01e1
Gitweb:     http://git.kernel.org/tip/9e04d3804d3ac97d8c03a41d78d0f0674b5d01e1
Author:     Bart Van Assche <bart.vanassche@gmail.com>
AuthorDate: Tue, 21 May 2013 20:43:50 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 28 Jun 2013 17:10:11 +0200

timer: Fix jiffies wrap behavior of round_jiffies_common()

Direct compare of jiffies related values does not work in the wrap
around case. Replace it with time_is_after_jiffies().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Link: http://lkml.kernel.org/r/519BC066.5080600@acm.org
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/timer.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 15ffdb3..15bc1b4 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -149,9 +149,11 @@ static unsigned long round_jiffies_common(unsigned long j, int cpu,
 	/* now that we have rounded, subtract the extra skew again */
 	j -= cpu * 3;
 
-	if (j <= jiffies) /* rounding ate our timeout entirely; */
-		return original;
-	return j;
+	/*
+	 * Make sure j is still in the future. Otherwise return the
+	 * unmodified value.
+	 */
+	return time_is_after_jiffies(j) ? j : original;
 }
 
 /**
