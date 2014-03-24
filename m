Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434AbaCXIWp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 04:22:45 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37294 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaCXIWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 04:22:42 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <532FEB03.20600@jp.fujitsu.com>
Date: Mon, 24 Mar 2014 17:21:23 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Preeti Murthy <preeti.lkml@gmail.com>
CC: linux-kernel@vger.kernel.org,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>, preeti@linux.vnet.ibm.com
Subject: Re: [PATCH 1/2] nohz: use seqlock to avoid race on idle time stats
References: <532FA0E8.4050106@jp.fujitsu.com>	<532FA20E.7090709@jp.fujitsu.com> <CAM4v1pPPmiHXNQ19My1Jd8XUQQh+VnbvWwGXq0mVGk4G1vYNfw@mail.gmail.com>
In-Reply-To: <CAM4v1pPPmiHXNQ19My1Jd8XUQQh+VnbvWwGXq0mVGk4G1vYNfw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/03/24 16:45), Preeti Murthy wrote:
> Hi Hidetoshi,
> 
> The patch looks good to me except the comments around the monotonicity
> of the return value of the idle stats observer. I am unable to relate them
> to the dependency on nr_iowait_cpu.
> 
> I see that when the reader queries for the idle stats and calls
> get_cpu_idle_time_us(), the nr_iowait_cpu might be 0. When he later
> queries get_cpu_iowait_time_us(), it may be >0 . Hence we will be
> accounting for the idle time in both idle time and iowait time. This
> is definitely a problem. But I do not understand what this has got to
> do with the monotonicity of the time
> returned. This is just for my understanding.

Thank you for your comment!

Ah yes, I think I could write better comments around here to clarify
the monotonicity problem. (It will be happy if someone can give me
such better sentence for here :-D)

One important point is that readers do not update idle stats when they
use these function. i.e.

given:
   idle stats:  idle=1000, iowait=100
   stamp at idle entry: entry=50
   nr tasks waiting io: nr_iowait=1

1st reader:
   query @ now=60
     idle=1000
     iowait=110 (=100+(60-50))

(here nr_iowait changed to 0)

2nd reader:
   query @ now=70
     idle=1020 (=1000+(70-50))
     iowait=100

So you will see iowait is decreased from 110 to 100.

I hope this short story helps you.

Thanks,
H.Seto

