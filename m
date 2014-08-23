Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989AbaHWTEy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 15:04:54 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:63165 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbaHWTEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 15:04:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Corey Minyard <minyard@acm.org>
Cc: openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] ipmi: work around gcc-4.9 build warning
Date: Sat, 23 Aug 2014 21:04:48 +0200
Message-ID: <58708252.p9ogO3naVQ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-26-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:yBPxYo/cwdvtH7niZ0rS1jB1PHGIW9Qt3KMzlMpaOIw
 MqAzyJahLEUcxCz6ADOvLl5R7NfXo8dF2pKlNwQtrJyzyOr/8o
 3jMLxMf389ui7vZyrX5tMOQSLMrCyoUCmqdPNyeu1zT+Mqktzr
 33UZ6poGQ95OX9J0pnwze/wdX+pPrq8FqwcYP2cw1bdiRzDYHC
 CtQuiQ4OlK8++ONRXvtm05RrqIm/gJHxj0VhUpPwquNVzXvi8x
 pDWHZRM9jXumJu/Vn4Le2+1pXSJC49BpLEWuUZSKQJ8W9ActrD
 M0aBi/r/WwhKnN/ATHi09ylNJucyw7XzUkBClZSiCLlFwv8AWr
 rtHv8YFg3y621LMr6hKU=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 5d665680ae33..539ff0db52fc 100644
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
 

