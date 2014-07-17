Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934958AbaGQQ1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:27:30 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:51248 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933607AbaGQQ12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:27:28 -0400
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-media@vger.kernel.org
Cc: gregkh@linuxfoundation.org, m.chehab@samsung.com,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>
Subject: [PATCH 2/4] drivers/staging/media/davinci_vpfe/dm365_ipipeif.c: fix negativity check
Date: Thu, 17 Jul 2014 19:27:16 +0300
Message-Id: <1405614436-4506-1-git-send-email-andrey.krieger.utkin@gmail.com>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[linux-3.16-rc5/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:210]:
(style) Checking if unsigned variable 'val' is less than zero.

    val = get_oneshot_mode(ipipeif->input);
    if (val < 0) {
        pr_err("ipipeif: links setup required");
        return -EINVAL;
    }

but

static int get_oneshot_mode(enum ipipeif_input_entity input)

Introduced temporary variable for negativity check.
"val" is afterwards used in a lot of bitwise operations, so changing its type
to signed is not safe, according to CERT C Secure Coding Standards chapter
INT13-C: "Use bitwise operators only on unsigned operands"
https://www.securecoding.cert.org/confluence/display/seccode/INT13-C.+Use+bitwise+operators+only+on+unsigned+operands

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=80521
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
---
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
index 59540cd..6d4893b 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
@@ -196,6 +196,7 @@ static int ipipeif_hw_setup(struct v4l2_subdev *sd)
 	int data_shift;
 	int pack_mode;
 	int source1;
+	int tmp;
 
 	ipipeif_base_addr = ipipeif->ipipeif_base_addr;
 
@@ -206,8 +207,8 @@ static int ipipeif_hw_setup(struct v4l2_subdev *sd)
 	outformat = &ipipeif->formats[IPIPEIF_PAD_SOURCE];
 
 	/* Combine all the fields to make CFG1 register of IPIPEIF */
-	val = get_oneshot_mode(ipipeif->input);
-	if (val < 0) {
+	tmp = val = get_oneshot_mode(ipipeif->input);
+	if (tmp < 0) {
 		pr_err("ipipeif: links setup required");
 		return -EINVAL;
 	}
-- 
1.8.5.5

