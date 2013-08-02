Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab3HBK2v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:28:51 -0400
Received: from cyclops.biessmann.org ([134.0.25.77]:46321 "EHLO
	cyclops.biessmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab3HBK2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:28:48 -0400
X-Greylist: delayed 436 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Aug 2013 06:28:48 EDT
From: =?UTF-8?q?Andreas=20Bie=C3=9Fmann?= <andreas@biessmann.de>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Andreas=20Bie=C3=9Fmann?= <andreas@biessmann.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay@vrfy.org>, Ben Hutchings <ben@decadent.org.uk>,
        stable@vger.kernel.org
Subject: [RESEND][PATCH v2] register_console: prevent adding the same console twice
Date: Fri,  2 Aug 2013 12:23:34 +0200
Message-Id: <1375439014-13679-1-git-send-email-andreas@biessmann.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <1364201964-2990-1-git-send-email-andreas@biessmann.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch guards the console_drivers list to be corrupted. The
for_each_console() macro insist on a strictly forward list ended by NULL:

 con0->next->con1->next->NULL

Without this patch it may happen easily to destroy this list for example by
adding 'earlyprintk' twice, especially on embedded devices where the early
console is often a single static instance.  This will result in the following
list:

 con0->next->con0

This in turn will result in an endless loop in console_unlock() later on by
printing the first __log_buf line endlessly.

Signed-off-by: Andreas Bießmann <andreas@biessmann.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org
---
since v1:
 * use WARN() as Ben suggested
 * print 'already registered' instead of 'prevent registering'

 kernel/printk/printk.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 5b5a708..b4e8500 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2226,6 +2226,13 @@ void register_console(struct console *newcon)
 	struct console *bcon = NULL;
 	struct console_cmdline *c;
 
+	if (console_drivers)
+		for_each_console(bcon)
+			if (WARN(bcon == newcon,
+					"console '%s%d' already registered\n",
+					bcon->name, bcon->index))
+				return;
+
 	/*
 	 * before we register a new CON_BOOT console, make sure we don't
 	 * already have a valid console
-- 
1.7.10.4

