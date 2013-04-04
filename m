Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759749Ab3DDMbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 08:31:44 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:52429 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758406Ab3DDMbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 08:31:43 -0400
MIME-Version: 1.0
In-Reply-To: <1365066635-2959-1-git-send-email-sgruszka@redhat.com>
References: <1365066635-2959-1-git-send-email-sgruszka@redhat.com>
Date: Thu, 4 Apr 2013 14:31:42 +0200
Message-ID: <CAFTL4hx-k42Af1qhpf+0jra6HZ3LBxL=1A8J3xabzjWLAxH9GQ@mail.gmail.com>
Subject: Re: [PATCH -tip 0/4] do not make cputime scaling in kernel
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Turner <pjt@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/4 Stanislaw Gruszka <sgruszka@redhat.com>:
> This patch series removes cputime scaling from kernel. It can be easily
> done in user space using floating point if we provide sum_exec_runtime,
> what patches 2/4 and 3/4 do. I have procps patch which utilize that:
>
> http://people.redhat.com/sgruszka/procps-use-sum_exec_runtime.patch
>
> I will post it, if this patch set will be queued.
>
> Change affect also getrusage() and times() syscals, but I don't think
> kernel give guarantees about utime/stime precision, in a matter of fact
> before commit b27f03d4bdc145a09fb7b0c0e004b29f1ee555fa, we do not
> perform any scaling and we provided raw cputime values to user space.
>
> Providing sum_exec_runtime via proc is done against malware that utilize
> lot of cpu time but hide itself from top program.
>
> This affect kernels not compiled with CONFIG_VIRT_CPU_ACCOUNTING_{GEN,NATIVE},
> if user choose to compile kernel with some of those options, he/she will
> have more precise cputime accounting, what is documented in Kconfig.
>

I don't know. I'm not convinced userland is the right place to perform
this kind of check. The kernel perhaps doesn't give guarantee about
utime/stime precision but now users may have got used to that scaled
behaviour. It's also a matter of security, a malicous app can hide
from the tick to make its activity less visible from tools like top.

It's sortof an ABI breakage to remove such an implicit protection. And
fixing that from userspace with a lib or so won't change that fact.

How about that 128bits based idea? I'm adding Paul Turner in Cc
because he seemed to agree with doing it using 128bits maths.
