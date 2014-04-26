Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593AbaDZIij (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 04:38:39 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:41417 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbaDZIiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 04:38:15 -0400
Message-ID: <1398501491.12941.5.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.14-rt1
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Date: Sat, 26 Apr 2014 10:38:11 +0200
In-Reply-To: <1398411635.11930.45.camel@marge.simpson.net>
References: <20140411185739.GA6644@linutronix.de>
	 <1397918766.5436.16.camel@marge.simpson.net>
	 <1398411635.11930.45.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-25 at 09:40 +0200, Mike Galbraith wrote:

> Hotplug can still deadlock in rt trees too, and will if you beat it
> hard.

Box actually deadlocks like so.

                                                CPU3 boot.kdump
                                                sys_wait4
                                                do_wait
                                                   read_lock(&tasklist_lock)
                                                      rt_read_lock
                                                         __rt_spin_lock(lock)
                                                            migrate_disable()
                                                               pin_current_cpu()
                                                                  if (hp->grab_lock) {
                                                                     preempt_enable(); <== hmm
                                                                     hotplug_lock(hp); 
                                                                       hp = &__get_cpu_var(hotplug_pcp);  <== hmm
                                                                       struct hotplug_pcp {
                                                                          unplug = 0xffff8800b7d0e540,
                                                                          sync_tsk = 0x0,
                                                                          refcount = 0, <== hmm
                                                                          grab_lock = 1,
                                                                          ...
                                                                          lock = {
                                                                             ...
                                                                             owner = 0xffff8802039f0001,
                                                                             stress-cpu-hotplug_stress.sh?!?
                                                                             <=== he's way over yonder.
                                                                             Yo, dude, would you please NOT
                                                                             take percpu locks with you?

CPU0 stress-cpu-hotplug_stress.sh
sysfs_write_file
dev_attr_store
online_store
device_offline
cpu_subsys_offline
cpu_down
_cpu_down
   cpu_hotplug_begin
       mutex_lock(&cpu_hotplug.lock);
       ...
      check_for_tasks
         write_lock_irq(&tasklist_lock);
         held by CPU3 boot.kdump over there ===>

CPU0 kworker/0:0
cpuset_hotplug_workfn+0x23e/0x380
rebuild_sched_domains+0x15/0x30
rebuild_sched_domains_locked+0x17/0x80
get_online_cpus+0x35/0x50
   mutex_lock(&cpu_hotplug.lock);
   held by stress-cpu-hotplug_stress.sh

twiddle twiddle twiddle...
INFO: task kworker/0:0:4 blocked for more than 120 seconds.


