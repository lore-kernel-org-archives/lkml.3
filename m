Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab3C1ShU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 14:37:20 -0400
Received: from mail1.bemta12.messagelabs.com ([216.82.251.4]:36179 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751718Ab3C1ShT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 14:37:19 -0400
X-Env-Sender: Max.Nekludov@us.elster.com
X-Msg-Ref: server-14.tower-109.messagelabs.com!1364495412!2568788!1
X-Originating-IP: [129.179.1.27]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
Subject: Bug in ks8851.c
X-KeepSent: D74B46B3:0370D664-44257B3C:00659B0D;
 type=4; name=$KeepSent
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org
X-Mailer: Lotus Notes Release 8.5.2FP3 July 11, 2011
Message-ID: <OFD74B46B3.0370D664-ON44257B3C.00659B0D-44257B3C.0065A14B@gb.elster.com>
From: Max.Nekludov@us.elster.com
Date: Thu, 28 Mar 2013 22:30:04 +0400
X-MIMETrack: Serialize by Router on US-SMTP01.domino.elster-group.com/RIM-TEMP(Release
 8.5.2FP3|July 10, 2011) at 03/28/2013 02:18:24 PM
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Forwarded by Max Nekludov/USE/Elster on 28.03.2013 22:29 -----
|------------>
| From:      |
|------------>
  >--------------------------------------------------------------------------------------------------------------------------------------------------|
  |Max Nekludov/USE/Elster                                                                                                                           |
  >--------------------------------------------------------------------------------------------------------------------------------------------------|
|------------>
| To:        |
|------------>
  >--------------------------------------------------------------------------------------------------------------------------------------------------|
  |torvalds@osdl.org                                                                                                                                 |
  >--------------------------------------------------------------------------------------------------------------------------------------------------|
|------------>
| Cc:        |
|------------>
  >--------------------------------------------------------------------------------------------------------------------------------------------------|
  |linux-kernel@vger.kernel.org, trivial@rustcorp.com.au                                                                                             |
  >--------------------------------------------------------------------------------------------------------------------------------------------------|
|------------>
| Date:      |
|------------>
  >--------------------------------------------------------------------------------------------------------------------------------------------------|
  |28.03.2013 22:25                                                                                                                                  |
  >--------------------------------------------------------------------------------------------------------------------------------------------------|
|------------>
| Subject:   |
|------------>
  >--------------------------------------------------------------------------------------------------------------------------------------------------|
  |Bug in ks8851.c                                                                                                                                   |
  >--------------------------------------------------------------------------------------------------------------------------------------------------|




According to the Datasheet (page 52):
15-12 Reserved
11-0 RXBC Receive Byte Count
This field indicates the present received frame byte size.

I suppose the code has a bug:
		rxh = ks8851_rdreg32(ks, KS_RXFHSR);
		rxstat = rxh & 0xffff;
		rxlen = rxh >> 16; // BUG!!! 0xFFF mask should be applied

P.S.
without bit mask applied I saw rxlen equal to 15360 which is bigger then
entire RX queue size (12KB).

Thanks,
Max Nekludov

>From cb3199cee4490f98d6062e32a75ca377a32b55bc Mon Sep 17 00:00:00 2001
From: Max Neklyudov <macscomp@gmail.com>
Date: Tue, 26 Mar 2013 11:46:57 +0400
Subject: [PATCH] Fix bug in ks8851 driver

---
 drivers/net/ks8851.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ks8851.c b/drivers/net/ks8851.c
index 91a93cb..0dc03da 100644
--- a/drivers/net/ks8851.c
+++ b/drivers/net/ks8851.c
@@ -553,7 +553,7 @@ static void ks8851_rx_pkts(struct ks8851_net *ks)
 	for (; rxfc != 0; rxfc--) {
 		rxh = ks8851_rdreg32(ks, KS_RXFHSR);
 		rxstat = rxh & 0xffff;
-		rxlen = rxh >> 16;
+		rxlen = (rxh >> 16) & 0xFFF;

 		netif_dbg(ks, rx_status, ks->netdev,
 			  "rx: stat 0x%04x, len 0x%04x\n", rxstat, rxlen);
--
1.7.10.4

