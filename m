Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab3H0D2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 23:28:20 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:55409 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab3H0D2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 23:28:19 -0400
Date: Mon, 26 Aug 2013 22:28:10 -0500 (CDT)
From: Ashley Lai <ashley@ashleylai.com>
To: Mathias.LEBLANC@st.com, jean-luc.blanc@st.com,
        =?ISO-8859-15?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>,
        linux-kernel@vger.kernel.org
cc: tpmdd-devel@lists.sourceforge.net,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        "Rajiv Andrade (mail@srajiv.net)" <mail@srajiv.net>,
        "Sirrix AG (tpmdd@sirrix.com)" <tpmdd@sirrix.com>,
        andy.shevchenko@gmail.com, adlai@linux.vnet.ibm.com
Subject: Re: TPM: STMicroelectronics st33 driver SPI
In-Reply-To: <201308230054.34660.PeterHuewe@gmx.de>
Message-ID: <alpine.DEB.2.02.1308262145290.13156@fishsauce>
References: <35286B1AE75A7C47BFF0870081A31B4B4C87C3BED8@SAFEX1MAIL4.st.com> <201308171245.20964.PeterHuewe@gmx.de> <CALfuBuR9ucum5Na=f_rqUgAZxrdAdOBQ1BZDbpCCKDsk2TUVXQ@mail.gmail.com> <201308230054.34660.PeterHuewe@gmx.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please see my comments below.  Did you get a chance to run the trousers 
testsuite?

git://trousers.git.sourceforge.net/gitroot/trousers/testsuite

+static u8 spi_read8_reg(struct tpm_chip *tpm, u8 tpm_register,
+                   u8 *tpm_data, u16 tpm_size)
+{
+       ...
+
+       /* header + status byte + size of the data + status byte */
+       value = spi_sync_transfer(dev, &xfer, 1);
+
+       if (tpm_size > 0 && value == 0) {
+               nbr_dummy_bytes = 2;
Why use 2 for the dummy bytes?  Some comments here would be 
helpful.  Should we use a #define for 2?

...

+static unsigned long wait_for_serirq_timeout(struct tpm_chip *chip,
+        bool condition, unsigned long timeout)
+{
+       long status = 0;
+       struct spi_device *client;
+       struct st33zp24_platform_data *pin_infos;
+
+       client = (struct spi_device __force *)chip->vendor.iobase;
+       pin_infos = client->dev.platform_data;
+
+       status = wait_for_completion_interruptible_timeout(
+                               &pin_infos->irq_detection, timeout);
+       if (status > 0)
+               enable_irq(gpio_to_irq(pin_infos->io_serirq));
+       gpio_direction_input(pin_infos->io_serirq);
+
+       if (!status)
+               return -EBUSY;
This function returns -EBUSY but the return function type is unsigned.

...

+static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
+{
+       u32 size = 0, burstcnt, len;
+       long status = 0;
+
+       while (size < count &&
+              wait_for_stat(chip,
+                            TPM_STS_DATA_AVAIL | TPM_STS_VALID,
+                            chip->vendor.timeout_c,
+                            &chip->vendor.read_queue)
+                                               == 0) {
+               burstcnt = get_burstcount(chip);
+               len = min_t(int, burstcnt, count - size);

What if get_burstcount returns -EBUSY?  Should burstcnt be checked
and handled here in case of error?

+               status = spi_read8_reg(chip, TPM_DATA_FIFO, buf + size, 
len);
+               if (status < 0)
+                       return status;
+
+
Extra empty line here.
+               size += len;

See above comment.  If len is -EBUSY, there might be an issue here.

+       }
+return size;

...

+static int tpm_stm_spi_send(struct tpm_chip *chip, unsigned char *buf,
+                           size_t len)
+{
...
+	for (i = 0; i < len - 1;) {
+		burstcnt = get_burstcount(chip);
Again burstcnt needs to be checked to make sure it is > 0.

+		size = min_t(int, len - i - 1, burstcnt);
+		ret = spi_write8_reg(chip, TPM_DATA_FIFO, buf, size);
+		if (ret < 0)
+			goto out_err;
+		i += size;
+	}
...
+       /* write last byte */
+       spi_write8_reg(chip, TPM_DATA_FIFO, buf + len - 1, 1);
Should we check for the return code here?  A few lines below it checks 
for the return value.
...
+
+
+       /* go and do it */
+       data = TPM_STS_GO;
+       ret = spi_write8_reg(chip, TPM_STS, &data, 1);

Regards,
--Ashley Lai


