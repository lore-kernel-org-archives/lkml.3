Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362AbaJIWUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 18:20:11 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:57055 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbaJIWUJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 18:20:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAO3aYcqi0g=eJta33s5oM-tAAmAhe86VvHd43p5RJ7qMPZzfrg@mail.gmail.com>
References: <1412618020-22278-1-git-send-email-sonnyrao@chromium.org>
 <CAGOxZ53bviLbuA27=1QjNUgxA_WMMP-6siV=DajuN8iSqsasMg@mail.gmail.com> <CAO3aYcqi0g=eJta33s5oM-tAAmAhe86VvHd43p5RJ7qMPZzfrg@mail.gmail.com>
From: Alim Akhtar <alim.akhtar@gmail.com>
Date: Fri, 10 Oct 2014 03:49:28 +0530
Message-ID: <CAGOxZ520EXdS9FoCVW7GPvheNSZu=xqc2makJY5D0c3zjVBkDw@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: Reset DMA before enabling IDMAC
To: =?UTF-8?B?RWRkaWUgQ2FpKOiUoeaeqyk=?= <eddie.cai@rock-chips.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Heiko Stuebner <heiko@sntech.de>, Sonny Rao <sonnyrao@chromium.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        addy.ke@rock-chips.com, Jaehoon Chung <jh80.chung@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Douglas Anderson <dianders@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eddie,

On Thu, Oct 9, 2014 at 7:43 PM, Eddie Cai(蔡枫) <eddie.cai@rock-chips.com> wrote:
> Hi Alim
>
> 2014年10月8日 上午4:28于 "Alim Akhtar" <alim.akhtar@gmail.com>写道：
>
>
>>
>> Hi Sonny/Doug,
>>
>> On Mon, Oct 6, 2014 at 11:23 PM, Sonny Rao <sonnyrao@chromium.org> wrote:
>> > We've already got a reset of DMA after it's done.  Add one before we
>> > start DMA too.  This fixes a data corruption on Rockchip SoCs which
>> > will get bad data when doing a DMA transfer after doing a PIO transfer.
>> >
>> > We tested this on an Exynos 5800 with HS200 and didn't notice any
>> > difference in sequential read throughput.
>> >
>> > Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
>> > Signed-off-by: Doug Anderson <dianders@chromium.org>
>> > ---
>> >  drivers/mmc/host/dw_mmc.c | 4 ++++
>> >  1 file changed, 4 insertions(+)
>> >
>> > diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
>> > index 69f0cc6..2b5401e 100644
>> > --- a/drivers/mmc/host/dw_mmc.c
>> > +++ b/drivers/mmc/host/dw_mmc.c
>> > @@ -83,6 +83,7 @@ struct idmac_desc {
>> >  #endif /* CONFIG_MMC_DW_IDMAC */
>> >
>> >  static bool dw_mci_reset(struct dw_mci *host);
>> > +static bool dw_mci_ctrl_reset(struct dw_mci *host, u32 reset);
>> >
>> >  #if defined(CONFIG_DEBUG_FS)
>> >  static int dw_mci_req_show(struct seq_file *s, void *v)
>> > @@ -448,6 +449,9 @@ static void dw_mci_idmac_start_dma(struct dw_mci
>> > *host, unsigned int sg_len)
>> >
>> >         dw_mci_translate_sglist(host, host->data, sg_len);
>> >
>> > +       /* Make sure to reset DMA in case we did PIO before this */
>> > +       dw_mci_ctrl_reset(host, SDMMC_CTRL_DMA_RESET);
>> > +
>> Though this is good to do, but this does not look complete to me.
>> dw_mmc data book does mention that " It is recommended that the host
>> issue reset to DMA interface by setting DMA_RESET bit of the CTRL
>> register and then issue a IDMAC software reset."
>> The above lines are from 'Transmission and reception with internal
>> DMA' section of the data book.
>> My suggestion here to add dw_mci_idmac_reset() call after this above
>> change.
>>
>> What is the controller version used in your case?
>
> it just compatible with dw mmc controler but not the same one. it is
> designed by rockchip.
>
Thats fine, I think every vendor (most of them) has a custom
implementation of dw_mmc, but they do have VERID register to check the
dw_mmc version.
The reason why I asked is, I have seen inconsistency in card
enumeration on few controller version, and this patch alone does not
help, and adding a call to dw_mci_idmac_reset() after DMA reset is
needed. And this is what is recommended in the synopsys's data book
also.
Do you see any issue/side effect after adding dw_mci_idmac_reset()?

>> >         /* Select IDMAC interface */
>> >         temp = mci_readl(host, CTRL);
>> >         temp |= SDMMC_CTRL_USE_IDMAC;
>> > --
>> > 1.8.3.2
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>> --
>> Regards,
>> Alim
>>
>>



-- 
Regards,
Alim
