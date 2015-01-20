Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbbATDDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 22:03:13 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:3898 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbbATDDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 22:03:12 -0500
Message-ID: <54BDC55D.3090200@huawei.com>
Date: Tue, 20 Jan 2015 11:02:53 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: <tixy@linaro.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] kprobes: bugfix: set kprobes_all_disarmed earlier to
 enable re-optimization.
References: <1420461075-27012-1-git-send-email-wangnan0@huawei.com> <54B3AED2.5070000@hitachi.com>
In-Reply-To: <54B3AED2.5070000@hitachi.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.129]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/12 19:24, Masami Hiramatsu wrote:
> (2015/01/05 21:31), Wang Nan wrote:
>> In original code, the probed instruction doesn't get optimized after
>>
>> echo 0 > /sys/kernel/debug/kprobes/enabled
>> echo 1 > /sys/kernel/debug/kprobes/enabled
>>
>> This is because original code checks kprobes_all_disarmed in
>> optimize_kprobe(), but this flag is turned off after calling that
>> function. Therefore, optimize_kprobe() will see
>> kprobes_all_disarmed == true and doesn't do the optimization.
> 
> OK, a workaround is to disable/enable optimizing via sysctl.
> 
>>
>> This patch simply turns off kprobes_all_disarmed earlier to enable
>> optimization.
>>
> 
> Anyway, thank you for finding that! :)
> 
> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 

Hi Masami Hiramatsu,

What about this patch? Are you still thinking on it like
'[PATCH] kprobes: bugfix: checks kprobes_all_disarmed in unoptimized_kprobe()' ?

Thank you.

> 
>> Signed-off-by: Wang Nan <wangnan0@huawei.com>
>> ---
>>  kernel/kprobes.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
>> index bad4e95..b185464 100644
>> --- a/kernel/kprobes.c
>> +++ b/kernel/kprobes.c
>> @@ -2320,6 +2320,12 @@ static void arm_all_kprobes(void)
>>  	if (!kprobes_all_disarmed)
>>  		goto already_enabled;
>>  
>> +	/*
>> +	 * optimize_kprobe() called by arm_kprobe() checks
>> +	 * kprobes_all_disarmed, so set kprobes_all_disarmed before
>> +	 * arm_kprobe.
>> +	 */
>> +	kprobes_all_disarmed = false;
>>  	/* Arming kprobes doesn't optimize kprobe itself */
>>  	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
>>  		head = &kprobe_table[i];
>> @@ -2328,7 +2334,6 @@ static void arm_all_kprobes(void)
>>  				arm_kprobe(p);
>>  	}
>>  
>> -	kprobes_all_disarmed = false;
>>  	printk(KERN_INFO "Kprobes globally enabled\n");
>>  
>>  already_enabled:
>>
> 
> 


