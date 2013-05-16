Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644Ab3EPJF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 05:05:27 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:59792 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751080Ab3EPJFY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 05:05:24 -0400
From: Mathias LEBLANC <Mathias.LEBLANC@st.com>
To: =?iso-8859-1?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>
Cc: Kent Yoder <key@linux.vnet.ibm.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        Jean-Luc BLANC <jean-luc.blanc@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 16 May 2013 10:45:51 +0200
Subject: RE: [tpmdd-devel] [PATCH 1/1] TPM: STMicroelectronics st33 driver
 SPI
Thread-Topic: [tpmdd-devel] [PATCH 1/1] TPM: STMicroelectronics st33 driver
 SPI
Thread-Index: Ac5RuwrjZaCmw5EJSn+2lRr63VuDfgAVIfqM
Message-ID: <35286B1AE75A7C47BFF0870081A31B4B45A8A84AF6@SAFEX1MAIL4.st.com>
References: <1368625999-1963-1-git-send-email-mathias.leblanc@st.com>,<201305160029.07073.PeterHuewe@gmx.de>
In-Reply-To: <201305160029.07073.PeterHuewe@gmx.de>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,
Thanks for your feedback.

You are right, this function looks like the spi_sync_transfer;
So, I will use it in the next version of the driver.

Regarding the while loop, I don't see how can I check the number of dummy byte differently?

For the module error, Yes I have modified the patch file :s, apparently I haven't correctly modified the number of lines

Finaly, These sparse warning are finaly fix ;).

Best regards,

Mathias Leblanc
________________________________________
From: Peter Hüwe [PeterHuewe@gmx.de]
Sent: 16 May 2013 00:29
To: tpmdd-devel@lists.sourceforge.net
Cc: Mathias LEBLANC; Kent Yoder; Rajiv Andrade; Marcel Selhorst; Sirrix AG; Jean-Luc BLANC; linux-kernel@vger.kernel.org
Subject: Re: [tpmdd-devel] [PATCH 1/1] TPM: STMicroelectronics st33 driver SPI

Hi Matthias,

Am Mittwoch, 15. Mai 2013, 15:53:19 schrieb Matthias Leblanc:

> +static inline int spi_read_write(struct spi_device *spi,
> +      struct spi_transfer xfer) {
> +     struct spi_message msg;
> +     spi_message_init(&msg);
> +     spi_message_add_tail(&xfer, &msg);
> +     return spi_sync(spi, &msg);
> +}

This looks extremely like the predefined spi_sync_transfer in include/linux/spi.h

/**
 * spi_sync_transfer - synchronous SPI data transfer
 * @spi: device with which data will be exchanged
 * @xfers: An array of spi_transfers
 * @num_xfers: Number of items in the xfer array
 * Context: can sleep
 *
 * Does a synchronous SPI data transfer of the given spi_transfer array.
 *
 * For more specific semantics see spi_sync().
 *
 * It returns zero on success, else a negative error code.
 */
static inline int
spi_sync_transfer(struct spi_device *spi, struct spi_transfer *xfers,
        unsigned int num_xfers)
{
        struct spi_message msg;

        spi_message_init_with_transfers(&msg, xfers, num_xfers);

        return spi_sync(spi, &msg);
}


where spi_message_init_with_transfers is defined as

static inline void
spi_message_init_with_transfers(struct spi_message *m,
struct spi_transfer *xfers, unsigned int num_xfers)
{
        unsigned int i;

        spi_message_init(m);
        for (i = 0; i < num_xfers; ++i)
                spi_message_add_tail(&xfers[i], m);
}


If you combine these functions you end up (more or less) with  your implementation

So please use spi_sync_transfer
OR as an alternative use spi_write / spi_read as an alternative as mentioned in a previous email



And here is a rather subjective remark:

> +             for (; nbr_dummy_bytes < total_length &&
> +                      ((u8 *)xfer.rx_buf)[nbr_dummy_bytes] == 0;
> +                      nbr_dummy_bytes++)
> +                     ;

Not sure if it would be easier to read using a while and putting the increment
into the loop body

>+              while (nbr_dummy_bytes < total_length &&
>+                      ((u8 *)xfer.rx_buf)[nbr_dummy_bytes] == 0)
>+                       nbr_dummy_bytes++;

I usually don't like empty loop bodies, as they tend to be overlooked.



> +module_spi_driver(tpm_st33_spi_driver);
> +
> +MODULE_AUTHOR("Christophe Ricard (tpmsupport@st.com)");
> +MODULE_DESCRIPTION("STM TPM SPI ST33 Driver");
> +MODULE_VERSION("1.2.0");
> +MODULE_LICENSE("GPL");

Something is strange here - if I apply your patch, the module license gets lost - so I get a compile warning:

WARNING: modpost: missing MODULE_LICENSE() in /data/data-old/linux-2.6/drivers/char/tpm/tpm_spi_stm_st33.o

Do you edit the patch by hand before sending?

Steps to reproduce:
drivers/char/tpm $ git reset --hard tpmdd/tpmdd-04-26-13
HEAD is now at d224213 tpm_tis: missing platform_driver_unregister() on error in init_tis()
drivers/char/tpm $ git am /tmp/\[tpmdd-devel\]\ \[PATCH\ 1_1\]\ TPM_STMicroelectronics\ st33\ driver\ SPI.mbox
Applying: TPM: STMicroelectronics st33 driver SPI

drivers/char/tpm $ tail tpm_spi_stm_st33.c                    },
        .probe = tpm_st33_spi_probe,
        .remove = tpm_st33_spi_remove,
};

module_spi_driver(tpm_st33_spi_driver);

MODULE_AUTHOR("Christophe Ricard (tpmsupport@st.com)");
MODULE_DESCRIPTION("STM TPM SPI ST33 Driver");
MODULE_VERSION("1.2.0");


And the usual sparse warnings ;)
drivers/char/tpm $ make M=`pwd` -C /data/data-old/linux-2.6/ modules C=1 CHECK=sparse
make: Entering directory `/data/data-old/linux-2.6'
  CHECK   /data/data-old/linux-2.6/drivers/char/tpm/tpm_spi_stm_st33.c
/data/data-old/linux-2.6/drivers/char/tpm/tpm_spi_stm_st33.c:104:35: warning: cast removes address space of expression
/data/data-old/linux-2.6/drivers/char/tpm/tpm_spi_stm_st33.c:170:35: warning: cast removes address space of expression
/data/data-old/linux-2.6/drivers/char/tpm/tpm_spi_stm_st33.c:242:19: warning: cast removes address space of expression
/data/data-old/linux-2.6/drivers/char/tpm/tpm_spi_stm_st33.c:235:15: warning: symbol 'wait_for_serirq_timeout' was not declared. Should it be static?
/data/data-old/linux-2.6/drivers/char/tpm/tpm_spi_stm_st33.c:482:19: warning: cast removes address space of expression



Regards,
Peter
