Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422731Ab3BOPya (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 10:54:30 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:35271 "HELO
	vsp-authed-03-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S935939Ab3BOPwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 10:52:46 -0500
From: Andreas Larsson <andreas@gaisler.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        spi-devel-general@lists.sourceforge.net,
        Mingkai Hu <Mingkai.hu@freescale.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
        Kumar Gala <galak@kernel.crashing.org>,
        Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: [PATCH v3 5/7] spi: spi-fsl-spi: Add support for setting a maximum number of bits per word
Date: Fri, 15 Feb 2013 16:52:25 +0100
Message-Id: <1360943547-2186-6-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1360943547-2186-1-git-send-email-andreas@gaisler.com>
References: <1360943547-2186-1-git-send-email-andreas@gaisler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Anton Vorontsov <anton@enomsg.org>
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---
 drivers/spi/spi-fsl-lib.h |    1 +
 drivers/spi/spi-fsl-spi.c |    8 +++++++-
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi-fsl-lib.h b/drivers/spi/spi-fsl-lib.h
index 5a9c36c..d5c788b 100644
--- a/drivers/spi/spi-fsl-lib.h
+++ b/drivers/spi/spi-fsl-lib.h
@@ -71,6 +71,7 @@ struct mpc8xxx_spi {
 
 #ifdef CONFIG_SPI_FSL_SPI
 	int type;
+	u8 max_bits_per_word;
 
 	void (*set_shifts)(u32 *rx_shift, u32 *tx_shift,
 			   int bits_per_word, int msb_first);
diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
index 9ae3c44..91d3d26 100644
--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -213,7 +213,8 @@ static int fsl_spi_setup_transfer(struct spi_device *spi,
 
 	/* Make sure its a bit width we support [4..16, 32] */
 	if ((bits_per_word < 4)
-	    || ((bits_per_word > 16) && (bits_per_word != 32)))
+	    || ((bits_per_word > 16) && (bits_per_word != 32))
+	    || (bits_per_word > mpc8xxx_spi->max_bits_per_word))
 		return -EINVAL;
 
 	if (!hz)
@@ -520,6 +521,7 @@ static struct spi_master * fsl_spi_probe(struct device *dev,
 	mpc8xxx_spi = spi_master_get_devdata(master);
 	mpc8xxx_spi->spi_do_one_msg = fsl_spi_do_one_msg;
 	mpc8xxx_spi->spi_remove = fsl_spi_remove;
+	mpc8xxx_spi->max_bits_per_word = 32;
 	mpc8xxx_spi->type = fsl_spi_get_type(dev);
 
 	ret = fsl_spi_cpm_init(mpc8xxx_spi);
@@ -557,6 +559,10 @@ static struct spi_master * fsl_spi_probe(struct device *dev,
 
 	/* Enable SPI interface */
 	regval = pdata->initial_spmode | SPMODE_INIT_VAL | SPMODE_ENABLE;
+	if (mpc8xxx_spi->max_bits_per_word < 8) {
+		regval &= ~SPMODE_LEN(0xF);
+		regval |= SPMODE_LEN(mpc8xxx_spi->max_bits_per_word - 1);
+	}
 	if (mpc8xxx_spi->flags & SPI_QE_CPU_MODE)
 		regval |= SPMODE_OP;
 
-- 
1.7.0.4

