Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab3IPA0w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 20:26:52 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62231 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab3IPA0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 20:26:51 -0400
Message-ID: <52365021.8040906@windriver.com>
Date: Mon, 16 Sep 2013 08:26:09 +0800
From: Fan Du <fan.du@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: David Miller <davem@davemloft.net>, <herbert@gondor.hengli.com.au>,
        <steffen.klassert@secunet.com>, <dborkman@redhat.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCHv3 linux-next] hrtimer: Add notifier when clock_was_set
 was called
References: <alpine.DEB.2.02.1309121441420.4089@ionos.tec.linutronix.de> <20130912134409.GB21212@gondor.apana.org.au> <alpine.DEB.2.02.1309121636010.4089@ionos.tec.linutronix.de> <20130912.133252.425268707009916773.davem@davemloft.net> <52327C92.5010009@windriver.com> <alpine.DEB.2.02.1309131628250.4089@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1309131628250.4089@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [128.224.162.195]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Thomas

On 2013年09月13日 22:32, Thomas Gleixner wrote:
> On Fri, 13 Sep 2013, Fan Du wrote:
>> (2) What I have been bugging you around here for this long time is really the
>> second
>>      problem, I'm sorry I didn't make it clearly to you and others, which is
>> below:
>>
>>      Why using wall clock time to calculate soft/hard IPsec events when
>> xfrm_state timer
>>      out happens in its timeout handler? Because even if xfrm_state using
>> CLOCK_BOOTTIME,
>>      system wall clock time changing will surely disturb soft/hard IPsec
>> events, which
>>      you raised your concern about in (*a*).
>
> No CLOCK_BOOTTIME is not affected by wall clock time changes. It's
> basically CLOCK_MONOTONIC, it just keeps counting the suspend time as
> well. So without a suspend/resume cycle CLOCK_MONOTONIC and
> CLOCK_BOOTTIME are the same. After a suspend/resume cycle
> CLOCK_BOOTTIME will be N seconds ahead of CLOCK_MONOTONIC, where N is
> the number of seconds spent in suspend.

Sorry for the ambiguity. Yes, CLOCK_BOOTTIME is monotonic *and* counting
suspend/resume time as well as not affected by wall clock time change.

Using CLOCK_BOOTTIME guarantees b- will timeout in a right manner, i.e., not
affected by wall clock time change, as well as keep the timer valid when
suspend/resume.

A classic way of using timer is:
  a- Arm a timer with specified interval
  b- Wait for the timer to timeout
  c- After the timeout, notify the event to other place in the timer handler.

IPsec key lifetime timer does its this way:
  a- Arm a timer with specified interval
  b- Wait for the timer to timeout
  c- After timeout, in the timer handler, using wall clock time to calculate
    which kind of event to notify user(soft or hard for both key use time,
    and key created time). So the problem arises at this stage if wall clock
    time changed.



Thanks

> Thanks,
>
> 	tglx
>

-- 
浮沉随浪只记今朝笑

--fan
