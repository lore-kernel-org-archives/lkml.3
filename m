Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbaCCTVQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:21:16 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:51660 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936AbaCCTVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 14:21:06 -0500
Message-ID: <5314D61B.9050407@redhat.com>
Date: Mon, 03 Mar 2014 20:20:59 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Li, Bin (Bin)" <bin.bl.li@alcatel-lucent.com>, kvm@vger.kernel.org
CC: Neel Jatania <neel.jatania@alcatel-lucent.com>,
        linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        ttracy@redhat.com, "Nakajima, Jun" <jun.nakajima@intel.com>,
        riel@redhat.com
Subject: Re: Enhancement for PLE handler in KVM
References: <53061044.2000009@alcatel-lucent.com> <530B9637.6030708@alcatel-lucent.com> <5314C8C3.3090607@alcatel-lucent.com>
In-Reply-To: <5314C8C3.3090607@alcatel-lucent.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 03/03/2014 19:24, Li, Bin (Bin) ha scritto:
> Hello, all.
>
> The PLE handler attempts to determine an alternate vCPU to schedule.  In
> some cases the wrong vCPU is scheduled and performance suffers.
>
> This patch allows for the guest OS to signal, using a hypercall, that
> it's starting/ending a critical section.  Using this information in the
> PLE handler allows for a more intelligent VCPU scheduling determination
> to be made.  The patch only changes the PLE behaviour if this new
> hypercall mechanism is used; if it isn't used, then the existing PLE
> algorithm continues to be used to determine the next vCPU.
>
> Benefit from the patch:
>  -  the guest OS real time performance being significantly improved when
> using hyper call marking entering and leaving guest OS kernel state.
>  - The guest OS system clock jitter measured on on Intel E5 2620 reduced
> from 400ms down to 6ms.
>  - The guest OS system lock is set to a 2ms clock interrupt. The jitter
> is measured by the difference between dtsc() value in clock interrupt
> handler and the expectation of tsc value.
>  - detail of test report is attached as reference.

This patch doesn't include the corresponding guest changes, so it's not 
clear how you would use it and what the overhead would be: a hypercall 
is ~30 times slower than an uncontended spin_lock or spin_unlock.

In fact, performance numbers for common workloads are useful too.

Have you looked at the recent "paravirtual ticketlock"?  It does roughly 
the opposite as this patch: the guest can signal when it's been spinning 
too much, and the host will schedule it out (which hopefully accelerates 
the end of the critical section).

Paolo



> Path details:
>
> From 77edfa193a4e29ab357ec3b1e097f8469d418507 Mon Sep 17 00:00:00 2001

