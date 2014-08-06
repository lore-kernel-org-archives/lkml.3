Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbaHFJLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 05:11:35 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:55441 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbaHFJLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 05:11:33 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, <DL-MPTFusionLinux@lsi.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: message: fusion: Simplify rounding
Organization: D03
References: <1404219380-2712-1-git-send-email-linux@rasmusvillemoes.dk>
	<alpine.DEB.2.02.1407031300280.9641@jlaw-desktop.mno.stratus.com>
X-Hashcash: 1:20:140806:linux-scsi@vger.kernel.org::N9xtPSagt3nxV3Vi:000000000000000000000000000000000002eCW
X-Hashcash: 1:20:140806:sreekanth.reddy@lsi.com::yx5tMMR3RPDfB/jj:000000000000000000000000000000000000002FhY
X-Hashcash: 1:20:140806:dl-mptfusionlinux@lsi.com::5wWyi5Q6qmtg/iYX:0000000000000000000000000000000000003gNC
X-Hashcash: 1:20:140806:linux-kernel@vger.kernel.org::1bFY5D2xvXPWrW5Z:00000000000000000000000000000000052Eq
X-Hashcash: 1:20:140806:joe.lawrence@stratus.com::RkKhzz2a3oPmw0a/:0000000000000000000000000000000000000DxFn
Date: Wed, 06 Aug 2014 11:11:30 +0200
In-Reply-To: <alpine.DEB.2.02.1407031300280.9641@jlaw-desktop.mno.stratus.com>
	(Joe Lawrence's message of "Thu, 3 Jul 2014 13:49:29 -0400")
Message-ID: <87y4v29e4d.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Lawrence <joe.lawrence@stratus.com> writes:

> On Tue, 1 Jul 2014, Rasmus Villemoes wrote:
>
>> Rounding up to a multiple of 4 should be done using the ALIGN
>> macro. As a bonus, this also makes the generated code smaller.
>> 
>> In GetIocFacts(), sz is assigned to a few lines below without being
>> read in the meantime, so it is ok that it doesn't end up with the same
>> value as facts->FWImageSize.
>> 
>> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>> ---
>>  drivers/message/fusion/mptbase.c | 7 +------
>>  drivers/message/fusion/mptctl.c  | 7 +------
>>  2 files changed, 2 insertions(+), 12 deletions(-)
>> 
>> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
>> index ebc0af7..10b16a1 100644
>> --- a/drivers/message/fusion/mptbase.c
>> +++ b/drivers/message/fusion/mptbase.c
>> @@ -3175,12 +3175,7 @@ GetIocFacts(MPT_ADAPTER *ioc, int sleepFlag, int reason)
>>  			facts->FWImageSize = le32_to_cpu(facts->FWImageSize);
>>  		}
>>  
>> -		sz = facts->FWImageSize;
>> -		if ( sz & 0x01 )
>> -			sz += 1;
>> -		if ( sz & 0x02 )
>> -			sz += 2;
>> -		facts->FWImageSize = sz;
>> +		facts->FWImageSize = ALIGN(facts->FWImageSize, 4);
>>  
>>  		if (!facts->RequestFrameSize) {
>>  			/*  Something is wrong!  */
>> diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
>> index 8a050e8..1004392 100644
>> --- a/drivers/message/fusion/mptctl.c
>> +++ b/drivers/message/fusion/mptctl.c
>> @@ -1749,12 +1749,7 @@ mptctl_replace_fw (unsigned long arg)
>>  
>>  	/* Allocate memory for the new FW image
>>  	 */
>> -	newFwSize = karg.newImageSize;
>> -
>> -	if (newFwSize & 0x01)
>> -		newFwSize += 1;
>> -	if (newFwSize & 0x02)
>> -		newFwSize += 2;
>> +	newFwSize = ALIGN(karg.newImageSize, 4);
>>  
>>  	mpt_alloc_fw_memory(ioc, newFwSize);
>>  	if (ioc->cached_fw == NULL)
>
> ALIGN is certainly more readable to me.
>
> Reviewed-by: Joe Lawrence <joe.lawrence@stratus.com>
>
> -- Joe

Did anyone pick this up?

Thanks,
Rasmus
