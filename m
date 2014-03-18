Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796AbaCRWIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 18:08:12 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:62731 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756803AbaCRWII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 18:08:08 -0400
MIME-Version: 1.0
In-Reply-To: <53281E89.7080201@linux.vnet.ibm.com>
References: <20140310203312.10746.310.stgit@srivatsabhat.in.ibm.com>
	<20140310203538.10746.25364.stgit@srivatsabhat.in.ibm.com>
	<20140312232127.GC24808@cbox>
	<53229701.8050405@linux.vnet.ibm.com>
	<20140314191055.GF28661@cbox>
	<53281E89.7080201@linux.vnet.ibm.com>
Date: Tue, 18 Mar 2014 15:08:06 -0700
Message-ID: <CAMJs5B9kVX9urC2PCXY2kbH-j1fA8bge0KQa1z0nK+A689SNYg@mail.gmail.com>
Subject: Re: [UPDATED PATCH v3 10/52] arm, kvm: Fix CPU hotplug callback registration
From: Christoffer Dall <christoffer.dall@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: ego@linux.vnet.ibm.com, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        peterz@infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>,
        Michel Lespinasse <walken@google.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        linux-arch@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        mingo@kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, linux-pm@vger.kernel.org,
        Gleb Natapov <gleb@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        rjw@rjwysocki.net, oleg@redhat.com, tj@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 March 2014 03:23, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> On 03/15/2014 12:40 AM, Christoffer Dall wrote:
>> On Fri, Mar 14, 2014 at 11:13:29AM +0530, Srivatsa S. Bhat wrote:
>>> On 03/13/2014 04:51 AM, Christoffer Dall wrote:
>>>> On Tue, Mar 11, 2014 at 02:05:38AM +0530, Srivatsa S. Bhat wrote:
>>>>> Subsystems that want to register CPU hotplug callbacks, as well as perform
>>>>> initialization for the CPUs that are already online, often do it as shown
>>>>> below:
>>>>>
> [...]
>>>> Just so we're clear, the existing code was simply racy as not prone to
>>>> deadlocks, right?
>>>>
>>>> This makes it clear that the test above for compatible CPUs can be quite
>>>> easily evaded by using CPU hotplug, but we don't really have a good
>>>> solution for handling that yet...  Hmmm, grumble grumble, I guess if you
>>>> hotplug unsupported CPUs on a KVM/ARM system for now, stuff will break.
>>>>
>>>
>>> In this particular case, there was no deadlock possibility, rather the
>>> existing code had insufficient synchronization against CPU hotplug.
>>>
>>> init_hyp_mode() would invoke cpu_init_hyp_mode() on currently online CPUs
>>> using on_each_cpu(). If a CPU came online after this point and before calling
>>> register_cpu_notifier(), that CPU would remain uninitialized because this
>>> subsystem would miss the hot-online event. This patch fixes this bug and
>>> also uses the new synchronization method (instead of get/put_online_cpus())
>>> to ensure that we don't deadlock with CPU hotplug.
>>>
>>
>> Yes, that was my conclusion as well.  Thanks for clarifying.  (It could
>> be noted in the commit message as well if you should feel so inclined).
>>
>
> Please find the patch with updated changelog (and your Ack) below.
> (No changes in code).
>

perfect, thanks!

> From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Subject: [PATCH] arm, kvm: Fix CPU hotplug callback registration
>
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
> In the existing arm kvm code, there is no synchronization with CPU hotplug
> to avoid missing the hotplug events that might occur after invoking
> init_hyp_mode() and before calling register_cpu_notifier(). Fix this bug
> and also use the new synchronization method (instead of get/put_online_cpus())
> to ensure that we don't deadlock with CPU hotplug.
>
> Cc: Gleb Natapov <gleb@kernel.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: kvmarm@lists.cs.columbia.edu
> Cc: kvm@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
>
>  arch/arm/kvm/arm.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index bd18bb8..f0e50a0 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -1051,21 +1051,26 @@ int kvm_arch_init(void *opaque)
>                 }
>         }
>
> +       cpu_notifier_register_begin();
> +
>         err = init_hyp_mode();
>         if (err)
>                 goto out_err;
>
> -       err = register_cpu_notifier(&hyp_init_cpu_nb);
> +       err = __register_cpu_notifier(&hyp_init_cpu_nb);
>         if (err) {
>                 kvm_err("Cannot register HYP init CPU notifier (%d)\n", err);
>                 goto out_err;
>         }
>
> +       cpu_notifier_register_done();
> +
>         hyp_cpu_pm_init();
>
>         kvm_coproc_table_init();
>         return 0;
>  out_err:
> +       cpu_notifier_register_done();
>         return err;
>  }
>
>
>
