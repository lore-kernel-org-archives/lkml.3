Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbaF3FpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 01:45:12 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50485 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbaF3FpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 01:45:11 -0400
Date: Mon, 30 Jun 2014 07:45:07 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: Mark Brown <broonie@kernel.org>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] regmap: Fix debugfs-file 'registers' mode
Message-ID: <20140630054507.GX14781@pengutronix.de>
References: <1403961791-15376-1-git-send-email-mpa@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403961791-15376-1-git-send-email-mpa@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Markus,

On Sat, Jun 28, 2014 at 03:23:11PM +0200, Markus Pargmann wrote:
> The macro "REGMAP_ALLOW_WRITE_DEBUGFS" can be used to enable write
minor nit: I'd not call it "macro", but "cpp symbol" because macro
sounds more function-like. (There is another "macro" at the end of the
commit log.)

> support on the registers file in the debugfs. The mode of the file is
> fixed to 0400 so it is not possible to write the file ever.
> 
> This patch fixes the mode by setting it to the correct value depending
> on the macro.
> 
> Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
> Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
> ---
> 
> Hi,
> 
> as the kconfig option will probably not be merged, I extracted the mode fix of
> my previous patch.
> 
> Regards,
> 
> Markus
> 
>  drivers/base/regmap/regmap-debugfs.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
> index 45d812c0ea77..f45a0a0e0371 100644
> --- a/drivers/base/regmap/regmap-debugfs.c
> +++ b/drivers/base/regmap/regmap-debugfs.c
> @@ -512,7 +512,14 @@ void regmap_debugfs_init(struct regmap *map, const char *name)
>  			    map, &regmap_reg_ranges_fops);
>  
>  	if (map->max_register || regmap_readable(map, 0)) {
> -		debugfs_create_file("registers", 0400, map->debugfs,
> +		unsigned int registers_mode;
> +
> +		if (IS_ENABLED(REGMAP_ALLOW_WRITE_DEBUGFS))
> +			registers_mode = 0600;
> +		else
> +			registers_mode = 0400;
> +
> +		debugfs_create_file("registers", registers_mode, map->debugfs,
>  				    map, &regmap_map_fops);
debugfs_create_file takes an umode_t as 2nd parameter. Maybe you should
pick that type for registers_mode here, too?

Best regards
Uwe

>  		debugfs_create_file("access", 0400, map->debugfs,
>  				    map, &regmap_access_fops);

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
