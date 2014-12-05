Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311AbaLEXrs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:47:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53862 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbaLEWp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:45:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        JS Park <aitdark.park@samsung.com>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.17 039/122] ASoC: wm_adsp: Avoid attempt to free buffers that might still be in use
Date: Fri,  5 Dec 2014 14:43:33 -0800
Message-Id: <20141205223311.328359021@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

commit 9da7a5a9fdeeb76b2243f6b473363a7e6147ab6f upstream.

We should not free any buffers associated with writing out coefficients
to the DSP until all the async writes have completed. This patch updates
the out of memory path when allocating a new buffer to include a call to
regmap_async_complete.

Reported-by: JS Park <aitdark.park@samsung.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm_adsp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -1355,6 +1355,7 @@ static int wm_adsp_load_coeff(struct wm_
 			  file, blocks, pos - firmware->size);
 
 out_fw:
+	regmap_async_complete(regmap);
 	release_firmware(firmware);
 	wm_adsp_buf_free(&buf_list);
 out:


