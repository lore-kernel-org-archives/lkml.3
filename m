Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761AbaCEVRW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 16:17:22 -0500
Received: from ihemail3.lucent.com ([135.245.0.37]:61335 "EHLO
	ihemail3.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbaCEVRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 16:17:18 -0500
From: "Li, Bin (Bin)" <bin.bl.li@alcatel-lucent.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: "Jatania, Neel (Neel)" <Neel.Jatania@alcatel-lucent.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        "ttracy@redhat.com" <ttracy@redhat.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "riel@redhat.com" <riel@redhat.com>
Subject: RE: Enhancement for PLE handler in KVM
Thread-Topic: Enhancement for PLE handler in KVM
Thread-Index: AQHPNw3F4lhzD8AlbUmUFBaMt3tdkZrQESCAgAJ5ASCAAF+xgP//5v4A
Date: Wed, 5 Mar 2014 21:16:45 +0000
Message-ID: <72F5E0D8DB6D83469579E473AD72DB23779F1B6B@US70UWXCHMBA01.zam.alcatel-lucent.com>
References: <53061044.2000009@alcatel-lucent.com>
 <530B9637.6030708@alcatel-lucent.com> <5314C8C3.3090607@alcatel-lucent.com>
 <5314D61B.9050407@redhat.com>
 <72F5E0D8DB6D83469579E473AD72DB23779EFF64@US70UWXCHMBA01.zam.alcatel-lucent.com>
 <53173961.6080301@redhat.com>
In-Reply-To: <53173961.6080301@redhat.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s25LHXoM020624

Thanks for the quick response.

Inline the comments and also added a typical log.

Regards
Bin
  

-----Original Message-----
From: Paolo Bonzini [mailto:pbonzini@redhat.com] 
Sent: Wednesday, March 05, 2014 9:49 AM
To: Li, Bin (Bin); kvm@vger.kernel.org
Cc: Jatania, Neel (Neel); linux-kernel@vger.kernel.org; Srivatsa Vaddagiri; Peter Zijlstra; Mike Galbraith; Chris Wright; ttracy@redhat.com; Nakajima, Jun; riel@redhat.com
Subject: Re: Enhancement for PLE handler in KVM

Il 05/03/2014 15:17, Li, Bin (Bin) ha scritto:
> Hello, Paolo,
>
> We are using a customized embedded SMP OS as guest OS. It is not meaningful to post the guest OS code.
> Also, there is no "performance numbers for common workloads" since there is no common workloads to compare with.
> In our OS, there is still a big kernel lock to protect the kernel.

Does this means that average spinning time for the spinlock is relatively high compared to Linux or Windows?

Binl:

Yes. The default setting for ple_window is 4096 which based on linux and window. In our guest OS, the ple_window need to be at least 16384 in order to prevent large jitter caused system reset. With setting ple_window to 16384, the biggest jitter in guest OS is about 24-25ms.


> - when the in-correct boosting happens, the vCPU in spin lock will run 
> longer time on the pCPU and causing the lock holder vCPU having less 
> time to run on pCPU since they are sharing the on same pCPU.

Correct.  This is an unfortunate problem in the current implementation of PLE.

> Adding hyper call in every kernel enter and kernel exist is expensive. 
> From the trace log collect from i7 running @ 3.0GHz , the cost per  
> hyper is <1us.

Right, it is around 1500 cycles and 0.4-0.5 us, i.e. approximately 1 us for enter and exit together.

This is not too bad for a kernel with a big lock, but not acceptable if you do not have it (as is the case for Linux and Windows).

> Regarding to the " paravirtual ticketlock ", we did try the same idea in our embedded guest OS.
> We got following results:
>
> a) We implemented similar approach like linux "paravirtual 
> ticketlock". The system clock jitter does get reduced a lot. But, the 
> system clock jitter is still happening at lower rate. In a few hours 
> system stress test, we still see the big jitter few times.

Did you find out why?  It could happen if the virtual CPU is scheduled out for a relatively long time.  A small number of spinning iterations can then account for a relatively large time.

