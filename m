Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbaKRPFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:05:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57147 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932074AbaKROJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:40 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Chris Ball <chris@printf.net>,
        Lee Jones <lee.jones@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 080/206] mfd: rtsx_pcr: Fix MSI enable error handling
Date: Tue, 18 Nov 2014 15:07:15 +0100
Message-Id: <3d96e8ff2dbd213598460bda628892ce091f8dcc.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Ball <chris@printf.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 5152970538a5e16c03bbcb9f1c780489a795ed40 upstream.

pci_enable_msi() can return failure with both positive and negative
integers -- it returns 0 for success -- but is only tested here for
"if (ret < 0)".  This causes us to try to use MSI on the RTS5249 SD
reader in the Dell XPS 11 when enabling MSI failed, causing:

[    1.737110] rtsx_pci: probe of 0000:05:00.0 failed with error -110

Reported-by: D. Jared Dominguez <Jared_Dominguez@Dell.com>
Tested-by: D. Jared Dominguez <Jared_Dominguez@Dell.com>
Signed-off-by: Chris Ball <chris@printf.net>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/mfd/rtsx_pcr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index 6ed83feb0c52..c2a7804014f4 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -1172,7 +1172,7 @@ static int rtsx_pci_probe(struct pci_dev *pcidev,
 	pcr->msi_en = msi_en;
 	if (pcr->msi_en) {
 		ret = pci_enable_msi(pcidev);
-		if (ret < 0)
+		if (ret)
 			pcr->msi_en = false;
 	}
 
-- 
2.1.3

