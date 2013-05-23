Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab3EWHnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 03:43:49 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:40255 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757418Ab3EWHnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 03:43:47 -0400
From: Mathias LEBLANC <Mathias.LEBLANC@st.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Kent Yoder <key@linux.vnet.ibm.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Luc BLANC <jean-luc.blanc@st.com>
Date: Thu, 23 May 2013 09:43:01 +0200
Subject: RE: [PATCH 1/1] TPM: STMicroelectronics st33 driver SPI
Thread-Topic: [PATCH 1/1] TPM: STMicroelectronics st33 driver SPI
Thread-Index: Ac5UfK3TvreE46RJTwmjcsXnnueewgDCZ+lA
Message-ID: <35286B1AE75A7C47BFF0870081A31B4B49E400663F@SAFEX1MAIL4.st.com>
References: <1368796239-2049-1-git-send-email-mathias.leblanc@st.com>
 <CAHp75Vf6iCZxe4tydVTJ3nMdFx7nMuSgnk0KSzps4ULxDoJV8Q@mail.gmail.com>
In-Reply-To: <CAHp75Vf6iCZxe4tydVTJ3nMdFx7nMuSgnk0KSzps4ULxDoJV8Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4N7hwuC002233

Hello Andy,

Thanks for your support, I will fix these code style problem.

However in a first time, can we publish this SPI driver?
I think that it will be preferable to submit it and apply some patch if it's only coding style error.
I have fix errors in this patch that has been discovered in the I2C patch, so I don't know what's stop this submission.
I think that's driver is more criticized than the I2C driver although it's the same base.
I know that's important to have good code in the kernel source and I'm agree about that,
I propose it be published as a first release and I fix coding style problem in a second time.

Thanks,

Mathias Leblanc

-----Original Message-----
From: Andy Shevchenko [mailto:andy.shevchenko@gmail.com] 
Sent: 19 May, 2013 12:36
To: Mathias LEBLANC
Cc: Kent Yoder; Rajiv Andrade; Marcel Selhorst; Sirrix AG; tpmdd-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org; Jean-Luc BLANC
Subject: Re: [PATCH 1/1] TPM: STMicroelectronics st33 driver SPI

On Fri, May 17, 2013 at 4:10 PM, Matthias Leblanc <mathias.leblanc@st.com> wrote:

> From: Mathias Leblanc <mathias.leblanc@st.com>

Which name is correct? You have not to have this From: line if submitter and author is the same person.

> +++ b/drivers/char/tpm/tpm_spi_stm_st33.c
> @@ -0,0 +1,943 @@
> +/*
> + * STMicroelectronics TPM SPI Linux driver for TPM ST33ZP24
> + * Copyright (C) 2009, 2010  STMicroelectronics

2013 as well?

> + *     09/15/2010:     First shot driver tpm_tis driver for lpc is
> + *                     used as model.

I beleive it could fit one line.

> +#include "tpm.h"
> +

Seems redundant empty line.

> +#include "tpm_spi_stm_st33.h"

> +enum stm33zp24_int_flags {
> +       TPM_GLOBAL_INT_ENABLE = 0x80,
> +       TPM_INTF_CMD_READY_INT = 0x080,

What the difference? It looks like first constant is not belong to this enum.

> +static int spi_write8_reg(struct tpm_chip *tpm, u8 tpm_register,
> +                     u8 *tpm_data, u16 tpm_size) {
> +       u8 data = 0;
> +       int total_length = 0, nbr_dummy_bytes;
> +       int value = 0;
> +       struct spi_device *dev =
> +                (struct spi_device __force *)tpm->vendor.iobase;
> +       struct st33zp24_platform_data *platform_data = dev->dev.platform_data;
> +       u8 *data_buffer = platform_data->tpm_spi_buffer[0];

It seems a bad idea to have buffers in platform_data. I bet the buffers should be part of other struct. What did I miss?

> +       struct spi_transfer xfer = {
> +               .tx_buf  = data_buffer,
> +               .rx_buf  = platform_data->tpm_spi_buffer[1],
> +       };

... even this entire structure.
Can you consider to use spi_message API ?

> +

Redundant empty line.

> +                       data = (tpm_size >> 8) & 0x00ff;

No need to do & 0xff. You have u8 type anyway.

> +                       data_buffer[total_length++] = data;
> +                       data = tpm_size & 0x00ff;

Ditto.

> +static unsigned long wait_for_serirq_timeout(struct tpm_chip *chip,
> +        bool condition, unsigned long timeout) {
> +       long status = 0;
> +       struct spi_device *client;
> +       struct st33zp24_platform_data *pin_infos;
> +
> +       client = (struct spi_device __force *)chip->vendor.iobase;

Is there any better storage for this pointer? It seems an abuse of iobase member.

> +       pin_infos = client->dev.platform_data;
> +
> +       status = wait_for_completion_interruptible_timeout(
> +                               &pin_infos->irq_detection, timeout);
> +       if (status > 0)
> +               enable_irq(gpio_to_irq(pin_infos->io_serirq));
> +       gpio_direction_input(pin_infos->io_serirq);
> +
> +       if (!status) {
> +               status = -EBUSY;
> +               goto wait_end;
> +       }
> +       clear_interruption(chip);
> +       if (condition)
> +               status = 1;
> +
> +wait_end:

Redundant label. Use direct return wherever it applies.

> +       return status;

> +/*
> + * tpm_stm_spi_cancel, cancel is not implemented.
> + * @param: chip, the tpm chip description as specified in
> + * driver/char/tpm/tpm.h.

Just mention the member and struct names here, no need to refer to entire file.

> + */
> +static void tpm_stm_spi_cancel(struct tpm_chip *chip) {
> +       u8 data = TPM_STS_COMMAND_READY;
> +
> +       /* this causes the current command to be aborted */
> +       spi_write8_reg(chip, TPM_STS, &data, 1); } /* 
> +tpm_stm_spi_cancel() */

