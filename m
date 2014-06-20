Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934639AbaFTFNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 01:13:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39566 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934673AbaFTFNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 01:13:09 -0400
Date: Thu, 19 Jun 2014 22:12:44 -0700
From: tip-bot for Michal Nazarewicz <tipbot@zytor.com>
Message-ID: <tip-891715793f0451e5114d200be932ac14ce8521a3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, rientjes@google.com, mina86@mina86.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, rientjes@google.com, mina86@mina86.com
In-Reply-To: <1403143116-21755-1-git-send-email-mina86@mina86.com>
References: <1403143116-21755-1-git-send-email-mina86@mina86.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86/tsc: Get rid of custom DIV_ROUND() macro
Git-Commit-ID: 891715793f0451e5114d200be932ac14ce8521a3
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

Commit-ID:  891715793f0451e5114d200be932ac14ce8521a3
Gitweb:     http://git.kernel.org/tip/891715793f0451e5114d200be932ac14ce8521a3
Author:     Michal Nazarewicz <mina86@mina86.com>
AuthorDate: Thu, 19 Jun 2014 03:58:36 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 19 Jun 2014 22:04:50 -0700

x86/tsc: Get rid of custom DIV_ROUND() macro

When invoced for positive values, DIV_ROUND macro defined in
arch/x86/kernel/tsc.c behaves exactly like DIV_ROUND_CLOSEST from
include/linux/kernel.h file, so remove the custom macro in favour
of the shared one.

[ hpa: changed line breaks ]

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Link: http://lkml.kernel.org/r/1403143116-21755-1-git-send-email-mina86@mina86.com
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/tsc.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 57e5ce1..8764232 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -234,9 +234,6 @@ static inline unsigned long long cycles_2_ns(unsigned long long cyc)
 	return ns;
 }
 
-/* XXX surely we already have this someplace in the kernel?! */
-#define DIV_ROUND(n, d) (((n) + ((d) / 2)) / (d))
-
 static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 {
 	unsigned long long tsc_now, ns_now;
@@ -259,7 +256,9 @@ static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 	 * time function is continuous; see the comment near struct
 	 * cyc2ns_data.
 	 */
-	data->cyc2ns_mul = DIV_ROUND(NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR, cpu_khz);
+	data->cyc2ns_mul =
+		DIV_ROUND_CLOSEST(NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR,
+				  cpu_khz);
 	data->cyc2ns_shift = CYC2NS_SCALE_FACTOR;
 	data->cyc2ns_offset = ns_now -
 		mul_u64_u32_shr(tsc_now, data->cyc2ns_mul, CYC2NS_SCALE_FACTOR);
