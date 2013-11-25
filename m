Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab3KYNHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:07:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57046 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056Ab3KYNHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:07:43 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Baruch Siach <baruch@tkos.co.il>, Max Filippov <jcmvbkbc@gmail.com>,
        Chris Zankel <chris@zankel.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 23/78] xtensa: don't use alternate signal stack on threads
Date: Mon, 25 Nov 2013 13:06:10 +0000
Message-Id: <1385384825-21681-24-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
References: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.26 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baruch Siach <baruch@tkos.co.il>

commit cba9a90053e3b7973eff4f1946f33032e98eeed5 upstream.

According to create_thread(3): "The new thread does not inherit the creating
thread's alternate signal stack". Since commit f9a3879a (Fix sigaltstack
corruption among cloned threads), current->sas_ss_size is set to 0 for cloned
processes sharing VM with their parent. Don't use the (nonexistent) alternate
signal stack in this case. This has been broken since commit 29c4dfd9 ([XTENSA]
Remove non-rt signal handling).

Fixes the SA_ONSTACK part of the nptl/tst-cancel20 test from uClibc.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Chris Zankel <chris@zankel.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/xtensa/kernel/signal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/xtensa/kernel/signal.c b/arch/xtensa/kernel/signal.c
index efe4e85..163cfc8 100644
--- a/arch/xtensa/kernel/signal.c
+++ b/arch/xtensa/kernel/signal.c
@@ -342,7 +342,7 @@ static int setup_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 
 	sp = regs->areg[1];
 
-	if ((ka->sa.sa_flags & SA_ONSTACK) != 0 && ! on_sig_stack(sp)) {
+	if ((ka->sa.sa_flags & SA_ONSTACK) != 0 && sas_ss_flags(sp) == 0) {
 		sp = current->sas_ss_sp + current->sas_ss_size;
 	}
 
-- 
1.8.3.2

