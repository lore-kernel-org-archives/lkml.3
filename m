Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933AbaJXQgO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 12:36:14 -0400
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:33745 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756379AbaJXQgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 12:36:13 -0400
Date: Fri, 24 Oct 2014 12:36:12 -0400
From: Eric B Munson <emunson@akamai.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Commit 35ce7f29a breaks hibernation for XPS 13
Message-ID: <20141024163612.GA2256@akamai.com>
References: <20141024160815.GA2968@akamai.com>
 <20141024161634.GR4977@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141024161634.GR4977@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2014, Paul E. McKenney wrote:

> On Fri, Oct 24, 2014 at 12:08:15PM -0400, Eric B Munson wrote:
> > Paul,
> > 
> > As of 3.18-rc1 I can no longer hibernate my Dell XPS-13.  Bisect points
> > the finger at 35ce7f29a.  A revert of that commit confirms, I can once
> > again hibernate my machine without it.
> > 
> > When the hibernation fails I see this in dmesg:
> > [   37.953313] PM: Syncing filesystems ... done.
> > [   37.963694] Freezing user space processes ... (elapsed 0.001 seconds) done.
> > [   37.965297] PM: Marking nosave pages: [mem 0x00000000-0x00000fff]
> > [   37.965299] PM: Marking nosave pages: [mem 0x00058000-0x00058fff]
> > [   37.965301] PM: Marking nosave pages: [mem 0x0009d000-0x000fffff]
> > [   37.965304] PM: Marking nosave pages: [mem 0xc496a000-0xc4b6bfff]
> > [   37.965315] PM: Marking nosave pages: [mem 0xdadb7000-0xdcffefff]
> > [   37.965479] PM: Marking nosave pages: [mem 0xdd000000-0xffffffff]
> > [   37.966000] PM: Basic memory bitmaps created
> > [   37.966046] PM: Preallocating image memory... done (allocated 181989 pages)
> > [   38.141524] PM: Allocated 727956 kbytes in 0.17 seconds (4282.09 MB/s)
> > [   38.141525] Freezing remaining freezable tasks ... 
> > [   58.151863] Freezing of tasks failed after 20.004 seconds (0 tasks refusing to freeze, wq_busy=1):
> > [   58.151894] 
> > [   58.151896] Restarting kernel threads ... done.
> > [   58.181915] PM: Basic memory bitmaps freed
> > [   58.181917] Restarting tasks ... done.
> > 
> > 
> > I am not sure what else I can provide that might be useful, but I did
> > see the thread on net-dev about this same commit.  Please CC me on any
> > fixes and I will be happy to test.
> 
> Thank you for the bug report!
> 
> Does the following patch help?
> 
> 							Thanx, Paul

Paul,

This patch does not help.  I see the same dmesg output and failure to
hibernate.

Eric

> 
> ------------------------------------------------------------------------
> 
> rcu: More on deadlock between CPU hotplug and expedited grace periods
> 
> Commit dd56af42bd82 (rcu: Eliminate deadlock between CPU hotplug and
> expedited grace periods) was incomplete.  Although it did eliminate
> deadlocks involving synchronize_sched_expedited()'s acquisition of
> cpu_hotplug.lock via get_online_cpus(), it did nothing about the similar
> deadlock involving acquisition of this same lock via put_online_cpus().
> This deadlock became apparent with testing involving hibernation.
> 
> This commit therefore changes put_online_cpus() acquisition of this lock
> to be conditional, and increments a new cpu_hotplug.puts_pending field
> in case of acquisition failure.  Then cpu_hotplug_begin() checks for this
> new field being non-zero, and applies any changes to cpu_hotplug.refcount.
> 
> Reported-by: Jiri Kosina <jkosina@suse.cz>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Tested-by: Jiri Kosina <jkosina@suse.cz>
> Tested-by: Borislav Petkov <bp@suse.de>
> 
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index 356450f09c1f..90a3d017b90c 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -64,6 +64,8 @@ static struct {
>  	 * an ongoing cpu hotplug operation.
>  	 */
>  	int refcount;
> +	/* And allows lockless put_online_cpus(). */
> +	atomic_t puts_pending;
>  
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
>  	struct lockdep_map dep_map;
> @@ -113,7 +115,11 @@ void put_online_cpus(void)
>  {
>  	if (cpu_hotplug.active_writer == current)
>  		return;
> -	mutex_lock(&cpu_hotplug.lock);
> +	if (!mutex_trylock(&cpu_hotplug.lock)) {
> +		atomic_inc(&cpu_hotplug.puts_pending);
> +		cpuhp_lock_release();
> +		return;
> +	}
>  
>  	if (WARN_ON(!cpu_hotplug.refcount))
>  		cpu_hotplug.refcount++; /* try to fix things up */
> @@ -155,6 +161,12 @@ void cpu_hotplug_begin(void)
>  	cpuhp_lock_acquire();
>  	for (;;) {
>  		mutex_lock(&cpu_hotplug.lock);
> +		if (atomic_read(&cpu_hotplug.puts_pending)) {
> +			int delta;
> +
> +			delta = atomic_xchg(&cpu_hotplug.puts_pending, 0);
> +			cpu_hotplug.refcount -= delta;
> +		}
>  		if (likely(!cpu_hotplug.refcount))
>  			break;
>  		__set_current_state(TASK_UNINTERRUPTIBLE);
> 
