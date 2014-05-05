Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932858AbaEEMxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:53:33 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:40999 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932287AbaEEMne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:43:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        Borislav Petkov <bp@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 16/50] amd64_edac: Fix logic to determine channel for F15 M30h processors
Date: Mon,  5 May 2014 14:42:58 +0200
Message-Id: <a9600ec90a49b7d1560f1e35fb83ead94f793b5b.1399292849.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
References: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
In-Reply-To: <cover.1399292849.git.jslaby@suse.cz>
References: <cover.1399292849.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 9d0e8d8348d54d60005c6c938b87b94648005d1c upstream.

Update current channel selection logic to include F15h, M30h memory
controllers.

Refer F15 M30h BKDG D18F2x110[7:6] (DRAM Controller Select Low)
(Link:http://support.amd.com/TechDocs/49125_15h_Models_30h-3Fh_BKDG.pdf)

Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Link: http://lkml.kernel.org/r/1390338216-3873-1-git-send-email-Aravind.Gopalakrishnan@amd.com
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/edac/amd64_edac.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 3c9e4e98c651..d43a6202a5c5 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1238,9 +1238,17 @@ static u8 f15_m30h_determine_channel(struct amd64_pvt *pvt, u64 sys_addr,
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
1.9.2

