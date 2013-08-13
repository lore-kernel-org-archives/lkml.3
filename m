Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737Ab3HMQg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:36:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33381 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686Ab3HMQ0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:26:47 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=-UT6RKgOsmYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=9Vqvd-N0FfIA:10 a=pGLkceISAAAA:8 a=N54-gffFAAAA:8 a=JfrnYn6hAAAA:8 a=rOUgymgbAAAA:8 a=VwQbUJbxAAAA:8 a=n89epd5HrI16DDiEk2AA:9 a=MSl-tDqOz04A:10 a=nAPXUAfsBmEA:10 a=3Rfx1nUSh_UA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155836.823075746@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:58:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [82/88] timer: Fix jiffies wrap behavior of round_jiffies_common()
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0082-timer-Fix-jiffies-wrap-behavior-of-round_jiffies_com.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bart.vanassche@gmail.com>

[ Upstream commit 9e04d3804d3ac97d8c03a41d78d0f0674b5d01e1 ]

Direct compare of jiffies related values does not work in the wrap
around case. Replace it with time_is_after_jiffies().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Link: http://lkml.kernel.org/r/519BC066.5080600@acm.org
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/timer.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 4cefc08..118237f 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -146,9 +146,11 @@ static unsigned long round_jiffies_common(unsigned long j, int cpu,
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
-- 
1.7.10.4


