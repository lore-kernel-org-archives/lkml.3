Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944AbaF3Twy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 15:52:54 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:47316 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbaF3Twx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 15:52:53 -0400
MIME-Version: 1.0
In-Reply-To: <1404157796-13613-1-git-send-email-marek@goldelico.com>
References: <1404157796-13613-1-git-send-email-marek@goldelico.com>
Date: Mon, 30 Jun 2014 21:52:52 +0200
Message-ID: <CAAfyv35uaaTOaWxKJNap07NXiEVh4RrYd4LhhtjvX=Nd+k7w5w@mail.gmail.com>
Subject: Re: [PATCH 1/2] bq27x00 - don't report power-supply change so often.
From: Belisko Marek <marek.belisko@gmail.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Sebastian Reichel <sre@kernel.org>
Cc: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        Marek Belisko <marek@goldelico.com>, NeilBrown <neilb@suse.de>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry forgot to CC lkml. CCing now.

On Mon, Jun 30, 2014 at 9:49 PM, Marek Belisko <marek@goldelico.com> wrote:
> From: NeilBrown <neilb@suse.de>
>
> A power_supply_changed should only be reported on significant changes
> such as transition between charging and not.  Incremental changes
> such as charge increasing should not be reported - that can easily
> be polled for.
>
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>  drivers/power/bq27x00_battery.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
> index b309713..27bac1d 100644
> --- a/drivers/power/bq27x00_battery.c
> +++ b/drivers/power/bq27x00_battery.c
> @@ -62,6 +62,8 @@
>  #define BQ27000_FLAG_FC                        BIT(5)
>  #define BQ27000_FLAG_CHGS              BIT(7) /* Charge state flag */
>
> +#define BQ27000_FLAGS_IMPORTANT                (BQ27000_FLAG_FC|BQ27000_FLAG_CHGS|BIT(31))
> +
>  #define BQ27500_REG_SOC                        0x2C
>  #define BQ27500_REG_DCAP               0x3C /* Design capacity */
>  #define BQ27500_FLAG_DSC               BIT(0)
> @@ -74,6 +76,8 @@
>  #define BQ27425_REG_OFFSET             0x04
>  #define BQ27425_REG_SOC                        0x18 /* Register address plus offset */
>
> +#define BQ27500_FLAGS_IMPORTANT                (BQ27500_FLAG_FC|BQ27500_FLAG_DSC|BIT(31))
> +
>  #define BQ27000_RS                     20 /* Resistor sense */
>  #define BQ27x00_POWER_CONSTANT         (256 * 29200 / 1000)
>
> @@ -413,6 +417,7 @@ static void bq27x00_update(struct bq27x00_device_info *di)
>         struct bq27x00_reg_cache cache = {0, };
>         bool is_bq27500 = di->chip == BQ27500;
>         bool is_bq27425 = di->chip == BQ27425;
> +       int flags_changed;
>
>         cache.flags = bq27x00_read(di, BQ27x00_REG_FLAGS, !is_bq27500);
>         if (cache.flags >= 0) {
> @@ -454,10 +459,14 @@ static void bq27x00_update(struct bq27x00_device_info *di)
>                         di->charge_design_full = bq27x00_battery_read_ilmd(di);
>         }
>
> -       if (memcmp(&di->cache, &cache, sizeof(cache)) != 0) {
> -               di->cache = cache;
> +       flags_changed = di->cache.flags ^ cache.flags;
> +       di->cache = cache;
> +       if (is_bq27500)
> +               flags_changed &= BQ27500_FLAGS_IMPORTANT;
> +       else
> +               flags_changed &= BQ27000_FLAGS_IMPORTANT;
> +       if (flags_changed)
>                 power_supply_changed(&di->bat);
> -       }
>
>         di->last_update = jiffies;
>  }
> --
> 1.9.1
>



-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
