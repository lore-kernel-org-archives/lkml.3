Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab3ICOkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 10:40:00 -0400
Received: from a9-78.smtp-out.amazonses.com ([54.240.9.78]:48995 "EHLO
	a9-78.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755057Ab3ICOj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 10:39:59 -0400
Date: Tue, 3 Sep 2013 14:39:57 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Will Deacon <will.deacon@arm.com>
cc: Tejun Heo <tj@kernel.org>,
        "akpm@linuxfoundation.org" <akpm@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [gcv v3 27/35] arm: Replace __get_cpu_var uses
In-Reply-To: <20130830100105.GF25628@mudshark.cambridge.arm.com>
Message-ID: <00000140e4440576-ae4236ee-3073-4f94-b569-d17396e57513-000000@email.amazonses.com>
References: <20130828193457.140443630@linux.com> <00000140c67834c9-cc2bec76-2d70-48d1-a35b-6e2d5dedf22b-000000@email.amazonses.com> <20130830100105.GF25628@mudshark.cambridge.arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="376175846-1704481339-1378219230=:17065"
X-SES-Outgoing: 2013.09.03-54.240.9.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--376175846-1704481339-1378219230=:17065
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Fri, 30 Aug 2013, Will Deacon wrote:

> This is the flavour we have for ARM's hw_breakpoint code, where we have an
> array of perf_event * instead of int...
>
> > Index: linux/arch/arm/kernel/hw_breakpoint.c
> > ===================================================================
> > --- linux.orig/arch/arm/kernel/hw_breakpoint.c  2013-08-26 13:48:40.956794980 -0500
> > +++ linux/arch/arm/kernel/hw_breakpoint.c       2013-08-26 13:48:40.952795024 -0500
> > @@ -344,13 +344,13 @@ int arch_install_hw_breakpoint(struct pe
> >                 /* Breakpoint */
> >                 ctrl_base = ARM_BASE_BCR;
> >                 val_base = ARM_BASE_BVR;
> > -               slots = (struct perf_event **)__get_cpu_var(bp_on_reg);
> > +               slots = (struct perf_event **)__this_cpu_read(bp_on_reg);
>
> ...so I don't think this is quite right, and indeed, we get a bunch of errors
> from GCC:
>
> arch/arm/kernel/hw_breakpoint.c: In function ‘arch_install_hw_breakpoint’:
> arch/arm/kernel/hw_breakpoint.c:347:33: error: incompatible types when assigning to type ‘struct perf_event *[16]’ from type ‘struct perf_event **’
> arch/arm/kernel/hw_breakpoint.c:347:1: error: incompatible types when assigning to type ‘struct perf_event *[16]’ from type ‘struct perf_event **’
> arch/arm/kernel/hw_breakpoint.c:347:1: error: incompatible types when assigning to type ‘struct perf_event *[16]’ from type ‘struct perf_event **’
> arch/arm/kernel/hw_breakpoint.c:347:1: error: incompatible types when assigning to type ‘struct perf_event *[16]’ from type ‘struct perf_event **’

Did you apply the first patch of this series which is a bug fix?

> changing to match your recipe still doesn't work, however:
>
> arch/arm/kernel/hw_breakpoint.c: In function ‘arch_install_hw_breakpoint’:
> arch/arm/kernel/hw_breakpoint.c:347:33: error: cast specifies array type

Yep that is the macro bug that was fixed in the first patch.

> >
> >         WARN_ON(preemptible());
> >
> > -       if (local_inc_return(&__get_cpu_var(mde_ref_count)) == 1)
> > +       if (this_cpu_inc_return(mde_ref_count) == 1)
> >                 enable = DBG_MDSCR_MDE;
>
> I'm not sure that this is safe. We rely on local_inc_return to be atomic
> with respect to the current CPU, which will end up being a wrapper around
> atomic64_inc_return. However, this_cpu_inc_return simply uses a lock, so
> other people accessing the count in a different manner (local_dec_and_test
> below) may break local atomicity unless we start disabling interrupts or
> something horrible like that.

I do not see any special code for ARM for this_cpu_inc_return. The
fallback solution in the core code is to disable interrupts for the
inc_return and arch/arm/include/asm/percpu.h includes
asm-generic/percpu.h.

Where did you see it using a lock?

--376175846-1704481339-1378219230=:17065--
