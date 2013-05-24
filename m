Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab3EXUdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 16:33:14 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:30995 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab3EXUdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 16:33:13 -0400
Message-ID: <519FCE6A.9020701@oracle.com>
Date: Fri, 24 May 2013 15:32:42 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
CC: Vahram Martirosyan <vmartirosyan@gmail.com>,
        Dave Kleikamp <shaggy@kernel.org>,
        Vahram Martirosyan <vahram.martirosyan@linuxtesting.org>,
        jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        spruce-project@linuxtesting.org
Subject: Re: [PATCH 2/2] jfs: Log shutdown error in jfs_freeze() function
References: <1369385833-6852-1-git-send-email-vahram.martirosyan@linuxtesting.org> <1369385833-6852-2-git-send-email-vahram.martirosyan@linuxtesting.org> <519F3212.6050602@cn.fujitsu.com>
In-Reply-To: <519F3212.6050602@cn.fujitsu.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2013 04:25 AM, Gu Zheng wrote:
> Hi Vahram,
>    I saw the same issue in the bugzilla:
> https://bugzilla.kernel.org/show_bug.cgi?id=53331,
> and I sent out a patch this issue, but I've get any feedback.

Sorry I missed that bug. I just realized that bugzilla.kernel.org has
been sending my email to my old IBM address. I've got some catching up
to do.

> In fact, I think it's the right way to fix this issue,
> can you help to test it?

I might go with your patch for now, as it is an improvement, but I don't
really like the way that lmLogShutdown is skipped altogether during a
"nointegrity" unmount. If we skip it during a "nointegrity" freeze, we
should also skip lmLogInit on "nointegrity" unfreeze. I'd like to keep
the nointegrity logic in jfs_logmgr.c, but it would be easiest to fix in
the freeze and unfreeze functions. A code cleanup may be better than the
easy fix. I'll have to work on that.

It also looks like freeze/unfreeze doesn't take into account that two or
more mounted file systems can share the same journal. I don't know how
often, if ever, this is done in practice, but it looks like it would be
a problem. Two "nointegrity" mounts may have problem too. That should be
easy enough to verify.

Thanks,
Shaggy

> 
> Thanks,
> Gu
> 
> 
> On 05/24/2013 04:57 PM, Vahram Martirosyan wrote:
> 
>> In function jfs_freeze() the log is shut down through lmLogShutdown() call.
>> When the "nointegrity" mount option is enabled, the log is actually not
>> initialized. As a result the freeze operation in that case brings to a
>> kernel OOPS.
>>
>> The solution is to check if the "nointegrity" option is enabled and if it is not
>> then shut the log down. 
>>
>> May be this is not the best solution, but at least it fixes the OOPS.
>>
>> Found by Linux File System Verification project (linuxtesting.org)
>>
>> Signed-off-by: Vahram Martirosyan <vahram.martirosyan@linuxtesting.org>
>> ---
>>  fs/jfs/super.c | 10 ++++++----
>>  1 file changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/jfs/super.c b/fs/jfs/super.c
>> index a3d424d..9788970 100644
>> --- a/fs/jfs/super.c
>> +++ b/fs/jfs/super.c
>> @@ -615,10 +615,12 @@ static int jfs_freeze(struct super_block *sb)
>>  
>>  	if (!(sb->s_flags & MS_RDONLY)) {
>>  		txQuiesce(sb);
>> -		rc = lmLogShutdown(log);
>> -		if (rc != 0) {
>> -			jfs_err("lmLogShutdown failed with return code %d", rc);
>> -			return rc;
>> +		if (!log->no_integrity) {
>> +			rc = lmLogShutdown(log);
>> +			if (rc != 0) {
>> +				jfs_err("lmLogShutdown failed with return code %d", rc);
>> +				return rc;
>> +			}
>>  		}
>>  		rc = updateSuper(sb, FM_CLEAN);
>>  		if (rc != 0) {
> 
> 
