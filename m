Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbaBFBZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 20:25:35 -0500
Received: from mail-pb0-f68.google.com ([209.85.160.68]:57770 "EHLO
	mail-pb0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbaBFBZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 20:25:33 -0500
Date: Wed, 5 Feb 2014 17:25:31 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: paulus@samba.org, oleg@redhat.com, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org,
        walken@google.com, ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>,
        Jean Delvare <jdelvare@suse.de>, lm-sensors@lm-sensors.org
Subject: Re: [PATCH 42/51] hwmon, coretemp: Fix CPU hotplug callback
 registration
Message-ID: <20140206012531.GA3887@roeck-us.net>
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
 <20140205221205.19080.15108.stgit@srivatsabhat.in.ibm.com>
 <20140206004412.GA1308@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140206004412.GA1308@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 05, 2014 at 04:44:12PM -0800, Guenter Roeck wrote:
> On Thu, Feb 06, 2014 at 03:42:06AM +0530, Srivatsa S. Bhat wrote:
> > Subsystems that want to register CPU hotplug callbacks, as well as perform
> > initialization for the CPUs that are already online, often do it as shown
> > below:
> > 
> > 	get_online_cpus();
> > 
> > 	for_each_online_cpu(cpu)
> > 		init_cpu(cpu);
> > 
> > 	register_cpu_notifier(&foobar_cpu_notifier);
> > 
> > 	put_online_cpus();
> > 
> > This is wrong, since it is prone to ABBA deadlocks involving the
> > cpu_add_remove_lock and the cpu_hotplug.lock (when running concurrently
> > with CPU hotplug operations).
> > 
> > Instead, the correct and race-free way of performing the callback
> > registration is:
> > 
> > 	cpu_maps_update_begin();
> > 
> > 	for_each_online_cpu(cpu)
> > 		init_cpu(cpu);
> > 
> > 	/* Note the use of the double underscored version of the API */
> > 	__register_cpu_notifier(&foobar_cpu_notifier);
> > 
> > 	cpu_maps_update_done();
> > 
> > 
> > Fix the hwmon coretemp code by using this latter form of callback
> > registration.
> > 
> > Cc: Fenghua Yu <fenghua.yu@intel.com>
> > Cc: Jean Delvare <jdelvare@suse.de>
> > Cc: Guenter Roeck <linux@roeck-us.net>
> > Cc: lm-sensors@lm-sensors.org
> > Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> 
> Applied.
> 
That obviously doesn't build ;-). Replace with 

Acked-by: Guenter Roeck <linux@roeck-us.net>

Guenter
