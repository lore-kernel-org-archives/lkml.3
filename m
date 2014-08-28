Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbaH1E3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 00:29:09 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:59224 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbaH1E3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 00:29:07 -0400
MIME-Version: 1.0
In-Reply-To: <000001cfc19a$6190fd10$24b2f730$%han@samsung.com>
References: <1408632923-19591-1-git-send-email-gautam.vivek@samsung.com>
	<1408632923-19591-5-git-send-email-gautam.vivek@samsung.com>
	<000001cfc19a$6190fd10$24b2f730$%han@samsung.com>
Date: Thu, 28 Aug 2014 09:59:05 +0530
X-Google-Sender-Auth: bCaChKjyHi0t-rJPhhlFWH4FaZ4
Message-ID: <CAFp+6iGySo_73h-V308Sm+LmX+GNRaJSmYmZjoUEAR_SpUr8CQ@mail.gmail.com>
Subject: Re: [PATCH v5 4/4] phy: exynos5-usbdrd: Calibrate LOS levels for exynos5420/5800
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, kishon <kishon@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Felipe Balbi <balbi@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,


On Wed, Aug 27, 2014 at 7:28 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> On Thursday, August 21, 2014 11:55 PM, Vivek Gautam wrote:
>>
>> Adding phy calibrate callback, which facilitates setting certain
>> PHY settings post initialization of the PHY controller.
>> Exynos5420 and Exynos5800 have 28nm USB 3.0 DRD PHY for which
>> the Loss-of-Signal (LOS) Detector Threshold Level as well as
>> Tx-Vboost-Level should be controlled for Super-Speed operations.
>>
>> Additionally set proper time to wait for RxDetect measurement,
>> for desired PHY reference clock, so as to solve issue with enumeration
>> of few USB 3.0 devices, like Samsung SUM-TSB16S 3.0 USB drive
>> on the controller.
>> We are using CR_port for this purpose to send required data
>> to override the LOS values.
>>
>> On testing with USB 3.0 devices on USB 3.0 port present on
>> SMDK5420, and peach-pit boards should see following message:
>> usb 2-1: new SuperSpeed USB device number 2 using xhci-hcd
>>
>> and without this patch, should see below shown message:
>> usb 1-1: new high-speed USB device number 2 using xhci-hcd
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> ---
>>  drivers/phy/phy-exynos5-usbdrd.c |  169 ++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 169 insertions(+)
>>
>> diff --git a/drivers/phy/phy-exynos5-usbdrd.c b/drivers/phy/phy-exynos5-usbdrd.c
>> index 47f47fe..fa13784 100644
>> --- a/drivers/phy/phy-exynos5-usbdrd.c
>> +++ b/drivers/phy/phy-exynos5-usbdrd.c
>> @@ -89,8 +89,20 @@
>>  #define PHYCLKRST_COMMONONN                  BIT(0)
>>
>>  #define EXYNOS5_DRD_PHYREG0                  0x14
>> +
>> +#define EXYNOS5_DRD_PHYREG0_SSC_REF_CLK_SEL  BIT(21)
>> +#define EXYNOS5_DRD_PHYREG0_SSC_RANGE                BIT(20)
>> +#define EXYNOS5_DRD_PHYREG0_CR_WRITE         BIT(19)
>> +#define EXYNOS5_DRD_PHYREG0_CR_READ          BIT(18)
>> +#define EXYNOS5_DRD_PHYREG0_CR_DATA_IN(_x)   ((_x) << 2)
>> +#define EXYNOS5_DRD_PHYREG0_CR_CAP_DATA              BIT(1)
>> +#define EXYNOS5_DRD_PHYREG0_CR_CAP_ADDR              BIT(0)
>> +
>>  #define EXYNOS5_DRD_PHYREG1                  0x18
>>
>> +#define EXYNOS5_DRD_PHYREG1_CR_DATA_OUT(_x)  ((_x) << 1)
>> +#define EXYNOS5_DRD_PHYREG1_CR_ACK           BIT(0)
>> +
>>  #define EXYNOS5_DRD_PHYPARAM0                        0x1c
>>
>>  #define PHYPARAM0_REF_USE_PAD                        BIT(31)
>> @@ -118,6 +130,26 @@
>>  #define EXYNOS5_DRD_PHYRESUME                        0x34
>>  #define EXYNOS5_DRD_LINKPORT                 0x44
>>
>> +/* USB 3.0 DRD PHY SS Function Control Reg; accessed by CR_PORT */
>> +#define EXYNOS5_DRD_PHYSS_LOSLEVEL_OVRD_IN           (0x15)
>> +
>
> Please remove unnecessary line.

