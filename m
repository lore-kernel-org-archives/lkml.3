Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235Ab3B1OsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:48:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42148 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955Ab3B1OsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:48:09 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Grant Likely <grant.likely@secretlab.ca>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 057/139] drivercore: Fix ordering between deferred_probe and exiting initcalls
Date: Thu, 28 Feb 2013 14:43:27 +0000
Message-Id: <1362062689-2567-58-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Grant Likely <grant.likely@secretlab.ca>

commit d72cca1eee5b26e313da2a380d4862924e271031 upstream.

One of the side effects of deferred probe is that some drivers which
used to be probed before initcalls completed are now happening slightly
later. This causes two problems.
- If a console driver gets deferred, then it may not be ready when
  userspace starts. For example, if a uart depends on pinctrl, then the
  uart will get deferred and /dev/console will not be available
- __init sections will be discarded before built-in drivers are probed.
  Strictly speaking, __init functions should not be called in a drivers
  __probe path, but there are a lot of drivers (console stuff again)
  that do anyway. In the past it was perfectly safe to do so because all
  built-in drivers got probed before the end of initcalls.

This patch fixes the problem by forcing the first pass of the deferred
list to complete at late_initcall time. This is late enough to catch the
drivers that are known to have the above issues.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Tested-by: Haojian Zhuang <haojian.zhuang@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/base/dd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 4b01ab3..82ff801 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -161,6 +161,8 @@ static int deferred_probe_initcall(void)
 
 	driver_deferred_probe_enable = true;
 	driver_deferred_probe_trigger();
+	/* Sort as many dependencies as possible before exiting initcalls */
+	flush_workqueue(deferred_wq);
 	return 0;
 }
 late_initcall(deferred_probe_initcall);
-- 
1.8.1.2

