Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab3IZTek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 15:34:40 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:64289 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518Ab3IZTeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 15:34:36 -0400
Message-ID: <52448C46.2050107@linaro.org>
Date: Thu, 26 Sep 2013 12:34:30 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Roger Luethi <rl@hellgate.ch>, Patrick McHardy <kaber@trash.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>,
        Jesse Gross <jesse@nicira.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 1/4] [RFC] net: Explicitly initialize u64_stats_sync structures
 for lockdep
References: <1380220464-28840-1-git-send-email-john.stultz@linaro.org>	 <1380220464-28840-2-git-send-email-john.stultz@linaro.org> <1380223585.3165.205.camel@edumazet-glaptop>
In-Reply-To: <1380223585.3165.205.camel@edumazet-glaptop>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 12:26 PM, Eric Dumazet wrote:
> On Thu, 2013-09-26 at 11:34 -0700, John Stultz wrote:
>> In order to enable lockdep on seqcount/seqlock structures, we
>> must explicitly initialize any locks.
>>
>> diff --git a/include/linux/u64_stats_sync.h b/include/linux/u64_stats_sync.h
>> index 8da8c4e..c450e11 100644
>> --- a/include/linux/u64_stats_sync.h
>> +++ b/include/linux/u64_stats_sync.h
>> @@ -67,6 +67,13 @@ struct u64_stats_sync {
>>  #endif
>>  };
>>  
>> +
>> +#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
>> +#define u64_stats_init(syncp)	seqcount_init(syncp.seq)
>> +#else
>> +#define u64_stats_init(syncp)
>> +#endif
>> +
> I would prefer a function.
>
> static inline void u64_stats_init(struct u64_stats_sync *syncp)
> {
> #if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
> 	seqcount_init(&syncp->seq);
> #endif
> }

No objection, though I worry that will obscure the lockdep key name,
causing all the u64_stat_sync locks to appear the same.

I'll give it a quick shot to see if the compiler inlines it well enough
to preserve the name.

thanks
-john

