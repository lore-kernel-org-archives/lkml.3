Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbaBQOPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 09:15:21 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:58378 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaBQOPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 09:15:18 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-54-530219735fe8
Message-id: <53021972.4050400@samsung.com>
Date: Mon, 17 Feb 2014 18:15:14 +0400
From: Alexey Perevalov <a.perevalov@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        anton@enomsg.org, kyungmin.park@samsung.com, akpm@linux-foundation.org,
        cw00.choi@samsung.com
Subject: Re: [PATCH v2 0/3] Deferrable timers support for timerfd API
References: <1389609835-24377-1-git-send-email-a.perevalov@samsung.com>
 <52DEC6A3.9020600@linaro.org> <52E606D8.6000401@samsung.com>
 <alpine.DEB.2.02.1402041419420.24986@ionos.tec.linutronix.de>
 <52F1DDA8.90605@samsung.com>
 <alpine.DEB.2.02.1402051229260.24986@ionos.tec.linutronix.de>
 <52F2B504.5010403@linaro.org>
 <alpine.DEB.2.02.1402052306580.24986@ionos.tec.linutronix.de>
 <52F3C8A5.708@samsung.com>
 <alpine.DEB.2.02.1402062148440.21991@ionos.tec.linutronix.de>
 <5300D752.5030403@samsung.com>
 <alpine.DEB.2.02.1402161634590.21991@ionos.tec.linutronix.de>
In-reply-to: <alpine.DEB.2.02.1402161634590.21991@ionos.tec.linutronix.de>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t/xq7rFkkzBBl/ni1rMWb+GzeLgVk2L
	61+es1qc+a1rcbbpDbvF5V1z2Cw2b5rK7MDuMaH/E6PHnWt72DzenTvH7nFixm8Wj74tqxg9
	Pm+SC2CL4rJJSc3JLEst0rdL4MrYfnUqe8Hk1IpvzXcYGxjnB3QxcnJICJhIfF16kRnCFpO4
	cG89WxcjF4eQwFJGiV8/vzFBOJ8ZJdavWghWxSugJbFjWhc7iM0ioCrxt+k1axcjBwebgIHE
	vnu2IKaoQITE0eWaENWCEj8m32MBsUUENCQ2XrrFDDKSWWAlo8Tcb3/AxggLuEqc2L6eFWLX
	YRaJDdOfgnVwCnhJfHx2kQ3EZhawllg5aRsjhC0vsXnNW+YJjAKzkCyZhaRsFpKyBYzMqxhF
	U0uTC4qT0nMN9YoTc4tL89L1kvNzNzFCgv3LDsbFx6wOMQpwMCrx8BpUMwYLsSaWFVfmHmKU
	4GBWEuH1F2QKFuJNSaysSi3Kjy8qzUktPsTIxMEp1QAM7Lk1xuKPbweWXN30z/apey27kMb2
	Bfdd3yyV0g+1Fvt91PvYr99KH3OXc1QaJqkWb1rzg60qMG7riqNSMfdr2uq2R2693/36+1HF
	r8XnZi5bdXbaJp2p4WctMw8XdEgdz1eRW2614+tfqeXb74nWGGnop+9MDVfacP355SnMJ2cu
	+fOifYWcEktxRqKhFnNRcSIABa8OIlQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2014 07:39 PM, Thomas Gleixner wrote:
> On Sun, 16 Feb 2014, Alexey Perevalov wrote:
>> As I understand main idea in hrtimer.c was do not decrement expires_next in
>> case of DEFERRABLE timers type.
>> Such small average delay could be explained: it's due higher resolution, and
>> cpu is not in idle when we in hrtimer_interrupt,
>> with timer_list decrementing process not so often.
>> In this case it's hard to me to explain such small "time delta", it occurs
>> almost every time we have larger delay.
> Well, the point of deferrable timers is that they get executed, when
> the cpu is not idle, i.e. running some other timers as well
>
> I did not test my patch and I have no idea whether it really does what
> it should do, but tracing should tell you rather fast.
>
> So w/o instrumenting the kernel you can't tell why a timer is
> expired. Just looking at random numbers does not help. You need to
> create a proper test scenario which makes sure that the system goes
> into an extended nohz idle and then check whether the timers are
> deferred over that idle time.
>
> Thanks,
>
> 	tglx
>
>
My system is NO_HZ=ON, I'm sure and timer_list results is proof it.
Regarding to previous result, yes, you right the rootcause of such 
insane deviation was a glitch in logging (but only for really big 
deviation).

