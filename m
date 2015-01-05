Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbbAEWKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 17:10:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58358 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602AbbAEWKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 17:10:14 -0500
Date: Mon, 5 Jan 2015 14:10:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyril Bur <cyrilbur@gmail.com>
Cc: linux-kernel@vger.kernel.org, mpe@ellerman.id.au, drjones@redhat.com,
        dzickus@redhat.com, mingo@kernel.org, uobergfe@redhat.com,
        chaiw.fnst@cn.fujitsu.com, cl@linu.com, fabf@skynet.be,
        atomlin@redhat.com, benzh@chromium.org
Subject: Re: [PATCH 2/2] powerpc: add running_clock for powerpc to prevent
 spurious softlockup warnings
Message-Id: <20150105141013.946b5d15c5d003de8238951c@linux-foundation.org>
In-Reply-To: <1419224764-11384-3-git-send-email-cyrilbur@gmail.com>
References: <1419224764-11384-1-git-send-email-cyrilbur@gmail.com>
	<1419224764-11384-3-git-send-email-cyrilbur@gmail.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Dec 2014 16:06:04 +1100 Cyril Bur <cyrilbur@gmail.com> wrote:

> On POWER8 virtualised kernels the VTB register can be read to have a view of
> time that only increases while the guest is running. This will prevent guests
> from seeing time jump if a guest is paused for significant amounts of time.
> 
> On POWER7 and below virtualised kernels stolen time is subtracted from
> sched_clock as a best effort approximation. This will not eliminate spurious
> warnings in the case of a suspended guest but may reduce the occurance in the
> case of softlockups due to host over commit.
> 
> Bare metal kernels should avoid reading the VTB as KVM does not restore sane
> values when not executing. sched_clock is returned in this case.
> 
> --- a/arch/powerpc/kernel/time.c
> +++ b/arch/powerpc/kernel/time.c
> @@ -621,6 +621,30 @@ unsigned long long sched_clock(void)
>  	return mulhdu(get_tb() - boot_tb, tb_to_ns_scale) << tb_to_ns_shift;
>  }
>  
> +unsigned long long running_clock(void)

Non-kvm kernels don't need this code.  Is there some appropriate
"#ifdef CONFIG_foo" we can wrap this in?


> +{
> +	/*
> +	 * Don't read the VTB as a host since KVM does not switch in host timebase
> +	 * into the VTB when it takes a guest off the CPU, reading the VTB would
> +	 * result in reading 'last switched out' guest VTB.
> +	 */
> +
> +	if (firmware_has_feature(FW_FEATURE_LPAR)) {
> +		if (cpu_has_feature(CPU_FTR_ARCH_207S))
> +			return mulhdu(get_vtb() - boot_tb, tb_to_ns_scale) << tb_to_ns_shift;
> +
> +		/* This is a next best approximation without a VTB. */
> +		return sched_clock() - cputime_to_nsecs(kcpustat_this_cpu->cpustat[CPUTIME_STEAL]);

Why is this result dependent on FW_FEATURE_LPAR?  It's all generic code.

In fact the kernel/sched/clock.c default implementation of
running_clock() could use this expression.  Would that be good or bad? :)

> +	}
> +
> +	/*
> +	 * On a host which doesn't do any virtualisation TB *should* equal VTB so
> +	 * it makes no difference anyway.
> +	 */
> +
> +	return sched_clock();
> +}

