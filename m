Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbaAUVYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:24:43 -0500
Received: from mail.windriver.com ([147.11.1.11]:56244 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965AbaAUVYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:24:33 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Scott Wood <scottwood@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: [PATCH 13/73] powerpc: use subsys_initcall for Freescale Local Bus
Date: Tue, 21 Jan 2014 16:22:16 -0500
Message-ID: <1390339396-3479-14-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FSL_SOC option is bool, and hence this code is either
present or absent.  It will never be modular, so using
module_init as an alias for __initcall is rather misleading.

Fix this up now, so that we can relocate module_init from
init.h into module.h in the future.  If we don't do this, we'd
have to add module.h to obviously non-modular code, and that
would be a worse thing.

Note that direct use of __initcall is discouraged, vs. one
of the priority categorized subgroups.  As __initcall gets
mapped onto device_initcall, our use of subsys_initcall (which
makes sense for bus code) will thus change this registration
from level 6-device to level 4-subsys (i.e. slightly earlier).
However no observable impact of that small difference has
been observed during testing, or is expected.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Scott Wood <scottwood@freescale.com>
Acked-by: Scott Wood <scottwood@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/powerpc/sysdev/fsl_lbc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/sysdev/fsl_lbc.c b/arch/powerpc/sysdev/fsl_lbc.c
index d631022..38138cf 100644
--- a/arch/powerpc/sysdev/fsl_lbc.c
+++ b/arch/powerpc/sysdev/fsl_lbc.c
@@ -407,4 +407,4 @@ static int __init fsl_lbc_init(void)
 {
 	return platform_driver_register(&fsl_lbc_ctrl_driver);
 }
-module_init(fsl_lbc_init);
+subsys_initcall(fsl_lbc_init);
-- 
1.8.4.1

