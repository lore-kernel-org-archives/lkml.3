Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbaAPWPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 17:15:51 -0500
Received: from mail.windriver.com ([147.11.1.11]:33472 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaAPWPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 17:15:50 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        <linux-m68k@vger.kernel.org>
Subject: [PATCH] m68k: don't use module_init in non-modular mvme16x/rtc.c code
Date: Thu, 16 Jan 2014 17:15:14 -0500
Message-ID: <1389910514-3802-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rtc.o is built for obj-y, i.e. always built in.  It will
never be modular, so using module_init as an alias for __initcall
can be somewhat misleading.

Fix this up now, so that we can relocate module_init from
init.h into module.h in the future.  If we don't do this, we'd
have to add module.h to obviously non-modular code, and that
would be a worse thing.

Note that direct use of __initcall is discouraged, vs. one
of the priority categorized subgroups.  As __initcall gets
mapped onto device_initcall, our use of device_initcall
directly in this change means that the runtime impact is
zero -- it will remain at level 6 in initcall ordering.

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@lists.linux-m68k.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/arch/m68k/mvme16x/rtc.c b/arch/m68k/mvme16x/rtc.c
index 6ef7a81a3b12..1755e2f7137d 100644
--- a/arch/m68k/mvme16x/rtc.c
+++ b/arch/m68k/mvme16x/rtc.c
@@ -161,4 +161,4 @@ static int __init rtc_MK48T08_init(void)
 	printk(KERN_INFO "MK48T08 Real Time Clock Driver v%s\n", RTC_VERSION);
 	return misc_register(&rtc_dev);
 }
-module_init(rtc_MK48T08_init);
+device_initcall(rtc_MK48T08_init);
-- 
1.8.5.2

