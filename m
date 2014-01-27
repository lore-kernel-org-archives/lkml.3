Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbaA0RHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 12:07:12 -0500
Received: from mail1.windriver.com ([147.11.146.13]:55661 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbaA0RHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 12:07:10 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, <linux-parisc@vger.kernel.org>
Subject: [PATCH] parisc64: don't use module_init for non-modular core perf code
Date: Mon, 27 Jan 2014 12:06:57 -0500
Message-ID: <1390842417-23443-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf.c code depends on CONFIG_64BIT, so it is either built-in
or absent.  It will never be modular, so using module_init as an
alias for __initcall is rather misleading.

Fix this up now, so that we can relocate module_init from
init.h into module.h in the future.  If we don't do this, we'd
have to add module.h to obviously non-modular code, and that
would be a worse thing.  Aside from it not making sense, it also
causes a ~10% increase in CPP overhead due to module.h having a
large list of headers itself -- for example compare line counts:

 device_initcall() and <linux/init.h>
	20238 arch/parisc/kernel/perf.i

 module_init() and <linux/module.h>
	22194 arch/parisc/kernel/perf.i

Direct use of __initcall is discouraged, vs prioritized ones.
Use of device_initcall is consistent with what __initcall
maps onto, and hence does not change the init order, making the
impact of this change zero.   Should someone with real hardware
for boot testing want to change it later to arch_initcall or
something different, they can do that at a later date.

Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[patch will be added to init cleanup series:
   http://git.kernel.org/cgit/linux/kernel/git/paulg/init.git/  ]

 arch/parisc/kernel/perf.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/parisc/kernel/perf.c b/arch/parisc/kernel/perf.c
index ba0c053e25ae..518f4f5f1f43 100644
--- a/arch/parisc/kernel/perf.c
+++ b/arch/parisc/kernel/perf.c
@@ -543,6 +543,7 @@ static int __init perf_init(void)
 
 	return 0;
 }
+device_initcall(perf_init);
 
 /*
  * perf_start_counters(void)
@@ -847,5 +848,3 @@ printk("perf_rdr_write\n");
 	}
 printk("perf_rdr_write done\n");
 }
-
-module_init(perf_init);
-- 
1.8.5.2

