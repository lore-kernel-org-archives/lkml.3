Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbaCDFiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 00:38:24 -0500
Received: from moutng.kundenserver.de ([212.227.17.24]:54811 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaCDFiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 00:38:22 -0500
Message-ID: <1393911500.6415.18.camel@marge.simpson.net>
Subject: [RFC][PATCH] clocksource: avoid unnecessary overflow in
 cyclecounter_cyc2ns()
From: Mike Galbraith <bitbucket@online.de>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "Cc: Salman Qazi" <sqazi@google.com>
Date: Tue, 04 Mar 2014 06:38:20 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:XB860jvpIJ//V1LArE3KF35qttWUYDxHstLXwiUdsQc
 kzS/9EhH9EElLPzDSWxZ1ZZ+tLnaldEXSor5RbvTSSJ5QiidMD
 MnYSoMtZm3vwZW4jlHnb48JQkDUU0+2qpjdCgk8kH9xO2VQdXQ
 WbbUqewrk7kI7sa1VtusslRgRM9AeuTtK4VgX0lH+gmDSKIjDZ
 zp4kDpfvwIWLkD1Gv63avz/YfctfDYzMLyiS1pjYwacmnxAIlO
 oOQU/adsaS1ip4RXildRL7l2GjlzCZvXxnTzzsTjwJdrQafMq6
 irKrTW291cvjHvFUSNuprUd79FFLE5Ix1Yq+VT2SnUFJSxoZmy
 K+CNg2dkTKKYvIp+GIlcEKuyniZmx3p2A4ipU/Eh0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(crap crap crap... M.A.I.N.T.A.I.N.E.R.S _dummy_)

clocksource: avoid unnecessary overflow in cyclecounter_cyc2ns()

As per 4cecf6d401a "sched, x86: Avoid unnecessary overflow in sched_clock",
cycles * mult >> shift is overflow prone. so give it the same treatment.

Cc: Salman Qazi <sqazi@google.com>
Cc: John Stultz <john.stultz@linaro.org>,
Signed-off-by: Mike Galbraith <bitbucket@online.de>
---
 include/linux/clocksource.h |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -77,13 +77,18 @@ struct timecounter {
  *
  * XXX - This could use some mult_lxl_ll() asm optimization. Same code
  * as in cyc2ns, but with unsigned result.
+ *
+ * Because it is the same as x86 __cycles_2_ns, give it the same treatment as
+ * commit 4cecf6d401a "sched, x86: Avoid unnecessary overflow in sched_clock"
+ * to avoid a potential cycles * mult overflow.
  */
 static inline u64 cyclecounter_cyc2ns(const struct cyclecounter *cc,
 				      cycle_t cycles)
 {
-	u64 ret = (u64)cycles;
-	ret = (ret * cc->mult) >> cc->shift;
-	return ret;
+	u64 quot = (u64)cycles >> cc->shift;
+	u64 rem = (u64)cycles & ((1ULL << cc->shift) - 1);
+
+	return  quot * cc->mult + ((rem * cc->mult) >> cc->shift);
 }
 
 /**