I traced it by ftrace.
Bellow is trace-cmd report for HRTIMER_BASE_MONOTONIC_DEFERRABLE.
(it's only part, but it's long part, summary right after the log)

           <idle>-0     [000]   339.148371: hrtimer_expire_entry: 
hrtimer=0xffffffffa04a9280 now=2154000086890 function=timerfd_tmrproc/0x0
           <idle>-0     [000]   339.148391: hrtimer_start:        
hrtimer=0xffffffffa04a9280 function=timerfd_tmrproc 
expires=2154300000000 softexpires=2154300000000
           <idle>-0     [000]   339.157821: hrtimer_expire_entry: 
hrtimer=0xffffffffa04a9280 now=2154328094166 function=timerfd_tmrproc/0x0
           <idle>-0     [000]   339.157837: hrtimer_start:        
hrtimer=0xffffffffa04a9280 function=timerfd_tmrproc 
expires=2154600000000 softexpires=2154600000000
           <idle>-0     [000]   339.170895: hrtimer_expire_entry: 
hrtimer=0xffffffffa04a9280 now=2154632081099 function=timerfd_tmrproc/0x0
           <idle>-0     [000]   339.170915: hrtimer_start:        
hrtimer=0xffffffffa04a9280 function=timerfd_tmrproc 
expires=2154900000000 softexpires=2154900000000
           <idle>-0     [000]   339.180459: hrtimer_expire_entry: 
hrtimer=0xffffffffa04a9280 now=2154912090729 function=timerfd_tmrproc/0x0
           <idle>-0     [000]   339.180475: hrtimer_start:        
hrtimer=0xffffffffa04a9280 function=timerfd_tmrproc 
expires=2155200000000 softexpires=2155200000000
           <idle>-0     [000]   339.204672: hrtimer_expire_entry: 
hrtimer=0xffffffffa04a9280 now=2155228092094 function=timerfd_tmrproc/0x0
           <idle>-0     [000]   339.204694: hrtimer_start:        
hrtimer=0xffffffffa04a9280 function=timerfd_tmrproc 
expires=2155500000000 softexpires=2155500000000
           <idle>-0     [000]   339.213807: hrtimer_expire_entry: 
hrtimer=0xffffffffa04a9280 now=2155532081987 function=timerfd_tmrproc/0x0
           <idle>-0     [000]   339.213823: hrtimer_start:        
hrtimer=0xffffffffa04a9280 function=timerfd_tmrproc 
expires=2155800000000 softexpires=2155800000000
           <idle>-0     [000]   339.226986: hrtimer_expire_entry: 
hrtimer=0xffffffffa04a9280 now=2155816087467 function=timerfd_tmrproc/0x0
           <idle>-0     [000]   339.227007: hrtimer_start:        
hrtimer=0xffffffffa04a9280 function=timerfd_tmrproc 
expires=2156100000000 softexpires=2156100000000
           <idle>-0     [000]   339.272420: hrtimer_expire_entry: 
hrtimer=0xffffffffa04a9280 now=2156101736770 function=timerfd_tmrproc/0x0
           <idle>-0     [000]   339.272438: hrtimer_start:        
hrtimer=0xffffffffa04a9280 function=timerfd_tmrproc 
expires=2156400000000 softexpires=2156400000000
           <idle>-0     [000]   339.286856: hrtimer_expire_entry: 
hrtimer=0xffffffffa04a9280 now=2156432078659 function=timerfd_tmrproc/0x0
           <idle>-0     [000]   339.286877: hrtimer_start:        
hrtimer=0xffffffffa04a9280 function=timerfd_tmrproc 
expires=2156700000000 softexpires=2156700000000
           <idle>-0     [000]   339.363097: hrtimer_expire_entry: 
hrtimer=0xffffffffa04a9280 now=2156728086117 function=timerfd_tmrproc/0x0
           <idle>-0     [000]   339.363122: hrtimer_start:        
hrtimer=0xffffffffa04a9280 function=timerfd_tmrproc 
expires=2157000000000 softexpires=2157000000000
           <idle>-0     [000]   339.411552: hrtimer_expire_entry: 
hrtimer=0xffffffffa04a9280 now=2157000091028 function=timerfd_tmrproc/0x0
           <idle>-0     [000]   339.411576: hrtimer_start:        
