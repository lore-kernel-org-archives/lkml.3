Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbbATHMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 02:12:22 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:50417 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbbATHMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 02:12:20 -0500
Message-ID: <54BDFFCD.4010500@hitachi.com>
Date: Tue, 20 Jan 2015 16:12:13 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Wang Nan <wangnan0@huawei.com>, Ingo Molnar <mingo@elte.hu>
Cc: tixy@linaro.org, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Re: [PATCH] kprobes: bugfix: set kprobes_all_disarmed earlier
 to enable re-optimization.
References: <1420461075-27012-1-git-send-email-wangnan0@huawei.com> <54B3AED2.5070000@hitachi.com> <54BDC55D.3090200@huawei.com>
In-Reply-To: <54BDC55D.3090200@huawei.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2015/01/20 12:02), Wang Nan wrote:
> On 2015/1/12 19:24, Masami Hiramatsu wrote:
>> (2015/01/05 21:31), Wang Nan wrote:
>>> In original code, the probed instruction doesn't get optimized after
>>>
>>> echo 0 > /sys/kernel/debug/kprobes/enabled
>>> echo 1 > /sys/kernel/debug/kprobes/enabled
>>>
>>> This is because original code checks kprobes_all_disarmed in
>>> optimize_kprobe(), but this flag is turned off after calling that
>>> function. Therefore, optimize_kprobe() will see
>>> kprobes_all_disarmed == true and doesn't do the optimization.
>>
>> OK, a workaround is to disable/enable optimizing via sysctl.
>>
>>>
>>> This patch simply turns off kprobes_all_disarmed earlier to enable
>>> optimization.
>>>
>>
>> Anyway, thank you for finding that! :)
>>
>> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>>
> 
> Hi Masami Hiramatsu,
> 
> What about this patch? Are you still thinking on it like
> '[PATCH] kprobes: bugfix: checks kprobes_all_disarmed in unoptimized_kprobe()' ?

Without this patch.
-----
[root@localhost tracing]# echo p do_fork+5 > kprobe_events
[root@localhost tracing]# echo 1 > events/kprobes/p_do_fork_5/enable
[root@localhost tracing]# cat ../kprobes/list
ffffffff810bd055  k  do_fork+0x5    [OPTIMIZED]
[root@localhost tracing]# echo 0 > /sys/kernel/debug/kprobes/enabled
[root@localhost tracing]# cat ../kprobes/list
ffffffff810bd055  k  do_fork+0x5
[root@localhost tracing]# echo 1 > /sys/kernel/debug/kprobes/enabled
[root@localhost tracing]# cat ../kprobes/list
ffffffff810bd055  k  do_fork+0x5
------
With this patch.
------
[root@localhost tracing]# echo p do_fork+5 > kprobe_events
[root@localhost tracing]# echo 1 > events/kprobes/enable
[root@localhost tracing]# cat ../kprobes/list
ffffffff810bc1c5  k  do_fork+0x5    [OPTIMIZED]
[root@localhost tracing]# echo 0 > ../kprobes/enabled
[root@localhost tracing]# cat ../kprobes/list
ffffffff810bc1c5  k  do_fork+0x5
[root@localhost tracing]# echo 1 > ../kprobes/enabled
[root@localhost tracing]# cat ../kprobes/list
ffffffff810bc1c5  k  do_fork+0x5    [OPTIMIZED]
------

So, looks OK to me too ;)

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Tested-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Ingo,
Could you also pull this patch to your -tip tree?

Thank you,

> 
> Thank you.
> 
>>
>>> Signed-off-by: Wang Nan <wangnan0@huawei.com>
>>> ---
>>>  kernel/kprobes.c | 7 ++++++-
>>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
>>> index bad4e95..b185464 100644
>>> --- a/kernel/kprobes.c
>>> +++ b/kernel/kprobes.c
>>> @@ -2320,6 +2320,12 @@ static void arm_all_kprobes(void)
>>>  	if (!kprobes_all_disarmed)
>>>  		goto already_enabled;
>>>  
>>> +	/*
>>> +	 * optimize_kprobe() called by arm_kprobe() checks
>>> +	 * kprobes_all_disarmed, so set kprobes_all_disarmed before
>>> +	 * arm_kprobe.
>>> +	 */
>>> +	kprobes_all_disarmed = false;
>>>  	/* Arming kprobes doesn't optimize kprobe itself */
>>>  	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
>>>  		head = &kprobe_table[i];
>>> @@ -2328,7 +2334,6 @@ static void arm_all_kprobes(void)
>>>  				arm_kprobe(p);
>>>  	}
>>>  
>>> -	kprobes_all_disarmed = false;
>>>  	printk(KERN_INFO "Kprobes globally enabled\n");
>>>  
>>>  already_enabled:
>>>
>>
>>
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


