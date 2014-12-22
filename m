Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbaLVNin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 08:38:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754767AbaLVNil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 08:38:41 -0500
Date: Mon, 22 Dec 2014 11:38:22 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Cleaning up the KVM clock
Message-ID: <20141222133822.GA3764@amt.cnet>
References: <CALCETrV4Bhc=pwjJR-S7dfgcR7n0xKtj0o=ofOxCfJmnVFcjGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrV4Bhc=pwjJR-S7dfgcR7n0xKtj0o=ofOxCfJmnVFcjGw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2014 at 07:31:19PM -0800, Andy Lutomirski wrote:
> I'm looking at the vdso timing code, and I'm puzzled by the pvclock
> code.  My motivation is comprehensibility, performance, and
> correctness.
> 
> # for i in `seq 10`; do ./timing_test_64 10 vclock_gettime 0; done
> 10000000 loops in 0.69138s = 69.14 nsec / loop
> 10000000 loops in 0.63614s = 63.61 nsec / loop
> 10000000 loops in 0.63213s = 63.21 nsec / loop
> 10000000 loops in 0.63087s = 63.09 nsec / loop
> 10000000 loops in 0.63079s = 63.08 nsec / loop
> 10000000 loops in 0.63096s = 63.10 nsec / loop
> 10000000 loops in 0.63096s = 63.10 nsec / loop
> 10000000 loops in 0.63062s = 63.06 nsec / loop
> 10000000 loops in 0.63100s = 63.10 nsec / loop
> 10000000 loops in 0.63112s = 63.11 nsec / loop
> bash-4.3# echo tsc
> >/sys/devices/system/clocksource/clocksource0/current_clocksource
> [   45.957524] Switched to clocksource tsc
> bash-4.3# for i in `seq 10`; do ./timing_test_64 10 vclock_gettime 0;
> done10000000 loops in 0.33583s = 33.58 nsec / loop
> 10000000 loops in 0.28530s = 28.53 nsec / loop
> 10000000 loops in 0.28904s = 28.90 nsec / loop
> 10000000 loops in 0.29001s = 29.00 nsec / loop
> 10000000 loops in 0.28775s = 28.78 nsec / loop
> 10000000 loops in 0.30102s = 30.10 nsec / loop
> 10000000 loops in 0.28006s = 28.01 nsec / loop
> 10000000 loops in 0.28584s = 28.58 nsec / loop
> 10000000 loops in 0.28175s = 28.17 nsec / loop
> 10000000 loops in 0.28724s = 28.72 nsec / loop
> 
> The current code is rather slow, especially compared to the tsc variant.
> 
> The algorithm used by the pvclock vgetsns implementation is, approximately:
> 
> cpu = getcpu;
> pvti = pointer to the relevant paravirt data
> version = pvti->version;
> rdtsc_barrier();
> tsc = rdtsc()
> delta = (tsc - x) * y >> z;
> cycles = delta + w;
> flags = pvti->flags;
> rdtsc_barrier();  <-- totally unnecessary

Why?

"The RDTSC instruction is not a serializing instruction. It does not
necessarily wait until all previous instructions have been executed
before reading the counter. Similarly, subsequent instructions may begin
execution before the read operation is performed."

