Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbaGZTdq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:33:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34558 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbaGZTVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:21:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christoph Schulz <develop@kristov.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.15 069/109] net: ppp: fix creating PPP pass and active filters
Date: Sat, 26 Jul 2014 12:02:31 -0700
Message-Id: <20140726190225.957449080@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190223.834037485@linuxfoundation.org>
References: <20140726190223.834037485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Schulz <develop@kristov.de>

[ Upstream commit cc25eaae238ddd693aa5eaa73e565d8ff4915f6e ]

Commit 568f194e8bd16c353ad50f9ab95d98b20578a39d ("net: ppp: use
sk_unattached_filter api") inadvertently changed the logic when setting
PPP pass and active filters. This applies to both the generic PPP subsystem
implemented by drivers/net/ppp/ppp_generic.c and the ISDN PPP subsystem
implemented by drivers/isdn/i4l/isdn_ppp.c. The original code in ppp_ioctl()
(or isdn_ppp_ioctl(), resp.) handling PPPIOCSPASS and PPPIOCSACTIVE allowed to
remove a pass/active filter previously set by using a filter of length zero.
However, with the new code this is not possible anymore as this case is not
explicitly checked for, which leads to passing NULL as a filter to
sk_unattached_filter_create(). This results in returning EINVAL to the caller.

Additionally, the variables ppp->pass_filter and ppp->active_filter (or
is->pass_filter and is->active_filter, resp.) are not reset to NULL, although
the filters they point to may have been destroyed by
sk_unattached_filter_destroy(), so in this EINVAL case dangling pointers are
left behind (provided the pointers were previously non-NULL).

This patch corrects both problems by checking whether the filter passed is
empty or non-empty, and prevents sk_unattached_filter_create() from being
called in the first case. Moreover, the pointers are always reset to NULL
as soon as sk_unattached_filter_destroy() returns.

Signed-off-by: Christoph Schulz <develop@kristov.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/isdn/i4l/isdn_ppp.c   |   20 ++++++++++++++++----
 drivers/net/ppp/ppp_generic.c |   22 ++++++++++++++++------
 2 files changed, 32 insertions(+), 10 deletions(-)

--- a/drivers/isdn/i4l/isdn_ppp.c
+++ b/drivers/isdn/i4l/isdn_ppp.c
@@ -644,9 +644,15 @@ isdn_ppp_ioctl(int min, struct file *fil
 		fprog.len = len;
 		fprog.filter = code;
 
-		if (is->pass_filter)
+		if (is->pass_filter) {
 			sk_unattached_filter_destroy(is->pass_filter);
-		err = sk_unattached_filter_create(&is->pass_filter, &fprog);
+			is->pass_filter = NULL;
+		}
+		if (fprog.filter != NULL)
+			err = sk_unattached_filter_create(&is->pass_filter,
+							  &fprog);
+		else
+			err = 0;
 		kfree(code);
 
 		return err;
@@ -663,9 +669,15 @@ isdn_ppp_ioctl(int min, struct file *fil
 		fprog.len = len;
 		fprog.filter = code;
 
-		if (is->active_filter)
+		if (is->active_filter) {
 			sk_unattached_filter_destroy(is->active_filter);
-		err = sk_unattached_filter_create(&is->active_filter, &fprog);
+			is->active_filter = NULL;
+		}
+		if (fprog.filter != NULL)
+			err = sk_unattached_filter_create(&is->active_filter,
+							  &fprog);
+		else
+			err = 0;
 		kfree(code);
 
 		return err;
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -763,10 +763,15 @@ static long ppp_ioctl(struct file *file,
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
@@ -784,10 +789,15 @@ static long ppp_ioctl(struct file *file,
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


