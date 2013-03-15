Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613Ab3COVJ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 17:09:57 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:30225 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932316Ab3COVJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 17:09:56 -0400
Date: Sat, 16 Mar 2013 00:09:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 07/50] staging: omap-thermal: introduce RMW_BITS macro
Message-ID: <20130315210946.GK9138@mwanda>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
 <1363352438-15935-8-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363352438-15935-8-git-send-email-eduardo.valentin@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 08:59:55AM -0400, Eduardo Valentin wrote:
> This patch introduce a macro to read, update, write bitfields.
> It will be specific to bandgap data structures.
> 
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> ---
>  drivers/staging/omap-thermal/omap-bandgap.c |  178 +++++++--------------------
>  1 files changed, 46 insertions(+), 132 deletions(-)
> 
> diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
> index 9f2d7cc..1c1b905 100644
> --- a/drivers/staging/omap-thermal/omap-bandgap.c
> +++ b/drivers/staging/omap-thermal/omap-bandgap.c
> @@ -52,25 +52,29 @@ static void omap_bandgap_writel(struct omap_bandgap *bg_ptr, u32 val, u32 reg)
>  	writel(val, bg_ptr->base + reg);
>  }
>  
> +/* update bits, value will be shifted */
> +#define RMW_BITS(bg_ptr, id, reg, mask, val)			\
> +do {								\
> +	struct temp_sensor_registers *t;			\
> +	u32 r;							\
> +								\
> +	t = bg_ptr->conf->sensors[(id)].registers;		\
> +	r = omap_bandgap_readl(bg_ptr, t->reg);			\
> +	r &= ~t->mask;						\
> +	r |= (val) << __ffs(t->mask);				\
> +	omap_bandgap_writel(bg_ptr, r, t->reg);			\
> +} while (0)
> +
>  static int omap_bandgap_power(struct omap_bandgap *bg_ptr, bool on)
>  {
> -	struct temp_sensor_registers *tsr;
>  	int i;
> -	u32 ctrl;
>  
>  	if (!OMAP_BANDGAP_HAS(bg_ptr, POWER_SWITCH))
>  		return 0;
>  
> -	for (i = 0; i < bg_ptr->conf->sensor_count; i++) {
> -		tsr = bg_ptr->conf->sensors[i].registers;
> -		ctrl = omap_bandgap_readl(bg_ptr, tsr->temp_sensor_ctrl);
> -		ctrl &= ~tsr->bgap_tempsoff_mask;
> +	for (i = 0; i < bg_ptr->conf->sensor_count; i++)
>  		/* active on 0 */
> -		ctrl |= !on << __ffs(tsr->bgap_tempsoff_mask);
> -
> -		/* write BGAP_TEMPSOFF should be reset to 0 */
> -		omap_bandgap_writel(bg_ptr, ctrl, tsr->temp_sensor_ctrl);
> -	}
> +		RMW_BITS(bg_ptr, i, temp_sensor_ctrl, bgap_tempsoff_mask, !on);
>  
>  	return 0;
>  }
> @@ -78,15 +82,13 @@ static int omap_bandgap_power(struct omap_bandgap *bg_ptr, bool on)
>  static u32 omap_bandgap_read_temp(struct omap_bandgap *bg_ptr, int id)
>  {

This patch is fine and it makes it cleaner than before.

But that said, I don't care for the RMW_BITS() very much as a long
term thing.  If we just used pointers instead of passing the offset
into the bg_ptr->conf->sensors[] array then everything would be a
lot cleaner.

In other words, instead of this:

static u32 omap_bandgap_read_temp(struct omap_bandgap *bg_ptr, int id)

We would have:

static u32 omap_bandgap_read_temp(struct omap_bandgap *bg_ptr,
				  struct temp_sensor_registers *tsr)

If you have the pointer then it's easy write RMW_BITS() as a
function.

static void rmw_bits(struct omap_bandgap *bg_ptr, u32 reg, u32 mask, u32 val)
{
	u32 r;

	r = omap_bandgap_readl(bg_ptr, reg);
	r &= ~mask;
	r |= val << __ffs(mask);
	omap_bandgap_writel(bg_ptr, r, reg);
}

It's called like:

	rmw_bits(bg_ptr, tsr->bgap_mask_ctrl, tsr->mask_freeze_mask, 1);

regards,
dan carpenter


