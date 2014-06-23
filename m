Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbaFWVu0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 17:50:26 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:41093 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596AbaFWVuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 17:50:24 -0400
Message-ID: <1403559665.25108.6.camel@misato.fc.hp.com>
Subject: Re: [PATCH v7] x86: initialize secondary CPU only if master CPU
 will wait for it
From: Toshi Kani <toshi.kani@hp.com>
To: Igor Mammedov <imammedo@redhat.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, xen-devel@lists.xenproject.org
Date: Mon, 23 Jun 2014 15:41:05 -0600
In-Reply-To: <1403266991-12233-1-git-send-email-imammedo@redhat.com>
References: <1403266991-12233-1-git-send-email-imammedo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-20 at 14:23 +0200, Igor Mammedov wrote:
> Hang is observed on virtual machines during CPU hotplug,
> especially in big guests with many CPUs. (It reproducible
> more often if host is over-committed).
> 
> It happens because master CPU gives up waiting on
> secondary CPU and allows it to run wild. As result
> AP causes locking or crashing system. For example
> as described here: https://lkml.org/lkml/2014/3/6/257
> 
> If master CPU have sent STARTUP IPI successfully,
> and AP signalled to master CPU that it's ready
> to start initialization, make master CPU wait
> indefinitely till AP is onlined.
> To ensure that AP won't ever run wild, make it
> wait at early startup till master CPU confirms its
> intention to wait for AP. If AP doesn't respond in 10
> seconds, the master CPU will timeout and cancel
> AP onlining.
> 
> Signed-off-by: Igor Mammedov <imammedo@redhat.com>
> ---
> v7:
>  - fix stuck boot with non SMP config
>  - fix stuck paravirtual Xen SMP boot with more than 1VCPU
>    and CPU hotplug
> v6:
>  - no changes
> v5:
>  - add smp_mb() after clearing cpu_initialized_mask in do_boot_cpu()
>  - add 10 sec timeout description into commit message.
> v4:
>  - move commont code in cpu_init() for x32/x64 in shared
>    helper function wait_formaster_cpu()
>  - add WARN_ON(cpumask_test_and_set_cpu(cpu, cpu_initialized_mask))
>    to wait_formaster_cpu()
> v3:
>  - leave timeouts in do_boot_cpu(), so that master CPU
>    won't hang if AP doesn't respond, use cpu_initialized_mask
>    as a way for AP to signal to master CPU that it's ready
>    to start initialzation.
> v2:
>  - ammend comment in cpu_init()
> ---
>  arch/x86/kernel/cpu/common.c |   29 ++++++++-----
>  arch/x86/kernel/smpboot.c    |   99 +++++++++++++-----------------------------
>  arch/x86/xen/smp.c           |    2 +
>  3 files changed, 51 insertions(+), 79 deletions(-)

For the changes under arch/x86/kernel (I'm not familiar with Xen):

Acked-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi




