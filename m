Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885Ab3JOAEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 20:04:39 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:13070 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757234Ab3JOAEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 20:04:37 -0400
Message-ID: <1381795255.26234.97.camel@misato.fc.hp.com>
Subject: Re: [PATCH] mm: Set N_CPU to node_states during boot
From: Toshi Kani <toshi.kani@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Date: Mon, 14 Oct 2013 18:00:55 -0600
In-Reply-To: <20131014161047.4a6a54e985d68a9f1ce7234b@linux-foundation.org>
References: <1381781096-13168-1-git-send-email-toshi.kani@hp.com>
	 <20131014161047.4a6a54e985d68a9f1ce7234b@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-14 at 16:10 -0700, Andrew Morton wrote:
> On Mon, 14 Oct 2013 14:04:56 -0600 Toshi Kani <toshi.kani@hp.com> wrote:
> 
> > After a system booted, N_CPU is not set to any node as has_cpu
> > shows an empty line.
> > 
> >   # cat /sys/devices/system/node/has_cpu
> >   (show-empty-line)
> > 
> > setup_vmstat() registers its CPU notifier callback,
> > vmstat_cpuup_callback(), which marks N_CPU to a node when
> > a CPU is put into online.  However, setup_vmstat() is called
> > after all CPUs are launched in the boot sequence.
> > 
> > Change setup_vmstat() to mark N_CPU to the nodes with online
> > CPUs at boot.
> > 
> > ...
> >
> > --- a/mm/vmstat.c
> > +++ b/mm/vmstat.c
> > @@ -1276,8 +1276,10 @@ static int __init setup_vmstat(void)
> >  
> >  	register_cpu_notifier(&vmstat_notifier);
> >  
> > -	for_each_online_cpu(cpu)
> > +	for_each_online_cpu(cpu) {
> >  		start_cpu_timer(cpu);
> > +		node_set_state(cpu_to_node(cpu), N_CPU);
> > +	}
> >  #endif
> >  #ifdef CONFIG_PROC_FS
> >  	proc_create("buddyinfo", S_IRUGO, NULL, &fragmentation_file_operations);
> 
> This seems a bit hacky.  Would it not be better to register
> vmstat_notifier() before bringing up CPUs?

Good question.  I evaluated two approaches and chose this way with the
reasons below.

First, this way is consistent with other operations.
vmstat_cpuup_callback() calls the following three functions at
CPU_ONLINE.

  - refresh_zone_stat_thresholds()
  - start_cpu_timer(cpu)
  - node_set_state(cpu_to_node(cpu), N_CPU)

init_per_zone_wmark_min() calls refresh_zone_stat_thresholds() from its
module_init entry point.  setup_vmstat() already calls start_cpu_timer()
for all online CPUs.  So, the existing code already assumes that
vmstat_cpuup_callback() does not get called during boot.

Second, it is not optimal to call refresh_zone_stat_thresholds() for all
CPUs since this is a system-wide operation.  There can be many CPUs on
large systems.

Lastly, the kernel panic'd at boot when I tested to move it up.  I did
not root cause it (since that was a quick experiment), but I can look
into the issue if necessary.

> And this patch might be racy as well - what happens if a CPU comes up
> and goes down again before setup_vmstat() is called?

I am not sure if a CPU comes and goes during module_init(), but I will
protect the for-loop with get_online_cpus() for safe.

  + get_online_cpus();
    for_each_online_cpu(cpu) {
 	:
    }
  + put_online_cpus();

> (Where does N_CPU get cleared?  It doesn't, afaict.  Should we clear it
> if a node's final CPU goes offline?)

Right, I noticed it as well.  Let me try to fix it with a separate
patch.

Thanks,
-Toshi

