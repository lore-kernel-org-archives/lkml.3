Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbaCYS2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 14:28:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:49936 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbaCYS2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 14:28:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,730,1389772800"; 
   d="scan'208";a="499317730"
From: Andi Kleen <andi@firstfloor.org>
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, peterz@infradead.org,
        akpm@linux-foundation.org, andi.kleen@intel.com, rob@landley.net,
        viro@zeniv.linux.org.uk, oleg@redhat.com, gnomes@lxorguk.ukuu.org.uk,
        riel@redhat.com, snorcht@gmail.com, dhowells@redhat.com,
        luto@amacapital.net, daeseok.youn@gmail.com, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2] Pre-emption control for userspace
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com>
	<1395767870-28053-1-git-send-email-khalid.aziz@oracle.com>
Date: Tue, 25 Mar 2014 11:20:04 -0700
In-Reply-To: <1395767870-28053-1-git-send-email-khalid.aziz@oracle.com>
	(Khalid Aziz's message of "Tue, 25 Mar 2014 11:17:50 -0600")
Message-ID: <871txqp2cr.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Khalid Aziz <khalid.aziz@oracle.com> writes:

First it would be nice to have some standard reference lock library that
uses this. What would it take to support this in glibc?

> +==================================
> +Using the preemption delay feature
> +==================================
> +
> +This feature is enabled in the kernel by setting
> +CONFIG_SCHED_PREEMPT_DELAY in kernel configuration. Once this feature is
> +enabled, the userspace process communicates with the kernel using a
> +4-byte memory location in its address space. It first gives the kernel
> +address for this memory location by writing its address to
> +/proc/<tgid>/task/<tid>/sched_preempt_delay. This memory location is
> +interpreted as a sequence of 4 bytes:
> +
> +	byte[0] = flag to request preemption delay
> +	byte[1] = flag from kernel indicating preemption delay was granted
> +	byte[2] = reserved for future use
> +	byte[3] = reserved for future use

Should reserve more bytes (64, 128?) and rename the proc flag
to a more generic name. I could well assume other things
using such a mechanism in the future. Also please add a flag
word with feature bits (similar to the perf mmap page)

How about alignment? x86 will not care, but other architectures
may. 

>  #endif
> +#ifdef CONFIG_SCHED_PREEMPT_DELAY
> +	REG("sched_preempt_delay", S_IRUGO|S_IWUSR,
> proc_tid_preempt_delay_ops),

This shouldn't be readable by group/other, as it exposes the address space,
so could help exploits.

> @@ -2061,6 +2069,13 @@ extern u64 scheduler_tick_max_deferment(void);
>  static inline bool sched_can_stop_tick(void) { return false; }
>  #endif
>  
> +#if defined(CONFIG_SCHED_PREEMPT_DELAY) && defined(CONFIG_PROC_FS)
> +extern void sched_preempt_delay_show(struct seq_file *m,
> +					struct task_struct *task);
> +extern void sched_preempt_delay_set(struct task_struct *task,
> +					unsigned char *val);
> +#endif

Prototypes don't need to be ifdefed.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
