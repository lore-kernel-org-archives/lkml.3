Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbaCKQOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 12:14:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346AbaCKQOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 12:14:12 -0400
Message-ID: <531F364C.5020406@redhat.com>
Date: Tue, 11 Mar 2014 17:14:04 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Li, Bin (Bin)" <bin.bl.li@alcatel-lucent.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jatania, Neel (Neel)" <Neel.Jatania@alcatel-lucent.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Enhancement for PLE handler in KVM
References: <530B9637.6030708@alcatel-lucent.com> <5314C8C3.3090607@alcatel-lucent.com> <5314D61B.9050407@redhat.com> <72F5E0D8DB6D83469579E473AD72DB23779EFF64@US70UWXCHMBA01.zam.alcatel-lucent.com> <53173961.6080301@redhat.com> <72F5E0D8DB6D83469579E473AD72DB23779F1B6B@US70UWXCHMBA01.zam.alcatel-lucent.com> <20140307030636.GA13701@amt.cnet> <72F5E0D8DB6D83469579E473AD72DB23779F63B3@US70UWXCHMBA01.zam.alcatel-lucent.com> <20140307174139.GB30738@amt.cnet> <72F5E0D8DB6D83469579E473AD72DB23779F88CA@US70UWXCHMBA01.zam.alcatel-lucent.com> <20140308015416.GA26349@amt.cnet> <531F19D7.6030909@alcatel-lucent.com>
In-Reply-To: <531F19D7.6030909@alcatel-lucent.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 11/03/2014 15:12, Li, Bin (Bin) ha scritto:
>     - For the guest OS which doesn't use the hyper call interface, there
>     will be no impact to them. The proposed ple handler enhancement has
>     structured to use the hint only if the guest OS using the new
>     proposed hyper call. And it is per VM only.
>     The VM which running general guest OS ( linux / windows) will still
>     use the today's ple hanlder to boost vCPUs. While the other VM,
>     which using new hyper call indicating the lock get and release, the
>     ple handler for this VM will boost the lock holder only.

No, if there is a jitter problem we want to fix it for all guest OSes, 
not just for those that use a big kernel lock.

>     - The main advantage of this proposal is that, it reliably solves
>     the problem. Any other option which could prevent the problem from
>     happening thoroughly?

You haven't proved this yet.  My impression is that, on a 
non-overcommitted system, your proposal is exactly the same as a fair 
lock with paravirtualization (except more expensive for the lock taker, 
even when there is no contention).

I think I understand why, on an overcommitted system, you could still 
have jitter with pv ticketlocks and not with your infrastructure.  The 
reason is that pv ticketlocks do not attempt to donate the quantum to 
the lock holder.  Is there anything we can do to fix *this*?  I would 
accept a new hypercall KVM_HC_HALT_AND_YIELD_TO_CPU that takes an APIC 
id, donates the quantum to that CPU, and puts the originating CPU in 
halted state.

If this is not enough, it's up to you to disprove this and explain why 
the two have different jitter characteristics.  To do this, you need to 
implement paravirtualized fair locks in your kernel (and possibly 
halt-and-yield), measure the difference in jitter, *trace what's 
happening on the host to characterize the benefits of your solution*, etc.

>     - Using hyper call to mark lock status does increase cpu
>     consumption. But the impact to the system is very much depending on
>     lock usage character in the guest OS.
>
>       For the guest OS, which typically doing less frequent kernel lock,
>     but longer operation for each kernel lock, the overall impact from
>     hype call could *NOT *be an issue.

Again, if there is a jitter problem we want to fix it for all locks, 
like we did for pv ticketlocks.

Paolo
