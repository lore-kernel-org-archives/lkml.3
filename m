Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757802Ab3EBLbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 07:31:24 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6092 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757043Ab3EBLbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 07:31:23 -0400
X-IronPort-AV: E=Sophos;i="4.87,595,1363158000"; 
   d="scan'208";a="43563031"
Message-ID: <51824E86.6010805@codeaurora.org>
Date: Thu, 02 May 2013 17:01:18 +0530
From: Sujit Reddy Thumma <sthumma@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Santosh Y <santoshsy@gmail.com>
CC: Vinayak Holikatti <vinholikatti@gmail.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] scsi: ufs: Add support for sending NOP OUT UPIU
References: <1366812872-26331-1-git-send-email-sthumma@codeaurora.org> <CALMYJDut2=gwVsNxfeEM5mR2K9uJ0nMiV2y=xu3WZEUpfN-z7w@mail.gmail.com>
In-Reply-To: <CALMYJDut2=gwVsNxfeEM5mR2K9uJ0nMiV2y=xu3WZEUpfN-z7w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/2/2013 12:57 PM, Santosh Y wrote:
>> +
>> +/**
>> + * ufshcd_validate_dev_connection() - Check device connection status
>> + * @hba: per-adapter instance
>> + *
>> + * Send NOP OUT UPIU and wait for NOP IN response to check whether the
>> + * device Transport Protocol (UTP) layer is ready after a reset.
>> + * If the UTP layer at the device side is not initialized, it may
>> + * not respond with NOP IN UPIU within timeout of %NOP_OUT_TIMEOUT
>> + * and we retry sending NOP OUT for %NOP_OUT_RETRIES iterations.
>> + */
>> +static int ufshcd_validate_dev_connection(struct ufs_hba *hba)
>> +{
>> +       int err;
>> +       struct ufshcd_lrb *lrbp;
>> +       unsigned long timeout;
>> +       unsigned long flags;
>> +       struct completion wait;
>> +       int retries = NOP_OUT_RETRIES;
>> +
>> +retry:
>> +       spin_lock_irqsave(hba->host->host_lock, flags);
>> +       lrbp = &hba->lrb[INTERNAL_CMD_TAG];
>> +       init_completion(&wait);
>> +
>> +       err = ufshcd_compose_nop_out_upiu(hba, lrbp);
>> +       if (err)
>> +               goto may_retry;
>> +
>> +       lrbp->completion = &wait;
>> +       ufshcd_send_command(hba, INTERNAL_CMD_TAG);
>> +       spin_unlock_irqrestore(hba->host->host_lock, flags);
>> +
>> +       timeout = wait_for_completion_timeout(
>> +                       &wait, msecs_to_jiffies(NOP_OUT_TIMEOUT));
>> +
>> +       spin_lock_irqsave(hba->host->host_lock, flags);
>> +       if (timeout > 0) {
>> +               int ocs;
>> +
>> +               ocs = ufshcd_get_tr_ocs(lrbp);
>> +               switch (ocs) {
>> +               case OCS_SUCCESS:
>> +                       goto out;
>> +               default:
>> +                       dev_dbg(hba->dev, "%s: OCS error %d\n", __func__, ocs);
>> +                       err = -EIO;
>> +                       goto may_retry;
>> +               }
>> +       } else {
>> +               u32 reg;
>> +
>> +               err = -ETIMEDOUT;
>> +
>> +               /* clear outstanding transaction before retry */
>> +               ufshcd_utrl_clear(hba, INTERNAL_CMD_TAG);
>> +               __clear_bit(INTERNAL_CMD_TAG, &hba->outstanding_reqs);
>> +
>> +               /* poll for max. 1 sec to clear door bell register by h/w */
>> +               spin_unlock_irqrestore(hba->host->host_lock, flags);
>> +               if (readl_poll_timeout(
>> +                               hba->mmio_base + REG_UTP_TRANSFER_REQ_DOOR_BELL,
>> +                               reg, !(reg & INTERNAL_CMD_TAG), 1000, 1000))
>
> Condition is always true here, change it to !(reg & (1 << INTERNAL_CMD_TAG)).

Good catch. I will update.

>
>> +                       retries = 0;
>> +               spin_lock_irqsave(hba->host->host_lock, flags);
>> +               goto may_retry;
>> +       }
>> +
>
>
>

-- 
Regards,
Sujit
