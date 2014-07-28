Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaG1VuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:50:10 -0400
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:47611 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751727AbaG1VuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:50:07 -0400
Message-ID: <53D6C58E.7070707@akamai.com>
Date: Mon, 28 Jul 2014 17:50:06 -0400
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] intel_idle: use static_key to optimize idle enter/exit
 paths
References: <20140711175458.6793B2029@prod-mail-relay06.akamai.com> <CAJvTdKkZoo1yO0N4ra8SBh0XY4PiY+KWkVysGptfhVWYb8kO1g@mail.gmail.com>
In-Reply-To: <CAJvTdKkZoo1yO0N4ra8SBh0XY4PiY+KWkVysGptfhVWYb8kO1g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2014 04:38 PM, Len Brown wrote:
> On Fri, Jul 11, 2014 at 1:54 PM, Jason Baron <jbaron@akamai.com> wrote:
>> If 'arat' is set in the cpuflags, we can avoid the checks for entering/exiting
>> the tick broadcast code entirely. It would seem that this is a hot enough code
>> path to make this worthwhile. I ran a few hackbench runs, and consistenly see
>> reduced branches and cycles.
> 
> Hi Jason,
> 
> Your logic looks right -- though I've never used this
> static_key_slow_inc() stuff.
> I'm impressed that something in user-space could detect this change.
> 
> Can you share how to run the workload where you detected a difference,
> and describe the hardware you measured?
> 
> thanks,
> -Len Brown, Intel Open Source Technology Center
> 


Hi Len,

So using something like hackbench appears to show the difference
(with CONFIG_JUMP_LABEL enabled):

Without the patch:

 Performance counter stats for 'perf bench sched messaging' (200 runs):

        641.113816 task-clock                #    8.020 CPUs utilized            ( +-  0.16% ) [100.00%]
             29020 context-switches          #    0.045 M/sec                    ( +-  1.66% ) [100.00%]
              2487 cpu-migrations            #    0.004 M/sec                    ( +-  0.89% ) [100.00%]
             10514 page-faults               #    0.016 M/sec                    ( +-  0.11% )
        2085813986 cycles                    #    3.253 GHz                      ( +-  0.16% ) [100.00%]
        1658381753 stalled-cycles-frontend   #   79.51% frontend cycles idle     ( +-  0.18% ) [100.00%]
   <not supported> stalled-cycles-backend  
        1221737228 instructions              #    0.59  insns per cycle        
                                             #    1.36  stalled cycles per insn  ( +-  0.12% ) [100.00%]
         211723499 branches                  #  330.243 M/sec                    ( +-  0.14% ) [100.00%]
            716846 branch-misses             #    0.34% of all branches          ( +-  0.66% )

       0.079936660 seconds time elapsed                                          ( +-  0.16% )


With the patch:

Performance counter stats for 'perf bench sched messaging' (200 runs):

        638.819963 task-clock                #    8.020 CPUs utilized            ( +-  0.15% ) [100.00%]
             27751 context-switches          #    0.043 M/sec                    ( +-  1.61% ) [100.00%]
              2502 cpu-migrations            #    0.004 M/sec                    ( +-  0.92% ) [100.00%]
             10503 page-faults               #    0.016 M/sec                    ( +-  0.09% )
        2078109565 cycles                    #    3.253 GHz                      ( +-  0.14% ) [100.00%]
        1653002141 stalled-cycles-frontend   #   79.54% frontend cycles idle     ( +-  0.17% ) [100.00%]
   <not supported> stalled-cycles-backend
        1218013520 instructions              #    0.59  insns per cycle
                                             #    1.36  stalled cycles per insn  ( +-  0.12% ) [100.00%]
         210943815 branches                  #  330.209 M/sec                    ( +-  0.14% ) [100.00%]
            697865 branch-misses             #    0.33% of all branches          ( +-  0.66% )

       0.079648462 seconds time elapsed                                          ( +-  0.15% )

So you can see that 'branches' is higher without the patch. Yes, there is some
'noise' here, but there is a measurable impact. It doesn't seem to make too much
sense to me to check for the presence of a h/w feature every time through this kind
of code path if its easily avoidable.

Hardware is 4 core Intel box:

model name	: Intel(R) Xeon(R) CPU E3-1270 V2 @ 3.50GHz
stepping	: 9
microcode	: 0x12
cpu MHz		: 3501.000
cache size	: 8192 KB

Thanks,

-Jason

