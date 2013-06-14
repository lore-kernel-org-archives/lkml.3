Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab3FNHkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 03:40:46 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41793 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab3FNHko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 03:40:44 -0400
Message-ID: <51BAC8F6.5010601@codeaurora.org>
Date: Fri, 14 Jun 2013 13:10:38 +0530
From: Sujit Reddy Thumma <sthumma@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Santosh Y <santoshsy@gmail.com>
CC: Dolev Raviv <draviv@codeaurora.org>, linux-scsi@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] scsi: ufs: Add support for sending NOP OUT UPIU
References: <1370873118-18468-1-git-send-email-draviv@codeaurora.org> <1370873118-18468-2-git-send-email-draviv@codeaurora.org> <CALMYJDsJ3OGwmcEjgpLWv2SYYXiGQpk0GCmG6rEVD0KKCjj+ng@mail.gmail.com> <51B94BAF.2070203@codeaurora.org>
In-Reply-To: <51B94BAF.2070203@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/13/2013 10:03 AM, Sujit Reddy Thumma wrote:
>>   static struct scsi_host_template ufshcd_driver_template = {
>> @@ -1771,8 +2064,8 @@ int ufshcd_init(struct device *dev, struct
>> ufs_hba **hba_handle,
>>          /* Configure LRB */
>>          ufshcd_host_memory_configure(hba);
>>
>> -       host->can_queue = hba->nutrs;
>> -       host->cmd_per_lun = hba->nutrs;
>> +       host->can_queue = SCSI_CMD_QUEUE_SIZE;
>
>
> I don't think this is appropriate. Reserving a slot exclusively for
> query/DM requests is not optimal.  can_queue should be changed
> dynamically, scsi_adjust_queue_depth() maybe?

The motivation to change the design for this patch  is that routing
query command through SCSI layer raised problems when we are trying to
improve the fatal error handling as we need to block the SCSI layer and
recover the link. Hence, the need to have the query/DM command send as
internal commands. Which probably makes sense.

One possible option was to look for a free command slot whenever we
try to send an internal command, but getting a free slot is not always 
guaranteed.

Even if we get hold of a tag, there is no way we can explain this to
SCSI/block layer that particular tag is in use internally (case where
normal query requests are sent in tandem with SCSI requests). In which
case, other option is to use tag[31] as you have said on need basis
and change the queue depth to 31. This again has problems - one
changing queue depth doesn't take effect immediately but for the next
command. Second, if the command in tag[31] is the root cause of the
fatal error and is stuck, then the internal command has to wait forever
(until scsi timesout) to plan recovery. Considering, all these factors
it is better to reserve a tag and use it for internal commands instead 
of playing around with the tags internally without/partially informing 
SCSI/block layers.

I am open for discussion, if there are any suggestions to handle such 
LLD requirements in the SCSI layer optimally.

Coming to how optimal is to work with 31 slots instead of h/w defined 32 
is something which we can answer when we have true multi queueing. 
AFAIK, there may not exist real-world applications which utilize full 32 
tags at particular instant. SATA AHCI controller driver which is 
ubiquitous in modern systems also reserves a slot for internal commands 
which is used only in case of error handling and AFAIK, no one has ever 
reported performance problems with this (its about 7 years the commit to 
reserve a slot is merged into Linux tree).

I hope this explains the intent. Please let me know what do you think.

-- 
Regards,
Sujit
