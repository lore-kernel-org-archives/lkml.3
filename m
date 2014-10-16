Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbaJPSNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 14:13:47 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:57891 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbaJPSNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 14:13:44 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Torsten Duwe <duwe@lst.de>, "Theodore Ts'o" <tytso@mit.edu>,
        Jason Cooper <jason@lakedaemon.net>, Amit Shah <amit.shah@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Kees Cook <keescook@chromium.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v4] char: hw_random: core.c:  Changed from using strncat to strlcat
Date: Thu, 16 Oct 2014 20:15:55 +0200
Message-Id: <1413483355-29650-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The buf is used to hold the list of hwrng devices registered.
The old code ensures we don't walk off the end of buf as we
fill it, but it's unnecessarily complicated and thus difficult
to maintain. Simplify it by using strlcat.
We also ensure the string within buf is NULL terminated
so the final strlen is ok.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/char/hw_random/core.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index aa30a25..25599ea 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -281,7 +281,7 @@ static ssize_t hwrng_attr_available_show(struct device *dev,
 					 char *buf)
 {
 	int err;
-	ssize_t ret = 0;
+	ssize_t ret;
 	struct hwrng *rng;
 
 	err = mutex_lock_interruptible(&rng_mutex);
@@ -289,13 +289,10 @@ static ssize_t hwrng_attr_available_show(struct device *dev,
 		return -ERESTARTSYS;
 	buf[0] = '\0';
 	list_for_each_entry(rng, &rng_list, list) {
-		strncat(buf, rng->name, PAGE_SIZE - ret - 1);
-		ret += strlen(rng->name);
-		strncat(buf, " ", PAGE_SIZE - ret - 1);
-		ret++;
+		strlcat(buf, rng->name, PAGE_SIZE);
+		strlcat(buf, " ", PAGE_SIZE);
 	}
-	strncat(buf, "\n", PAGE_SIZE - ret - 1);
-	ret++;
+	ret = strlcat(buf, "\n", PAGE_SIZE);
 	mutex_unlock(&rng_mutex);
 
 	return ret;
-- 
1.7.10.4

