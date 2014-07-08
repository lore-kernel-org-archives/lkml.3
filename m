Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344AbaGHXlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 19:41:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38040 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaGHXlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 19:41:04 -0400
Date: Tue, 8 Jul 2014 16:45:29 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Fabio Falzoi <fabio.falzoi84@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, joe@perches.com,
        dan.carpenter@oracle.com, wei_wang@realsil.com.cn,
        micky_ching@realsil.com.cn
Subject: Re: [PATCH v3 2/4] Staging: rts5208: Replace custom macro with
 print_hex_dump_bytes
Message-ID: <20140708234529.GA25645@kroah.com>
References: <1404855512-5864-1-git-send-email-fabio.falzoi84@gmail.com>
 <1404855512-5864-3-git-send-email-fabio.falzoi84@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404855512-5864-3-git-send-email-fabio.falzoi84@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 11:38:30PM +0200, Fabio Falzoi wrote:
> Use print_hex_dump_bytes to have memory properly dumped only when
> DEBUG is defined.
> 
> Signed-off-by: Fabio Falzoi <fabio.falzoi84@gmail.com>
> ---
>  drivers/staging/rts5208/ms.c        |  4 ++--
>  drivers/staging/rts5208/rtsx_chip.c |  4 ++--
>  drivers/staging/rts5208/rtsx_scsi.c |  9 ++++-----
>  drivers/staging/rts5208/sd.c        |  6 +++---
>  drivers/staging/rts5208/trace.h     | 11 +++++------
>  5 files changed, 16 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/staging/rts5208/ms.c b/drivers/staging/rts5208/ms.c
> index 2476d22..0a33043 100644
> --- a/drivers/staging/rts5208/ms.c
> +++ b/drivers/staging/rts5208/ms.c
> @@ -307,7 +307,7 @@ static int ms_read_bytes(struct rtsx_chip *chip,
>  
>  	if ((tpc == PRO_READ_SHORT_DATA) && (data_len == 8)) {
>  		pr_debug("Read format progress:\n");
> -		RTSX_DUMP(ptr, cnt);
> +		rtsx_hex_dump(ptr, cnt);
>  	}
>  
>  	return STATUS_SUCCESS;
> @@ -1910,7 +1910,7 @@ RE_SEARCH:
>  	ptr = rtsx_get_cmd_data(chip);
>  
>  	pr_debug("Boot block data:\n");
> -	RTSX_DUMP(ptr, 16);
> +	rtsx_hex_dump(ptr, 16);
>  
>  	/* Block ID error
>  	 * HEADER_ID0, HEADER_ID1
> diff --git a/drivers/staging/rts5208/rtsx_chip.c b/drivers/staging/rts5208/rtsx_chip.c
> index 8f447ef..761e83c 100644
> --- a/drivers/staging/rts5208/rtsx_chip.c
> +++ b/drivers/staging/rts5208/rtsx_chip.c
> @@ -1299,8 +1299,8 @@ int rtsx_write_cfg_seq(struct rtsx_chip *chip, u8 func, u16 addr, u8 *buf,
>  		}
>  	}
>  
> -	RTSX_DUMP(mask, dw_len * 4);
> -	RTSX_DUMP(data, dw_len * 4);
> +	rtsx_hex_dump(mask, dw_len * 4);
> +	rtsx_hex_dump(data, dw_len * 4);
>  
>  	for (i = 0; i < dw_len; i++) {
>  		retval = rtsx_write_cfg_dw(chip, func, aligned_addr + i * 4,
> diff --git a/drivers/staging/rts5208/rtsx_scsi.c b/drivers/staging/rts5208/rtsx_scsi.c
> index fd3c2e7..8269a02 100644
> --- a/drivers/staging/rts5208/rtsx_scsi.c
> +++ b/drivers/staging/rts5208/rtsx_scsi.c
> @@ -40,7 +40,8 @@
>  void scsi_show_command(struct scsi_cmnd *srb)
>  {
>  	char *what = NULL;
> -	int i, unknown_cmd = 0;
> +	int unknown_cmd = 0;
> +	size_t len;
>  
>  	switch (srb->cmnd[0]) {
>  	case TEST_UNIT_READY:
> @@ -319,10 +320,8 @@ void scsi_show_command(struct scsi_cmnd *srb)
>  		pr_debug("Command %s (%d bytes)\n", what, srb->cmd_len);
>  
>  	if (unknown_cmd) {
> -		pr_debug("");
> -		for (i = 0; i < srb->cmd_len && i < 16; i++)
> -			pr_debug(" %02x", srb->cmnd[i]);
> -		pr_debug("\n");
> +		len = min_t(size_t, srb->cmd_len, 16);
> +		rtsx_hex_dump(srb->cmnd, len);
>  	}
>  }
>  
> diff --git a/drivers/staging/rts5208/sd.c b/drivers/staging/rts5208/sd.c
> index 96acd39..2f50f9c 100644
> --- a/drivers/staging/rts5208/sd.c
> +++ b/drivers/staging/rts5208/sd.c
> @@ -426,7 +426,7 @@ static int sd_check_csd(struct rtsx_chip *chip, char check_wp)
>  	memcpy(sd_card->raw_csd, rsp + 1, 15);
>  
>  	pr_debug("CSD Response:\n");
> -	RTSX_DUMP(sd_card->raw_csd, 16);
> +	rtsx_hex_dump(sd_card->raw_csd, 16);
>  
>  	csd_ver = (rsp[1] & 0xc0) >> 6;
>  	pr_debug("csd_ver = %d\n", csd_ver);
> @@ -1059,7 +1059,7 @@ static int sd_check_switch_mode(struct rtsx_chip *chip, u8 mode,
>  		TRACE_RET(chip, STATUS_FAIL);
>  	}
>  
> -	RTSX_DUMP(buf, 64);
> +	rtsx_hex_dump(buf, 64);
>  
>  	if (func_group == NO_ARGUMENT) {
>  		sd_card->func_group1_mask = buf[0x0D];
> @@ -2107,7 +2107,7 @@ static int sd_check_wp_state(struct rtsx_chip *chip)
>  	}
>  
>  	pr_debug("ACMD13:\n");
> -	RTSX_DUMP(buf, 64);
> +	rtsx_hex_dump(buf, 64);
>  
>  	sd_card_type = ((u16)buf[2] << 8) | buf[3];
>  	pr_debug("sd_card_type = 0x%04x\n", sd_card_type);
> diff --git a/drivers/staging/rts5208/trace.h b/drivers/staging/rts5208/trace.h
> index 7fcb459..6a85415 100644
> --- a/drivers/staging/rts5208/trace.h
> +++ b/drivers/staging/rts5208/trace.h
> @@ -82,12 +82,11 @@ static inline char *filename(char *path)
>  #define TRACE_GOTO(chip, label)	goto label
>  #endif
>  
> -#ifdef CONFIG_RTS5208_DEBUG
> -#define RTSX_DUMP(buf, buf_len)					\
> -	print_hex_dump(KERN_DEBUG, KBUILD_MODNAME ": ",		\
> -		       DUMP_PREFIX_NONE, 16, 1, (buf), (buf_len), false)
> -#else
> -#define RTSX_DUMP(buf, buf_len)
> +static inline void rtsx_hex_dump(const void *buf, size_t len)
> +{
> +#ifdef DEBUG
> +	print_hex_dump_bytes(KBUILD_MODNAME ": ", DUMP_PREFIX_NONE, buf, len);
>  #endif
> +}

What a mess.  What's wrong with just using the %*ph modifier in
dev_dbg() like other drivers do?

thanks,

greg k-h
