Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab3KYOPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:15:53 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58902 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754047Ab3KYNxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:42 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Chris Zankel" <chris@zankel.net>,
        "Baruch Siach" <baruch@tkos.co.il>,
        "Max Filippov" <jcmvbkbc@gmail.com>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.447655415@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 68/87] xtensa: don't use alternate signal stack on threads
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/xtensa/kernel/signal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/xtensa/kernel/signal.c
+++ b/arch/xtensa/kernel/signal.c
@@ -346,7 +346,7 @@ static void setup_frame(int sig, struct
 
 	sp = regs->areg[1];
 
-	if ((ka->sa.sa_flags & SA_ONSTACK) != 0 && ! on_sig_stack(sp)) {
+	if ((ka->sa.sa_flags & SA_ONSTACK) != 0 && sas_ss_flags(sp) == 0) {
 		sp = current->sas_ss_sp + current->sas_ss_size;
 	}
 

