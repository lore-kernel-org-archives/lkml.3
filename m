Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbbAXIPE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 03:15:04 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:39749 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbbAXIPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 03:15:01 -0500
Message-ID: <54C3547E.6000204@mm-sol.com>
Date: Sat, 24 Jan 2015 10:14:54 +0200
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Gilad Avidov <gavidov@codeaurora.org>
CC: sdharia@codeaurora.org, mlocke@codeaurora.org,
        linux-arm-msm@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, iivanov@mm-sol.com, galak@codeaurora.org,
        agross@codeaurora.org
Subject: Re: [PATCH] spmi: pmic_arb: add support for hw version 2
References: <1421716210-14805-1-git-send-email-gavidov@codeaurora.org> <54C27ED9.9080403@mm-sol.com> <54C2B4A7.3060503@codeaurora.org>
In-Reply-To: <54C2B4A7.3060503@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gilad,

<snip>

>>
>>>   -/* Non-data command */
>>> -static int pmic_arb_cmd(struct spmi_controller *ctrl, u8 opc, u8 sid)
>>> +static int
>>> +pmic_arb_non_data_cmd_v1(struct spmi_controller *ctrl, u8 opc, u8 sid)
>>>   {
>>>       struct spmi_pmic_arb_dev *pmic_arb =
>>> spmi_controller_get_drvdata(ctrl);
>>>       unsigned long flags;
>>>       u32 cmd;
>>>       int rc;
>>> -
>>> -    /* Check for valid non-data command */
>>> -    if (opc < SPMI_CMD_RESET || opc > SPMI_CMD_WAKEUP)
>>> -        return -EINVAL;
>>> +    u32 offset = pmic_arb->ver->offset(pmic_arb, sid, 0);
>>>         cmd = ((opc | 0x40) << 27) | ((sid & 0xf) << 20);
>>>         raw_spin_lock_irqsave(&pmic_arb->lock, flags);
>>> -    pmic_arb_base_write(pmic_arb, PMIC_ARB_CMD(pmic_arb->channel),
>>> cmd);
>>> -    rc = pmic_arb_wait_for_done(ctrl);
>>> +    pmic_arb_base_write(pmic_arb, offset + PMIC_ARB_CMD, cmd);
>>> +    rc = pmic_arb_wait_for_done(ctrl, pmic_arb->wr_base, sid, 0);
>>>       raw_spin_unlock_irqrestore(&pmic_arb->lock, flags);
>>>         return rc;
>>>   }
>>>   +/* Unsupported by HW */
>>> +static int
>>> +pmic_arb_non_data_cmd_v2(struct spmi_controller *ctrl, u8 opc, u8 sid)
>>> +{
>>> +    return -EOPNOTSUPP;
>>> +}
> 
> Hi Stanimir,
> 
>> Does pmic arbiter v2 supports SPMI_CMD_WAKEUP and SPMI_CMD_SHUTDOWN
>> commands? If so how we send those commands to the arbiter when the
> pmic-arbiter v2 does not support non-data commands including the two
> that you have mentioned above.
>> .non_data_cmd operation returns EOPNOTSUPP. If we returning EOPNOTSUPP
>> the spmi bus .probe method will not call spmi driver .probe. See spmi.c
>> spmi_drv_probe().
> Very keen observation!
> 
> The slaves that I'm working on do not need nor support the wakeup command.
> I'll add a patch to add a new device tree boolean property to the
> framework, maybe "skip-wakeup", for similar slaves.
> Then change spmi_drv_probe() to skip the wakeup if the property is there.

No, instead of adding one more dt property just return zero from
.non_data_cmd operation and keep the comment that this is not supported
on v2. The other way is to fill the .non_data_cmd = NULL on v2 and add a
check for .non_data_cmd != NULL in the callers.

-- 
regards,
Stan
