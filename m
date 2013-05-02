Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955Ab3EBLdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 07:33:31 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12596 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873Ab3EBLd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 07:33:29 -0400
X-IronPort-AV: E=Sophos;i="4.87,595,1363158000"; 
   d="scan'208";a="43417378"
Message-ID: <51824F02.9070103@codeaurora.org>
Date: Thu, 02 May 2013 17:03:22 +0530
From: Sujit Reddy Thumma <sthumma@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Santosh Y <santoshsy@gmail.com>
CC: Vinayak Holikatti <vinholikatti@gmail.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] scsi: ufs: Generalize UFS Interconnect Layer (UIC)
 command support
References: <1366736234-8964-1-git-send-email-sthumma@codeaurora.org> <CALMYJDtE=GnETSi7KfLCWWqow3Let3Q5aL70ei3MkJKH6FWzFg@mail.gmail.com>
In-Reply-To: <CALMYJDtE=GnETSi7KfLCWWqow3Let3Q5aL70ei3MkJKH6FWzFg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/2/2013 12:49 PM, Santosh Y wrote:
>> -static inline void
>> -ufshcd_send_uic_command(struct ufs_hba *hba, struct uic_command *uic_cmnd)
>> +static int ufshcd_send_uic_command(struct ufs_hba *hba,
>> +               struct uic_command *uic_cmnd, int retries)
>>   {
>> +       int err = 0;
>> +       unsigned long flags;
>> +
>> +       if (unlikely(mutex_trylock(&hba->uic_cmd_mutex))) {
>> +               mutex_unlock(&hba->uic_cmd_mutex);
>> +               dev_err(hba->dev, "%s: called without prepare command\n",
>> +                               __func__);
>> +               BUG();
>> +       }
>> +
>> +retry:
>> +       /* check if controller is ready to accept UIC commands */
>> +       if (!(readl(hba->mmio_base + REG_CONTROLLER_STATUS) &
>> +                               UIC_COMMAND_READY)) {
>> +               dev_err(hba->dev, "Controller not ready to accept UIC commands\n");
>> +               err = -EIO;
>> +               goto out;
>> +       }
>> +
>> +       init_completion(&uic_cmnd->completion);
>> +
>> +       spin_lock_irqsave(hba->host->host_lock, flags);
>> +
>> +       /* enable UIC related interrupts */
>> +       if (!(hba->int_enable_mask & UIC_COMMAND_COMPL)) {
>> +               hba->int_enable_mask |= UIC_COMMAND_COMPL;
>> +               ufshcd_int_config(hba, UFSHCD_INT_ENABLE);
>> +       }
>> +
>
> No need to check if the interrupt is already enabled, it can be
> directly enabled.

That would be unnecessary device access (writel) every time we send a 
UIC command.

>
>
>>          /* Write Args */
>>          writel(uic_cmnd->argument1,
>>                (hba->mmio_base + REG_UIC_COMMAND_ARG_1));
>> @@ -415,6 +491,45 @@ ufshcd_send_uic_command(struct ufs_hba *hba, struct uic_command *uic_cmnd)
>>          /* Write UIC Cmd */
>>          writel((uic_cmnd->command & COMMAND_OPCODE_MASK),
>>                 (hba->mmio_base + REG_UIC_COMMAND));
>> +
>> +       /* flush to make sure h/w sees the write */
>> +       readl(hba->mmio_base + REG_UIC_COMMAND);
>> +
>> +       spin_unlock_irqrestore(hba->host->host_lock, flags);
>> +
>
> mutex lock/unlock can be done in the send_uic_command, It will
> simplify the process for the caller.

  ufshcd_dme_get_attr()
  {
    1) ufshcd_prepare_uic_command_lck();
    2) ufshcd_send_uic_command();
    3) Read arg3 to know the value of Uni-pro attribute.
    4) ufshcd_unprepare_uic_command_unlck();
  }

Step 3 above is optional for some of the UIC commands but when it is 
required it should be done with mutex lock held as the 
hba->active_uic_cmd might be modified by some one else before value 
present hba->active_uic_cmd->argument3 is read.

But thinking more on this holding lock only in send_uic_command() is 
feasible.

>
>> +       err = wait_for_completion_timeout(
>> +                       &uic_cmnd->completion, UIC_COMMAND_TIMEOUT);
>> +       if (!err) {
>> +               err = -ETIMEDOUT;
>> +       } else if (uic_cmnd->argument2 & MASK_UIC_COMMAND_RESULT) {
>> +               /* something bad with h/w or arguments, try again */
>> +               if (--retries)
>> +                       goto retry;
>> +
>

-- 
Regards,
Sujit
