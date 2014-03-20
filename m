Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbaCTHzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 03:55:48 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:54950 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaCTHzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 03:55:47 -0400
Date: Thu, 20 Mar 2014 00:55:43 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        DCG_UPD_stlinux_kernel@list.st.com, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org, Angus.Clark@st.com
Subject: Re: [PATCH 25/35] mtd: st_spi_fsm: Add the ability to read from a
 Serial Flash device
Message-ID: <20140320075543.GD31517@norris-Latitude-E6410>
References: <1392735362-1245-1-git-send-email-lee.jones@linaro.org>
 <1392735362-1245-26-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392735362-1245-26-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 02:55:52PM +0000, Lee Jones wrote:
> diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
> index fe538bb..e4815fe 100644
> --- a/drivers/mtd/devices/st_spi_fsm.c
> +++ b/drivers/mtd/devices/st_spi_fsm.c
> @@ -942,6 +945,100 @@ static int stfsm_n25q_config(struct stfsm *fsm)
[...]
> +static int stfsm_mtd_read(struct mtd_info *mtd, loff_t from, size_t len,
> +			  size_t *retlen, u_char *buf)
> +{
> +	struct stfsm *fsm = dev_get_drvdata(mtd->dev.parent);
> +	uint32_t bytes;
> +
> +	dev_dbg(fsm->dev, "%s from 0x%08x, len %zd\n",
> +		__func__, (u32)from, len);
> +
> +	mutex_lock(&fsm->lock);
> +
> +	while (len > 0) {
> +		bytes = min_t(size_t, len, FLASH_PAGESIZE);
> +
> +		stfsm_read(fsm, buf, bytes, from);
> +
> +		buf += bytes;
> +		from += bytes;
> +		len -= bytes;
> +
> +		if (retlen)

Same as with your _write implementation; you can assume that retlen is
always non-NULL.

> +			*retlen += bytes;
> +	}
> +
> +	mutex_unlock(&fsm->lock);
> +
> +	return 0;
> +}
> +
>  static void stfsm_read_jedec(struct stfsm *fsm, uint8_t *const jedec)
>  {
>  	const struct stfsm_seq *seq = &stfsm_seq_read_jedec;

Brian
