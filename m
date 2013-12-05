Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab3LEVnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 16:43:25 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:55392 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab3LEVnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 16:43:24 -0500
MIME-Version: 1.0
In-Reply-To: <20131204164627.GA27677@infradead.org>
References: <20131204164627.GA27677@infradead.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 5 Dec 2013 14:43:03 -0700
Message-ID: <CAErSpo49VvgpoRpS2+KHJe=zWhzR6sXdcrGdYQ5MGemi3m_Xuw@mail.gmail.com>
Subject: Re: smp_call_function_single with wait=0 considered harmful
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        Robert Richter <rric@kernel.org>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        David Daney <david.daney@cavium.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 4, 2013 at 9:46 AM, Christoph Hellwig <hch@infradead.org> wrote:
> While doing my recent work on the generic smp function calls I noticed
> that smp_call_function_single without the wait flag can't work, as
> it allocates struct call_single_data on stack, and without the wait
> flag will happily return before the IPI has been executed.

I don't understand the problem yet.  With wait==0,
smp_call_function_single() sets "csd = &__get_cpu_var(csd_data)", so
it's not using a struct on the stack.  We'll queue up "func" and
likely will return before it is executed, but that should be fine
because nobody will overwrite csd_data until it *is* executed and
csd_unlock() has been called.

> This affects the following callers:
>
>   arch/ia64/kernel/mca.c:mca_cpu_callback()
>   arch/ia64/kernel/smpboot.c:ia64_sync_itc()
>   arch/x86/kernel/kvm.c:kvm_cpu_notify()
>   arch/x86/oprofile/nmi_int.c:oprofile_cpu_notifier()
>   arch/x86/pci/amd_bus.c:amd_cpu_notify()

I don't see any reason why amd_cpu_notify() needs to use wait==0.

>   drivers/staging/octeon/ethernet-rx.c:cvm_oct_enable_one_cpu()
>   kernel/stop_machine.c:stop_two_cpus()
>
> It would be good to get these fixed so that we could remove the
> parameter.  Either convert them to wait, or use a preallocated
> call_single_data and __smp_call_function_single.
>
> After that I'd like to remove the wait argument to prevent further
> abuses.
