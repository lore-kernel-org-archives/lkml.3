Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338AbaBNRf1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 12:35:27 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:55225 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaBNRfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 12:35:24 -0500
MIME-Version: 1.0
In-Reply-To: <20140214075511.22701.15084.stgit@srivatsabhat.in.ibm.com>
References: <20140214074750.22701.47330.stgit@srivatsabhat.in.ibm.com> <20140214075511.22701.15084.stgit@srivatsabhat.in.ibm.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 14 Feb 2014 10:35:03 -0700
Message-ID: <CAErSpo4nyoY8jCR5omywB06ka5T-qKMQURSO6c3_569o-WbOgw@mail.gmail.com>
Subject: Re: [PATCH v2 27/52] x86, pci, amd-bus: Fix CPU hotplug callback registration
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "paulus@samba.org" <paulus@samba.org>, oleg@redhat.com,
        Ingo Molnar <mingo@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>,
        Michel Lespinasse <walken@google.com>, ego@linux.vnet.ibm.com,
        Russell King <linux@arm.linux.org.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 12:55 AM, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> Subsystems that want to register CPU hotplug callbacks, as well as perform
> initialization for the CPUs that are already online, often do it as shown
> below:
>
>         get_online_cpus();
>
>         for_each_online_cpu(cpu)
>                 init_cpu(cpu);
>
>         register_cpu_notifier(&foobar_cpu_notifier);
>
>         put_online_cpus();
>
> This is wrong, since it is prone to ABBA deadlocks involving the
> cpu_add_remove_lock and the cpu_hotplug.lock (when running concurrently
> with CPU hotplug operations).
>
> Instead, the correct and race-free way of performing the callback
> registration is:
>
>         cpu_notifier_register_begin();
>
>         for_each_online_cpu(cpu)
>                 init_cpu(cpu);
>
>         /* Note the use of the double underscored version of the API */
>         __register_cpu_notifier(&foobar_cpu_notifier);
>
>         cpu_notifier_register_done();
>
>
> Fix the amd-bus code in x86 by using this latter form of callback
> registration.
>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> Cc: linux-pci@vger.kernel.org
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

This looks fine to me.

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

I think it makes sense for you to merge it along with all your other
similar changes.  I don't foresee any conflicts with things in my PCI
tree.

> ---
>
>  arch/x86/pci/amd_bus.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
> index a48be98..f05cbf0 100644
> --- a/arch/x86/pci/amd_bus.c
> +++ b/arch/x86/pci/amd_bus.c
> @@ -380,10 +380,13 @@ static int __init pci_io_ecs_init(void)
>         if (early_pci_allowed())
>                 pci_enable_pci_io_ecs();
>
> -       register_cpu_notifier(&amd_cpu_notifier);
> +       cpu_notifier_register_begin();
>         for_each_online_cpu(cpu)
>                 amd_cpu_notify(&amd_cpu_notifier, (unsigned long)CPU_ONLINE,
>                                (void *)(long)cpu);
> +       __register_cpu_notifier(&amd_cpu_notifier);
> +       cpu_notifier_register_done();
> +
>         pci_probe |= PCI_HAS_IO_ECS;
>
>         return 0;
>
