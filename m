Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933504Ab3CVKQj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 06:16:39 -0400
Received: from cyclops.biessmann.org ([134.0.25.77]:37480 "EHLO
	cyclops.biessmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab3CVKQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 06:16:38 -0400
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Mar 2013 06:16:38 EDT
From: =?UTF-8?q?Andreas=20Bie=C3=9Fmann?= <andreas@biessmann.de>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Andreas=20Bie=C3=9Fmann?= <andreas@biessmann.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay@vrfy.org>, stable@vger.kernel.org
Subject: [PATCH] register_console: prevent adding the same console twice
Date: Fri, 22 Mar 2013 11:10:52 +0100
Message-Id: <1363947052-15605-1-git-send-email-andreas@biessmann.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch guards the console_drivers list to be corrupted. The
for_each_console() macro insist on a strictly forward list ended by NULL:

 con0->next->con1->next->NULL

Without this patch it may happen easily to destroy this list for example by
adding 'earlyprintk' twice. This will result in the following list:

 con0->next->con0

This in turn will result in an endless loop in console_unlock() later on by
printing the first __log_buf line endlessly.

Signed-off-by: Andreas Bießmann <andreas@biessmann.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kay Sievers <kay@vrfy.org>
Cc: stable@vger.kernel.org
---
 kernel/printk.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/printk.c b/kernel/printk.c
index 0b31715..f78bfcd 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -2254,6 +2254,14 @@ void register_console(struct console *newcon)
 	unsigned long flags;
 	struct console *bcon = NULL;
 
+	if (console_drivers)
+		for_each_console(bcon)
+			if (bcon == newcon) {
+				pr_warn("prevent adding console '%s%d' twice\n",
+					newcon->name, newcon->index);
+				return;
+			}
+
 	/*
 	 * before we register a new CON_BOOT console, make sure we don't
 	 * already have a valid console
-- 
1.7.10.4

