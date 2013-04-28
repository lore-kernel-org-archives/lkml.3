Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab3D1BMr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 21:12:47 -0400
Received: from mout.gmx.net ([212.227.15.19]:49195 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755081Ab3D1BMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 21:12:46 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+tIt9uJsGtipjKuQURp46ctaIlKomY6inLhOXkon
	FkGXQqnztMdyXI
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: tpmdd-devel@lists.sourceforge.net
Subject: Re: [tpmdd-devel] [PATCH 1/1] TPM: STMicroelectronics st33 driver SPI
Date: Sun, 28 Apr 2013 03:16:33 +0200
User-Agent: KMail/1.13.7 (Linux/3.8.4; KDE/4.9.5; x86_64; ; )
Cc: Mathias Leblanc <mathias.leblanc@st.com>,
        Kent Yoder <key@linux.vnet.ibm.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        "Jean-Luc Blanc" <jean-luc.blanc@st.com>, linux-kernel@vger.kernel.org,
        Matthias Leblanc <matthias.leblanc@gmail.com>
References: <1366620606-2952-1-git-send-email-mathias.leblanc@st.com>
In-Reply-To: <1366620606-2952-1-git-send-email-mathias.leblanc@st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304280316.34094.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthias,

it's nice to see that you consider most of the comments, unfortunately I still 
have some left ;)

> +/*
> + * tpm_st33_spi_init initialize driver
> + * @return: 0 if successful, else non zero value.
> + */
> +static int __init tpm_st33_spi_init(void)
> +{
> +	return spi_register_driver(&tpm_st33_spi_driver);
> +}
> +
> +/*
> + * tpm_st33_spi_exit The kernel calls this function during unloading the
> + * module or during shut down process
> + */
> +static void __exit tpm_st33_spi_exit(void)
> +{
> +	spi_unregister_driver(&tpm_st33_spi_driver);
> +}
> +
> +module_init(tpm_st33_spi_init);
> +module_exit(tpm_st33_spi_exit);

Please use module_spi_driver(&tpm_st33_spi_driver); instead
Boilerplate code sucks.


> +	u8 *data_buffer = platform_data->tpm_spi_buffer[0];
> +	struct spi_transfer xfer = {
> +		.tx_buf	 = data_buffer,
> +		.rx_buf	 = platform_data->tpm_spi_buffer[1],
> +	};
> +	struct spi_message msg;
>...
> +	xfer.len = total_length;
> +	spi_message_init(&msg);
> +	spi_message_add_tail(&xfer, &msg);
> +	value = spi_sync(dev, &msg);


Doesn't spi_write fit here ?

static inline int
spi_write(struct spi_device *spi, const void *buf, size_t len)
{
	struct spi_transfer	t = {
			.tx_buf		= buf,
			.len		= len,
		};
	struct spi_message	m;

	spi_message_init(&m);
	spi_message_add_tail(&t, &m);
	return spi_sync(spi, &m);
}

Seems pretty identical.
-> This would save some lines of code,
and again - boilerplate code sucks.
Same applies to spi_read,



The driver generates some gcc warnings:
 drivers/char/tpm/tpm_spi_stm_st33.c: In function 'read8_reg': 
 drivers/char/tpm/tpm_spi_stm_st33.c:180:5: warning: unused variable 'latency'  
[-Wunused-variable]
 drivers/char/tpm/tpm_spi_stm_st33.c: In function 'tpm_stm_spi_status':
 drivers/char/tpm/tpm_spi_stm_st33.c:353:2: warning: 'data' is used  
uninitialized in this function [-Wuninitialized]
 drivers/char/tpm/tpm_spi_stm_st33.c: In function 'get_burstcount':
 drivers/char/tpm/tpm_spi_stm_st33.c:450:12: warning: 'temp' is used  
uninitialized in this function [-Wuninitialized]
 drivers/char/tpm/tpm_spi_stm_st33.c: In function 'check_locality':
 drivers/char/tpm/tpm_spi_stm_st33.c:369:22: warning: 'data' may be used  
uninitialized in this function [-Wuninitialized]



The driver does give me some smatch errors:

$ LANG=C make -j16 C=1 CHECK=smatch
 CHECK   drivers/char/tpm/tpm_spi_stm_st33.c
 drivers/char/tpm/tpm_spi_stm_st33.c:882 tpm_st33_spi_probe() warn: variable  
dereferenced before check 'platform_data' (see line 781)
 drivers/char/tpm/tpm_spi_stm_st33.c:980 tpm_st33_spi_pm_resume() warn: should  
this be a bitwise op?
 drivers/char/tpm/tpm_spi_stm_st33.c:980 tpm_st33_spi_pm_resume() warn: should  
this be a bitwise op?



and some sparse errors:
 drivers/char/tpm/tpm_spi_stm_st33.c:102:35: warning: cast removes address 
space of expression
 drivers/char/tpm/tpm_spi_stm_st33.c:171:35: warning: cast removes address 
space of expression
 drivers/char/tpm/tpm_spi_stm_st33.c:299:19: warning: cast removes address 
space of expression
 drivers/char/tpm/tpm_spi_stm_st33.c:311:15: warning: symbol 
'wait_for_serirq_timeout' was not declared. Should it be static?
 drivers/char/tpm/tpm_spi_stm_st33.c:546:19: warning: cast removes address 
space of expression





And here are some other, rather subjective remarks:

> +		for (; nbr_dummy_bytes < total_length &&
> +			 ((u8 *)xfer.rx_buf)[nbr_dummy_bytes] == 0;
> +			 nbr_dummy_bytes++)
> +			;

Not sure if it would be easier to read using a while and putting the increment 
into the loop body

>+		while (nbr_dummy_bytes < total_length && 
>+			((u8 *)xfer.rx_buf)[nbr_dummy_bytes] == 0)
>+			 nbr_dummy_bytes++;

I usually don't like empty loop bodies, as they tend to be overlooked.



> +static u32 SPI_WRITE_DATA(struct tpm_chip *tpm, u8 tpm_register,
> +			  u8 *tpm_data, u16 tpm_size)
> +{
> +	u8 value = 0;
> +	value = write8_reg(tpm, tpm_register, tpm_data, tpm_size);
> +
> +	switch (value) {
> +	case TPM_ST_SPI_OK:
> +		return TPM_ST_SPI_OK;
> +	case 0:
> +		return 0;
> +	default:
> +		return -EBUSY;
> +	}
> +} /* SPI_WRITE_DATA() */

Why do you need a wrapper function here for the return code?
write8_reg is only called from this location, so why doesn't it return the 
correct error code directly?
*confused*


Same applies to read8_reg.




> +static int _wait_for_interrupt_serirq_timeout(struct tpm_chip *chip,
> +					unsigned long timeout)
Is only called from wait_for_serirq_timeout - I'm not really sure if it helps 
readability to have a separate function.




> +	.resume = tpm_st33_spi_pm_resume,
> +	.suspend = tpm_st33_spi_pm_suspend,
Maybe use 
SIMPLE_DEV_PM_OPS 
instead as it is (afaik) the new standard way for PM_OPS.
The conversion should be pretty similar to the one in your I2C TPM driver:
https://github.com/shpedoikal/linux/commit/d459335381eca1cb91fefb87021d3d172342e55a


Regards,
Peter

