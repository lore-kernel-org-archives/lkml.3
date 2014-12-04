Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682AbaLDQpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:45:07 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:33785 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092AbaLDQpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:45:05 -0500
Message-ID: <54808F8B.6030807@codeaurora.org>
Date: Thu, 04 Dec 2014 18:44:59 +0200
From: Tanya Brokhman <tlinder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: dedekind1@gmail.com, Richard Weinberger <richard@nod.at>
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] UBI: Fastmap: Ensure that all fastmap work is done
 upon WL shutdown
References: <1416835236-25185-1-git-send-email-richard@nod.at> <1416835236-25185-4-git-send-email-richard@nod.at> <1417102739.5858.112.camel@sauron.fi.intel.com>
In-Reply-To: <1417102739.5858.112.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2014 5:38 PM, Artem Bityutskiy wrote:
> On Mon, 2014-11-24 at 14:20 +0100, Richard Weinberger wrote:
>> ...otherwise the deferred work might run after datastructures
>> got freed and corrupt memory.
>>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
>> ---
>>   drivers/mtd/ubi/wl.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
>> index 7f135df..cb2e571 100644
>> --- a/drivers/mtd/ubi/wl.c
>> +++ b/drivers/mtd/ubi/wl.c
>> @@ -2041,6 +2041,9 @@ static void protection_queue_destroy(struct ubi_device *ubi)
>>   void ubi_wl_close(struct ubi_device *ubi)
>>   {
>>   	dbg_wl("close the WL sub-system");
>> +#ifdef CONFIG_MTD_UBI_FASTMAP
>> +	flush_work(&ubi->fm_work);
>> +#endif
>
> If you are using the work infrastructure implemented in wl.c, then
> fastmap work should be no different to any other work. And we do flush
> all works in 'shutdown_work()'. The fastmap work should be flushed there
> too.

I tend to agree with Artem. Could you please move it to shutdown_work()? 
I'm asking because I do want to pick up all the bug fixes patches, but 
not going to pick up the "cleaning up" patches at this point.

>
> I think we discussed this already - there should be one single queue of
> works, managed by the same set of functions, all flushed in the same
> place, one-by-one...
>
> Obviously, there is some misunderstanding. This looks like lack of
> separation and misuse of layering. I am missing explanations why I am
> wrong...
>
>
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/
>


Thanks,
Tanya Brokhman
-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum, a Linux Foundation Collaborative Project
