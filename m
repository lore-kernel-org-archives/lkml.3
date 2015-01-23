Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451AbbAWShw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:37:52 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:41070 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756421AbbAWShr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:37:47 -0500
Message-ID: <54C294F8.5020709@codeaurora.org>
Date: Fri, 23 Jan 2015 11:37:44 -0700
From: Gilad Avidov <gavidov@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: sdharia@codeaurora.org, mlocke@codeaurora.org,
        linux-arm-msm@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, galak@codeaurora.org,
        agross@codeaurora.org
Subject: Re: [PATCH] spmi: pmic_arb: add support for hw version 2
References: <1421716210-14805-1-git-send-email-gavidov@codeaurora.org> <1421850757.10327.4.camel@mm-sol.com>
In-Reply-To: <1421850757.10327.4.camel@mm-sol.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ivan,

On 1/21/2015 7:32 AM, Ivan T. Ivanov wrote:
> Hi Gilad,
>
> Just few comments.
>
> On Mon, 2015-01-19 at 18:10 -0700, Gilad Avidov wrote:
>> Qualcomm PMIC Arbiter version-2 changes from version-1 are:
>>
>> - Some diffrent register offsets.
>> - New channel register space, one per PMIC peripheral (ppid).
>>    All tx tarffic uses these channels.
>> - New observer register space. All rx trafic uses this space.
>> - Diffrent command format for spmi command registers.
>>
>> Signed-off-by: Gilad Avidov <gavidov@codeaurora.org>
>> Acked-by: Sagar Dharia <sdharia@codeaurora.org>
>> ---
> <snip>
>
>> +struct pmic_arb_ver;
>> +
> Is there a better name for this structure. Ok it contain version
> information, but.
will rename to pmic_arb_ver_ops.
>
>>   /**
>>    * spmi_pmic_arb_dev - SPMI PMIC Arbiter object
>>    *
>> - * @base:              address of the PMIC Arbiter core registers.
>> + * @rd_base:           on v1 "core", on v2 "observer" register base off DT.
>> + * @rd_base:           on v1 "core", on v2 "chnls"    register base off DT.
> s/rd/wr/
>
>>    * @intr:              address of the SPMI interrupt control registers.
>>    * @cnfg:              address of the PMIC Arbiter configuration registers.
>>    * @lock:              lock to synchronize accesses.
>> - * @channel:           which channel to use for accesses.
>> + * @channel:           which ee channel to use for accesses.
>>    * @irq:               PMIC ARB interrupt.
>>    * @ee:                        the current Execution Environment
>>    * @min_apid:          minimum APID (used for bounding IRQ search)
>> @@ -114,9 +121,11 @@ enum pmic_arb_cmd_op_code {
>>    * @domain:            irq domain object for PMIC IRQ domain
>>    * @spmic:             SPMI controller object
>>    * @apid_to_ppid:      cached mapping from APID to PPID
>> + * @ppid_to_chan       cached mapping from APID to channel number, v2 only.
>>    */
>>   struct spmi_pmic_arb_dev {
>> -       void __iomem*base;
>> +       void __iomem*rd_base;
>> +       void __iomem*wr_base;
>>          void __iomem*intr;
>>          void __iomem*cnfg;
>>          raw_spinlock_tlock;
>> @@ -129,17 +138,61 @@ struct spmi_pmic_arb_dev {
>>          struct irq_domain*domain;
>>          struct spmi_controller*spmic;
>>          u16     apid_to_ppid[256];
>> +       const struct pmic_arb_ver *ver;
>> +       u8      *ppid_to_chan;
>> +};
>> +
>> +/**
>> + * pmic_arb_ver: version dependent functionality and values.
>> + *
>> + * @non_data_cmd:      on v1 issues an spmi non-data command.
>> + *                             on v2 no HW support, returns -EOPNOTSUPP.
>> + * @offset:            on v1 offset of per-ee channel.
>> + *                             on v2 offset of per-ee and per-ppid channel.
>> + * @fmt_cmd:           formats a GENI/SPMI command.
>> + * @owner_acc_status:  on v1 offset of PMIC_ARB_SPMI_PIC_OWNERm_ACC_STATUSn
>> + *                             on v2 offset of SPMI_PIC_OWNERm_ACC_STATUSn.
>> + * @acc_enable:                on v1 offset of PMIC_ARB_SPMI_PIC_ACC_ENABLEn
>> + *                             on v2 offset of SPMI_PIC_ACC_ENABLEn.
>> + * @irq_status:                on v1 offset of PMIC_ARB_SPMI_PIC_IRQ_STATUSn
>> + *                             on v2 offset of SPMI_PIC_IRQ_STATUSn.
>> + * @irq_clear:         on v1 offset of PMIC_ARB_SPMI_PIC_IRQ_CLEARn
>> + *                             on v2 offset of SPMI_PIC_IRQ_CLEARn.
>> + * @geni_ctrl:         PMIC_ARB_GENI_CTRL offset.
>> + * @geni_status:       PMIC_ARB_GENI_STATUS offset.
>> + * @protocol_irq_status: PMIC_ARB_PROTOCOL_IRQ_STATUS offset.
>> + */
>> +struct pmic_arb_ver {
>> +       int     (*non_data_cmd)(struct spmi_controller *ctrl, u8 opc, u8 sid);
>> +       /* SPMI commands (including data) related functionality */
>> +       off_t   (*offset)(struct spmi_pmic_arb_dev *dev, u8 sid, u16 addr);
>> +       u32     (*fmt_cmd)(u8 opc, u8 sid, u16 addr, u8 bc);
>> +       /* Interrupts related functionality (offset of PIC registers) */
>> +       off_t   (*owner_acc_status)(u8 m, u8 n);
>> +       off_t   (*acc_enable)(u8 n);
>> +       off_t   (*irq_status)(u8 n);
>> +       off_t   (*irq_clear)(u8 n);
>> +       /* Register offsets */
>> +       off_t   geni_ctrl;
>> +       off_t   geni_status;
>> +       off_t   protocol_irq_status;
>>   };
>>
>>
> <snip>
>
>> +
>> +/* Non-data command */
>> +static int pmic_arb_cmd(struct spmi_controller *ctrl, u8 opc, u8 sid)
>> +{
>> +       struct spmi_pmic_arb_dev *pmic_arb = spmi_controller_get_drvdata(ctrl);
>> +
>> +       pr_debug("op:0x%x sid:%d\n", opc, sid);
>>
> Please use dev_dbg.
agree
>
>
>> +static const struct pmic_arb_ver pmic_arb_v1 = {
>> +       .non_data_cmd= pmic_arb_non_data_cmd_v1,
> Missing space before =
will fix
>
>> +       .offset = pmic_arb_offset_v1,
>> +       .fmt_cmd              = pmic_arb_fmt_cmd_v1,
> Bad indentation... and bellow
>
>> +       .owner_acc_status= pmic_arb_owner_acc_status_v1,
>> +       .acc_enable= pmic_arb_acc_enable_v1,
>> +       .irq_status= pmic_arb_irq_status_v1,
>> +       .irq_clear= pmic_arb_irq_clear_v1,
>> +       .geni_ctrl= 0x24,
>> +       .geni_status= 0x28,
>> +       .protocol_irq_status= (0x700 + 0x820),
>> +};
>> +
>> +static const struct pmic_arb_ver pmic_arb_v2 = {
>> +       .non_data_cmd= pmic_arb_non_data_cmd_v2,
>> +       .offset = pmic_arb_offset_v2,
>> +       .fmt_cmd              = pmic_arb_fmt_cmd_v2,
>> +       .owner_acc_status= pmic_arb_owner_acc_status_v2,
>> +       .acc_enable= pmic_arb_acc_enable_v2,
>> +       .irq_status= pmic_arb_irq_status_v2,
>> +       .irq_clear= pmic_arb_irq_clear_v2,
>> +       .geni_ctrl= 0x28,
>> +       .geni_status= 0x2C,
>> +       .protocol_irq_status= (0x700 + 0x900),
>> +};
>> +
>>   static const struct irq_domain_ops pmic_arb_irq_domain_ops = {
>>          .map    = qpnpint_irq_domain_map,
>>          .xlate  = qpnpint_irq_domain_dt_translate,
>> @@ -634,9 +798,11 @@ static int spmi_pmic_arb_probe(struct platform_device *pdev)
>>          struct spmi_pmic_arb_dev *pa;
>>          struct spmi_controller *ctrl;
>>          struct resource *res;
>> -       u32 channel, ee;
>> +       u32 channel, ee, hw_ver;
>>          int err, i;
>>
>> +       pr_err("PMIC Arbiter\n");
>> +
> leftover from debug?
will remove.
>
>>          ctrl = spmi_controller_alloc(&pdev->dev, sizeof(*pa));
>>          if (!ctrl)
>>                  return -ENOMEM;
>> @@ -645,12 +811,64 @@ static int spmi_pmic_arb_probe(struct platform_device *pdev)
>>          pa->spmic = ctrl;
>>
>>          res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "core");
>> -       pa->base = devm_ioremap_resource(&ctrl->dev, res);
>> -       if (IS_ERR(pa->base)) {
>> -               err = PTR_ERR(pa->base);
>> +       pa->rd_base = devm_ioremap_resource(&ctrl->dev, res);
>> +       if (IS_ERR(pa->rd_base)) {
>> +               err = PTR_ERR(pa->rd_base);
>>                  goto err_put_ctrl;
>>          }
>>
>> +       hw_ver = readl_relaxed(pa->rd_base + PMIC_ARB_VERSION);
>> +
>> +       if (hw_ver < PMIC_ARB_VERSION_V2_MIN) {
>> +               pa->ver= &pmic_arb_v1;
>> +               dev_dbg(&ctrl->dev, "PMIC Arb Version-1 (0x%x)\n", hw_ver);
>> +               pa->wr_base = pa->rd_base;
>> +       } else {
>> +               u8  chan;
>> +               u16 ppid;
>> +               u32 regval;
>> +
>> +               pa->ver = &pmic_arb_v2;
>> +               dev_dbg(&ctrl->dev, "PMIC Arb Version-2 (0x%x)\n", hw_ver);
> Do we really need two almost the same dev_dbg's?
I'll try to combine these two
>
>> +
>> +               pa->ppid_to_chan = devm_kzalloc(&ctrl->dev,
>> +                                       PPID_TO_CHAN_TABLE_SZ, GFP_KERNEL);
>> +               if (!pa->ppid_to_chan) {
>> +                       dev_err(&ctrl->dev,
>> +                               "faild allocation of ppid_to_chan table\n");
>> +                       err = -ENOMEM;
>> +                       goto err_put_ctrl;
>> +               }
>> +               /*
>> +                       * PMIC_ARB_REG_CHNL is a table in HW mapping channel to ppid.
>> +                       * ppid_to_chan is an inverted cache of that table.
>> +                       */
>> +               for (chan = 0; chan < PMIC_ARB_MAX_CHNL; ++chan) {
>> +                       regval = readl_relaxed(pa->rd_base +
>> +
>> PMIC_ARB_REG_CHNL(chan));
>> +                       if (!regval)
>> +                               continue;
>> +
>> +                       ppid = (regval >> 8) & 0xFFF;
>> +                       pa->ppid_to_chan[ppid] = chan;
>> +               }
>> +
>> +               res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
>> +                                                               "obsrvr");
>> +               pa->rd_base = devm_ioremap_resource(&ctrl->dev, res);
>> +               if (IS_ERR(pa->rd_base)) {
>> +                       err = PTR_ERR(pa->rd_base);
>> +                       goto err_put_ctrl;
>> +               }
>> +
>> +               res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
>> +                                                               "chnls");
> it looks like
>                    pa->wr_base = devm_ioremap_resource(&ctrl->dev, res);
> is missing?
correct, will add.
>
>> +               if (IS_ERR(pa->wr_base)) {
>> +                       err = PTR_ERR(pa->wr_base);
>> +                       goto err_put_ctrl;
>> +               }
>> +       }
>> +
>>
> Thanks Ivan.
>
Thanks Gilad

-- 
Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project