My impression is that you're implementing a paravirtual spinlock, except that you're relying on PLE to decide when to go to sleep.  PLE is implemented using the TSC.  Can you assume the host TSC is of good quality?  If so, perhaps you can try to modify the pv ticketlock algorithm, and use a threshold based on TSC instead of an iteration count?

BinL:
Our "paravirtual ticket lock" is done in following way, 
 - when a vCPU is doing spin loop to get into kernel state, it will set up a counter to track how many time in the tight loop.
If the counter reach certain threshold, the vCPU will add a request to the lock holder work item pipe ( multiple producer, single consumer pipe ) and the vCPU will run "hlt" instruction, waiting for the lock holder to wake it up.
 - TSC is not used in this case.
 - When lock holder sees the request, it will send an IPI interrupt to wake up the vCPU which is hlt-ed.
 - With this implementation, we are able to get the system stress test ( about hours run with traffic ) completing successfully most of time. But not all the time. The big jitter still happening during the run, just less frequently. The root cause of the problem is still there.

 The lock holder vCPU is schedule out for a relatively long time. We did more investigation for why.
  a) From the trace-cmd log, we believe the root cause is PLE handler incorrectly boost the spin loop vCPU which being stack with the lock holder vCPU on same pCPU. 
     The sample log we captured is, lock holder vCPU and the vCPU doing spin loop, both running on a pCPU. The vCPU in spin loop being incorrectly boosted by ple handler. And linux scheduler could toggling two vCPU on the pCPU at vert high rate. The worst case is, the lock is happen to stay between the two vCPUs on the same pCPU. Then we will see lock holder vCPU is scheduled in doing a little bit real work and the other spin loop vCPU being scheduled in doing spin loop. And the context switch on the pCPU happens very often. ( see more details of typical trace below)

     This causing the real cpu power used for processing real work becomes much less than normal. ( a short period truly over load on this pCPU). And the guest OS stays in a very slow kernel work stage because the lock holder vCPU having much less time to do its real work. The system will get out of this slow movement eventually. But depending on how long being stuck in slow movement, when system get back to normal speed, the application could realize big time gap passed by already. And many time out following...

  b) We also did another test to verify the theory. We built a KVM with a dummy ple handler ( not doing yield to, ple vm exit, just return right away). With this dummy ple handler, the jitter is an issue any more. The biggest jitter in the system is just around 25-30ms during the hours traffic run.

  c) the typical trace captured when running on cent os 6.4 ( even older ple handler which would incorrectly boost spin loop vcpu more often)

      Typical trace is like:

        In the following trace, - cpu 0 being hold for 6ms ( no chance to run ). 
        6ms here is not a big deal. But showing linux could decide not allowing a process to run.

       brief event
...
        qemu-kvm-5069  [003]  8242.604669: kvm_apic_ipi:         dst 9 vec 253 (Fixed|physical|assert|edge|dst)
        qemu-kvm-5069  [003]  8242.604670: kvm_apic_accept_irq:  apicid 9 vec 253 (Fixed|edge)
        qemu-kvm-5069  [003]  8242.604673: wakeup:               5069:120:0  ==+ 5078:120:0 [003]
        qemu-kvm-5069  [003]  8242.604677: context_switch:       5069:120:0  ==> 5078:120:0 [003]   ... linux stacking vcpu 9 (pid 5078) on cpu 3 too
...
        qemu-kvm-5077  [001]  8242.610485: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x60edd06
        qemu-kvm-5073  [000]  8242.610485: kvm_entry:            vcpu 4
        qemu-kvm-5076  [015]  8242.610486: kvm_entry:            vcpu 7
        qemu-kvm-5078  [003]  8242.610486: kvm_entry:            vcpu 9
        qemu-kvm-5075  [014]  8242.610488: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x60edd06 ---> exist due to pause instruction.,
        qemu-kvm-5070  [016]  8242.610488: kvm_entry:            vcpu 1
        qemu-kvm-5073  [000]  8242.610488: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x60edd06
        qemu-kvm-5078  [003]  8242.610488: kvm_exit:             [FAILED TO PARSE] exit_reason=1 guest_rip=0x60edd08
