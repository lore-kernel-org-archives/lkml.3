Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309Ab3D2OSD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 10:18:03 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:37942 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab3D2OSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 10:18:00 -0400
Date: Mon, 29 Apr 2013 09:15:30 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Peter =?iso-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: tpmdd-devel@lists.sourceforge.net,
        Mathias Leblanc <mathias.leblanc@st.com>,
        Rajiv Andrade <mail@srajiv.net>, Marcel Selhorst <tpmdd@selhorst.net>,
        Sirrix AG <tpmdd@sirrix.com>, Jean-Luc Blanc <jean-luc.blanc@st.com>,
        linux-kernel@vger.kernel.org,
        Matthias Leblanc <matthias.leblanc@gmail.com>
Subject: Re: [tpmdd-devel] [PATCH 1/1] TPM: STMicroelectronics st33 driver SPI
Message-ID: <20130429141530.GA4789@ennui.austin.ibm.com>
References: <1366620606-2952-1-git-send-email-mathias.leblanc@st.com>
 <201304280316.34094.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201304280316.34094.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042914-3620-0000-0000-0000023D2A63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 28, 2013 at 03:16:33AM +0200, Peter Hüwe wrote:
> Hi Matthias,
> 
> it's nice to see that you consider most of the comments, unfortunately I still 
> have some left ;)
> 
> > +/*
> > + * tpm_st33_spi_init initialize driver
> > + * @return: 0 if successful, else non zero value.
> > + */
> > +static int __init tpm_st33_spi_init(void)
> > +{
> > +	return spi_register_driver(&tpm_st33_spi_driver);
> > +}
> > +
> > +/*
> > + * tpm_st33_spi_exit The kernel calls this function during unloading the
> > + * module or during shut down process
> > + */
> > +static void __exit tpm_st33_spi_exit(void)
> > +{
> > +	spi_unregister_driver(&tpm_st33_spi_driver);
> > +}
> > +
> > +module_init(tpm_st33_spi_init);
> > +module_exit(tpm_st33_spi_exit);
> 
> Please use module_spi_driver(&tpm_st33_spi_driver); instead
> Boilerplate code sucks.
> 
> 
> > +	u8 *data_buffer = platform_data->tpm_spi_buffer[0];
> > +	struct spi_transfer xfer = {
> > +		.tx_buf	 = data_buffer,
> > +		.rx_buf	 = platform_data->tpm_spi_buffer[1],
> > +	};
> > +	struct spi_message msg;
> >...
> > +	xfer.len = total_length;
> > +	spi_message_init(&msg);
> > +	spi_message_add_tail(&xfer, &msg);
> > +	value = spi_sync(dev, &msg);
> 
> 
> Doesn't spi_write fit here ?
> 
> static inline int
> spi_write(struct spi_device *spi, const void *buf, size_t len)
> {
> 	struct spi_transfer	t = {
> 			.tx_buf		= buf,
> 			.len		= len,
> 		};
> 	struct spi_message	m;
> 
> 	spi_message_init(&m);
> 	spi_message_add_tail(&t, &m);
> 	return spi_sync(spi, &m);
> }
> 
> Seems pretty identical.
> -> This would save some lines of code,
> and again - boilerplate code sucks.
> Same applies to spi_read,
> 
> 
> 
> The driver generates some gcc warnings:
>  drivers/char/tpm/tpm_spi_stm_st33.c: In function 'read8_reg': 
>  drivers/char/tpm/tpm_spi_stm_st33.c:180:5: warning: unused variable 'latency'  
> [-Wunused-variable]
>  drivers/char/tpm/tpm_spi_stm_st33.c: In function 'tpm_stm_spi_status':
>  drivers/char/tpm/tpm_spi_stm_st33.c:353:2: warning: 'data' is used  
> uninitialized in this function [-Wuninitialized]
>  drivers/char/tpm/tpm_spi_stm_st33.c: In function 'get_burstcount':
>  drivers/char/tpm/tpm_spi_stm_st33.c:450:12: warning: 'temp' is used  
> uninitialized in this function [-Wuninitialized]
>  drivers/char/tpm/tpm_spi_stm_st33.c: In function 'check_locality':
>  drivers/char/tpm/tpm_spi_stm_st33.c:369:22: warning: 'data' may be used  
> uninitialized in this function [-Wuninitialized]

 Thanks for pointing this out Peter -- it made me realize my bash
aliases for checking were not working. :-)

Please take a look at these too:

