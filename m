Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761542Ab3BNSOq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 13:14:46 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:53683 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758418Ab3BNSOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 13:14:44 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, stable@vger.kernel.org
Subject: [PATCH] drivercore: Fix ordering between deferred_probe and exiting initcalls
Date: Thu, 14 Feb 2013 18:14:27 +0000
Message-Id: <1360865667-8353-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: stable@vger.kernel.org
---

Hi Greg and Linus,

Okay, so this is really late to be sending for v3.8, and it doesn't have
nearly the amount of testing that I would like it to have. I haven't
even put it into linux-next yet. However, it is a real bug that some of
the Linaro folks have run into that is caused by deferred probe. It
isn't very widespread, but it is there.

It probably should be in v3.8, but given how ridiculously late it is and
that it isn't a widespread problem it would probably be just fine to go
in during the v3.9 merge window and get backported to linux-stable. If I
don't hear otherwise then that is what I'll do.

Still, here it is. If you think it really should be merged before
tagging v3.8 then please go ahead and apply it.

For stable it needs to go into v3.4 onwards.

g.


 drivers/base/dd.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index e3bbed8..61d3e1b 100644
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
-- 
1.7.10.4