hrtimer=0xffffffffa04a9280 function=timerfd_tmrproc 
expires=2157300000000 softexpires=2157300000000
           <idle>-0     [000]   339.492448: hrtimer_expire_entry: 
hrtimer=0xffffffffa04a9280 now=2157328089996 function=timerfd_tmrproc/0x0
           <idle>-0     [000]   339.492471: hrtimer_start:        
hrtimer=0xffffffffa04a9280 function=timerfd_tmrproc 
expires=2157600000000 softexpires=2157600000000
           <idle>-0     [000]   339.526305: hrtimer_expire_entry: 
hrtimer=0xffffffffa04a9280 now=2157600425537 function=timerfd_tmrproc/0x0
           <idle>-0     [000]   339.526341: hrtimer_start:        
hrtimer=0xffffffffa04a9280 function=timerfd_tmrproc 
expires=2157900000000 softexpires=2157900000000
           <idle>-0     [000]   339.572977: hrtimer_expire_entry: 
hrtimer=0xffffffffa04a9280 now=2157928085502 function=timerfd_tmrproc/0x0
           <idle>-0     [000]   339.572997: hrtimer_start:        
hrtimer=0xffffffffa04a9280 function=timerfd_tmrproc 
expires=2158200000000 softexpires=2158200000000
             Xorg-1166  [000]   339.658862: hrtimer_expire_entry: 
hrtimer=0xffffffffa04a9280 now=2158200013165 function=timerfd_tmrproc/0x0
             Xorg-1166  [000]   339.658893: hrtimer_start: 
hrtimer=0xffffffffa04a9280 function=timerfd_tmrproc 
expires=2158500000000 softexpires=2158500000000
           <idle>-0     [000]   339.694244: hrtimer_expire_entry: 
hrtimer=0xffffffffa04a9280 now=2158532090801 function=timerfd_tmrproc/0x0
           <idle>-0     [000]   339.694263: hrtimer_start:        
hrtimer=0xffffffffa04a9280 function=timerfd_tmrproc 
expires=2158800000000 softexpires=2158800000000
           <idle>-0     [000]   339.769293: hrtimer_expire_entry: 
hrtimer=0xffffffffa04a9280 now=2158816038362 function=timerfd_tmrproc/0x0
           <idle>-0     [000]   339.769316: hrtimer_start:        
hrtimer=0xffffffffa04a9280 function=timerfd_tmrproc 
expires=2159100000000 softexpires=2159100000000
           <idle>-0     [000]   339.808105: hrtimer_expire_entry: 
hrtimer=0xffffffffa04a9280 now=2159122612405 function=timerfd_tmrproc/0x0
           <idle>-0     [000]   339.808127: hrtimer_start:        
hrtimer=0xffffffffa04a9280 function=timerfd_tmrproc 
expires=2159400000000 softexpires=2159400000000

Here is the summary:

now value    |  difference with previous value
2159122612405|
2158816038362|    306574043
2158532090801|    283947561
2158200013165|    332077636
2157928085502|    271927663
2157600425537|    327659965
2157328089996|    272335541
2157000091028|    327998968
2156728086117|    272004911
2156432078659|    296007458
2156101736770|    330341889
2155816087467|    285649303
2155532081987|    284005480
2155228092094|    303989893
2154912090729|    316001365
2154632081099|    280009630
2154328094166|    303986933
2154000086890|    328007276

Timer was charged with 300ms interval. And we see difference in neighborhood
  of point 300 000 000 - 300ms. The average value as we can see: 
301325030.294118
  - the average delay is 1 ms.

Here is the summary for timer_list, timer is charged with 200 ms interval:

now value | difference with previous value
4295653665|
4295653615|    200000000
4295653563|    208000000
4295653500|    252000000
4295653438|    248000000
4295653365|    292000000
4295653313|    208000000
4295653248|    260000000
4295653198|    200000000
4295653140|    232000000
4295653090|    200000000
4295653038|    208000000
4295652988|    200000000

Average interval is 225 666 666.666667, 25ms delay, it's better.
And for 300ms timer_list shows following result:

4298170712|    300000000
4298170637|    300000000
4298170562|    300000000
4298170483|    316000000
4298170387|    384000000
4298170287|    400000000
4298170212|    300000000
4298170129|    332000000
4298170053|    304000000
4298169978|    300000000
4298169903|    300000000
4298169828|    300000000

