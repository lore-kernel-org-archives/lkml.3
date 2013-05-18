Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040Ab3ERCSB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:18:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7265 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756818Ab3ERCRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:17:01 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=thDxtl0yAjAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Wy3OW9QRPU4A:10 a=Iz6zksb9AAAA:8 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=aCPqOQJ_S1qBLZ7JjQ4A:9 a=-QRGccgW5JIA:10 a=jeBq3FmKZ4MA:10 a=WwgC8nHKvroA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021650.123152360@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: David Engraf <david.engraf@sysgo.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [ 052/136 ] hrtimer: Fix ktime_add_ns() overflow on 32bit architectures
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0052-hrtimer-Fix-ktime_add_ns-overflow-on-32bit-architect.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: David Engraf <david.engraf@sysgo.com>

[ Upstream commit 51fd36f3fad8447c487137ae26b9d0b3ce77bb25 ]

One can trigger an overflow when using ktime_add_ns() on a 32bit
architecture not supporting CONFIG_KTIME_SCALAR.

When passing a very high value for u64 nsec, e.g. 7881299347898368000
the do_div() function converts this value to seconds (7881299347) which
is still to high to pass to the ktime_set() function as long. The result
in is a negative value.

The problem on my system occurs in the tick-sched.c,
tick_nohz_stop_sched_tick() when time_delta is set to
timekeeping_max_deferment(). The check for time_delta < KTIME_MAX is
valid, thus ktime_add_ns() is called with a too large value resulting in
a negative expire value. This leads to an endless loop in the ticker code:

time_delta: 7881299347898368000
expires = ktime_add_ns(last_update, time_delta)
expires: negative value

This fix caps the value to KTIME_MAX.

This error doesn't occurs on 64bit or architectures supporting
CONFIG_KTIME_SCALAR (e.g. ARM, x86-32).

Cc: stable@vger.kernel.org
Signed-off-by: David Engraf <david.engraf@sysgo.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[jstultz: Minor tweaks to commit message & header]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/hrtimer.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 1c5ab31..532294f 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -298,6 +298,10 @@ ktime_t ktime_sub_ns(const ktime_t kt, u64 nsec)
 	} else {
 		unsigned long rem = do_div(nsec, NSEC_PER_SEC);
 
+		/* Make sure nsec fits into long */
+		if (unlikely(nsec > KTIME_SEC_MAX))
+			return (ktime_t){ .tv64 = KTIME_MAX };
+
 		tmp = ktime_set((long)nsec, rem);
 	}
 
-- 
1.7.10.4


