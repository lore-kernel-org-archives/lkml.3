Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526Ab3BANoo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:44:44 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:48829 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099Ab3BANom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:44:42 -0500
MIME-Version: 1.0
In-Reply-To: <20130131120742.098044736@linutronix.de>
References: <20130131120348.372374706@linutronix.de>
	<20130131120742.098044736@linutronix.de>
Date: Fri, 1 Feb 2013 21:44:41 +0800
Message-ID: <CAJd=RBCn0bM2rkXD3C6+7UZxFGO=fT7JNAcG-3SjR_zuGOZiCw@mail.gmail.com>
Subject: Re: [patch 09/40] cpu: hotplug: Implement setup/removal interface
From: Hillf Danton <dhillf@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul@jasper.es
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 8:11 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> +/**
> + * __cpuhp_setup_state - Setup the callbacks for an hotplug machine state
> + * @state:     The state to setup
> + * @invoke:    If true, the startup function is invoked for cpus where
> + *             cpu state >= @state
> + * @startup:   startup callback function
> + * @teardown:  teardown callback function
> + *
> + * Returns 0 if successful, otherwise a proper error code
> + */
> +int __cpuhp_setup_state(enum cpuhp_states state, bool invoke,
> +                       int (*startup)(unsigned int cpu),
> +                       int (*teardown)(unsigned int cpu))
> +{
> +       int cpu, ret = 0;
> +
> +       if (cpuhp_cb_check(state))
> +               return -EINVAL;
> +
> +       get_online_cpus();
> +
> +       if (!invoke || !startup)
> +               goto install;
> +
> +       /*
> +        * Try to call the startup callback for each present cpu
> +        * depending on the hotplug state of the cpu.
> +        */
> +       for_each_present_cpu(cpu) {
> +               int ret, cpustate = per_cpu(cpuhp_state, cpu);

s/ret,//

> +
> +               if (cpustate < state)
> +                       continue;
> +
> +               ret = cpuhp_issue_call(cpu, state, startup, true);
> +               if (ret) {
> +                       cpuhp_rollback_install(cpu, state, teardown);
> +                       goto out;
> +               }
> +       }
> +install:
> +       cpuhp_store_callbacks(state, startup, teardown);
> +out:
> +       put_online_cpus();
> +       return ret;
> +}
> +EXPORT_SYMBOL(__cpuhp_setup_state);
