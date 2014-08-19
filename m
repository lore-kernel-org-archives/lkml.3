Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbaHSQ0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 12:26:30 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:38750 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbaHSQ01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 12:26:27 -0400
MIME-Version: 1.0
In-Reply-To: <1408460913-13863-6-git-send-email-javier.martinez@collabora.co.uk>
References: <1408460913-13863-1-git-send-email-javier.martinez@collabora.co.uk>
	<1408460913-13863-6-git-send-email-javier.martinez@collabora.co.uk>
Date: Tue, 19 Aug 2014 09:26:26 -0700
X-Google-Sender-Auth: -ORwiZc_qD8OmohCpI_-M38CusM
Message-ID: <CAD=FV=V9oct-iJ==1SLdxusq68AY3utMQF+MbX0Uf+2dC0mwww@mail.gmail.com>
Subject: Re: [PATCH 5/6] ARM: dts: Add vmmc and vqmmc supplies for Peach Pit
 and Pi boards
From: Doug Anderson <dianders@chromium.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@kernel.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Javier,

On Tue, Aug 19, 2014 at 8:08 AM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
> The VCC/VDD and VCCQ/VDD_IO power supplies for the MMC are
> provided by the tps65090 fet4 and max77802 ldo4 regulators
> respectively. Add the phandle to the regulators tree nodes
> for the the dw_mmc device device.
>
> These DTS snippets were taken from the downstream ChromeOS
> 3.8 kernel Device Tree for Peach Pit and Pi boards.
>
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
>  arch/arm/boot/dts/exynos5420-peach-pit.dts | 2 ++
>  arch/arm/boot/dts/exynos5800-peach-pi.dts  | 2 ++
>  2 files changed, 4 insertions(+)
>
> diff --git a/arch/arm/boot/dts/exynos5420-peach-pit.dts b/arch/arm/boot/dts/exynos5420-peach-pit.dts
> index 8e50042..5b9dbb9 100644
> --- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
> +++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts
> @@ -547,6 +547,8 @@
>  };
>
>  &mmc_2 {
> +       vmmc-supply = <&tps65090_fet4>;
> +       vqmmc-supply = <&vqmmc_sdcard>;
>         status = "okay";
>         num-slots = <1>;
>         supports-highspeed;
> diff --git a/arch/arm/boot/dts/exynos5800-peach-pi.dts b/arch/arm/boot/dts/exynos5800-peach-pi.dts
> index 939f91c..dcac443 100644
> --- a/arch/arm/boot/dts/exynos5800-peach-pi.dts
> +++ b/arch/arm/boot/dts/exynos5800-peach-pi.dts
> @@ -545,6 +545,8 @@
>  };
>
>  &mmc_2 {
> +       vmmc-supply = <&tps65090_fet4>;
> +       vqmmc-supply = <&vqmmc_sdcard>;
>         status = "okay";
>         num-slots = <1>;
>         supports-highspeed;

While your change is correct, I have a worry that it will break things
if it's merged before some patches that Yuvaraj is working on.

Specifically the problem on pit and pi (and any exynos5250 / 5420 /
5800 / ... boards using the built-in "card detect") is that the card
detect line is on the same power rail as "vqmmc".  That means you
can't turn off vqmmc if you still need to be able to detect card
insertions.

...but you can't turn off vmmc without turning off vqmmc, otherwise
current will leak through the IO lines into the card, which is bad.


Right now the SDMMC core will try to turn off power to the card at two times:
1. when the card is ejected
2. when it's trying to reset the card


Obviously the first problem is a huge problem on exynos because it
means that we won't be able to detect card insertions.  ...but we
still want to turn the power off from #2.  To really fix the problem I
think the core needs to be extended to treat the above as two separate
cases.


Your patch might work at the moment because I think dw_mmc doesn't
actually try to turn off these rails with the main SDMMC core asks it
to.  ...but I still worry about merging them before Yuvaraj's changes
are ready.


-Doug
