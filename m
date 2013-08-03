Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab3HCVQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 17:16:57 -0400
Received: from lunge.queued.net ([173.255.254.236]:38719 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab3HCVQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 17:16:56 -0400
Date: Sat, 3 Aug 2013 14:16:54 -0700
From: Andres Salomon <dilinger@queued.net>
To: Jens Frederich <jfrederich@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, cjb@laptop.org, dsd@laptop.org
Subject: Re: [PATCH] Staging: olpc_dcon: replace some magic numbers
Message-ID: <20130803141654.0f84baac@dev.queued.net>
In-Reply-To: <1375562675-7816-1-git-send-email-jfrederich@gmail.com>
References: <1375562675-7816-1-git-send-email-jfrederich@gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please Cc Daniel on these.  Cjb and myself are no longer at olpc. 



On Sat,  3 Aug 2013 22:44:35 +0200
Jens Frederich <jfrederich@gmail.com> wrote:

> This patch replace some magic numbers. I believe it makes
> the driver more readable.
> 
> The magic number 0x26 is the XO system embedded controller
> (EC) command 'DCON power enable/disable'.
> 
> Number 0x41, and 0x42 are special memory controller settings
> register.  The 0x41 initialize bit sequence 0x101 means:
> enable memory power down function and special SDRAM clock
> delay for synchronize SDRAM output and clock signal.
> 
> The 0x42 initialize squence 0x101 is wrong.  According to
> the specification Bit 8 is reserved, thus not in use.
> I removed it.
> 
> Signed-off-by: Jens Frederich <jfrederich@gmail.com>
> 
> diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c
> b/drivers/staging/olpc_dcon/olpc_dcon.c index 7c460f2..5ca4fa4 100644
> --- a/drivers/staging/olpc_dcon/olpc_dcon.c
> +++ b/drivers/staging/olpc_dcon/olpc_dcon.c
> @@ -90,9 +90,10 @@ static int dcon_hw_init(struct dcon_priv *dcon,
> int is_init) 
>  	/* SDRAM setup/hold time */
>  	dcon_write(dcon, 0x3a, 0xc040);
> -	dcon_write(dcon, 0x41, 0x0000);
> -	dcon_write(dcon, 0x41, 0x0101);
> -	dcon_write(dcon, 0x42, 0x0101);
> +	dcon_write(dcon, DCON_REG_MEM_OPT_A, 0x0000);  /* clear
> option bits */
> +	dcon_write(dcon, DCON_REG_MEM_OPT_A,
> +				MEM_DLL_CLOCK_DELAY |
> MEM_POWER_DOWN);
> +	dcon_write(dcon, DCON_REG_MEM_OPT_B, MEM_SOFT_RESET);
>  
>  	/* Colour swizzle, AA, no passthrough, backlight */
>  	if (is_init) {
> @@ -126,7 +127,7 @@ static int dcon_bus_stabilize(struct dcon_priv
> *dcon, int is_powered_down) power_up:
>  	if (is_powered_down) {
>  		x = 1;
> -		x = olpc_ec_cmd(0x26, (unsigned char *)&x, 1, NULL,
> 0);
> +		x = olpc_ec_cmd(EC_DCON_POWER_MODE, (u8 *)&x, 1,
> NULL, 0); if (x) {
>  			pr_warn("unable to force dcon to power up:
> %d!\n", x); return x;
> @@ -144,7 +145,7 @@ power_up:
>  		pr_err("unable to stabilize dcon's smbus,
> reasserting power and praying.\n");
> BUG_ON(olpc_board_at_least(olpc_board(0xc2))); x = 0;
> -		olpc_ec_cmd(0x26, (unsigned char *)&x, 1, NULL, 0);
> +		olpc_ec_cmd(EC_DCON_POWER_MODE, (u8 *)&x, 1, NULL,
> 0); msleep(100);
>  		is_powered_down = 1;
>  		goto power_up;	/* argh, stupid hardware.. */
> @@ -208,7 +209,7 @@ static void dcon_sleep(struct dcon_priv *dcon,
> bool sleep) 
>  	if (sleep) {
>  		x = 0;
> -		x = olpc_ec_cmd(0x26, (unsigned char *)&x, 1, NULL,
> 0);
> +		x = olpc_ec_cmd(EC_DCON_POWER_MODE, (u8 *)&x, 1,
> NULL, 0); if (x)
>  			pr_warn("unable to force dcon to power down:
> %d!\n", x); else
> diff --git a/drivers/staging/olpc_dcon/olpc_dcon.h
> b/drivers/staging/olpc_dcon/olpc_dcon.h index 997bded..524ee49 100644
> --- a/drivers/staging/olpc_dcon/olpc_dcon.h
> +++ b/drivers/staging/olpc_dcon/olpc_dcon.h
> @@ -22,15 +22,24 @@
>  #define MODE_DEBUG	(1<<14)
>  #define MODE_SELFTEST	(1<<15)
>  
> -#define DCON_REG_HRES		2
> -#define DCON_REG_HTOTAL		3
> -#define DCON_REG_HSYNC_WIDTH	4
> -#define DCON_REG_VRES		5
> -#define DCON_REG_VTOTAL		6
> -#define DCON_REG_VSYNC_WIDTH	7
> -#define DCON_REG_TIMEOUT	8
> -#define DCON_REG_SCAN_INT	9
> -#define DCON_REG_BRIGHT		10
> +#define DCON_REG_HRES		0x2
> +#define DCON_REG_HTOTAL		0x3
> +#define DCON_REG_HSYNC_WIDTH	0x4
> +#define DCON_REG_VRES		0x5
> +#define DCON_REG_VTOTAL		0x6
> +#define DCON_REG_VSYNC_WIDTH	0x7
> +#define DCON_REG_TIMEOUT	0x8
> +#define DCON_REG_SCAN_INT	0x9
> +#define DCON_REG_BRIGHT		0x10
> +#define DCON_REG_MEM_OPT_A	0x41
> +#define DCON_REG_MEM_OPT_B	0x42
> +
> +/* Load Delay Locked Loop (DLL) settings for clock delay */
> +#define MEM_DLL_CLOCK_DELAY	(1<<0)
> +/* Memory controller power down function */
> +#define MEM_POWER_DOWN  	(1<<8)
> +/* Memory controller software reset */
> +#define MEM_SOFT_RESET		(1<<0)
>  
>  /* Status values */
>  
> diff --git a/include/linux/olpc-ec.h b/include/linux/olpc-ec.h
> index 5bb6e76..2925df3 100644
> --- a/include/linux/olpc-ec.h
> +++ b/include/linux/olpc-ec.h
> @@ -6,6 +6,7 @@
>  #define EC_WRITE_SCI_MASK		0x1b
>  #define EC_WAKE_UP_WLAN			0x24
>  #define EC_WLAN_LEAVE_RESET		0x25
> +#define EC_DCON_POWER_MODE		0x26
>  #define EC_READ_EB_MODE			0x2a
>  #define EC_SET_SCI_INHIBIT		0x32
>  #define EC_SET_SCI_INHIBIT_RELEASE	0x34
