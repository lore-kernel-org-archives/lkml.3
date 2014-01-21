Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbaAUVR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:17:57 -0500
Received: from mail-db9lp0250.outbound.messaging.microsoft.com ([213.199.154.250]:35114
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750824AbaAUVRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:17:55 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zze0eahzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchz1de098h17326ah8275bh1de097h186068hz2dh839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h1155h)
X-WSS-ID: 0MZRSHM-08-4KN-02
X-M-MSG: 
From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
To: <dougthompson@xmission.com>, <bp@alien8.de>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: [PATCH] AMD64_EDAC: Fix logic to determine channel for F15 M30h processors
Date: Tue, 21 Jan 2014 15:03:36 -0600
Message-ID: <1390338216-3873-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current logic that returns (sys_addr >> 8) & 0x7 when
num_dcts_intlv = 4 is incorrect. We should really be doing-
If intlv_addr = 0x4, then interleave on bits [9:8] and if
intlv_addr = 0x5, interleave on bits [10:9].

Refer F15 M30h BKDG D18F2x110[7:6] (DRAM Controller Select Low)
(Link:http://support.amd.com/TechDocs/49125_15h_Models_30h-3Fh_BKDG.pdf)

Tested on F15 M30h with mce_inj module and patch did not cause
any regressions.

Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
---
 drivers/edac/amd64_edac.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index b53d0de..ef9fe30 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1240,9 +1240,17 @@ static u8 f15_m30h_determine_channel(struct amd64_pvt *pvt, u64 sys_addr,
 	if (num_dcts_intlv == 2) {
 		select = (sys_addr >> 8) & 0x3;
 		channel = select ? 0x3 : 0;
-	} else if (num_dcts_intlv == 4)
-		channel = (sys_addr >> 8) & 0x7;
-
+	} else if (num_dcts_intlv == 4) {
+		u8 intlv_addr = dct_sel_interleave_addr(pvt);
+		switch (intlv_addr) {
+		case 0x4:
+			channel = (sys_addr >> 8) & 0x3;
+			break;
+		case 0x5:
+			channel = (sys_addr >> 9) & 0x3;
+			break;
+		}
+	}
 	return channel;
 }
 
-- 
1.7.10.4


