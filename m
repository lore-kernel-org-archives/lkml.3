Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbbAVC3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 21:29:24 -0500
Received: from mga11.intel.com ([192.55.52.93]:29806 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706AbbAVC3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 21:29:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,445,1418112000"; 
   d="scan'208";a="654604756"
Message-ID: <54C1B1E8.2080800@intel.com>
Date: Fri, 23 Jan 2015 10:28:56 +0800
From: Pan Xinhui <xinhuix.pan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, oleg@redhat.com, bill.c.roberts@gmail.com,
        yanmin_zhang@linux.intel.com
Subject: Re: [PATCH] mm/util.c: add a none zero check of "len"
References: <54BE0FB3.1030008@intel.com> <alpine.DEB.2.10.1501211506120.2716@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.10.1501211506120.2716@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015年01月22日 07:09, David Rientjes wrote:
> On Tue, 20 Jan 2015, Pan Xinhui wrote:
>
>> Although this check should have been done by caller. But as it's exported to
>> others,
>> It's better to add a none zero check of "len" like other functions.
>>
>> Signed-off-by: xinhuix.pan <xinhuix.pan@intel.com>
>> ---
>>   mm/util.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/mm/util.c b/mm/util.c
>> index fec39d4..3dc2873 100644
>> --- a/mm/util.c
>> +++ b/mm/util.c
>> @@ -72,6 +72,9 @@ void *kmemdup(const void *src, size_t len, gfp_t gfp)
>>   {
>>   	void *p;
>>   +	if (unlikely(!len))
>> +		return ERR_PTR(-EINVAL);
>> +
>>   	p = kmalloc_track_caller(len, gfp);
>>   	if (p)
>>   		memcpy(p, src, len);
>> @@ -91,6 +94,8 @@ void *memdup_user(const void __user *src, size_t len)
>>   {
>>   	void *p;
>>   +	if (unlikely(!len))
>> +		return ERR_PTR(-EINVAL);
>>   	/*
>>   	 * Always use GFP_KERNEL, since copy_from_user() can sleep and
>>   	 * cause pagefault, which makes it pointless to use GFP_NOFS
>
> Nack, there's no need for this since both slab and slub check for
> ZERO_OR_NULL_PTR() and kmalloc_slab() will return ZERO_SIZE_PTR in these
> cases.  kmemdup() would then return NULL, which is appropriate since it
> doesn't return an ERR_PTR() even when memory cannot be allocated.
> memdup_user() would return -ENOMEM for size == 0, which would arguably be
> the wrong return value, but I don't think we need to slow down either of
> these library functions to check for something as stupid as duplicating
> size == 0.
>

Hi, David
	Thanks for your reply :)
	But let me explain it to you as I think it's not stupid to do a duplicate check.
1) if size is zero, kmalloc_track_caller will return ZERO_SIZE_PTR, and the value is 0x10, that makes the next line if (p) meaningless.
panic will hit. Actually we have hit this panic in our tests. So make this "len" check is needed in my opinion.

2) yes, you point out that the called should have done the check before call these two functions. However we can make the codes more simpler.
The caller will be able to skip the check of "len",

before applying this patch, the code may be
if (size == 0){
	//do something else. mostly this is an error.
} else {
	p = kmemdup(src, len, flags);
	if (IS_ERR(p))
	....
}

after applying this patch, the code may be
p = kmemdup(src, len, flags);
if (IS_ERR(p)) {
.....
}
......

we can handle these errors more simpler :) And I have reviewed most functions who will call kmemdup/memdup_user.
some of them do a len == 0 check, but some didn't.

in my opinion, it should always be an error to pass len of 0 to them, so my patch don't broke anything.

3) People always know some lib functions, like strcpy, is not safe to call, so we must do a null check. But here, and now, I think it is our duty to do such check. Not all users(who calls these functions)
know the fact that "these functions behave like strcpy".

Thanks for your reply again, David :)
I appreciate that you will give me some advices and your opinions.

Thanks.
xinhui