Sure will remove extra lines.

[snip]

>> +static void crport_ctrl_write(struct exynos5_usbdrd_phy *phy_drd,
>> +                                             u32 addr, u32 data)
>> +{
>> +     /* Write Address */
>> +     crport_handshake(phy_drd, EXYNOS5_DRD_PHYREG0_CR_DATA_IN(addr),
>> +                      EXYNOS5_DRD_PHYREG0_CR_CAP_ADDR);
>
> According to the guidance from H/W team, before calling crport_handshake(),
> write access for EXYNOS5_DRD_PHYREG0 register is necessary.
>
> Please, add the write access as follows.
>
> +       /* Write Address */
> +       writel(EXYNOS5_DRD_PHYREG0_CR_DATA_IN(addr),
> +               phy_drd->reg_phy + EXYNOS5_DRD_PHYREG0);
> +       crport_handshake(phy_drd, EXYNOS5_DRD_PHYREG0_CR_DATA_IN(addr),
> +                        EXYNOS5_DRD_PHYREG0_CR_CAP_ADDR);

Sure will add this, thanks for getting the information from H/W team
and suggesting.

>
> Best regards,
> Jingoo Han
>
>> +
>> +     /* Write Data */
>> +     crport_handshake(phy_drd, EXYNOS5_DRD_PHYREG0_CR_DATA_IN(data),
>> +                      EXYNOS5_DRD_PHYREG0_CR_CAP_DATA);
>> +     crport_handshake(phy_drd, EXYNOS5_DRD_PHYREG0_CR_DATA_IN(data),
>> +                      EXYNOS5_DRD_PHYREG0_CR_WRITE);
>> +}
>> +
>> +/*
>> + * Override PHY paramaeters using CR_PORT register to calibrate settings
>> + * to meet meet SuperSpeed requirements, on Exynos5420 and Exynos5800 systems,
>> + * which have 28nm USB 3.0 DRD PHY.
>> + */
>> +static void exynos5420_usbdrd_phy_calibrate(struct exynos5_usbdrd_phy *phy_drd)
>> +{
>> +     u32 temp;
>> +
>> +     /*
>> +      * Change los_bias to (0x5) for 28nm PHY from a
>> +      * default value (0x0); los_level is set as default
>> +      * (0x9) as also reflected in los_level[30:26] bits
>> +      * of PHYPARAM0 register.
>> +      */
>> +     temp = LOSLEVEL_OVRD_IN_LOS_BIAS_5420 |
>> +             LOSLEVEL_OVRD_IN_EN |
>> +             LOSLEVEL_OVRD_IN_LOS_LEVEL_DEFAULT;
>> +     crport_ctrl_write(phy_drd,
>> +                       EXYNOS5_DRD_PHYSS_LOSLEVEL_OVRD_IN,
>> +                       temp);
>> +
>> +     /*
>> +      * Set tx_vboost_lvl to (0x5) for 28nm PHY Tuning,
>> +      * to raise Tx signal level from its default value of (0x4)
>> +      */
>> +     temp = TX_VBOOSTLEVEL_OVRD_IN_VBOOST_5420;
>> +     crport_ctrl_write(phy_drd,
>> +                       EXYNOS5_DRD_PHYSS_TX_VBOOSTLEVEL_OVRD_IN,
>> +                       temp);
>> +
>> +     /*
>> +      * Set proper time to wait for RxDetect measurement, for
>> +      * desired reference clock of PHY, by tuning the CRPORT
>> +      * register LANE0.TX_DEBUG which is internal to PHY.
>> +      * This fixes issue with few USB 3.0 devices, which are
>> +      * not detected (not even generate interrupts on the bus
>> +      * on insertion) without this change.
>> +      * e.g. Samsung SUM-TSB16S 3.0 USB drive.
>> +      */
>> +     switch (phy_drd->extrefclk) {
>> +     case EXYNOS5_FSEL_50MHZ:
>> +             temp = LANE0_TX_DEBUG_RXDET_MEAS_TIME_48M_50M_52M;
>> +             break;
>> +     case EXYNOS5_FSEL_20MHZ:
>> +     case EXYNOS5_FSEL_19MHZ2:
>> +             temp = LANE0_TX_DEBUG_RXDET_MEAS_TIME_19M2_20M;
>> +             break;
>> +     case EXYNOS5_FSEL_24MHZ:
>> +     default:
>> +             temp = LANE0_TX_DEBUG_RXDET_MEAS_TIME_24M;
>> +             break;
>> +     }
>> +
>> +     crport_ctrl_write(phy_drd,
>> +                       EXYNOS5_DRD_PHYSS_LANE0_TX_DEBUG,
>> +                       temp);
>> +}
>> +
>> +/* Calibrate PIPE3 PHY settings, if any */
>> +static int exynos5_usbdrd_pipe3_calibrate(struct phy_usb_instance *inst)
>> +{
>> +     struct exynos5_usbdrd_phy *phy_drd = to_usbdrd_phy(inst);
>> +
>> +     /* Call respective phy_calibrate given by certain platform */
>> +     if (phy_drd->drv_data->calibrate)
>> +             phy_drd->drv_data->calibrate(phy_drd);
>> +
>> +     return 0;
>> +}
>> +
>> +static int exynos5_usbdrd_phy_calibrate(struct phy *phy)
>> +{
>> +     struct phy_usb_instance *inst = phy_get_drvdata(phy);
>> +
>> +     if (inst->phy_cfg->phy_calibrate)
>> +             inst->phy_cfg->phy_calibrate(inst);
>> +
>> +     return 0;
>> +}
>> +
>>  static struct phy *exynos5_usbdrd_phy_xlate(struct device *dev,
>>                                       struct of_phandle_args *args)
>>  {
>> @@ -503,6 +669,7 @@ static struct phy_ops exynos5_usbdrd_phy_ops = {
>>       .exit           = exynos5_usbdrd_phy_exit,
>>       .power_on       = exynos5_usbdrd_phy_power_on,
>>       .power_off      = exynos5_usbdrd_phy_power_off,
>> +     .calibrate      = exynos5_usbdrd_phy_calibrate,
>>       .owner          = THIS_MODULE,
>>  };
>>
>> @@ -518,6 +685,7 @@ static const struct exynos5_usbdrd_phy_config phy_cfg_exynos5[] = {
>>               .phy_isol       = exynos5_usbdrd_phy_isol,
>>               .phy_init       = exynos5_usbdrd_pipe3_init,
>>               .set_refclk     = exynos5_usbdrd_pipe3_set_refclk,
>> +             .phy_calibrate  = exynos5_usbdrd_pipe3_calibrate,
>>       },
>>  };
>>
>> @@ -525,6 +693,7 @@ static const struct exynos5_usbdrd_phy_drvdata exynos5420_usbdrd_phy = {
>>       .phy_cfg                = phy_cfg_exynos5,
>>       .pmu_offset_usbdrd0_phy = EXYNOS5_USBDRD_PHY_CONTROL,
>>       .pmu_offset_usbdrd1_phy = EXYNOS5420_USBDRD1_PHY_CONTROL,
>> +     .calibrate              = exynos5420_usbdrd_phy_calibrate,
>
> Hmm, how about adding just flag for this, instead of function callback?
> It looks a little bit confusing.

Yeah, i understand the function pointer name looks a bit confusing
since we are using same name in struct phy_ops too.
But i think keeping a function here for each platform may help in
adding any such support in future SoCs too.

May be we can rename it to phy_exynos_calibrate, if you think
that's fine.
Please let me know your opinion about this.




-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
