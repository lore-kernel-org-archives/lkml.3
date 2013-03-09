Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481Ab3CISPP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 13:15:15 -0500
Received: from smtp-out-195.synserver.de ([212.40.185.195]:1089 "EHLO
	smtp-out-193.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751425Ab3CISPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 13:15:13 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 31737
From: Lars-Peter Clausen <lars@metafoo.de>
To: Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH 5/6] i2c: Ignore the return value of i2c_del_mux_adapter()
Date: Sat,  9 Mar 2013 19:16:48 +0100
Message-Id: <1362853009-20789-6-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1362853009-20789-1-git-send-email-lars@metafoo.de>
References: <1362853009-20789-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i2c_del_mux_adapter() always returns 0. So all checks testing whether it will be
non zero will always evaluate to false and the conditional code is dead code.
This patch updates all callers of i2c_del_mux_adapter() to ignore its return
value and assume that it will always succeed (which it will). A subsequent
patch will make the return type of i2c_del_mux_adapter() void.

Cc: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/i2c/muxes/i2c-mux-pca954x.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/muxes/i2c-mux-pca954x.c b/drivers/i2c/muxes/i2c-mux-pca954x.c
index 8e43872..a531d80 100644
--- a/drivers/i2c/muxes/i2c-mux-pca954x.c
+++ b/drivers/i2c/muxes/i2c-mux-pca954x.c
@@ -262,13 +262,11 @@ static int pca954x_remove(struct i2c_client *client)
 {
 	struct pca954x *data = i2c_get_clientdata(client);
 	const struct chip_desc *chip = &chips[data->type];
-	int i, err;
+	int i;
 
 	for (i = 0; i < chip->nchans; ++i)
 		if (data->virt_adaps[i]) {
-			err = i2c_del_mux_adapter(data->virt_adaps[i]);
-			if (err)
-				return err;
+			i2c_del_mux_adapter(data->virt_adaps[i]);
 			data->virt_adaps[i] = NULL;
 		}
 
-- 
1.8.0

