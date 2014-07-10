Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbaGJQUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 12:20:22 -0400
Received: from service87.mimecast.com ([91.220.42.44]:39086 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaGJQUU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 12:20:20 -0400
From: "Javi Merino" <javi.merino@arm.com>
Date: Thu, 10 Jul 2014 17:20:14 +0100
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Punit Agrawal <Punit.Agrawal@arm.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC PATCH v5 09/10] thermal: add trace events to the power
 allocator governor
Message-ID: <20140710162014.GB2622@e104805>
References: <1405001928-12697-1-git-send-email-javi.merino@arm.com>
 <1405001928-12697-10-git-send-email-javi.merino@arm.com>
 <20140710114451.4bbf6785@gandalf.local.home>
MIME-Version: 1.0
In-Reply-To: <20140710114451.4bbf6785@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 10 Jul 2014 16:20:15.0191 (UTC) FILETIME=[D5052E70:01CF9C5A]
X-MC-Unique: 114071017201804801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 04:44:51PM +0100, Steven Rostedt wrote:
> On Thu, 10 Jul 2014 15:18:47 +0100
> "Javi Merino" <javi.merino@arm.com> wrote:
> 
> > Add trace events for the power allocator governor and the power actor
> > interface of the cpu cooling device.
> > 
> > Cc: Zhang Rui <rui.zhang@intel.com>
> > Cc: Eduardo Valentin <edubezval@gmail.com>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Signed-off-by: Javi Merino <javi.merino@arm.com>
> > ---
> >  drivers/thermal/cpu_actor.c                    |  17 ++-
> >  drivers/thermal/power_allocator.c              |  22 +++-
> >  include/trace/events/thermal_power_allocator.h | 138 +++++++++++++++++++++++++
> >  3 files changed, 173 insertions(+), 4 deletions(-)
> >  create mode 100644 include/trace/events/thermal_power_allocator.h
> > 
> > diff --git a/drivers/thermal/cpu_actor.c b/drivers/thermal/cpu_actor.c
> > index 45ea4fa92ea0..b5ed2e80e288 100644
> > --- a/drivers/thermal/cpu_actor.c
> > +++ b/drivers/thermal/cpu_actor.c
> > @@ -28,6 +28,8 @@
> >  #include <linux/printk.h>
> >  #include <linux/slab.h>
> >  
> > +#include <trace/events/thermal_power_allocator.h>
> > +
> >  /**
> >   * struct power_table - frequency to power conversion
> >   * @frequency:	frequency in KHz
> > @@ -184,11 +186,12 @@ static u32 get_static_power(struct cpu_actor *cpu_actor,
> >   */
> >  static u32 get_dynamic_power(struct cpu_actor *cpu_actor, unsigned long freq)
> >  {
> > -	int cpu;
> > -	u32 power = 0, raw_cpu_power, total_load = 0;
> > +	int i, cpu;
> > +	u32 power = 0, raw_cpu_power, total_load = 0, load_cpu[NR_CPUS];
> 
> When NR_CPUS == 1024, you just killed the stack, as you added 4K to it.
> We upped the stack recently to 16k, but still.

True, this array should be static.

> >  
> >  	raw_cpu_power = cpu_freq_to_power(cpu_actor, freq);
> >  
> > +	i = 0;
> >  	for_each_cpu(cpu, &cpu_actor->cpumask) {
> >  		u32 load;
> >  
> > @@ -198,8 +201,15 @@ static u32 get_dynamic_power(struct cpu_actor *cpu_actor, unsigned long freq)
> >  		load = get_load(cpu_actor, cpu);
> >  		power += (raw_cpu_power * load) / 100;
> >  		total_load += load;
> > +		load_cpu[i] = load;
> > +
> > +		i++;
> >  	}
> >  
> > +	trace_thermal_power_actor_cpu_get_dyn_power(&cpu_actor->cpumask, freq,
> > +						raw_cpu_power, load_cpu, i,
> > +						power);
> 
> How many CPUs are you saving load_cpu on? A trace event can't be bigger
> than a page. And the data is actually a little less than that with the
> required headers.

The biggest system I've tested it on is an 8 cpu system (with
NR_CPUS==8).  So yes, small and we haven't seen any issues.

Are you saying that we are siphoning too much data through ftrace?  He
find it really valuable to collect information during run and process
it afterwards but I can see how this may not be feasible for systems
with thousands of cpus.

