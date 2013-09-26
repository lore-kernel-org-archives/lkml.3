Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab3IZTqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 15:46:30 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:64718 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab3IZTq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 15:46:26 -0400
Message-ID: <52448F0F.9050408@linaro.org>
Date: Thu, 26 Sep 2013 12:46:23 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/4] [RFC] ipv6: Fix for possible ipv6 seqlock deadlock
References: <1380220464-28840-1-git-send-email-john.stultz@linaro.org>	 <1380220464-28840-5-git-send-email-john.stultz@linaro.org> <1380223848.3165.207.camel@edumazet-glaptop>
In-Reply-To: <1380223848.3165.207.camel@edumazet-glaptop>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 12:30 PM, Eric Dumazet wrote:
> On Thu, 2013-09-26 at 11:34 -0700, John Stultz wrote:
>> While enabling lockdep on seqlocks, I ran accross the warning below
>> caused by the ipv6 stats being updated in both irq and non-irq context.
>>
>> This is a novice attempt to correct the issue, and with this patch
>> the warning goes away. Any better solutions would be appreciated!
> ...
>
>>  
>>  out_err_release:
>> -	if (err == -ENETUNREACH)
>> +	if (err == -ENETUNREACH) {
>> +		unsigned long flags;
>> +		/* some of the stats are locked in irq context */
>> +		local_irq_save(flags);
>>  		IP6_INC_STATS_BH(net, NULL, IPSTATS_MIB_OUTNOROUTES);
>> +		local_irq_restore(flags);
>> +	}
>>  	dst_release(*dst);
>>  	*dst = NULL;
>>  	return err;
> You better change IP6_INC_STATS_BH() to IP6_INC_STATS()
>
> On x86 for example, no extra code will be generated (no need to disable
> hard or soft irqs)

Ah, thanks! Verified it resolves the warning as well, so I've changed my
patch to use your suggestion.

thanks again
-john
