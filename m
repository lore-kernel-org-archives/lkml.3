Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016Ab3JJQDM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:03:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52822 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757087Ab3JJPru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:47:50 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Mark Brown <broonie@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 079/104] ASoC: ab8500-codec: info leak in anc_status_control_put()
Date: Thu, 10 Oct 2013 08:42:07 -0700
Message-Id: <1381419752-29733-80-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit d63733aed90b432e5cc489ddfa28e342f91b4652 upstream.

If the user passes an invalid value it leads to an info leak when we
print the error message or it could oops.  This is called with user
supplied data from snd_ctl_elem_write().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/codecs/ab8500-codec.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/ab8500-codec.c b/sound/soc/codecs/ab8500-codec.c
index 6c12ac2..52509dd 100644
--- a/sound/soc/codecs/ab8500-codec.c
+++ b/sound/soc/codecs/ab8500-codec.c
@@ -1225,13 +1225,18 @@ static int anc_status_control_put(struct snd_kcontrol *kcontrol,
 	struct ab8500_codec_drvdata *drvdata = dev_get_drvdata(codec->dev);
 	struct device *dev = codec->dev;
 	bool apply_fir, apply_iir;
-	int req, status;
+	unsigned int req;
+	int status;
 
 	dev_dbg(dev, "%s: Enter.\n", __func__);
 
 	mutex_lock(&drvdata->anc_lock);
 
 	req = ucontrol->value.integer.value[0];
+	if (req >= ARRAY_SIZE(enum_anc_state)) {
+		status = -EINVAL;
+		goto cleanup;
+	}
 	if (req != ANC_APPLY_FIR_IIR && req != ANC_APPLY_FIR &&
 		req != ANC_APPLY_IIR) {
 		dev_err(dev, "%s: ERROR: Unsupported status to set '%s'!\n",
-- 
1.8.1.2

