Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbaBLBmw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 20:42:52 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:47626 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaBLBmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 20:42:51 -0500
Message-ID: <52FAD18C.8080208@huawei.com>
Date: Wed, 12 Feb 2014 09:42:36 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, <dwmw2@infradead.org>,
        <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH 2/3] jffs2: avoid soft-lockup in jffs2_reserve_space_gc()
References: <52F592F2.6010008@huawei.com> <52F5934B.4000101@huawei.com> <20140211155440.62c5e90eb498ec2964258969@linux-foundation.org>
In-Reply-To: <20140211155440.62c5e90eb498ec2964258969@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> --- a/fs/jffs2/nodemgmt.c
>> +++ b/fs/jffs2/nodemgmt.c
>> @@ -216,15 +216,20 @@ int jffs2_reserve_space_gc(struct jffs2_sb_info *c, uint32_t minsize,
>>  
>>  	jffs2_dbg(1, "%s(): Requested 0x%x bytes\n", __func__, minsize);
>>  
>> -	spin_lock(&c->erase_completion_lock);
>> -	while(ret == -EAGAIN) {
>> +	while (true) {
>> +		spin_lock(&c->erase_completion_lock);
>>  		ret = jffs2_do_reserve_space(c, minsize, len, sumsize);
>>  		if (ret) {
>>  			jffs2_dbg(1, "%s(): looping, ret is %d\n",
>>  				  __func__, ret);
>>  		}
>> +		spin_unlock(&c->erase_completion_lock);
>> +
>> +		if (ret == -EAGAIN)
>> +			cond_resched();
>> +		else
>> +			break;
>>  	}
>> -	spin_unlock(&c->erase_completion_lock);
>>  	if (!ret)
>>  		ret = jffs2_prealloc_raw_node_refs(c, c->nextblock, 1);
> 
> Looks OK.  We can do this:
> 

Yeah, thanks for the cleanup.

> --- a/fs/jffs2/nodemgmt.c~jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc-fix
> +++ a/fs/jffs2/nodemgmt.c
> @@ -211,7 +211,7 @@ out:
>  int jffs2_reserve_space_gc(struct jffs2_sb_info *c, uint32_t minsize,
>  			   uint32_t *len, uint32_t sumsize)
>  {
> -	int ret = -EAGAIN;
> +	int ret;
>  	minsize = PAD(minsize);
>  
>  	jffs2_dbg(1, "%s(): Requested 0x%x bytes\n", __func__, minsize);
> _

