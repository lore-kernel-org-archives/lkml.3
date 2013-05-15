Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab3EOWZF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 18:25:05 -0400
Received: from mout.gmx.net ([212.227.17.21]:57748 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546Ab3EOWZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 18:25:03 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX188OdE9Syk8iRFUiXNKqI8pXQ10Du09k5c6r4Vgt9
	bsHPgxHIdAR9SI
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: tpmdd-devel@lists.sourceforge.net
Subject: Re: [tpmdd-devel] [PATCH 1/1] TPM: STMicroelectronics st33 driver SPI
Date: Thu, 16 May 2013 00:29:06 +0200
User-Agent: KMail/1.13.7 (Linux/3.8.11; KDE/4.9.5; x86_64; ; )
Cc: Matthias Leblanc <mathias.leblanc@st.com>,
        Kent Yoder <key@linux.vnet.ibm.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        "Jean-Luc Blanc" <jean-luc.blanc@st.com>, linux-kernel@vger.kernel.org
References: <1368625999-1963-1-git-send-email-mathias.leblanc@st.com>
In-Reply-To: <1368625999-1963-1-git-send-email-mathias.leblanc@st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305160029.07073.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthias,

Am Mittwoch, 15. Mai 2013, 15:53:19 schrieb Matthias Leblanc:

> +static inline int spi_read_write(struct spi_device *spi,
> +	 struct spi_transfer xfer) {
> +	struct spi_message msg;
> +	spi_message_init(&msg);
> +	spi_message_add_tail(&xfer, &msg);
> +	return spi_sync(spi, &msg);
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
