Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763663Ab3DDGbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 02:31:31 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:37294 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab3DDGba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 02:31:30 -0400
MIME-Version: 1.0
In-Reply-To: <20130403161955.GE17995@n2100.arm.linux.org.uk>
References: <1362663356-21151-1-git-send-email-tom.leiming@gmail.com>
	<CACVXFVOhr222CVrzkVP_oLgVkdReD9BXXSBg7fmp6Wvx9_peCw@mail.gmail.com>
	<20130312105638.GQ4977@n2100.arm.linux.org.uk>
	<20130403161955.GE17995@n2100.arm.linux.org.uk>
Date: Thu, 4 Apr 2013 14:31:29 +0800
Message-ID: <CACVXFVMMpqYFzP7KpCgvBRLPpWffZuM6q_h+8AS3vYFpk-4B_w@mail.gmail.com>
Subject: Re: [PATCH v1] ARM: keep __my_cpu_offset consistent with generic one
From: Ming Lei <tom.leiming@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Nicolas Pitre <nico@linaro.org>, Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Ingo Molnar <mingo@redhat.com>,
        linux-arm-kernel@lists.infradead.org, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Apr 4, 2013 at 12:19 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
>
> Still not convinced this is a proper fix.  Look, the problem is this:
>
> - Initially, set the CPU percpu offset to zero.  This means the boot
>   CPU reads and writes to the percpu data section in the kernel image.
>
> - The percpu areas are initialized, and the percpu data copied to each
>   percpu data - this will have any writes from the boot CPU included as
>   changes to the percpu data.
>
> - The boot CPU continues to read/write to the percpu data section.

No, the boot CPU switches to access percpu area after the area is
created(after setup_per_cpu_areas() and smp_prepare_boot_cpu()).

>
> - If the boot CPU suspends/resumes, cpu_init() gets called, which will
>   call set_my_cpu_offset(per_cpu_offset(cpu)); for the boot CPU.
>
> - The boot CPU now uses the allocated percpu data section and any
>   updates it did in the percpu data section in the kernel image are
>   lost to it.
>
> Your patch may be right on its own to solve the initial problem, but
> it leaves a _big_ hole.

Without the patch, looks the hols was still here, at least before commit
14318efb(ARM: 7587/1: implement optimized percpu variable access),
the per_cpu_offset() always return 0 before percpu area is created on ARM.
Same on other ARCHs too.

>
> Now, the big question here: is it right that the boot CPU should ever
> write to the static percpu data section in the kernel image?  What if

IMO, it isn't right, but as Tejun said, "it mostly due to historical
reasons rather than by design, as long as the data is in consistent
state by and during percpu setup, nothing will break."

As far as the lockdep case, it is a bit special since lock can
be used very early, and surely more early than creating percpu
area.

> there's a pointer in there, initially NULL, which then gets checked
> by each CPU and initialized if NULL - we'll end up sharing the same
> allocation amongst all CPUs, which probably isn't what was intended.
> If there's a list_head which gets added to, that too will be very bad.

Once lockstat is disabled, arm can boot well, that means no others might
access percpu data section early, so could we just treat it as a special case?

>
> Although you have uncovered a problem, I still think by setting the
> offset to zero initially, you're just papering over a much bigger
> can of worms.
>
> So, should percpu data be used this early in boot before the percpu
> stuff is properly initialized?  That feels _extremely_ unsafe.
>
> This, I think, needs to be addressed properly.  And part of that is
> knowing where things went wrong.  Will Deacon asked you for a backtrace
> showing where this problem occured.  Your response seems to be to
> resend the patch with a "v1" tag a no new information.

I have explained to Will Deacon, and looks no oops trace is generated
on the memory access exception during booting. And the hang
happened in mutex_unlock(&cgroup_mutex)(cgroup_init_subsys<-
cgroup_init_early).

> Sorry, not applying this until the above issue has been discussed
> and the location of these percpu accesses has been properly analysed.

No problem.

Thanks,
-- 
Ming Lei
