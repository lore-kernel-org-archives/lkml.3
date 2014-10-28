Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759164AbaJ1HZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:25:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45088 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204AbaJ1Dmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:42:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Xiubo Li <Li.Xiubo@freescale.com>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.16 026/127] regmap: fix possible ZERO_SIZE_PTR pointer dereferencing error.
Date: Tue, 28 Oct 2014 11:34:21 +0800
Message-Id: <20141028033422.057403669@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033420.925922046@linuxfoundation.org>
References: <20141028033420.925922046@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiubo Li <Li.Xiubo@freescale.com>

commit d6b41cb06044a7d895db82bdd54f6e4219970510 upstream.

Since we cannot make sure the 'val_count' will always be none zero
here, and then if it equals to zero, the kmemdup() will return
ZERO_SIZE_PTR, which equals to ((void *)16).

So this patch fix this with just doing the zero check before calling
kmemdup().

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/regmap/regmap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1646,6 +1646,9 @@ out:
 	} else {
 		void *wval;
 
+		if (!val_count)
+			return -EINVAL;
+
 		wval = kmemdup(val, val_count * val_bytes, GFP_KERNEL);
 		if (!wval) {
 			dev_err(map->dev, "Error in memory allocation\n");


