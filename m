Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581Ab3JKUDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:03:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46250 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932558Ab3JKTlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:41:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Mark Brown <broonie@linaro.org>
Subject: [ 057/135] ASoC: ab8500-codec: info leak in anc_status_control_put()
Date: Fri, 11 Oct 2013 12:38:58 -0700
Message-Id: <20131011193951.474213125@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit d63733aed90b432e5cc489ddfa28e342f91b4652 upstream.

If the user passes an invalid value it leads to an info leak when we
print the error message or it could oops.  This is called with user
supplied data from snd_ctl_elem_write().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/ab8500-codec.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/sound/soc/codecs/ab8500-codec.c
+++ b/sound/soc/codecs/ab8500-codec.c
@@ -1225,13 +1225,18 @@ static int anc_status_control_put(struct
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


