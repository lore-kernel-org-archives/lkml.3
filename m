Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587AbaKROfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:35:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57207 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755082AbaKROKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:11 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Mark Brown <broonie@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 156/206] spi: fsl-dspi: Fix CTAR selection
Date: Tue, 18 Nov 2014 15:08:31 +0100
Message-Id: <35a3997ba76f408d13266a1e4cf01bbd264f9332.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Stein <alexander.stein@systec-electronic.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 5cc7b04740effa5cc0af53f434134b5859d58b73 upstream.

There are only 4 CTAR registers (CTAR0 - CTAR3) so we can only use the
lower 2 bits of the chip select to select a CTAR register.
SPI_PUSHR_CTAS used the lower 3 bits which would result in wrong bit values
if the chip selects 4/5 are used. For those chip selects SPI_CTAR even
calculated offsets of non-existing registers.

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/spi/spi-fsl-dspi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index f1322343d789..5d61ccbd31c2 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -45,7 +45,7 @@
 
 #define SPI_TCR			0x08
 
-#define SPI_CTAR(x)		(0x0c + (x * 4))
+#define SPI_CTAR(x)		(0x0c + (((x) & 0x3) * 4))
 #define SPI_CTAR_FMSZ(x)	(((x) & 0x0000000f) << 27)
 #define SPI_CTAR_CPOL(x)	((x) << 26)
 #define SPI_CTAR_CPHA(x)	((x) << 25)
@@ -69,7 +69,7 @@
 
 #define SPI_PUSHR		0x34
 #define SPI_PUSHR_CONT		(1 << 31)
-#define SPI_PUSHR_CTAS(x)	(((x) & 0x00000007) << 28)
+#define SPI_PUSHR_CTAS(x)	(((x) & 0x00000003) << 28)
 #define SPI_PUSHR_EOQ		(1 << 27)
 #define SPI_PUSHR_CTCNT	(1 << 26)
 #define SPI_PUSHR_PCS(x)	(((1 << x) & 0x0000003f) << 16)
-- 
2.1.3