Average delay here is 20ms.
------------------------------------------------------------------------
It's log for 300ms timer_list, you could skip it
------------------------------------------------------------------------
<idle>-0     [000]  1914.815152: timer_expire_entry: 
timer=0xffffffffa05c2280 function=test_def_timer_fn now=4298169828
           <idle>-0     [000]  1914.815183: timer_start:          
timer=0xffffffffa05c2280 function=test_def_timer_fn expires=4298169903 
[timeout=75]
           <idle>-0     [000]  1914.862357: timer_expire_entry:   
timer=0xffffffffa05c2280 function=test_def_timer_fn now=4298169903
           <idle>-0     [000]  1914.862378: timer_start:          
timer=0xffffffffa05c2280 function=test_def_timer_fn expires=4298169978 
[timeout=75]
          firefox-2898  [000]  1914.901656: timer_expire_entry: 
timer=0xffffffffa05c2280 function=test_def_timer_fn now=4298169978
          firefox-2898  [000]  1914.901680: timer_start: 
timer=0xffffffffa05c2280 function=test_def_timer_fn expires=4298170053 
[timeout=75]
           <idle>-0     [000]  1914.946591: timer_expire_entry:   
timer=0xffffffffa05c2280 function=test_def_timer_fn now=4298170053
           <idle>-0     [000]  1914.946625: timer_start:          
timer=0xffffffffa05c2280 function=test_def_timer_fn expires=4298170128 
[timeout=75]
           <idle>-0     [000]  1914.994114: timer_expire_entry:   
timer=0xffffffffa05c2280 function=test_def_timer_fn now=4298170129
           <idle>-0     [000]  1914.994137: timer_start:          
timer=0xffffffffa05c2280 function=test_def_timer_fn expires=4298170204 
[timeout=75]
           <idle>-0     [000]  1915.035696: timer_expire_entry:   
timer=0xffffffffa05c2280 function=test_def_timer_fn now=4298170212
           <idle>-0     [000]  1915.035719: timer_start:          
timer=0xffffffffa05c2280 function=test_def_timer_fn expires=4298170287 
[timeout=75]
           <idle>-0     [000]  1915.082886: timer_expire_entry:   
timer=0xffffffffa05c2280 function=test_def_timer_fn now=4298170287
           <idle>-0     [000]  1915.082920: timer_start:          
timer=0xffffffffa05c2280 function=test_def_timer_fn expires=4298170362 
[timeout=75]
           <idle>-0     [000]  1915.141888: timer_expire_entry:   
timer=0xffffffffa05c2280 function=test_def_timer_fn now=4298170387
           <idle>-0     [000]  1915.141923: timer_start:          
timer=0xffffffffa05c2280 function=test_def_timer_fn expires=4298170462 
[timeout=75]
      soffice.bin-3237  [000]  1915.201642: timer_expire_entry: 
timer=0xffffffffa05c2280 function=test_def_timer_fn now=4298170483
      soffice.bin-3237  [000]  1915.201665: timer_start: 
timer=0xffffffffa05c2280 function=test_def_timer_fn expires=4298170558 
[timeout=75]
           <idle>-0     [000]  1915.264248: timer_expire_entry:   
timer=0xffffffffa05c2280 function=test_def_timer_fn now=4298170562
           <idle>-0     [000]  1915.264271: timer_start:          
timer=0xffffffffa05c2280 function=test_def_timer_fn expires=4298170637 
[timeout=75]
           <idle>-0     [000]  1915.309599: timer_expire_entry:   
timer=0xffffffffa05c2280 function=test_def_timer_fn now=4298170637
           <idle>-0     [000]  1915.309628: timer_start:          
timer=0xffffffffa05c2280 function=test_def_timer_fn expires=4298170712 
[timeout=75]
           <idle>-0     [000]  1915.354971: timer_expire_entry:   
timer=0xffffffffa05c2280 function=test_def_timer_fn now=4298170712
           <idle>-0     [000]  1915.354986: timer_start:          
timer=0xffffffffa05c2280 function=test_def_timer_fn expires=4298170787 
[timeout=75]
           <idle>-0     [000]  1915.398761: timer_expire_entry:   
timer=0xffffffffa05c2280 function=test_def_timer_fn now=4298170787
           <idle>-0     [000]  1915.398794: timer_start:          
timer=0xffffffffa05c2280 function=test_def_timer_fn expires=4298170862 
[timeout=75]


Maybe it's due cpuidle implementation or clock_device on my system. It 
was MENU cpuidle governor.


-- 
Best regards,
Alexey Perevalov
