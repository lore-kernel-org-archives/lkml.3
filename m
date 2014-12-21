Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaLUDbm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 22:31:42 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:59613 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbaLUDbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 22:31:41 -0500
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 20 Dec 2014 19:31:19 -0800
Message-ID: <CALCETrV4Bhc=pwjJR-S7dfgcR7n0xKtj0o=ofOxCfJmnVFcjGw@mail.gmail.com>
Subject: Cleaning up the KVM clock
To: Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm looking at the vdso timing code, and I'm puzzled by the pvclock
code.  My motivation is comprehensibility, performance, and
correctness.

# for i in `seq 10`; do ./timing_test_64 10 vclock_gettime 0; done
10000000 loops in 0.69138s = 69.14 nsec / loop
10000000 loops in 0.63614s = 63.61 nsec / loop
10000000 loops in 0.63213s = 63.21 nsec / loop
10000000 loops in 0.63087s = 63.09 nsec / loop
10000000 loops in 0.63079s = 63.08 nsec / loop
10000000 loops in 0.63096s = 63.10 nsec / loop
10000000 loops in 0.63096s = 63.10 nsec / loop
10000000 loops in 0.63062s = 63.06 nsec / loop
10000000 loops in 0.63100s = 63.10 nsec / loop
10000000 loops in 0.63112s = 63.11 nsec / loop
bash-4.3# echo tsc
>/sys/devices/system/clocksource/clocksource0/current_clocksource
[   45.957524] Switched to clocksource tsc
bash-4.3# for i in `seq 10`; do ./timing_test_64 10 vclock_gettime 0;
done10000000 loops in 0.33583s = 33.58 nsec / loop
10000000 loops in 0.28530s = 28.53 nsec / loop
10000000 loops in 0.28904s = 28.90 nsec / loop
10000000 loops in 0.29001s = 29.00 nsec / loop
10000000 loops in 0.28775s = 28.78 nsec / loop
10000000 loops in 0.30102s = 30.10 nsec / loop
10000000 loops in 0.28006s = 28.01 nsec / loop
10000000 loops in 0.28584s = 28.58 nsec / loop
10000000 loops in 0.28175s = 28.17 nsec / loop
10000000 loops in 0.28724s = 28.72 nsec / loop

The current code is rather slow, especially compared to the tsc variant.

The algorithm used by the pvclock vgetsns implementation is, approximately:

cpu = getcpu;
pvti = pointer to the relevant paravirt data
version = pvti->version;
rdtsc_barrier();
tsc = rdtsc()
delta = (tsc - x) * y >> z;
cycles = delta + w;
flags = pvti->flags;
rdtsc_barrier();  <-- totally unnecessary

cpu1 = getcpu;
if (cpu != cpu1 || the we missed the seqlock)
  retry;

if (!stable)
  bail;

After that, the main vclock_gettime code applies the kernel's regular
time adjustments.


First, is there any guarantee that, if pvti is marked as stable, that
the pvti data is consistent across cpus?  If so (which would be really
nice), then we could always use vcpu 0's pvti, which would be a really
nice cleanup.

If not, then the current algorithm is buggy.  There is no guarantee
that the tsc stamp we get matches the cpu whose pvti we looked at.  We
could fix that using rdtscp.

I think it's also rather strange that the return value is "cycles"
instead of nanoseconds.  If the guest is using pvclock *and* ntp,
isn't something very wrong?

Can the algorithm just be:

tsc, cpu = rdtscp;
pvti = pvti for cpu

read the scale, offset, etc;
if (!stable)
  bail;
barrier();
read pvti->tsc_timestamp;
if (tsc < pvti->tsc_timestamp)
  retry;
if (the versions are unhappy)
  retry;
return the computed nanosecond count;

I think this is likely to be at least as correct as the current
algorithm, if not more so, and it correctly handles the case where we
migrate to a different vcpu in the middle.  (I also think that, with
this algorithm, the version check should also be unnecessary, since if
we race with a host update, we'll fail the tsc < pvti->tsc_timestamp
check.)

It would be even nicer, though, if we could do much the same thing but
without worrying about which vcpu we're on.

Thoughts?  Am I missing some considerations here?

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
