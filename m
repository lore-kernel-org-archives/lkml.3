Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab3I0OdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 10:33:07 -0400
Received: from smtp-out-079.synserver.de ([212.40.185.79]:1074 "EHLO
	smtp-out-079.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab3I0OdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 10:33:04 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 25502
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@kernel.org>, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Cameron <jic23@kernel.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-spi@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 1/3] spi: Add a spi_w8r16be() helper
Date: Fri, 27 Sep 2013 16:34:27 +0200
Message-Id: <1380292469-17347-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new spi_w8r16be() helper, which is similar to spi_w8r16()
except that it converts the read data word from big endian to native endianness
before returning it. The reason for introducing this new helper is that for SPI
slave devices it is quite common that the read 16 bit data word is in big
endian. So users of spi_w8r16() have to convert the result to native endianness
manually. A second reason is that in this case the endianness of the return
value of spi_w8r16() depends on its sign. If it is negative (i.e. a error code)
it is already in native endianness, if it is positive it is in big endian. The
sparse code checker doesn't like this kind of mixed endianness and special
annotations are necessary to keep it quiet (E.g. casting to be16 using __force).
Doing the conversion to native endianness in the helper function does not
require such annotations since we are not mixing different endiannesses in the
same variable.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
I don't expect any conflicts, so in my opinion it should be fine to merge the
two users also through the SPI tree. Otherwise we can also just hold them off by
one release.
---
 include/linux/spi/spi.h | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 887116d..0e0aebd 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -823,6 +823,33 @@ static inline ssize_t spi_w8r16(struct spi_device *spi, u8 cmd)
 	return (status < 0) ? status : result;
 }
 
+/**
+ * spi_w8r16be - SPI synchronous 8 bit write followed by 16 bit big-endian read
+ * @spi: device with which data will be exchanged
+ * @cmd: command to be written before data is read back
+ * Context: can sleep
+ *
+ * This returns the (unsigned) sixteen bit number returned by the device in cpu
+ * endianness, or else a negative error code. Callable only from contexts that
+ * can sleep.
+ *
+ * This function is similar to spi_w8r16, with the exception that it will
+ * convert the read 16 bit data word from big-endian to native endianness.
+ *
+ */
+static inline ssize_t spi_w8r16be(struct spi_device *spi, u8 cmd)
+
+{
+	ssize_t status;
+	__be16 result;
+
+	status = spi_write_then_read(spi, &cmd, 1, &result, 2);
+	if (status < 0)
+		return status;
+
+	return be16_to_cpu(result);
+}
+
 /*---------------------------------------------------------------------------*/
 
 /*
-- 
1.8.0
