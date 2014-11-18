Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460AbaKRRGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:06:34 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:35069 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413AbaKRRGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:06:33 -0500
Date: Tue, 18 Nov 2014 18:06:27 +0100
From: Johan Hovold <johan@kernel.org>
To: Laurentiu Palcu <laurentiu.palcu@intel.com>
Cc: Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Johan Havold <johan@kernel.org>,
        Octavian Purdila <octavian.purdila@intel.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] spi: add support for DLN-2 USB-SPI adapter
Message-ID: <20141118170627.GB22786@localhost>
References: <1416312599-5176-1-git-send-email-laurentiu.palcu@intel.com>
 <1416312599-5176-2-git-send-email-laurentiu.palcu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416312599-5176-2-git-send-email-laurentiu.palcu@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 02:09:58PM +0200, Laurentiu Palcu wrote:

> +/*
> + * Copy the data to DLN2 buffer and change the byte order to LE, requested by
> + * DLN2 module. SPI core makes sure that the data length is a multiple of word
> + * size.
> + */
> +static int dln2_spi_copy_to_buf(u8 *dln2_buf, const u8 *src, u16 len, u8 bpw)
> +{
> +#ifdef __LITTLE_ENDIAN
> +	memcpy(dln2_buf, src, len);
> +#else
> +	if (bpw <= 8) {
> +		memcpy(dln2_buf, src, len);
> +	} else if (bpw <= 16) {
> +		__le16 *d = (__le16 *)dln2_buf;
> +		u16 *s = (u16 *)src;
> +
> +		len = len / 2;
> +		while (len--)
> +			put_unaligned_le16(get_unaligned(s++), d++);

You said the dln2 buffer was properly aligned, right? Then you don't
need to use put_unaligned_lexx here...

> +	} else {
> +		__le32 *d = (__le32 *)dln2_buf;
> +		u32 *s = (u32 *)src;
> +
> +		len = len / 4;
> +		while (len--)
> +			put_unaligned_le32(get_unaligned(s++), d++);
> +	}
> +#endif
> +
> +	return 0;
> +}
> +
> +/*
> + * Copy the data from DLN2 buffer and convert to CPU byte order since the DLN2
> + * buffer is LE ordered. SPI core makes sure that the data length is a multiple
> + * of word size.
> + */
> +static int dln2_spi_copy_from_buf(u8 *dest, const u8 *dln2_buf, u16 len, u8 bpw)
> +{
> +#ifdef __LITTLE_ENDIAN
> +	memcpy(dest, dln2_buf, len);
> +#else
> +	if (bpw <= 8) {
> +		memcpy(dest, dln2_buf, len);
> +	} else if (bpw <= 16) {
> +		u16 *d = (u16 *)dest;
> +		__le16 *s = (__le16 *)dln2_buf;
> +
> +		len = len / 2;
> +		while (len--)
> +			put_unaligned(get_unaligned_le16(s++), d++)

...or get_unaligned_lexx here.

> +	} else {
> +		u32 *d = (u32 *)dest;
> +		__le32 *s = (__le32 *)dln2_buf;
> +
> +		len = len / 4;
> +		while (len--)
> +			put_unaligned(get_unaligned_le32(s++), d++)
> +	}
> +#endif
> +
> +	return 0;
> +}

Did you check the alignment of the SPI buffers as well? I'd assume they
were DMA-able and thus properly aligned, and then you do not need to use
any unaligned helpers above at all.

Johan
