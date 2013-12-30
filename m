Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab3L3PIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 10:08:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755979Ab3L3PIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 10:08:49 -0500
Message-ID: <52C18C6B.8090802@redhat.com>
Date: Mon, 30 Dec 2013 10:08:27 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: rui wang <ruiv.wang@gmail.com>
CC: Tony Luck <tony.luck@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, X86-ML <x86@kernel.org>,
        Michel Lespinasse <walken@google.com>, Andi Kleen <ak@linux.intel.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>, janet.morgan@intel.com,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        chen gong <gong.chen@linux.intel.com>
Subject: Re: [PATCH] x86: Add check for number of available vectors before
 CPU down [v2]
References: <1387394945-5704-1-git-send-email-prarit@redhat.com>	<CA+8MBbKHZ0i0mEYLUrmWwaofvnRcxc7Dvm+w0CfZf2uQydjdjQ@mail.gmail.com>	<CA+8MBbLMFW5fnUdgNRFpPv9+U1DqB5AeoDOV44kZHozibxjqSg@mail.gmail.com>	<52B336D4.8010809@redhat.com>	<CANVTcTa2AiHYrLQt-P_=4GmER_mqbSCZwY13phOkSA4XxrzF=A@mail.gmail.com>	<52BF060E.7090905@redhat.com> <CANVTcTbNqwzVBzqzGisbUJGtVCa9RtA6OuD4hVp0O39Nz_KDrQ@mail.gmail.com>
In-Reply-To: <CANVTcTbNqwzVBzqzGisbUJGtVCa9RtA6OuD4hVp0O39Nz_KDrQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/30/2013 07:56 AM, rui wang wrote:

> An irq can be mapped to only one vector number, but can have multiple
> destination CPUs. i.e. the same irq/vector can appear on multiple
> CPUs' vector_irq[]. So checking data->affinity is necessary I think.

That's true Rui -- but here's what I think the scenario actually is.

Suppose we have a 4-cpu system, and we have an IRQ that is mapped to multiple
cpu's vector_irq[].  For example, we have IRQ 200 that is mapped to CPU 2
vector_irq[50], and CPU 3 vector_irq[60].

Now I 'echo 0 > /sys/devices/system/cpu/cpu3/online'.

cpu_disable is called and the kernel migrates IRQs off to other cpus.
Regardless if IRQ 200 is already mapped to CPU2 vector_irq[50], the mapping for
CPU 3 vector_irq[60] *must be migrated* to another CPU.  It has a valid irq
handler and the IRQ is active.  It doesn't just disappear because the CPU went down.

ie) AFAICT we should not differentiate between a multiple mapped IRQ and a
singly mapped IRQ when traversing the vector_irq[] for CPU 3.

I'm probably being dense on this but I'm not seeing a problem with migrating the
IRQ.

> But notice that data->affinity is updated in chip->irq_set_affinity()
> inside fixup_irqs(), while cpu_online_mask is updated in
> remove_cpu_from_maps() inside cpu_disable_common(). 

It shouldn't matter that the maps are updated in different areas during the
execution as we're in stop_machine().

They are updated
> in different places. So the algorithm to check them against each other
> should be different, depending on where you put the check_vectors().
> That's my understanding.
> 

P.

> Thanks
> Rui