drivers/char/tpm/tpm_spi_stm_st33.c:446 get_burstcount() warn: unsigned
'status' is never less than zero.
drivers/char/tpm/tpm_spi_stm_st33.c:452 get_burstcount() warn: unsigned
'status' is never less than zero.
drivers/char/tpm/tpm_spi_stm_st33.c:523 recv_data() warn: unsigned
'status' is never less than zero.
drivers/char/tpm/tpm_spi_stm_st33.c:572 tpm_stm_spi_send() warn:
unsigned 'ret' is never less than zero.
drivers/char/tpm/tpm_spi_stm_st33.c:590 tpm_stm_spi_send() warn:
unsigned 'ret' is never less than zero.
drivers/char/tpm/tpm_spi_stm_st33.c:613 tpm_stm_spi_send() warn:
unsigned 'ret' is never less than zero.
drivers/char/tpm/tpm_spi_stm_st33.c:836 tpm_st33_spi_probe() warn:
unsigned 'err' is never less than zero.
drivers/char/tpm/tpm_spi_stm_st33.c:842 tpm_st33_spi_probe() warn:
unsigned 'err' is never less than zero.
drivers/char/tpm/tpm_spi_stm_st33.c:854 tpm_st33_spi_probe() warn:
unsigned 'err' is never less than zero.
drivers/char/tpm/tpm_spi_stm_st33.c:859 tpm_st33_spi_probe() warn:
unsigned 'err' is never less than zero.
drivers/char/tpm/tpm_spi_stm_st33.c:863 tpm_st33_spi_probe() warn:
unsigned 'err' is never less than zero.

Kent

> 
> 
> The driver does give me some smatch errors:
> 
> $ LANG=C make -j16 C=1 CHECK=smatch
>  CHECK   drivers/char/tpm/tpm_spi_stm_st33.c
>  drivers/char/tpm/tpm_spi_stm_st33.c:882 tpm_st33_spi_probe() warn: variable  
> dereferenced before check 'platform_data' (see line 781)
>  drivers/char/tpm/tpm_spi_stm_st33.c:980 tpm_st33_spi_pm_resume() warn: should  
> this be a bitwise op?
>  drivers/char/tpm/tpm_spi_stm_st33.c:980 tpm_st33_spi_pm_resume() warn: should  
> this be a bitwise op?
> 
> 
> 
> and some sparse errors:
>  drivers/char/tpm/tpm_spi_stm_st33.c:102:35: warning: cast removes address 
> space of expression
>  drivers/char/tpm/tpm_spi_stm_st33.c:171:35: warning: cast removes address 
> space of expression
>  drivers/char/tpm/tpm_spi_stm_st33.c:299:19: warning: cast removes address 
> space of expression
>  drivers/char/tpm/tpm_spi_stm_st33.c:311:15: warning: symbol 
> 'wait_for_serirq_timeout' was not declared. Should it be static?
>  drivers/char/tpm/tpm_spi_stm_st33.c:546:19: warning: cast removes address 
> space of expression
> 
> 
> 
> 
> 
> And here are some other, rather subjective remarks:
> 
> > +		for (; nbr_dummy_bytes < total_length &&
> > +			 ((u8 *)xfer.rx_buf)[nbr_dummy_bytes] == 0;
> > +			 nbr_dummy_bytes++)
> > +			;
> 
> Not sure if it would be easier to read using a while and putting the increment 
> into the loop body
> 
> >+		while (nbr_dummy_bytes < total_length && 
> >+			((u8 *)xfer.rx_buf)[nbr_dummy_bytes] == 0)
> >+			 nbr_dummy_bytes++;
> 
> I usually don't like empty loop bodies, as they tend to be overlooked.
> 
> 
> 
> > +static u32 SPI_WRITE_DATA(struct tpm_chip *tpm, u8 tpm_register,
> > +			  u8 *tpm_data, u16 tpm_size)
> > +{
> > +	u8 value = 0;
> > +	value = write8_reg(tpm, tpm_register, tpm_data, tpm_size);
> > +
> > +	switch (value) {
> > +	case TPM_ST_SPI_OK:
> > +		return TPM_ST_SPI_OK;
> > +	case 0:
> > +		return 0;
> > +	default:
> > +		return -EBUSY;
> > +	}
> > +} /* SPI_WRITE_DATA() */
> 
> Why do you need a wrapper function here for the return code?
> write8_reg is only called from this location, so why doesn't it return the 
> correct error code directly?
> *confused*
> 
> 
> Same applies to read8_reg.
> 
> 
> 
> 
> > +static int _wait_for_interrupt_serirq_timeout(struct tpm_chip *chip,
> > +					unsigned long timeout)
> Is only called from wait_for_serirq_timeout - I'm not really sure if it helps 
> readability to have a separate function.
> 
> 
> 
> 
> > +	.resume = tpm_st33_spi_pm_resume,
> > +	.suspend = tpm_st33_spi_pm_suspend,
> Maybe use 
> SIMPLE_DEV_PM_OPS 
> instead as it is (afaik) the new standard way for PM_OPS.
> The conversion should be pretty similar to the one in your I2C TPM driver:
> https://github.com/shpedoikal/linux/commit/d459335381eca1cb91fefb87021d3d172342e55a
> 
> 
> Regards,
> Peter
> 

