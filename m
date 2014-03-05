Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbaCEOSt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:18:49 -0500
Received: from ihemail1.lucent.com ([135.245.0.33]:46951 "EHLO
	ihemail1.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbaCEOSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:18:46 -0500
From: "Li, Bin (Bin)" <bin.bl.li@alcatel-lucent.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: "Jatania, Neel (Neel)" <Neel.Jatania@alcatel-lucent.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, "Chris Wright" <chrisw@sous-sol.org>,
        "ttracy@redhat.com" <ttracy@redhat.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "riel@redhat.com" <riel@redhat.com>
Subject: RE: Enhancement for PLE handler in KVM
Thread-Topic: Enhancement for PLE handler in KVM
Thread-Index: AQHPNw3F4lhzD8AlbUmUFBaMt3tdkZrQESCAgAJ5ASA=
Date: Wed, 5 Mar 2014 14:17:54 +0000
Message-ID: <72F5E0D8DB6D83469579E473AD72DB23779EFF64@US70UWXCHMBA01.zam.alcatel-lucent.com>
References: <53061044.2000009@alcatel-lucent.com>
 <530B9637.6030708@alcatel-lucent.com> <5314C8C3.3090607@alcatel-lucent.com>
 <5314D61B.9050407@redhat.com>
In-Reply-To: <5314D61B.9050407@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [135.5.27.17]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s25EIvIQ015939

Hello, Paolo, 

We are using a customized embedded SMP OS as guest OS. It is not meaningful to post the guest OS code.
Also, there is no "performance numbers for common workloads" since there is no common workloads to compare with. 
In our OS, there is still a big kernel lock to protect the kernel. 

What we have observed from trace log ( collected via trace-cmd ) 
  - when 2+ vCPU from same VM being stacked on a pCPU 
  - one of the above vCPU happened to be the lock holder and the other vCPU is in spin lock trying to get the kernel lock, 
  - the vCPU in spin lock could still be boosted by vanilla ple handler incorrectly (current ple handler can yield in current PLE VM exist. But vCPU in spin loop becomes eligible to be "yield-to" in the next PLE VM exist. ) 
  - when the in-correct boosting happens, the vCPU in spin lock will run longer time on the pCPU and causing the lock holder vCPU having less time to run on pCPU since they are sharing the on same pCPU.
  - when the lock holder vCPU being scheduled on pCPU less enough, we observe the clock interrupt is issued the lock holder vCPU but being coalesced. This is the root cause of the system clock jitter in the guest OS

When we applied the hyper call in SMP guest OS and using KVM to boost the lock holder only, we can observe following thing with trace-cmd log: 
  - when 2+ vCPU ( n and m ) from same VM being stacked on pCPU a 
  - one of the above vCPU happened to be the lock holder and the other vCPU is in spin lock trying to get the kernel lock, 
  - we observed two types of scheduling events 
  - Type A: 
     vCpu n is lock holder,  but being switched out. vCpu m is switched on to same pCpu a and doing spin loop trying to get into kernel state. 
     after about 1ms, the lock holder vCpu n being schedule to other pCpu b and starting to run. Then LHP ( lock holder preemption) is resolved. 

  - Type B: 
     vCpu n holding lock, but being switched out. vCpu m is switched on to same pCpu a and doing spin loop to get into kernel state. 
     after about 0.4ms ( biggest # is 2ms in the log I captured while running system test case), the vCpu n being switch back to pCpu a. 
     then the vCpu n done its kernel jobs and released the kernel lock. Other vCpus getting the lock and system is happy after. 

   Adding hyper call in every kernel enter and kernel exist is expensive. 
   From the trace log collect from i7 running @ 3.0GHz , the cost per hyper is <1us. Since my measurement can only give us level result. I would consider it as 1us. Comparing the jitter caused by lock holder preemption, I think this cost is acceptable. 
   
   The most important is, the guest OS real time performance becomes stable and predictable.

   At the end, we can give the guest OS an option if the guest OS really care about the real time performance. It is up to the guest OS to  decide use it or not. And there is a challenge in the guest OS to mark the lock correctly and accurately too. 

Regarding to the " paravirtual ticketlock ", we did try the same idea in our embedded guest OS.
We got following results:

a) We implemented similar approach like linux "paravirtual ticketlock". The system clock jitter does get reduced a lot. But, the system clock jitter is still happening at lower rate. In a few hours system stress test, we still see the big jitter few times.

b) When using "paravirtual ticketlock", the threshold to decide "are we spinning too much" becomes an important factor need to be tuned to the final system case by case. What we found from the test is, different application running in our guest OS would require different threshold setting.

c) Again, with the enhancement patch in kvm and using hyper call in guest OS, the guest OS system clock jitter is not increasing over time. Also it is not application related either. And the max. jitter is very close to the pinning vCPU to pCPU case. ( no vCPU stack from same VM in the system - the best we can expect. )

Regards 
Bin 


-----Original Message-----
From: Paolo Bonzini [mailto:paolo.bonzini@gmail.com] On Behalf Of Paolo Bonzini
Sent: Monday, March 03, 2014 2:21 PM
To: Li, Bin (Bin); kvm@vger.kernel.org
Cc: Jatania, Neel (Neel); linux-kernel@vger.kernel.org; Avi Kiviti; Srivatsa Vaddagiri; Peter Zijlstra; Mike Galbraith; Chris Wright; ttracy@redhat.com; Nakajima, Jun; riel@redhat.com
Subject: Re: Enhancement for PLE handler in KVM

Il 03/03/2014 19:24, Li, Bin (Bin) ha scritto:
> Hello, all.
>
> The PLE handler attempts to determine an alternate vCPU to schedule.  
> In some cases the wrong vCPU is scheduled and performance suffers.
>
> This patch allows for the guest OS to signal, using a hypercall, that 
> it's starting/ending a critical section.  Using this information in 
> the PLE handler allows for a more intelligent VCPU scheduling 
> determination to be made.  The patch only changes the PLE behaviour if 
> this new hypercall mechanism is used; if it isn't used, then the 
> existing PLE algorithm continues to be used to determine the next vCPU.
>
> Benefit from the patch:
>  -  the guest OS real time performance being significantly improved 
> when using hyper call marking entering and leaving guest OS kernel state.
>  - The guest OS system clock jitter measured on on Intel E5 2620 
> reduced from 400ms down to 6ms.
>  - The guest OS system lock is set to a 2ms clock interrupt. The 
> jitter is measured by the difference between dtsc() value in clock 
> interrupt handler and the expectation of tsc value.
>  - detail of test report is attached as reference.

This patch doesn't include the corresponding guest changes, so it's not clear how you would use it and what the overhead would be: a hypercall is ~30 times slower than an uncontended spin_lock or spin_unlock.

In fact, performance numbers for common workloads are useful too.

Have you looked at the recent "paravirtual ticketlock"?  It does roughly the opposite as this patch: the guest can signal when it's been spinning too much, and the host will schedule it out (which hopefully accelerates the end of the critical section).

Paolo



> Path details:
>
> From 77edfa193a4e29ab357ec3b1e097f8469d418507 Mon Sep 17 00:00:00 2001

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
