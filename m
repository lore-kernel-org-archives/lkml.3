Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933541AbaLCAgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 19:36:49 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:42685 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaLCAgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 19:36:47 -0500
MIME-Version: 1.0
In-Reply-To: <547E569C.3080606@samsung.com>
References: <1417563767-32181-1-git-send-email-dianders@chromium.org>
	<1417563767-32181-4-git-send-email-dianders@chromium.org>
	<547E569C.3080606@samsung.com>
Date: Tue, 2 Dec 2014 16:36:46 -0800
X-Google-Sender-Auth: guyBY3LLNWZ9x5X9eGswSQLxcaQ
Message-ID: <CAD=FV=VU5804WD5SRwr8HAOXwvumkUY+yzjM81oNbPUwwv=nTQ@mail.gmail.com>
Subject: Re: [PATCH v5 3/4] mmc: dw_mmc: Cleanup disable of low power mode w/
 SDIO interrupts
From: Doug Anderson <dianders@chromium.org>
To: Jaehoon Chung <jh80.chung@samsung.com>
Cc: Seungwon Jeon <tgih.jun@samsung.com>, Ulf Hansson <ulf.hansson@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>, Chris Ball <chris@printf.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaehoon,

On Tue, Dec 2, 2014 at 4:17 PM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
>> @@ -1245,27 +1246,37 @@ static int dw_mci_get_cd(struct mmc_host *mmc)
>>       return present;
>>  }
>>
>> -/*
>> - * Disable lower power mode.
>> - *
>> - * Low power mode will stop the card clock when idle.  According to the
>> - * description of the CLKENA register we should disable low power mode
>> - * for SDIO cards if we need SDIO interrupts to work.
>> - *
>> - * This function is fast if low power mode is already disabled.
>> - */
>> -static void dw_mci_disable_low_power(struct dw_mci_slot *slot)
>> +static void dw_mci_init_card(struct mmc_host *mmc, struct mmc_card *card)
>>  {
>> +     struct dw_mci_slot *slot = mmc_priv(mmc);
>>       struct dw_mci *host = slot->host;
>> -     u32 clk_en_a;
>> -     const u32 clken_low_pwr = SDMMC_CLKEN_LOW_PWR << slot->id;
>>
>> -     clk_en_a = mci_readl(host, CLKENA);
>> +     /*
>> +      * Low power mode will stop the card clock when idle.  According to the
>> +      * description of the CLKENA register we should disable low power mode
>> +      * for SDIO cards if we need SDIO interrupts to work.
>> +      */
>> +     if (mmc->caps & MMC_CAP_SDIO_IRQ) {
>> +             const u32 clken_low_pwr = SDMMC_CLKEN_LOW_PWR << slot->id;
>> +             u32 clk_en_a_old;
>> +             u32 clk_en_a;
>>
>> -     if (clk_en_a & clken_low_pwr) {
>> -             mci_writel(host, CLKENA, clk_en_a & ~clken_low_pwr);
>> -             mci_send_cmd(slot, SDMMC_CMD_UPD_CLK |
>> -                          SDMMC_CMD_PRV_DAT_WAIT, 0);
>> +             clk_en_a_old = mci_readl(host, CLKENA);
>> +
>> +             if (card->type == MMC_TYPE_SDIO ||
>> +                 card->type == MMC_TYPE_SD_COMBO) {
>> +                     set_bit(DW_MMC_CARD_NO_LOW_PWR, &slot->flags);
>> +                     clk_en_a = clk_en_a_old & ~clken_low_pwr;
>> +             } else {
>
> I wonder this point. When entered at this point?
>
> MMC_CAP_SDIO_IRQ is sdio capability. and card->type is also related with SDIO, isn't?

Right.  As I understand it:

* You can certainly add MMC_CAP_SDIO_IRQ to an external card slot that
might have an MMC card, and SD card, or an SDIO card.  You still want
the LOW_PWR mode for MMC/SD cards but don't want it for SDIO cards in
that case.

* If you don't set MMC_CAP_SDIO_IRQ then presumably you've got some
problem where the SDIO interrupt is broken on your board.  That means
you're using polling mode to find interrupts.  As I understand it that
would allow you to use LOW_PWR since you don't need to detect SDIO
interrupts.  I know on Marvell WiFi modules I tested this seemed to
work OK, but I doubt anyone is really running a production device in
this way.


Basically I was trying to mirror the functionality of the old code as
closely as possible.  In the old code if you were using polling mode
then dw_mci_enable_sdio_irq() should never be called and you'd never
go out of low power mode.

-Doug
