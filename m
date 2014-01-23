Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014AbaAWUeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 15:34:19 -0500
Received: from mail1.windriver.com ([147.11.146.13]:64328 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaAWUeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 15:34:18 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        Thomas Meyer <thomas@m3y3r.de>, <linux-xtensa@linux-xtensa.org>
Subject: [PATCH v2] xtensa: don't use module_init for non-modular core network.c code
Date: Thu, 23 Jan 2014 15:33:58 -0500
Message-ID: <1390509238-3831-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1390508811-3755-1-git-send-email-paul.gortmaker@windriver.com>
References: <1390508811-3755-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The network.c code is piggybacking off of the arch independent
CONFIG_NET, which is bool.  So the code is either built in or
absent.  It will never be modular, so using module_init as an
alias for __initcall is rather misleading.

Fix this up now, so that we can relocate module_init from
init.h into module.h in the future.  If we don't do this, we'd
have to add module.h to obviously non-modular code, and that
would be a worse thing.

Direct use of __initcall is discouraged, vs prioritized ones.
Use of device_initcall is consistent with what __initcall
maps onto, and hence does not change the init order, making the
impact of this change zero.   Should someone with real hardware
for boot testing want to change it later to arch_initcall or
something different, they can do that at a later date.

Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Thomas Meyer <thomas@m3y3r.de>
Cc: linux-xtensa@linux-xtensa.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[v2: fix 1st paragraph of commit log; code depends on CONFIG_NET
     and not on obj-y ; otherwise patch is unchanged. ]

[patch will be added to init cleanup series:
   http://git.kernel.org/cgit/linux/kernel/git/paulg/init.git/  ]

 arch/xtensa/platforms/iss/network.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/xtensa/platforms/iss/network.c b/arch/xtensa/platforms/iss/network.c
index d05f8feeb8d7..32b413b21483 100644
--- a/arch/xtensa/platforms/iss/network.c
+++ b/arch/xtensa/platforms/iss/network.c
@@ -680,6 +680,4 @@ static int iss_net_init(void)
 
 	return 1;
 }
-
-module_init(iss_net_init);
-
+device_initcall(iss_net_init);
-- 
1.8.5.2

