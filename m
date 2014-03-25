Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680AbaCYFbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 01:31:34 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:42026 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaCYFbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 01:31:33 -0400
Message-ID: <533113C4.2000007@linux.vnet.ibm.com>
Date: Tue, 25 Mar 2014 10:57:32 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: Preeti Murthy <preeti.lkml@gmail.com>, linux-kernel@vger.kernel.org,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/2] nohz: use seqlock to avoid race on idle time stats
References: <532FA0E8.4050106@jp.fujitsu.com> <532FA20E.7090709@jp.fujitsu.com> <CAM4v1pPPmiHXNQ19My1Jd8XUQQh+VnbvWwGXq0mVGk4G1vYNfw@mail.gmail.com> <532FEB03.20600@jp.fujitsu.com>
In-Reply-To: <532FEB03.20600@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032505-9574-0000-0000-00000C9A1411
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2014 01:51 PM, Hidetoshi Seto wrote:
> (2014/03/24 16:45), Preeti Murthy wrote:
>> Hi Hidetoshi,
>>
>> The patch looks good to me except the comments around the monotonicity
>> of the return value of the idle stats observer. I am unable to relate them
>> to the dependency on nr_iowait_cpu.
>>
>> I see that when the reader queries for the idle stats and calls
>> get_cpu_idle_time_us(), the nr_iowait_cpu might be 0. When he later
>> queries get_cpu_iowait_time_us(), it may be >0 . Hence we will be
>> accounting for the idle time in both idle time and iowait time. This
>> is definitely a problem. But I do not understand what this has got to
>> do with the monotonicity of the time
>> returned. This is just for my understanding.
> 
> Thank you for your comment!
> 
> Ah yes, I think I could write better comments around here to clarify
> the monotonicity problem. (It will be happy if someone can give me
> such better sentence for here :-D)
> 
> One important point is that readers do not update idle stats when they
> use these function. i.e.
> 
> given:
>    idle stats:  idle=1000, iowait=100
>    stamp at idle entry: entry=50
>    nr tasks waiting io: nr_iowait=1
> 
> 1st reader:
>    query @ now=60
>      idle=1000
>      iowait=110 (=100+(60-50))
> 
> (here nr_iowait changed to 0)
> 
> 2nd reader:
>    query @ now=70
>      idle=1020 (=1000+(70-50))
>      iowait=100
> 
> So you will see iowait is decreased from 110 to 100.

Ah ok! I get it. Please do add my Reviewed-by to it.

> 
> I hope this short story helps you.

Thanks!

Regards
Preeti U Murthy
> 
> Thanks,
> H.Seto
> 

