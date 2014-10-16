Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbaJPKjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 06:39:54 -0400
Received: from smtprelay4.synopsys.com ([198.182.44.111]:35131 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbaJPKjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 06:39:51 -0400
From: Prabu Thangamuthu <Prabu.T@synopsys.com>
To: Jaehoon Chung <jh80.chung@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Alim Akhtar <alim.akhtar@gmail.com>
CC: Prabu Thangamuthu <Prabu.T@synopsys.com>,
        Seungwon Jeon <tgih.jun@samsung.com>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Manjunath M Bettegowda <Manjunath.MB@synopsys.com>
Subject: RE: [PATCH v6] mmc: dw_mmc: Add IDMAC 64-bit address mode support
Thread-Topic: [PATCH v6] mmc: dw_mmc: Add IDMAC 64-bit address mode support
Thread-Index: Ac/jk1qr/snYPd5/S8KOP2Bi2Gh6DQD5pesAADITLAAAJ0L7gAASq14A
Date: Thu, 16 Oct 2014 10:39:34 +0000
Message-ID: <705D14B1C7978B40A723277C067CEDE21B333F07@IN01WEMBXB.internal.synopsys.com>
References: <705D14B1C7978B40A723277C067CEDE21B3336B2@IN01WEMBXB.internal.synopsys.com>
 <CAGOxZ51fzvoqUQ7=8312iLyu4jwgmskkaysgXQHju-E5EM5gNQ@mail.gmail.com>
 <CAFp+6iFQ=MU-R-mYLeL0=H5fVWkxVu5s4ineh3RcSExCUNAjCA@mail.gmail.com>
 <543F6A93.1070008@samsung.com>
In-Reply-To: <543F6A93.1070008@samsung.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.144.112.99]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9GAe4rU005173


Hi Jaehoon, Vivek, Alim,

Thanks for your review comments.

On Thu, Oct 16, 2014 at 12:20 PM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
> Hi, Prabu.
> 
> On 10/15/2014 09:05 PM, Vivek Gautam wrote:
> > Hi Prabu,
> >
> >
> > On Tue, Oct 14, 2014 at 5:41 PM, Alim Akhtar <alim.akhtar@gmail.com>
> wrote:
> >> Hi Prahu,
> >> Thanks for a quick re-spin o the patch.
> >> One last comment, this is more of a information seek.
> >> On Thu, Oct 9, 2014 at 1:09 PM, Prabu Thangamuthu
> <Prabu.T@synopsys.com> wrote:
> >>> Synopsys DW_MMC IP core supports Internal DMA Controller with 64-bit
> address mode from IP version 2.70a onwards.
> >>> Updated the driver to support IDMAC 64-bit addressing mode.
> >>>
> >>> Tested the features in DW_MMC core v2.70a and v2.40a with HAPS-51
> setup and driver is working fine.
> >>>
> >>> Signed-off-by: Prabu Thangamuthu <prabu.t@synopsys.com>
> >>> ---
> >>> Change log v6:
> >>>         - Updated with review comment.
> >>>
> >>> Change log v5:
> >>>         - Recreated the patch against linux-next as this patch is
> >>> required for another patch
> >>> http://www.spinics.net/lists/arm-kernel/msg357985.html
> >>>
> >>> Change log v4:
> >>>         - Add the dynamic support for 32-bit and 64-bit address mode based
> on hw configuration.
> >>>         - Removed the CONFIG_MMC_DW_IDMAC_64BIT_ADDRESS macro.
> >>>
> >>>  drivers/mmc/host/dw_mmc.c  |  195
> +++++++++++++++++++++++++++++++++++---------
> >>>  drivers/mmc/host/dw_mmc.h  |   11 +++
> >>>  include/linux/mmc/dw_mmc.h |    2 +
> >>>  3 files changed, 170 insertions(+), 38 deletions(-)
> >>>
> >>> diff --git a/drivers/mmc/host/dw_mmc.c
> b/drivers/mmc/host/dw_mmc.c
> >>> index 69f0cc6..c3b75a5 100644
> >>> --- a/drivers/mmc/host/dw_mmc.c
> >>> +++ b/drivers/mmc/host/dw_mmc.c
> >>> @@ -62,6 +62,24 @@
> >>>                                  SDMMC_IDMAC_INT_FBE | SDMMC_IDMAC_INT_RI | \
> >>>                                  SDMMC_IDMAC_INT_TI)
> >>>
> >>> +struct idmac_desc_64addr {
> >>> +       u32             des0;   /* Control Descriptor */
> >>> +
> >>> +       u32             des1;   /* Reserved */
> >> What is the default value of these _Reserved_ descriptors? As these
> >> are pointers, do you thing initializing then to zero make sense?

We don't think it's required to assign zero to reserved des field as mobster core not going to use this field's for any operations unless user has modified it. 
Also it's working fine in our test set-up without initializing them to zero.

> >
> > I think the default reset value of these descriptors will depend on
> > how dwmmc is integrated in h/w and how these descriptors are then
> > configured.
> >
> > So it makes sense to initialize these descriptors to zero before use.
> > We have seen on our exynos7 system, that we need to initialize the
> > descriptors des1 and des2 to zero before we use them further.

It looks like exynos7 is using this reserved fields for some other purposes. To make it generic, we will initialize the reserved fields to zero.

Does exynos7 requires des2 (Buffer sizes) also to be initialized to zero? 

> 
> I agreed with Vivek and Alim's comment.
> 
> And I think you can fix the below compile warning.
> 
> drivers/mmc/host/dw_mmc.c: In function â€˜dw_mci_idmac_initâ€™:
> drivers/mmc/host/dw_mmc.c:542:21: warning: right shift count >= width of
> type [enabled by default]
> drivers/mmc/host/dw_mmc.c:547:3: warning: right shift count >= width of
> type [enabled by default]
> drivers/mmc/host/dw_mmc.c:575:3: warning: right shift count >= width of
> type [enabled by default]
> 
> I will check this patch with 2.70a and other version.
> 

We will fix the warnings and post the new patch.

Regards,
Prabu Thangamuthu.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