This comment is redundant.

> +} /* tpm_stm_spi_status() */

Ditto.
Here and anywhere in the file.

> +
> +
> +

Couple of redundant empty lines.

> +static int request_locality(struct tpm_chip *chip) {

> +       unsigned long stop;
> +       long rc;
> +       u8 data = 0;

Redundant assignment. Please, check entire file for such assignments.

> +end:

Redundant label.

> +       return -EACCES;

> +static int get_burstcount(struct tpm_chip *chip) {

> +               tpm_reg = tpm_reg + 1;

tpm_reg++;

> +end:

Redundant label. Please, clean up entire file from such useless labels.

> +       return -EBUSY;

> +static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count) {

> +               burstcnt = get_burstcount(chip);
> +               len = min_t(int, burstcnt, count - size);
> +               status = spi_read8_reg(chip, TPM_DATA_FIFO, buf + size, len);
> +               if (status < 0)
> +                       return status;
> +
> +

Useless empty line(s).

> +static int tpm_stm_spi_send(struct tpm_chip *chip, unsigned char *buf,
> +                           size_t len) {
> +       u32 burstcnt = 0, i, size = 0;
> +       u8 data = 0;
> +       long status = 0, ret = 0;
> +
> +       if (chip == NULL)
> +               return -EBUSY;

-EINVAL, btw.

> +       if (len < TPM_HEADER_SIZE)
> +               return -EBUSY;

Same.

> +static int tpm_stm_spi_recv(struct tpm_chip *chip, unsigned char *buf,
> +                           size_t count) {
> +       int size = 0;
> +       int expected;
> +
> +       if (chip == NULL)
> +               return -EBUSY;

-EINVAL. Check entire code.

> +       if (count < TPM_HEADER_SIZE) {
> +               size = -EIO;
> +               goto out;
> +       }

You will perform asymmetric actions here. At least it requires some explanations in the header of fuction.

> +static int interrupts;
> +module_param(interrupts, int, 0444);
> +MODULE_PARM_DESC(interrupts, "Enable interrupts");
> +
> +static int power_mgt = 1;
> +module_param(power_mgt, int, 0444);
> +MODULE_PARM_DESC(power_mgt, "Power Management");

Move this section to the top/bottom of the file.

> +static int
> +tpm_st33_spi_probe(struct spi_device *dev) {
> +       long err = 0;
> +       u8 intmask;
> +       struct tpm_chip *chip;
> +       struct st33zp24_platform_data *platform_data;
> +
> +       /* Check SPI platform functionnalities */
> +       if (dev == NULL) {
> +               pr_info("dev is NULL. exiting.\n");

Looks like debug print. Should be remove

> +               err = -ENODEV;
> +               goto end;

return -ENODEV;

> +       chip = tpm_register_hardware(&dev->dev, &st_spi_tpm);
> +       if (!chip) {
> +               err = -ENODEV;
> +               goto end;

Ditto.

> +       /* Allocation of SPI buffers MISO and MOSI              */
> +       /* Size is as follow:                                   */
> +       /* Request burstcount value  = 0x800 = 2048             */
> +       /* +                                                    */
> +       /* Response burstcount value = 0x400 = 1024             */
> +       /* +                                                    */
> +       /* At least:                                            */
> +       /* 1 byte for direction/locality                        */
> +       /* 1 byte tpm tis register                              */
> +       /* 2 bytes spi data length (for request only)           */
> +       /* 2 latency bytes                                      */
> +       /* 1 status byte                                        */
> +       /* = 2048 + 1024 + 7                                    */
> +       /* We reserved 2048 + 1024 + 20 in case latency byte    */
> +       /* change                                               */

Looks like a candidate to *.h file in the struct description.

> +       platform_data = dev->dev.platform_data;

And as I said already, it's not a platform_data.

> +
> +       if (platform_data)

if (!platform_data)
 return -ENODEV;

> +               platform_data->tpm_spi_buffer[0] =
> +               kmalloc((TPM_BUFSIZE + (TPM_BUFSIZE / 2) +
> +                                TPM_DIGEST_SIZE) * sizeof(u8), 
> + GFP_KERNEL);

This magic calc may gone when you will use dedicated constant with mentioned explanations.

> +       else
> +               goto end;

Remove those two.

> +       chip->vendor.iobase = (void __iomem *)dev;

Don't like this one. Try to find better way to drag pointer.

> +       pr_info("TPM SPI Initialized\n");

Something like
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt at the very top of file could be helpful.

> +       if (platform_data->tpm_spi_buffer[1] != NULL) {

Redundant check.

> +               kfree(platform_data->tpm_spi_buffer[1]);

> +       if (platform_data->tpm_spi_buffer[0] != NULL) {

Ditto.

> +/*
> + * tpm_st33_spi_remove remove the TPM device
> + * @param: client, the spi_device drescription (TPM SPI description).

> +               clear_bit(0, &chip->is_open);

Leftover?

> + * @return: 0 in case of success.
> + */
> +static int tpm_st33_spi_remove(struct spi_device *client) {
> +       struct tpm_chip *chip = (struct tpm_chip *)spi_get_drvdata(client);
> +       struct st33zp24_platform_data *pin_infos =
> +        ((struct spi_device __force 
> +*)chip->vendor.iobase)->dev.platform_data;
> +
> +       if (pin_infos != NULL) {
> +               gpio_free(pin_infos->io_lpcpd);
> +
> +               /* Check if chip has been previously clean */
> +               if (pin_infos->bchipf != true)
> +                       tpm_remove_hardware(chip->dev);
> +               if (pin_infos->tpm_spi_buffer[1] != NULL) {

Redundant check.

> +                       kfree(pin_infos->tpm_spi_buffer[1]);
> +                       pin_infos->tpm_spi_buffer[1] = NULL;
> +               }
> +               if (pin_infos->tpm_spi_buffer[0] != NULL) {

Ditto.

> +++ b/drivers/char/tpm/tpm_spi_stm_st33.h
> @@ -0,0 +1,61 @@
> +/*
> + * STMicroelectronics TPM SPI Linux driver for TPM ST33NP18
> + * Copyright (C) 2009, 2010  STMicroelectronics

2013 as well?

> +#define TPM_ACCESS                     (0x0)
> +#define TPM_STS                                (0x18)
> +#define TPM_DATA_FIFO                  (0x24)
> +#define TPM_HASH_DATA                  (0x24)
> +#define TPM_INTF_CAPABILITY            (0x14)
> +#define TPM_INT_STATUS                 (0x10)
> +#define TPM_INT_ENABLE                 (0x08)

What the point to embrace those constants?

--
With Best Regards,
Andy Shevchenko
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
