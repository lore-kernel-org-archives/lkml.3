Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162419Ab3LFNPL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:15:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44688 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162038Ab3LFNFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:05:30 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gerhard Sittig <gsi@denx.de>, Anatolij Gustschin <agust@denx.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 237/272] powerpc/mpc512x: silence build warning upon disabled DIU
Date: Fri,  6 Dec 2013 12:58:46 +0000
Message-Id: <1386334761-25517-238-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gerhard Sittig <gsi@denx.de>

commit 45d20e8348969a165c53cfb91f445e7cc599a9f0 upstream.

a disabled Kconfig option results in a reference to a not implemented
routine when the IS_ENABLED() macro is used for both conditional
implementation of the routine as well as a C language source code test
at the call site -- the "if (0) func();" construct only gets eliminated
later by the optimizer, while the compiler already has emitted its
warning about "func()" being undeclared

provide an empty implementation for the mpc512x_setup_diu() and
mpc512x_init_diu() routines in case of the disabled option, to avoid the
compiler warning which is considered fatal and breaks compilation

the bug appeared with commit 2abbbb63c90ab55ca3f054772c2e5ba7df810c48
"powerpc/mpc512x: move common code to shared.c file", how to reproduce:

  make mpc512x_defconfig
  echo CONFIG_FB_FSL_DIU=n >> .config && make olddefconfig
  make

    CC      arch/powerpc/platforms/512x/mpc512x_shared.o
  .../arch/powerpc/platforms/512x/mpc512x_shared.c: In function 'mpc512x_init_early':
  .../arch/powerpc/platforms/512x/mpc512x_shared.c:456:3: error: implicit declaration of function 'mpc512x_init_diu' [-Werror=implicit-function-declaration]
  .../arch/powerpc/platforms/512x/mpc512x_shared.c: In function 'mpc512x_setup_arch':
  .../arch/powerpc/platforms/512x/mpc512x_shared.c:469:3: error: implicit declaration of function 'mpc512x_setup_diu' [-Werror=implicit-function-declaration]
  cc1: all warnings being treated as errors
  make[4]: *** [arch/powerpc/platforms/512x/mpc512x_shared.o] Error 1

Signed-off-by: Gerhard Sittig <gsi@denx.de>
Signed-off-by: Anatolij Gustschin <agust@denx.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/platforms/512x/mpc512x_shared.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/platforms/512x/mpc512x_shared.c b/arch/powerpc/platforms/512x/mpc512x_shared.c
index a82a41b..1a7b1d0 100644
--- a/arch/powerpc/platforms/512x/mpc512x_shared.c
+++ b/arch/powerpc/platforms/512x/mpc512x_shared.c
@@ -303,6 +303,9 @@ void __init mpc512x_setup_diu(void)
 	diu_ops.release_bootmem		= mpc512x_release_bootmem;
 }
 
+#else
+void __init mpc512x_setup_diu(void) { /* EMPTY */ }
+void __init mpc512x_init_diu(void) { /* EMPTY */ }
 #endif
 
 void __init mpc512x_init_IRQ(void)
-- 
1.8.3.2

