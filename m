Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704AbaL0Tkx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 14:40:53 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47483 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaL0Tks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 14:40:48 -0500
Date: Sat, 27 Dec 2014 20:40:45 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@kernel.org>
Cc: Pali Rohar <pali.rohar@gmail.com>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>, Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, lm-sensors@lm-sensors.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH 2/3] hwmon: Driver for OMAP3 temperature sensor
Message-ID: <20141227194045.GD10007@amd>
References: <20141226102933.GA28778@amd>
 <1419597294-21487-1-git-send-email-sre@kernel.org>
 <1419597294-21487-3-git-send-email-sre@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419597294-21487-3-git-send-email-sre@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-12-26 13:34:53, Sebastian Reichel wrote:
> OMAP34xx and OMAP36xx processors contain a register in the syscon area,
> which can be used to determine the SoCs temperature. This patch provides
> a DT based driver for the temperature sensor based on an older driver
> written by Peter De Schrijver for the Nokia N900 and N9.
> 
> Signed-off-by: Sebastian Reichel <sre@kernel.org>

I'd suggest these cleanups... But I don't see why it would fail. (Aha,
and sorry for trailing whitespace, you'll probably need to delete it.)

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/hwmon/omap3-temp.c b/drivers/hwmon/omap3-temp.c
index afe1b5a..8a69604 100644
--- a/drivers/hwmon/omap3-temp.c
+++ b/drivers/hwmon/omap3-temp.c
@@ -35,21 +35,29 @@
 /* 32.768Khz clock speed in nano seconds */
 #define CLOCK_32K_SPEED_NS 30518
 
-/* minimum delay for EOCZ rise after SOC rise is
- * 11 cycles of the 32.768Khz clock */
+/*
+ * minimum delay for EOCZ rise after SOC rise is
+ * 11 cycles of the 32.768Khz clock
+ */
 #define EOCZ_MIN_RISING_DELAY (11 * CLOCK_32K_SPEED_NS)
 
-/* From docs, maximum delay for EOCZ rise after SOC rise is
+/*
+ * From docs, maximum delay for EOCZ rise after SOC rise is
  * 14 cycles of the 32.768Khz clock. But after some experiments,
- * 24 cycles as maximum is safer. */
+ * 24 cycles as maximum is safer.
+ */
 #define EOCZ_MAX_RISING_DELAY (24 * CLOCK_32K_SPEED_NS)
 
-/* minimum delay for EOCZ falling is
- * 36 cycles of the 32.768Khz clock */
+/*
+ * minimum delay for EOCZ falling is
+ * 36 cycles of the 32.768Khz clock 
+ */
 #define EOCZ_MIN_FALLING_DELAY (36 * CLOCK_32K_SPEED_NS)
 
-/* maximum delay for EOCZ falling is
- * 40 cycles of the 32.768Khz clock */
+/*
+ * maximum delay for EOCZ falling is
+ * 40 cycles of the 32.768Khz clock 
+ */
 #define EOCZ_MAX_FALLING_DELAY (40 * CLOCK_32K_SPEED_NS)
 
 /* temperature register offset in the syscon register area */
@@ -116,8 +124,8 @@ struct omap3_temp_data {
 	bool valid;
 };
 
-static inline u32 wait_for_eocz(int min_delay, int max_delay, u32 level,
-				struct omap3_temp_data *data)
+static inline bool wait_for_eocz(struct omap3_temp_data *data,
+				 int min_delay, int max_delay, u32 level)
 {
 	ktime_t timeout, expire;
 	u32 temp_sensor_reg, eocz_mask;
@@ -133,10 +141,10 @@ static inline u32 wait_for_eocz(int min_delay, int max_delay, u32 level,
 	do {
 		regmap_read(data->syscon, SYSCON_TEMP_REG, &temp_sensor_reg);
 		if ((temp_sensor_reg & eocz_mask) == level)
-			break;
+			return true;
 	} while (ktime_us_delta(expire, ktime_get()) > 0);
 
-	return (temp_sensor_reg & eocz_mask) == level;
+	return false;
 }
 
 static int omap3_temp_update(struct omap3_temp_data *data)
@@ -153,16 +161,16 @@ static int omap3_temp_update(struct omap3_temp_data *data)
 		regmap_update_bits(data->syscon, SYSCON_TEMP_REG,
 				   soc_mask, soc_mask);
 
-		if (!wait_for_eocz(EOCZ_MIN_RISING_DELAY,
-		    EOCZ_MAX_RISING_DELAY, 1, data)) {
+		if (!wait_for_eocz(data, EOCZ_MIN_RISING_DELAY,
+		    EOCZ_MAX_RISING_DELAY, 1)) {
 			e = -EIO;
 			goto err;
 		}
 
 		regmap_update_bits(data->syscon, SYSCON_TEMP_REG, soc_mask, 0);
 
-		if (!wait_for_eocz(EOCZ_MIN_FALLING_DELAY,
-		    EOCZ_MAX_FALLING_DELAY, 0, data)) {
+		if (!wait_for_eocz(data, EOCZ_MIN_FALLING_DELAY,
+		    EOCZ_MAX_FALLING_DELAY, 0)) {
 			e = -EIO;
 			goto err;
 		}


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
