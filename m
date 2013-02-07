Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706Ab3BGNNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 08:13:32 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:42568 "HELO
	vsp-authed-01-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758422Ab3BGNNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 08:13:16 -0500
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
Subject: [PATCH v2 7/7] spi: spi-fsl-spi: Add support for gpio chipselects for GRLIB type cores
Date: Thu,  7 Feb 2013 14:12:11 +0100
Message-Id: <1360242731-13700-8-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1360242731-13700-1-git-send-email-andreas@gaisler.com>
References: <1360242731-13700-1-git-send-email-andreas@gaisler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This relies upon of_spi_register_master to find out which gpios to use.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---
 drivers/spi/spi-fsl-lib.h |    1 +
 drivers/spi/spi-fsl-spi.c |   53 +++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 48 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-fsl-lib.h b/drivers/spi/spi-fsl-lib.h
index d5c788b..52db693 100644
--- a/drivers/spi/spi-fsl-lib.h
+++ b/drivers/spi/spi-fsl-lib.h
@@ -71,6 +71,7 @@ struct mpc8xxx_spi {
 
 #ifdef CONFIG_SPI_FSL_SPI
 	int type;
+	int native_chipselects;
 	u8 max_bits_per_word;
 
 	void (*set_shifts)(u32 *rx_shift, u32 *tx_shift,
diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
index 55652e6..2befe16 100644
--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -418,7 +418,7 @@ static int fsl_spi_setup(struct spi_device *spi)
 {
 	struct mpc8xxx_spi *mpc8xxx_spi;
 	struct fsl_spi_reg *reg_base;
-	int retval;
+	int retval, desel;
 	u32 hw_mode;
 	struct spi_mpc8xxx_cs	*cs = spi->controller_state;
 
@@ -456,12 +456,45 @@ static int fsl_spi_setup(struct spi_device *spi)
 		return retval;
 	}
 
+	if (mpc8xxx_spi->type == TYPE_GRLIB) {
+		if (gpio_is_valid(spi->cs_gpio)) {
+			retval = gpio_request(spi->cs_gpio,
+					      dev_name(&spi->dev));
+			if (retval)
+				return retval;
+
+			desel = !(spi->mode & SPI_CS_HIGH);
+			desel ^= !!(spi->cs_gpio_flags & OF_GPIO_ACTIVE_LOW);
+			retval = gpio_direction_output(spi->cs_gpio, desel);
+			if (retval) {
+				gpio_free(spi->cs_gpio);
+				return retval;
+			}
+		} else if (spi->cs_gpio != -EEXIST) {
+			if (spi->cs_gpio < 0)
+				return spi->cs_gpio;
+			return -EINVAL;
+		}
+		/* When spi->cs_gpio == -EEXIST, a hole in the phandle list
+		 * indicates to use native chipselect if present, or allow for
+		 * an always selected chip
+		 */
+	}
+
 	/* Initialize chipselect - might be active for SPI_CS_HIGH mode */
 	fsl_spi_chipselect(spi, BITBANG_CS_INACTIVE);
 
 	return 0;
 }
 
+static void fsl_spi_cleanup(struct spi_device *spi)
+{
+	struct mpc8xxx_spi *mpc8xxx_spi = spi_master_get_devdata(spi->master);
+
+	if (mpc8xxx_spi->type == TYPE_GRLIB && gpio_is_valid(spi->cs_gpio))
+		gpio_free(spi->cs_gpio);
+}
+
 static void fsl_spi_cpu_irq(struct mpc8xxx_spi *mspi, u32 events)
 {
 	struct fsl_spi_reg *reg_base = mspi->reg_base;
@@ -529,9 +562,15 @@ static void fsl_spi_grlib_cs_control(struct spi_device *spi, bool on)
 	u32 slvsel;
 	u16 cs = spi->chip_select;
 
-	slvsel = mpc8xxx_spi_read_reg(&reg_base->slvsel);
-	slvsel = on ? (slvsel | (1 << cs)) : (slvsel & ~(1 << cs));
-	mpc8xxx_spi_write_reg(&reg_base->slvsel, slvsel);
+	if (gpio_is_valid(spi->cs_gpio)) {
+		if  (spi->cs_gpio_flags & OF_GPIO_ACTIVE_LOW)
+			on = !on;
+		gpio_set_value(spi->cs_gpio, on);
+	} else if (cs < mpc8xxx_spi->native_chipselects) {
+		slvsel = mpc8xxx_spi_read_reg(&reg_base->slvsel);
+		slvsel = on ? (slvsel | (1 << cs)) : (slvsel & ~(1 << cs));
+		mpc8xxx_spi_write_reg(&reg_base->slvsel, slvsel);
+	}
 }
 
 static void fsl_spi_grlib_probe(struct device *dev)
@@ -550,11 +589,12 @@ static void fsl_spi_grlib_probe(struct device *dev)
 	if (mbits)
 		mpc8xxx_spi->max_bits_per_word = mbits + 1;
 
-	master->num_chipselect = 1; /* Allow for an always selected chip */
+	mpc8xxx_spi->native_chipselects = 0;
 	if (SPCAP_SSEN(capabilities)) {
-		master->num_chipselect = SPCAP_SSSZ(capabilities);
+		mpc8xxx_spi->native_chipselects = SPCAP_SSSZ(capabilities);
 		mpc8xxx_spi_write_reg(&reg_base->slvsel, 0xffffffff);
 	}
+	master->num_chipselect = mpc8xxx_spi->native_chipselects;
 	pdata->cs_control = fsl_spi_grlib_cs_control;
 }
 
@@ -581,6 +621,7 @@ static struct spi_master * fsl_spi_probe(struct device *dev,
 		goto err_probe;
 
 	master->setup = fsl_spi_setup;
+	master->cleanup = fsl_spi_cleanup;
 
 	mpc8xxx_spi = spi_master_get_devdata(master);
 	mpc8xxx_spi->spi_do_one_msg = fsl_spi_do_one_msg;
-- 
1.7.0.4

