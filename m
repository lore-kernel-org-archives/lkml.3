Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693Ab3BYWXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 17:23:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55300 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932581Ab3BYWU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 17:20:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 40/58] drivercore: Fix ordering between deferred_probe and exiting initcalls
Date: Mon, 25 Feb 2013 14:19:36 -0800
Message-Id: <20130225221644.890301978@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130225221636.018756060@linuxfoundation.org>
References: <20130225221636.018756060@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/base/dd.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -172,6 +172,8 @@ static int deferred_probe_initcall(void)
 
 	driver_deferred_probe_enable = true;
 	driver_deferred_probe_trigger();
+	/* Sort as many dependencies as possible before exiting initcalls */
+	flush_workqueue(deferred_wq);
 	return 0;
 }
 late_initcall(deferred_probe_initcall);


