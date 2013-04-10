Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936907Ab3DJPKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 11:10:08 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:63848 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932795Ab3DJPKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 11:10:06 -0400
MIME-Version: 1.0
In-Reply-To: <20130410111620.GB29752@gmail.com>
References: <20130403193743.GB29151@sgi.com>
	<20130408155701.GB19974@gmail.com>
	<5162EC1A.4050204@zytor.com>
	<20130408165916.GA3672@sgi.com>
	<20130410111620.GB29752@gmail.com>
Date: Wed, 10 Apr 2013 08:10:05 -0700
X-Google-Sender-Auth: 2WyVKgjSA3dppHIOBItrD5R48yY
Message-ID: <CA+55aFw8bRwMRm8cWtTGRvd1AEP-LR7pYL-pEoBkHqJUuJrjSg@mail.gmail.com>
Subject: Re: [PATCH] Do not force shutdown/reboot to boot cpu.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Robin Holt <holt@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russ Anderson <rja@sgi.com>, Shawn Guo <shawn.guo@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 4:16 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> I think rebooting on the same CPU where we booted up is something worth having in
> general, as a firmware robustness feature. (assuming the CPU in question is still
> online)

Yeah, we've had issues with ACPI in the past, so I do think we should
always reboot using the BP. Even if it almost certainly works on 99+%
of all machines on any random CPU.

The optimal solution would be to just speed up the
disable_nonboot_cpus() code so much that it isn't an issue. That would
be good for suspending too, although I guess suspend isn't a big issue
if you have a thousand CPU's.

Has anybody checked whether we could do the cpu_down() on non-boot
CPU's in parallel? Right now we serialize the thing completely, with
one single

    for_each_online_cpu(cpu) {
        ...

loop that does a synchrinous _cpu_down() for each CPU. No wonder it
takes forever. We do __stop_machine() over and over and over again:
the whole thing is basically O(n**2) in CPU's.

                        Linus
