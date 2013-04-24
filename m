Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540Ab3DXWRw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 18:17:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44119 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758403Ab3DXWRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 18:17:52 -0400
Date: Wed, 24 Apr 2013 15:17:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Robin Holt <holt@sgi.com>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Russ Anderson <rja@sgi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH -v6 2/5] Migrate shutdown/reboot to boot cpu.
Message-Id: <20130424151749.30b0680dc9392b110537bcd5@linux-foundation.org>
In-Reply-To: <1366802333-8890-3-git-send-email-holt@sgi.com>
References: <1366802333-8890-1-git-send-email-holt@sgi.com>
	<1366802333-8890-3-git-send-email-holt@sgi.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Apr 2013 06:18:50 -0500 Robin Holt <holt@sgi.com> wrote:

> We recently noticed that reboot of a 1024 cpu machine takes approx 16
> minutes of just stopping the cpus.  The slowdown was tracked to commit
> f96972f.
> 
> The current implementation does all the work of hot removing the cpus
> before halting the system.  We are switching to just migrating to the
> boot cpu and then continuing with shutdown/reboot.
> 
> This also has the effect of not breaking x86's command line parameter for
> specifying the reboot cpu.  Note, this code was shamelessly copied from
> arch/x86/kernel/reboot.c with bits removed pertaining to the reboot_cpu
> command line parameter.
> 
> @@ -357,6 +357,24 @@ int unregister_reboot_notifier(struct notifier_block *nb)
>  }
>  EXPORT_SYMBOL(unregister_reboot_notifier);
>  
> +static void migrate_to_reboot_cpu(void)
> +{
> +	/* The boot cpu is always logical cpu 0 */
> +	int reboot_cpu_id = 0;
> +
> +	cpu_hotplug_disable();
> +
> +	/* Make certain the cpu I'm about to reboot on is online */
> +	if (!cpu_online(reboot_cpu_id))
> +		reboot_cpu_id = cpumask_first(cpu_online_mask);
> +
> +	/* Prevent races with other tasks migrating this task */
> +	current->flags |= PF_THREAD_BOUND;

PF_THREAD_BOUND was removed/replaced in linux-next's a9ab775bc
("workqueue: directly restore CPU affinity of workers from CPU_ONLINE")


