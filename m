Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbaJFTTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 15:19:35 -0400
Received: from mail-oi0-f54.google.com ([209.85.218.54]:44393 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbaJFTTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 15:19:34 -0400
From: minyard@acm.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>, Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 3/4] ipmi: work around gcc-4.9 build warning
Date: Mon,  6 Oct 2014 14:17:52 -0500
Message-Id: <1412623073-6166-4-git-send-email-minyard@acm.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1412623073-6166-1-git-send-email-minyard@acm.org>
References: <1412623073-6166-1-git-send-email-minyard@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Building ipmi on arm with gcc-4.9 results in this warning
for an allmodconfig build:

drivers/char/ipmi/ipmi_si_intf.c: In function 'ipmi_thread':
include/linux/time.h:28:5: warning: 'busy_until.tv_sec' may be used uninitialized in this function [-Wmaybe-uninitialized]
  if (lhs->tv_sec > rhs->tv_sec)
     ^
drivers/char/ipmi/ipmi_si_intf.c:1007:18: note: 'busy_until.tv_sec' was declared here
  struct timespec busy_until;
                  ^

The warning is bogus and this case can not occur. Apparently
this is a false positive resulting from gcc getting a little
smarter about tracking assignments but not smart enough. Marking
the ipmi_thread_busy_wait function as inline gives the gcc
optimization logic enough information to figure out for itself
that the case cannot happen, which gets rid of the warning
without adding any fake initialization.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
 drivers/char/ipmi/ipmi_si_intf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 4fc8931..1c43f9a 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -965,9 +965,9 @@ static inline int ipmi_si_is_busy(struct timespec *ts)
 	return ts->tv_nsec != -1;
 }
 
-static int ipmi_thread_busy_wait(enum si_sm_result smi_result,
-				 const struct smi_info *smi_info,
-				 struct timespec *busy_until)
+static inline int ipmi_thread_busy_wait(enum si_sm_result smi_result,
+					const struct smi_info *smi_info,
+					struct timespec *busy_until)
 {
 	unsigned int max_busy_us = 0;
 
-- 
1.8.3.1

