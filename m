Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967487AbaFTOB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 10:01:27 -0400
Received: from server721-han.de-nserver.de ([85.158.180.102]:49052 "EHLO
	server721-han.de-nserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966332AbaFTOB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 10:01:26 -0400
X-Greylist: delayed 324 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jun 2014 10:01:25 EDT
X-Fcrdns: Yes
Message-ID: <53A43D66.9070005@kristov.de>
Date: Fri, 20 Jun 2014 15:55:50 +0200
From: Christoph Schulz <develop@kristov.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: paulus@samba.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] net: ppp: make PPP pass and active filters work again
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by mail@kristov.de through 89.182.48.140
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Schulz <develop@kristov.de>

Commit 568f194e8bd16c353ad50f9ab95d98b20578a39d ("net: ppp: use
sk_unattached_filter api") contains two glitches. The first one is that
sk_chk_filter() is called from within get_filter(). However, sk_chk_filter()
is not idempotent as it sometimes replaces filter codes. So running it a second
time over the same filter does not work and yields EINVAL. But sk_chk_filter()
_is_ run a second time, namely through the call chain:

  ppp_ioctl() --> sk_unattached_filter_create()
              --> __sk_prepare_filter()
              --> sk_chk_filter()

This results in sk_unattached_filter_create() always returning EINVAL,
regardless whether the filter was sane or not. So this patch simply removes
the call to sk_chk_filter() from within get_filter().

The second problem is that the original ppp_ioctl() code handling PPPIOCSPASS
and PPPIOCSACTIVE allowed to remove a pass/active filter previously set by
using a filter of length zero. However, with the new code this is not possible
anymore as this case is not explicitly checked for, which leads to passing NULL
as a filter to sk_unattached_filter_create(). This also results in returning
EINVAL to the caller. Additionally, ppp->pass_filter and ppp->active_filter
are not reset by sk_unattached_filter_create() in this EINVAL case, so dangling
pointers may be left behind. This patch corrects both problems by checking
whether the filter passed is empty or not, and so prevents
sk_unattached_filter_create() from being called for empty filters.

This patch applies to 3.15.1.

Signed-off-by: Christoph Schulz <develop@kristov.de>
---
This is my first Linux kernel patch. If I made something wrong, please tell
me ;-)

I know about the 80-characters-per-line limit, but I wanted to let the original
code as unmodified as possible. If you think the long lines have to be broken
somehow, I'll try.

The patch actually consists of two changes (I described them above), but
because these changes are both needed to fix the problem, I refrained from
splitting this patch into two. If you do think this has to be done, I will do
it. (In this case, I would like to know whether the second patch should be
created on top of the first one or independent of it?)

Best regards,

Christoph Schulz

diff -uprN linux-3.15.1.orig/drivers/net/ppp/ppp_generic.c linux-3.15.1/drivers/net/ppp/ppp_generic.c
--- linux-3.15.1.orig/drivers/net/ppp/ppp_generic.c	2014-06-08 20:19:54.000000000 +0200
+++ linux-3.15.1/drivers/net/ppp/ppp_generic.c	2014-06-19 08:19:57.000000000 +0200
@@ -554,12 +554,6 @@ static int get_filter(void __user *arg,
 	if (IS_ERR(code))
 		return PTR_ERR(code);
 
-	err = sk_chk_filter(code, uprog.len);
-	if (err) {
-		kfree(code);
-		return err;
-	}
-
 	*p = code;
 	return uprog.len;
 }
@@ -763,10 +757,15 @@ static long ppp_ioctl(struct file *file,
 			};
 
 			ppp_lock(ppp);
-			if (ppp->pass_filter)
+			if (ppp->pass_filter) {
 				sk_unattached_filter_destroy(ppp->pass_filter);
-			err = sk_unattached_filter_create(&ppp->pass_filter,
-							  &fprog);
+				ppp->pass_filter = NULL;
+			}
+			if (fprog.filter != NULL)
+				err = sk_unattached_filter_create(&ppp->pass_filter,
+								  &fprog);
+			else
+				err = 0;
 			kfree(code);
 			ppp_unlock(ppp);
 		}
@@ -784,10 +783,15 @@ static long ppp_ioctl(struct file *file,
 			};
 
 			ppp_lock(ppp);
-			if (ppp->active_filter)
+			if (ppp->active_filter) {
 				sk_unattached_filter_destroy(ppp->active_filter);
-			err = sk_unattached_filter_create(&ppp->active_filter,
-							  &fprog);
+				ppp->active_filter = NULL;
+			}
+			if (fprog.filter != NULL)
+				err = sk_unattached_filter_create(&ppp->active_filter,
+								  &fprog);
+			else
+				err = 0;
 			kfree(code);
 			ppp_unlock(ppp);
 		}
