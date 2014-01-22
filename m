Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbaAVFxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 00:53:24 -0500
Received: from ozlabs.org ([203.10.76.45]:50166 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbaAVFxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 00:53:18 -0500
Date: Wed, 22 Jan 2014 16:52:39 +1100
From: Paul Mackerras <paulus@samba.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Deadlock between cpu_hotplug_begin and cpu_add_remove_lock
Message-ID: <20140122055239.GA29418@iris.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This arises out of a report from a tester that offlining a CPU never
finished on a system they were testing.  This was on a POWER8 running
a 3.10.x kernel, but the issue is still present in mainline AFAICS.

What I found when I looked at the system was this:

* There was a ppc64_cpu process stuck inside cpu_hotplug_begin(),
  called from _cpu_down(), from cpu_down().  This process was holding
  the cpu_add_remove_lock mutex, since cpu_down() calls
  cpu_maps_update_begin() before calling _cpu_down().  It was stuck
  there because cpu_hotplug.refcount == 1.

* There was a mdadm process trying to acquire the cpu_add_remove_lock
  mutex inside register_cpu_notifier(), called from
  raid5_alloc_percpu() in drivers/md/raid5.c.  That process had
  previously called get_online_cpus, which is why cpu_hotplug.refcount
  was 1.

Result: deadlock.

Thus it seems that the following code is not safe:

	get_online_cpus();
	register_cpu_notifier(&...);
	put_online_cpus();

There are a few different places that do that sort of thing; besides
drivers/md/raid5.c, there are instances in arch/x86/kernel/cpu,
arch/x86/oprofile, drivers/cpufreq/acpi-cpufreq.c,
drivers/oprofile/nmi_timer_int.c and kernel/trace/ring_buffer.c.

My question is this: is it reasonable to call register_cpu_notifier
inside a get/put_online_cpus block?  If so, the deadlock needs to be
fixed; if not, the callers need to be fixed, and the restriction
should be documented.

Regards,
Paul.
