Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239AbbAYSX7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:23:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57551 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105AbbAYSKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Mike Looijmans <mike.looijmans@topic.nl>,
        Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 3.18 174/183] iio: ad799x: Fix ad7991/ad7995/ad7999 config setup
Date: Sun, 25 Jan 2015 10:08:16 -0800
Message-Id: <20150125180817.729755044@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit 2eacc608b3bf3519fc353c558454873f4589146d upstream.

The ad7991/ad7995/ad7999 does not have a configuration register like the
other devices that can be written and read. The configuration is written as
part of the conversion sequence.

Fixes: 0f7ddcc1bff1 ("iio:adc:ad799x: Write default config on probe and reset alert status on probe")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Tested-by: Mike Looijmans <mike.looijmans@topic.nl>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/ad799x.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/ad799x.c
+++ b/drivers/iio/adc/ad799x.c
@@ -143,9 +143,15 @@ static int ad799x_write_config(struct ad
 	case ad7998:
 		return i2c_smbus_write_word_swapped(st->client, AD7998_CONF_REG,
 			val);
-	default:
+	case ad7992:
+	case ad7993:
+	case ad7994:
 		return i2c_smbus_write_byte_data(st->client, AD7998_CONF_REG,
 			val);
+	default:
+		/* Will be written when doing a conversion */
+		st->config = val;
+		return 0;
 	}
 }
 
@@ -155,8 +161,13 @@ static int ad799x_read_config(struct ad7
 	case ad7997:
 	case ad7998:
 		return i2c_smbus_read_word_swapped(st->client, AD7998_CONF_REG);
-	default:
+	case ad7992:
+	case ad7993:
+	case ad7994:
 		return i2c_smbus_read_byte_data(st->client, AD7998_CONF_REG);
+	default:
+		/* No readback support */
+		return st->config;
 	}
 }
 