...
        qemu-kvm-5078  [003]  8242.610491: context_switch:       5078:120:0  ==> 5069:120:0 [003]

        qemu-kvm-5069  [003]  8242.610494: kvm_apic_accept_irq:  apicid 0 vec 240 (Fixed|edge)
...
        qemu-kvm-5069  [003]  8242.610496: context_switch:       5069:120:0  ==> 5078:120:0 [003]

... ( all other CPUs are busy trying to entering kernel state )
       qemu-kvm-5078  [003]  8242.610502: context_switch:       5078:120:0  ==> 5069:120:0 [003]
... ( all other CPUs are busy trying to entering kernel state )

        qemu-kvm-5069  [003]  8242.610552: kvm_apic_accept_irq:  apicid 0 vec 240 (Fixed|edge) (coalesced)
        qemu-kvm-5069  [003]  8242.610554: context_switch:       5069:120:0  ==> 5078:120:0 [003]
        qemu-kvm-5069  [003]  8242.610559: kvm_apic_accept_irq:  apicid 0 vec 240 (Fixed|edge) (coalesced)
        qemu-kvm-5069  [003]  8242.610562: context_switch:       5069:120:0  ==> 5078:120:0 [003]
        qemu-kvm-5069  [003]  8242.610569: kvm_apic_accept_irq:  apicid 0 vec 240 (Fixed|edge) (coalesced)
        qemu-kvm-5069  [003]  8242.610571: context_switch:       5069:120:0  ==> 5078:120:0 [003]
        qemu-kvm-5069  [003]  8242.610577: kvm_entry:            vcpu 0
        qemu-kvm-5069  [003]  8242.610579: kvm_exit:             [FAILED TO PARSE] exit_reason=1 guest_rip=0x60ed11f
        qemu-kvm-5069  [003]  8242.610579: kvm_apic_accept_irq:  apicid 0 vec 240 (Fixed|edge) (coalesced)
        qemu-kvm-5069  [003]  8242.610581: context_switch:       5069:120:0  ==> 5078:120:0 [003]
        qemu-kvm-5069  [003]  8242.610588: kvm_apic_accept_irq:  apicid 0 vec 240 (Fixed|edge) (coalesced)
        qemu-kvm-5069  [003]  8242.610590: context_switch:       5069:120:0  ==> 5078:120:0 [003]
        qemu-kvm-5069  [003]  8242.610595: kvm_apic_accept_irq:  apicid 0 vec 240 (Fixed|edge) (coalesced)
        qemu-kvm-5069  [003]  8242.610597: context_switch:       5069:120:0  ==> 5078:120:0 [003]
        qemu-kvm-5069  [003]  8242.610605: kvm_apic_accept_irq:  apicid 0 vec 240 (Fixed|edge) (coalesced)
        qemu-kvm-5069  [003]  8242.610607: context_switch:       5069:120:0  ==> 5078:120:0 [003]
...
       qemu-kvm-5078  [003]  8242.610611: context_switch:       5078:120:0  ==> 5069:120:0 [003]
...
       qemu-kvm-5069  [003]  8242.610613: kvm_entry:            vcpu 0   ... start run vm work after not having chance to do real work for 6 ms.
