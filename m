Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555AbaCEOtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:49:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbaCEOtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:49:32 -0500
Message-ID: <53173961.6080301@redhat.com>
Date: Wed, 05 Mar 2014 15:49:05 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Li, Bin (Bin)" <bin.bl.li@alcatel-lucent.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: "Jatania, Neel (Neel)" <Neel.Jatania@alcatel-lucent.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        "ttracy@redhat.com" <ttracy@redhat.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "riel@redhat.com" <riel@redhat.com>
Subject: Re: Enhancement for PLE handler in KVM
References: <53061044.2000009@alcatel-lucent.com> <530B9637.6030708@alcatel-lucent.com> <5314C8C3.3090607@alcatel-lucent.com> <5314D61B.9050407@redhat.com> <72F5E0D8DB6D83469579E473AD72DB23779EFF64@US70UWXCHMBA01.zam.alcatel-lucent.com>
In-Reply-To: <72F5E0D8DB6D83469579E473AD72DB23779EFF64@US70UWXCHMBA01.zam.alcatel-lucent.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 05/03/2014 15:17, Li, Bin (Bin) ha scritto:
> Hello, Paolo,
>
> We are using a customized embedded SMP OS as guest OS. It is not meaningful to post the guest OS code.
> Also, there is no "performance numbers for common workloads" since there is no common workloads to compare with.
> In our OS, there is still a big kernel lock to protect the kernel.

Does this means that average spinning time for the spinlock is 
relatively high compared to Linux or Windows?

> - when the in-correct boosting happens, the vCPU in spin lock will run
> longer time on the pCPU and causing the lock holder vCPU having less
> time to run on pCPU since they are sharing the on same pCPU.

Correct.  This is an unfortunate problem in the current implementation 
of PLE.

> Adding hyper call in every kernel enter and kernel exist is
> expensive. From the trace log collect from i7 running @ 3.0GHz , the
> cost per  hyper is <1us.

Right, it is around 1500 cycles and 0.4-0.5 us, i.e. approximately 1 us 
for enter and exit together.

This is not too bad for a kernel with a big lock, but not acceptable if 
you do not have it (as is the case for Linux and Windows).

> Regarding to the " paravirtual ticketlock ", we did try the same idea in our embedded guest OS.
> We got following results:
>
> a) We implemented similar approach like linux "paravirtual
> ticketlock". The system clock jitter does get reduced a lot. But, the
> system clock jitter is still happening at lower rate. In a few hours
> system stress test, we still see the big jitter few times.

Did you find out why?  It could happen if the virtual CPU is scheduled 
out for a relatively long time.  A small number of spinning iterations 
can then account for a relatively large time.

My impression is that you're implementing a paravirtual spinlock, except 
that you're relying on PLE to decide when to go to sleep.  PLE is 
implemented using the TSC.  Can you assume the host TSC is of good 
quality?  If so, perhaps you can try to modify the pv ticketlock 
algorithm, and use a threshold based on TSC instead of an iteration count?

> b) When using "paravirtual ticketlock", the threshold to decide "are
> we spinning too much" becomes an important factor need to be tuned to
> the final system case by case. What we found from the test is, different
> application running in our guest OS would require different threshold
> setting.

Did you also find out here why this is the case?

Paolo
