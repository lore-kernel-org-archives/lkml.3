Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab3DYG5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 02:57:10 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:63770 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab3DYG5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 02:57:08 -0400
Date: Thu, 25 Apr 2013 08:57:04 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robin Holt <holt@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Russ Anderson <rja@sgi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH -v6 2/5] Migrate shutdown/reboot to boot cpu.
Message-ID: <20130425065704.GE7806@gmail.com>
References: <1366802333-8890-1-git-send-email-holt@sgi.com>
 <1366802333-8890-3-git-send-email-holt@sgi.com>
 <20130424151749.30b0680dc9392b110537bcd5@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130424151749.30b0680dc9392b110537bcd5@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 24 Apr 2013 06:18:50 -0500 Robin Holt <holt@sgi.com> wrote:
> 
> > We recently noticed that reboot of a 1024 cpu machine takes approx 16
> > minutes of just stopping the cpus.  The slowdown was tracked to commit
> > f96972f.
> > 
> > The current implementation does all the work of hot removing the cpus
> > before halting the system.  We are switching to just migrating to the
> > boot cpu and then continuing with shutdown/reboot.
> > 
> > This also has the effect of not breaking x86's command line parameter for
> > specifying the reboot cpu.  Note, this code was shamelessly copied from
> > arch/x86/kernel/reboot.c with bits removed pertaining to the reboot_cpu
> > command line parameter.
> > 
> > @@ -357,6 +357,24 @@ int unregister_reboot_notifier(struct notifier_block *nb)
> >  }
> >  EXPORT_SYMBOL(unregister_reboot_notifier);
> >  
> > +static void migrate_to_reboot_cpu(void)
> > +{
> > +	/* The boot cpu is always logical cpu 0 */
> > +	int reboot_cpu_id = 0;
> > +
> > +	cpu_hotplug_disable();
> > +
> > +	/* Make certain the cpu I'm about to reboot on is online */
> > +	if (!cpu_online(reboot_cpu_id))
> > +		reboot_cpu_id = cpumask_first(cpu_online_mask);
> > +
> > +	/* Prevent races with other tasks migrating this task */
> > +	current->flags |= PF_THREAD_BOUND;
> 
> PF_THREAD_BOUND was removed/replaced in linux-next's a9ab775bc
> ("workqueue: directly restore CPU affinity of workers from CPU_ONLINE")

I don't see PF_THREAD_BOUND being removed by commit a9ab775bc. Did you 
mean some other commit?

Thanks,

	Ingo
