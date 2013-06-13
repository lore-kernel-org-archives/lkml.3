Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab3FMEgn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 00:36:43 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:47379 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab3FMEgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 00:36:41 -0400
Message-ID: <51B94C54.8070209@codeaurora.org>
Date: Thu, 13 Jun 2013 10:06:36 +0530
From: Sujit Reddy Thumma <sthumma@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Santosh Y <santoshsy@gmail.com>
CC: Dolev Raviv <draviv@codeaurora.org>, linux-scsi@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] scsi: ufs: Set fDeviceInit flag to initiate device
 initialization
References: <1370873118-18468-1-git-send-email-draviv@codeaurora.org> <1370873118-18468-3-git-send-email-draviv@codeaurora.org> <CALMYJDvXi7M8AgdJNpoL4H2-b3WBNZ3LLc2d8wkUMRJi5OQJQQ@mail.gmail.com>
In-Reply-To: <CALMYJDvXi7M8AgdJNpoL4H2-b3WBNZ3LLc2d8wkUMRJi5OQJQQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/12/2013 11:04 AM, Santosh Y wrote:
>>
>>   /**
>> + *  ufshcd_query_request() - API for issuing query request to the device.
>> + *  @hba: ufs driver context
>> + *  @query: params for query request
>> + *  @descriptor: buffer for sending/receiving descriptor
>> + *  @retries: number of times to try executing the command
>> + *
>> + *   All necessary fields for issuing a query and receiving its response
>> + *   are stored in the UFS hba struct. We can use this method since we know
>> + *   there is only one active query request or any internal command at all
>> + *   times.
>> + */
>> +static int ufshcd_send_query_request(struct ufs_hba *hba,
>> +                                       struct ufs_query_req *query,
>> +                                       u8 *descriptor,
>> +                                       struct ufs_query_res *response)
>> +{
>> +       int ret;
>> +
>> +       BUG_ON(!hba);
>> +       if (!query || !response) {
>> +               dev_err(hba->dev,
>> +                       "%s: NULL pointer query = %p, response = %p\n",
>> +                       __func__, query, response);
>> +               return -EINVAL;
>> +       }
>> +
>> +       mutex_lock(&hba->i_cmd.dev_cmd_lock);
>> +       hba->i_cmd.query.request = query;
>> +       hba->i_cmd.query.response = response;
>> +       hba->i_cmd.query.descriptor = descriptor;
>> +
>> +       ret = ufshcd_exec_internal_cmd(hba, DEV_CMD_TYPE_QUERY,
>> +                                       QUERY_REQ_TIMEOUT);
>
> Can this be generic, as external query commands might also use it?

External query commands can call ufshcd_send_query_request() directly, 
without going into hassle of taking mutex lock and filling internal cmd 
structure.

>
>> +
>> +       hba->i_cmd.query.request = NULL;
>> +       hba->i_cmd.query.response = NULL;
>> +       hba->i_cmd.query.descriptor = NULL;
>> +       mutex_unlock(&hba->i_cmd.dev_cmd_lock);
>> +
>> +       return ret;
>> +}
>> +
>> +/**
>
>

-- 
Regards,
Sujit
