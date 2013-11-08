Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab3KHCSd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:18:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34640 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317Ab3KHCST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:18:19 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 22/91] net: secure_seq: Fix warning when CONFIG_IPV6 and CONFIG_INET are not selected
Date: Thu,  7 Nov 2013 18:14:37 -0800
Message-Id: <1383876946-2396-23-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <fabio.estevam@freescale.com>

[ Upstream commit cb03db9d0e964568407fb08ea46cc2b6b7f67587 ]

net_secret() is only used when CONFIG_IPV6 or CONFIG_INET are selected.

Building a defconfig with both of these symbols unselected (Using the ARM
at91sam9rl_defconfig, for example) leads to the following build warning:

$ make at91sam9rl_defconfig

$ make net/core/secure_seq.o
scripts/kconfig/conf --silentoldconfig Kconfig
  CHK     include/config/kernel.release
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
make[1]: `include/generated/mach-types.h' is up to date.
  CALL    scripts/checksyscalls.sh
  CC      net/core/secure_seq.o
net/core/secure_seq.c:17:13: warning: 'net_secret_init' defined but not used [-Wunused-function]

Fix this warning by protecting the definition of net_secret() with these
symbols.

Reported-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/core/secure_seq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/secure_seq.c b/net/core/secure_seq.c
index e61a8bb..53fcc11 100644
--- a/net/core/secure_seq.c
+++ b/net/core/secure_seq.c
@@ -10,6 +10,7 @@
 
 #include <net/secure_seq.h>
 
+#if IS_ENABLED(CONFIG_IPV6) || IS_ENABLED(CONFIG_INET)
 static u32 net_secret[MD5_MESSAGE_BYTES / 4] ____cacheline_aligned;
 
 static int __init net_secret_init(void)
@@ -18,6 +19,7 @@ static int __init net_secret_init(void)
 	return 0;
 }
 late_initcall(net_secret_init);
+#endif
 
 #ifdef CONFIG_INET
 static u32 seq_scale(u32 seq)
-- 
1.8.1.2

