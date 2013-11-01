Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab3KAWfi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:35:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54987 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999Ab3KAWEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:04:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Olof Johansson <olof@lixom.net>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 15/54] net: secure_seq: Fix warning when CONFIG_IPV6 and CONFIG_INET are not selected
Date: Fri,  1 Nov 2013 15:03:43 -0700
Message-Id: <20131101220213.042147900@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101220211.311926234@linuxfoundation.org>
References: <20131101220211.311926234@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <fabio.estevam@freescale.com>

[ Upstream commit cb03db9d0e964568407fb08ea46cc2b6b7f67587 ]

net_secret() is only used when CONFIG_IPV6 or CONFIG_INET are selected.

Building a defconfig with both of these symbols unselected (Using the ARM
at91sam9rl_defconfig, for example) leads to the following build warning:

$ make at91sam9rl_defconfig
#
# configuration written to .config
#

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/secure_seq.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/core/secure_seq.c
+++ b/net/core/secure_seq.c
@@ -10,6 +10,7 @@
 
 #include <net/secure_seq.h>
 
+#if IS_ENABLED(CONFIG_IPV6) || IS_ENABLED(CONFIG_INET)
 #define NET_SECRET_SIZE (MD5_MESSAGE_BYTES / 4)
 
 static u32 net_secret[NET_SECRET_SIZE] ____cacheline_aligned;
@@ -29,6 +30,7 @@ static void net_secret_init(void)
 		cmpxchg(&net_secret[--i], 0, tmp);
 	}
 }
+#endif
 
 #ifdef CONFIG_INET
 static u32 seq_scale(u32 seq)


