Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab3AJWYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 17:24:51 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:25483 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab3AJWYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 17:24:50 -0500
Message-ID: <50EF3FAF.7070803@hp.com>
Date: Thu, 10 Jan 2013 14:24:47 -0800
From: Chegu Vinod <chegu_vinod@hp.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: linux-kernel@vger.kernel.org, aquini@redhat.com, walken@google.com,
        eric.dumazet@gmail.com, lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>, knoel@redhat.com,
        raghavendra.kt@linux.vnet.ibm.com, mingo@redhat.com
Subject: Re: [PATCH 0/5] x86,smp: make ticket spinlock proportional backoff
 w/ auto tuning
References: <20130108172632.1126898a@annuminas.surriel.com>
In-Reply-To: <20130108172632.1126898a@annuminas.surriel.com>
Content-Type: multipart/mixed;
 boundary="------------050202070902020200030106"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050202070902020200030106
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 1/8/2013 2:26 PM, Rik van Riel wrote:
<...>
> Performance is within the margin of error of v2, so the graph
> has not been update.
>
> Please let me know if you manage to break this code in any way,
> so I can fix it...
>

Attached below is some preliminary data with one of the AIM7 micro-benchmark
workloads (i.e. high_systime). This is a kernel intensive workload which
does tons of forks/execs etc.and stresses quite a few of the same set
of spinlocks and semaphores.

Observed a drop in performance as we go to 40way and 80 way. Wondering
if the back off keeps increasing to such an extent that it actually starts
to hurt given the nature of this workload ?  Also in the case of 80way
observed quite a bit of variation from run to run...

Also ran it inside a single KVM guest. There were some perf. dips but
interestingly didn't observe the same level of drop (compared to the
drop in the native case) as the guest size was scaled up to 40vcpu or
80vcpu.

FYI
Vinod


--------------050202070902020200030106
Content-Type: text/plain; charset=windows-1252;
 name="aim7_rik"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="aim7_rik"



---

Platform : 8 socket (80 Core) Westmere with 1TB RAM.

Workload: AIM7-highsystime microbenchmark - 2000 users & 100 jobs per user.  

Values reported are Jobs Per Minute (Higher is better).  The values
are average of 3 runs.

1) Native run:
--------------

Config 1:  3.7 kernel
Config 2:  3.7 + Rik's 1-4 patches

------------------------------------------------------------
              20way     40way     80way
------------------------------------------------------------
Config 1     ~179K     ~159K     ~146K 
------------------------------------------------------------
Config 2     ~180K     ~134K     ~21K-43K  <- high variation!
------------------------------------------------------------

(Note: Used numactl to restrict workload to 
            2 sockets (20way) and 4 sockets(40way))

------

2) KVM run : 
------------

Single guest of different sizes (No over commit, NUMA enabled in the guest).

Note: This kernel intensive micro benchmark is exposes the PLE handler issue 
      esp. for large guests. Since Raghu's PLE changes are not yet in upstream 
      'have just run with current PLE handler & then by disabling 
      PLE (ple_gap=0).

Config 1 : Host & Guest at 3.7
Config 2 : Host & Guest are at 3.7 + Rik's 1-4 patches

--------------------------------------------------------------------------
             20vcpu/128G      40vcpu/256G      80vcpu/512G
            (on 2 sockets)   (on 4 sockets)   (on 8 sockets)
--------------------------------------------------------------------------
Config 1       ~144K             ~39K             ~10K
--------------------------------------------------------------------------
Config 2       ~143K             ~37.5K           ~11K
--------------------------------------------------------------------------

Config 3 : Host & Guest at 3.7 AND ple_gap=0
Config 4 : Host & Guest are at 3.7 + Rik's 1-4 patches AND ple_gap=0

--------------------------------------------------------------------------
Config 3       ~154K            ~131K            ~116K 
--------------------------------------------------------------------------
Config 4       ~151K            ~130K            ~115K
--------------------------------------------------------------------------


(Note: Used numactl to restrict qemu to 
            2 sockets (20way) and 4 sockets(40way))

--------------050202070902020200030106--
