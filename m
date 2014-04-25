Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbaDYPNI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:13:08 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:45541 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752268AbaDYPNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:13:04 -0400
X-Greylist: delayed 643 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Apr 2014 11:13:04 EDT
From: Roman Gushchin <klamm@yandex-team.ru>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
        "tkhai@yandex.ru" <tkhai@yandex.ru>
In-Reply-To: <20140425131620.GB11096@twins.programming.kicks-ass.net>
References: <36851398363372@webcorp2g.yandex-team.ru>
	 <20140424185858.GB26782@laptop.programming.kicks-ass.net>
	 <17051398423889@webcorp2e.yandex-team.ru> <20140425131620.GB11096@twins.programming.kicks-ass.net>
Subject: Re: Real-time scheduling policies and hyper-threading
MIME-Version: 1.0
Message-Id: <34791398438136@webcorp2g.yandex-team.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Fri, 25 Apr 2014 19:02:16 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

25.04.2014, 17:16, "Peter Zijlstra" <peterz@infradead.org>:
> On Fri, Apr 25, 2014 at 03:04:49PM +0400, Roman Gushchin wrote:
>
>> š24.04.2014, 22:59, "Peter Zijlstra" <peterz@infradead.org>:
>>> šOn Thu, Apr 24, 2014 at 10:16:12PM +0400, Roman Gushchin wrote:
>>>> ššAre there any known solutions of this problem except disabling
>>>> ššhyper-threading and frequency scaling at all?
>>> šThis is what we generally tell people to do; disable HT in the BIOS,
>>> šoffline the siblings or similar approaches.
>> šIt's a good, but expensive approach, if you have many machines.
>
> Expensive how? If you require the latency, there's really no option.

Hm. What I really want (and try to implement), is 
"work as if ht is disabled if there are free physical cores, start using ht siblings otherwise".

> That said, if only a small part of your workload is RT then you don't
> need to disable all SMT siblings, you can only disable the few that are
> in your RT partition.

Ok, I understand, that I have something different than what is usual called RT.

I have requests from a user and I want to handle them without any significant delays,
while possible. For instance, if a request takes 100ms, I don't want to get 165ms
just because the sibling ht thread was loaded. In the same time, it's important to have
good resource utilization, what can be less important in real RT tasks.

Of course, there is always a trade-off between latency and performance utilization,
but the common practice here is to keep cpu load between 40% and 70%. So, there is
fast always a free CPU thread, and a good chance that there is a free core.
In this case, both latency and average performance depends on how effectively 
all physical cores are utilized.

Below is the comparison of average response times (in microseconds) under CFS and RT
scheduler with my patches depending on the number of simultaneous requests. 
It's a 32-thread processor with 16 physical cores.

nr_req  CFS  RT*      diff                                                                                                                    
1       9664     9237    +4.41%                                                                                                                  
2       9179     9107    +0.79%                                                                                                                  
3       9179     9310    -1.43%                                                                                                                  
4       9325     9245    +0.86%                                                                                                                  
5       9562     9387    +1.83%                                                                                                                  
6       9523     9478    +0.47%                                                                                                                  
7       10105   9727    +3.74%                                                                                                                  
8       9900     9781    +1.21%                                                                                                                  
9       10077   9871    +2.04%                                                                                                                  
10     10270   9963    +2.99%                                                                                                                  
11     10604   10231   +3.52%                                                                                                                  
12     10760   10299   +4.29%                                                                                                                  
13     11022   10316   +6.40%                                                                                                                  
14     11595   10310   +11.08%                                                                                                                 
15     11489   10200   +11.22%                                                                                                                 
16     12059   10404   +13.72%                                                                                                                 
17     12056   10691   +11.32%                                                                                                                 
18     12208   11027   +9.67%                                                                                                                  
19     12412   11337   +8.66%                                                                                                                  
20     12634   11663   +7.69%                                                                                                                  
21     12843   12165   +5.28%                                                                                                                  
22     13181   12273   +6.89%                                                                                                                  
23     13214   12560   +4.95%                                                                                                                  
24     13465   12822   +4.78%                                                                                                                  
25     13469   13106   +2.70%                                                                                                                  
26     13725   13329   +2.88%                                                                                                                  
27     13943   13581   +2.60%                                                                                                                  
28     14007   13845   +1.16%                                                                                                                  
29     14242   14040   +1.41%                                                                                                                  
30     14386   14265   +0.84%                                                                                                                  
31     14909   14478   +2.90%                                                                                                                  
32     14772   14769   +0.02%     

Probably, it's possible to tune CFS for this case, but I have no idea how.

In my opinion, such load pattern is not very rare. For instance, front-end 
web-servers can have similar load.

Thanks,
Roman
