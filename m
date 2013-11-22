Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab3KVMNo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 07:13:44 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:62433 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202Ab3KVMNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 07:13:42 -0500
Message-ID: <528F4A78.1080505@linaro.org>
Date: Fri, 22 Nov 2013 13:13:44 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@linaro.org>, mingo@redhat.com, peterz@infradead.org,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        fweisbec@gmail.com, linux@arm.linux.org.uk, tony.luck@intel.com,
        fenghua.yu@intel.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, pjt@google.com, fengguang.wu@intel.com
CC: james.hogan@imgtec.com, jason.low2@hp.com, gregkh@linuxfoundation.org,
        hanjun.guo@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] sched: remove cpu_load decay.
References: <1385102235-25664-1-git-send-email-alex.shi@linaro.org>
In-Reply-To: <1385102235-25664-1-git-send-email-alex.shi@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2013 07:37 AM, Alex Shi wrote:
> The cpu_load decays on time according past cpu load of rq. New sched_avg decays on tasks' load of time. Now we has 2 kind decay for cpu_load. That is a kind of redundancy. And increase the system load in sched_tick etc.
>
> This patch trying to remove the cpu_load decay. And fixed a nohz_full bug by the way.
>
> There are 5 load_idx used for cpu_load in sched_domain. busy_idx and idle_idx are not zero usually, but newidle_idx, wake_idx and forkexec_idx are all zero on every arch. A shortcut to remove cpu_Load decay in the first patch. just one line patch for this change. :)
>
> I have tested the patchset on my pandaES board, 2 cores ARM Cortex A9.
> hackbench thread/pipe performance increased nearly 10% with this patchset! That do surprise me!
>
> 	latest kernel 527d1511310a89		+ this patchset
> hackbench -T -g 10 -f 40
> 	23.25"					21.7"
> 	23.16"					19.99"
> 	24.24"					21.53"
> hackbench -p -g 10 -f 40
> 	26.52"					22.48"
> 	23.89"					24.00"
> 	25.65"					23.06"
> hackbench -P -g 10 -f 40
> 	20.14"					19.37"
> 	19.96"					19.76"
> 	21.76"					21.54"
>
> The git tree for this patchset at:
>   git@github.com:alexshi/power-scheduling.git no-load-idx
> Since Fengguang had included this tree into his kernel testing system. and I haven't get a regression report until now. I suppose it is fine for x86 system.
>
> But anyway, since the scheduler change will effect all archs. and hackbench is only benchmark I found now for this patchset. I'd like to see more testing and talking on this patchset.

Hi Alex,

I tried on my Xeon server (2 x 4 cores) your patchset and got the 
following result:

kernel a5d6e63323fe7799eb0e6  / + patchset

hackbench -T -s 4096 -l 1000 -g 10 -f 40
	  27.604     	     38.556
	  27.397	     38.694
	  26.695	     38.647
	  25.975	     38.528
	  29.586	     38.553
	  25.956	     38.331
	  27.895	     38.472
	  26.874	     38.608
	  26.836	     38.341
	  28.064	     38.626
hackbench -p -s 4096 -l 1000 -g 10 -f 40
	  34.502     	     35.489
	  34.551	     35.389
	  34.027	     35.664
	  34.343	     35.418
	  34.570	     35.423
	  34.386	     35.466
	  34.387	     35.486
	  33.869	     35.212
	  34.600	     35.465
	  34.155	     35.235
hackbench -P -s 4096 -l 1000 -g 10 -f 40
	  39.170     	     38.794
	  39.108	     38.662
	  39.056	     38.946
	  39.120	     38.668
	  38.896	     38.865
	  39.109	     38.803
	  39.020	     38.946
	  39.099	     38.844
	  38.820	     38.872
	  38.923	     39.337



-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

