Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758928Ab3FMVMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 17:12:18 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:35692 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757669Ab3FMVMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 17:12:17 -0400
X-Greylist: delayed 390 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Jun 2013 17:12:17 EDT
From: Dominik Paulus <dominik.paulus@fau.de>
To: devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@i4.cs.fau.de,
        David Binderman <dcb314@hotmail.com>,
        Devendra Naga <devendra.aaru@gmail.com>, Priit Laes <plaes@plaes.org>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Tobias Polzer <tobias.polzer@fau.de>,
        Dominik Paulus <dominik.paulus@fau.de>
Subject: [PATCH] Fix obvious logic error in staging/csr
Date: Thu, 13 Jun 2013 23:00:35 +0200
Message-Id: <1371157235-4697-1-git-send-email-dominik.paulus@fau.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tobias Polzer <tobias.polzer@fau.de>

In uf_process_ma_packet_req() (staging/csr/unifi_pdu_processing.c), the
test for
(staInfo->timSet != CSR_WIFI_TIM_RESET) || (staInfo->timSet !=
CSR_WIFI_TIM_RESETTING)
obviously makes no sense and causes GCC to emit a warning if
-Wlogical-op is enabled.
As suggested in the referenced bug report, || was replaced by &&.

References: https://bugzilla.kernel.org/show_bug.cgi?id=46571
Reported-By: David Binderman <dcb314@hotmail.com>
Signed-off-by: Tobias Polzer <tobias.polzer@fau.de>
Signed-off-by: Dominik Paulus <dominik.paulus@fau.de>
---
 drivers/staging/csr/unifi_pdu_processing.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/csr/unifi_pdu_processing.c b/drivers/staging/csr/unifi_pdu_processing.c
index f9b421b..8634193 100644
--- a/drivers/staging/csr/unifi_pdu_processing.c
+++ b/drivers/staging/csr/unifi_pdu_processing.c
@@ -2704,7 +2704,7 @@ static void uf_handle_uspframes_delivery(unifi_priv_t * priv, CsrWifiRouterCtrlS
      */
     is_all_ac_deliver_enabled_and_moredata(staInfo, &allDeliveryEnabled, &dataAvailable);
     if ((allDeliveryEnabled && !dataAvailable)) {
-        if ((staInfo->timSet != CSR_WIFI_TIM_RESET) || (staInfo->timSet != CSR_WIFI_TIM_RESETTING)) {
+        if ((staInfo->timSet != CSR_WIFI_TIM_RESET) && (staInfo->timSet != CSR_WIFI_TIM_RESETTING)) {
             staInfo->updateTimReqQueued = (u8) CSR_WIFI_TIM_RESET;
             unifi_trace(priv, UDBG4, " --uf_handle_uspframes_delivery, UAPSD timset\n");
             if (!staInfo->timRequestPendingFlag) {
-- 
1.7.10.4