...  

        Close to the end of this log file, we can see, only vcpu 0 and vcpu 9 doing some real work but very slow, but all on        physical cpu 003. While others kept doing kvm_exit ( reason 40, due to pause instruction ) and kvm_entry. 

        qemu-kvm-5078  [003]  8242.617050: kvm_entry:            vcpu 9
        qemu-kvm-5071  [005]  8242.617051: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x6180a6c
        qemu-kvm-5070  [016]  8242.617051: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x6180a6c
        qemu-kvm-5078  [003]  8242.617052: kvm_exit:             [FAILED TO PARSE] exit_reason=0 guest_rip=0x6194c00
        qemu-kvm-5075  [014]  8242.617053: kvm_entry:            vcpu 6
        qemu-kvm-5074  [013]  8242.617054: kvm_entry:            vcpu 5
        qemu-kvm-5073  [000]  8242.617054: kvm_entry:            vcpu 4
        qemu-kvm-5072  [017]  8242.617054: kvm_entry:            vcpu 3
        qemu-kvm-5079  [004]  8242.617054: kvm_entry:            vcpu 10
        qemu-kvm-5076  [015]  8242.617055: kvm_entry:            vcpu 7
        qemu-kvm-5071  [005]  8242.617055: kvm_entry:            vcpu 2
        qemu-kvm-5070  [016]  8242.617055: kvm_entry:            vcpu 1
        qemu-kvm-5077  [001]  8242.617056: kvm_entry:            vcpu 8
        qemu-kvm-5075  [014]  8242.617056: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x6180a6c
        qemu-kvm-5078  [003]  8242.617056: context_switch:       5078:120:0  ==> 5069:120:0 [003]
        qemu-kvm-5073  [000]  8242.617057: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x618b94b
        qemu-kvm-5074  [013]  8242.617057: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x6180a6c
        qemu-kvm-5072  [017]  8242.617057: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x6180a6c
        qemu-kvm-5079  [004]  8242.617058: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x6180a6c
        qemu-kvm-5076  [015]  8242.617058: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x6180a6c
        qemu-kvm-5071  [005]  8242.617058: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x6180a6c
        qemu-kvm-5075  [014]  8242.617059: kvm_entry:            vcpu 6
        qemu-kvm-5070  [016]  8242.617059: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x6180a6c
        qemu-kvm-5077  [001]  8242.617059: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x6180a6c
        qemu-kvm-5069  [003]  8242.617060: context_switch:       5069:120:0  ==> 5078:120:0 [003]
        qemu-kvm-5075  [014]  8242.617062: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x6180a6c
        qemu-kvm-5076  [015]  8242.617062: kvm_entry:            vcpu 7
        qemu-kvm-5071  [005]  8242.617063: kvm_entry:            vcpu 2
        qemu-kvm-5070  [016]  8242.617063: kvm_entry:            vcpu 1
        qemu-kvm-5077  [001]  8242.617064: kvm_entry:            vcpu 8
        qemu-kvm-5072  [017]  8242.617064: kvm_entry:            vcpu 3
        qemu-kvm-5078  [003]  8242.617065: context_switch:       5078:120:0  ==> 5069:120:0 [003]
        qemu-kvm-5076  [015]  8242.617066: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x6180a6c
        qemu-kvm-5071  [005]  8242.617066: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x6180a6c
        qemu-kvm-5070  [016]  8242.617067: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x6180a6c
        qemu-kvm-5074  [013]  8242.617067: kvm_entry:            vcpu 5
        qemu-kvm-5077  [001]  8242.617068: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x6180a6c
        qemu-kvm-5072  [017]  8242.617068: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x6180a6c
        qemu-kvm-5073  [000]  8242.617068: kvm_entry:            vcpu 4
        qemu-kvm-5079  [004]  8242.617068: kvm_entry:            vcpu 10
        qemu-kvm-5069  [003]  8242.617069: context_switch:       5069:120:0  ==> 5078:120:0 [003]
        qemu-kvm-5074  [013]  8242.617071: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x6180a6c
        qemu-kvm-5073  [000]  8242.617071: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x618b94b
        qemu-kvm-5079  [004]  8242.617071: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x6180a6c
        qemu-kvm-5072  [017]  8242.617071: kvm_entry:            vcpu 3
        qemu-kvm-5075  [014]  8242.617072: kvm_entry:            vcpu 6
        qemu-kvm-5078  [003]  8242.617072: context_switch:       5078:120:0  ==> 5069:120:0 [003]
        qemu-kvm-5077  [001]  8242.617072: kvm_entry:            vcpu 8
        qemu-kvm-5075  [014]  8242.617075: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x6180a6c
        qemu-kvm-5072  [017]  8242.617075: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x6180a6c
        qemu-kvm-5076  [015]  8242.617076: kvm_entry:            vcpu 7
        qemu-kvm-5077  [001]  8242.617076: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x6180a6c
        qemu-kvm-5071  [005]  8242.617076: kvm_entry:            vcpu 2
        qemu-kvm-5073  [000]  8242.617076: kvm_entry:            vcpu 4
        qemu-kvm-5070  [016]  8242.617076: kvm_entry:            vcpu 1
        qemu-kvm-5074  [013]  8242.617077: kvm_entry:            vcpu 5
        qemu-kvm-5079  [004]  8242.617077: kvm_entry:            vcpu 10
        qemu-kvm-5069  [003]  8242.617077: context_switch:       5069:120:0  ==> 5078:120:0 [003]
        qemu-kvm-5071  [005]  8242.617079: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x6180a6c
        qemu-kvm-5076  [015]  8242.617079: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x6180a6c
        qemu-kvm-5073  [000]  8242.617079: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x618b94b
        qemu-kvm-5070  [016]  8242.617080: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x6180a6c
        qemu-kvm-5074  [013]  8242.617080: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x6180a6c
        qemu-kvm-5079  [004]  8242.617080: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x6180a6c
        qemu-kvm-5077  [001]  8242.617081: kvm_entry:            vcpu 8
        qemu-kvm-5075  [014]  8242.617081: kvm_entry:            vcpu 6
        qemu-kvm-5078  [003]  8242.617082: context_switch:       5078:120:0  ==> 5069:120:0 [003]
        qemu-kvm-5069  [003]  8242.617083: kvm_entry:            vcpu 0
        qemu-kvm-5072  [017]  8242.617084: kvm_entry:            vcpu 3
        qemu-kvm-5077  [001]  8242.617084: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x6180a6c
        qemu-kvm-5075  [014]  8242.617084: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x6180a6c
        qemu-kvm-5069  [003]  8242.617086: kvm_exit:             [FAILED TO PARSE] exit_reason=1 guest_rip=0x60edd08
        qemu-kvm-5072  [017]  8242.617087: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x6180a6c
        qemu-kvm-5074  [013]  8242.617087: kvm_entry:            vcpu 5
        qemu-kvm-5079  [004]  8242.617087: kvm_entry:            vcpu 10
        qemu-kvm-5071  [005]  8242.617088: kvm_entry:            vcpu 2
        qemu-kvm-5069  [003]  8242.617089: context_switch:       5069:120:0  ==> 5078:120:0 [003]
        qemu-kvm-5076  [015]  8242.617089: kvm_entry:            vcpu 7
        qemu-kvm-5074  [013]  8242.617090: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x6180a6c
        qemu-kvm-5070  [016]  8242.617090: kvm_entry:            vcpu 1
        qemu-kvm-5078  [003]  8242.617090: kvm_entry:            vcpu 9
        qemu-kvm-5079  [004]  8242.617090: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x6180a6c
        qemu-kvm-5073  [000]  8242.617091: kvm_entry:            vcpu 4
        qemu-kvm-5071  [005]  8242.617091: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x6180a6c
        qemu-kvm-5076  [015]  8242.617092: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x6180a6c
        qemu-kvm-5072  [017]  8242.617092: kvm_entry:            vcpu 3
        qemu-kvm-5078  [003]  8242.617092: kvm_exit:             [FAILED TO PARSE] exit_reason=1 guest_rip=0x6194c00
        qemu-kvm-5075  [014]  8242.617093: kvm_entry:            vcpu 6
        qemu-kvm-5079  [004]  8242.617093: kvm_entry:            vcpu 10
        qemu-kvm-5070  [016]  8242.617094: kvm_exit:             [FAILED TO PARSE] exit_reason=40 guest_rip=0x6180a6c
        qemu-kvm-5077  [001]  8242.617094: kvm_entry:            vcpu 8

> b) When using "paravirtual ticketlock", the threshold to decide "are 
> we spinning too much" becomes an important factor need to be tuned to 
> the final system case by case. What we found from the test is, 
> different application running in our guest OS would require different 
> threshold setting.

Did you also find out here why this is the case?

Binl:
Yes. The application running in our customized embedded OS is also real time application which is timing sensitive. 
The timing sensitive level varies among the applications.
When I talking about different threshold, the assumption is using default 4096 ple_window setting.
If I set up the ple_window to 16384 or higher, there will be no problem for our application. But the finial user could also run linux or window VM on same hypervisor which would prefer default 4096 setting for linux and windows.
We are looking for a solution to be good for both linux / window and real time application.
The enhancement patch we proposed will satisfy both linux/window application and real time embedded applications.

Paolo
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
