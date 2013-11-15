Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab3KOMN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 07:13:58 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:4156 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861Ab3KOMNr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 07:13:47 -0500
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
From: "Hante Meuleman" <meuleman@broadcom.com>
To: "Geyslan G. Bem" <geyslan@gmail.com>
cc: "Brett Rudley" <brudley@broadcom.com>,
        "Arend Van Spriel" <arend@broadcom.com>,
        "Franky Lin" <frankyl@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Pieter-Paul Giesberts" <pieterpg@broadcom.com>,
        "Piotr Haber" <phaber@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list <brcm80211-dev-list@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] brcmfmac: fix possible memory leak
Thread-Topic: [PATCH] brcmfmac: fix possible memory leak
Thread-Index: AQHO4fpMK2ChQlgc2UWX5OSdFp3HBpomMogA
Date: Fri, 15 Nov 2013 12:13:37 +0000
Message-ID: <F51492713EF10846800D8C0ED37A7DCE0186947A@SJEXCHMB15.corp.ad.broadcom.com>
References: <1384516475-26589-1-git-send-email-geyslan@gmail.com>
In-Reply-To: <1384516475-26589-1-git-send-email-geyslan@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.203.100]
MIME-Version: 1.0
X-WSS-ID: 7E98D0691508419282-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good find, wrong solution. The chanspecs is a temporarily variable which should be freed when exiting the function. Not only when there is an error. I personally would have preferred just a  free at the end of the " if (request->n_channels) {". So something like this:

		}
		err = brcmf_p2p_escan(p2p, num_nodfs, chanspecs, search_state,
				      action, P2PAPI_BSSCFG_DEVICE);
+		kfree(chanspecs);
	}

In this case the pointer doesn't have to be initialized to NULL.


Regards,
Hante

-----Original Message-----
From: Geyslan G. Bem [mailto:geyslan@gmail.com] 
Sent: vrijdag 15 november 2013 12:54
To: geyslan@gmail.com
Cc: Brett Rudley; Arend Van Spriel; Franky Lin; Hante Meuleman; John W. Linville; Pieter-Paul Giesberts; Piotr Haber; linux-wireless@vger.kernel.org; brcm80211-dev-list; netdev@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: [PATCH] brcmfmac: fix possible memory leak

In case of error free 'chanspecs'.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index d7a9745..aea2c2e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -771,7 +771,7 @@ static s32 brcmf_p2p_run_escan(struct brcmf_cfg80211_info *cfg,
 	struct brcmf_cfg80211_vif *vif;
 	struct net_device *dev = NULL;
 	int i, num_nodfs = 0;
-	u16 *chanspecs;
+	u16 *chanspecs = NULL;
 
 	brcmf_dbg(TRACE, "enter\n");
 
@@ -825,8 +825,10 @@ static s32 brcmf_p2p_run_escan(struct brcmf_cfg80211_info *cfg,
 				      action, P2PAPI_BSSCFG_DEVICE);
 	}
 exit:
-	if (err)
+	if (err) {
 		brcmf_err("error (%d)\n", err);
+		kfree(chanspecs);
+	}
 	return err;
 }
 
-- 
1.8.4.2



