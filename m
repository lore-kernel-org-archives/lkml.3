Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab3FXKI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 06:08:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47258 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab3FXKI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 06:08:28 -0400
Date: Mon, 24 Jun 2013 12:08:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <rric@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/14] perf, persistent: Kernel updates for perf tool
 integration
Message-ID: <20130624100819.GQ28407@twins.programming.kicks-ass.net>
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370968960-22527-1-git-send-email-rric@kernel.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 06:42:26PM +0200, Robert Richter wrote:
> This patch set implements out of the box support of perf tools for
> persistent events. For this the kernel must provide necessary
> information about existing persistent events via sysfs to userland.
> Persistent events are provided by the kernel with readonly event
> buffers. To allow the independent usage of the event buffers by any
> process without limiting other processes, multiple users of a single
> event must be handled too.
> 
> The basic concept is to use a pmu as an event container for persistent
> events. The pmu registers events in sysfs and provides format and
> event information for the userland. The persistent event framework
> requires to add events to the pmu dynamically.
> 
> With the information in sysfs userland knows about how to setup the
> perf_event attribute of a persistent event. Since a persistent event
> always has the persistent flag set, a way is needed to express this in
> sysfs. A new syntax is used for this. With 'attr<num>:<mask>' any bit
> in the attribute structure may be set in a similar way as using
> 'config<num>', but <num> is an index that points to the u64 value to
> change within the attribute.
> 
> For persistent events the persistent flag (bit 23 of flag field in
> struct perf_event_attr) needs to be set which is expressed in sysfs
> with "attr5:23". E.g. the mce_record event is described in sysfs as
> follows:
> 
>  /sys/bus/event_source/devices/persistent/events/mce_record:persistent,config=106
>  /sys/bus/event_source/devices/persistent/format/persistent:attr5:23
> 
> Note that perf tools need to support the 'attr<num>' syntax that is
> added in a separate patch set. With it we are able to run perf tool
> commands to read persistent events, e.g.:
> 
>  # perf record -e persistent/mce_record/ sleep 10
>  # perf top -e persistent/mce_record/
> 
> In general the new syntax is flexible to describe with sysfs any event
> to be setup by perf tools.
> 
> First patches contain also fixes and reworks made after reviewing
> code. Could be applied separately.
> 
> Patches base on Boris' patches which I have rebased to latest
> tip/perf/core. All patches can be found here:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git persistent-v2
> 

OK, so I gave up on reading the patches :/ and went and looked at the git
tree. There's just too much needless churn in the patches.

As already said somewhere else; get_persistent_event() -- although that
wasn't the name at the time -- needs a better match function.


+ int perf_add_persistent_event(struct perf_event_attr *attr, unsigned nr_pages)
+ {
+ 	struct perf_event *event;
+ 	int i;
+ 
+ 	for_each_possible_cpu(i) {
+ 		event = add_persistent_event_on_cpu(i, attr, nr_pages);
+ 		if (IS_ERR(event))
+ 			goto unwind;
+ 	}
+ 	return 0;
+ 
+ unwind:
+ 	pr_err("%s: Error adding persistent event on cpu %d: %ld\n",
+ 		__func__, i, PTR_ERR(event));
+ 
+ 	while (--i >= 0)
+ 		del_persistent_event(i, attr);
+ 
+ 	return PTR_ERR(event);
+ }

This assumes cpu_possible_mask doesn't have holes in; I'm fairly sure we cannot
assume such.

Furthermore; while the function is exposed and thus looks like a generic usable
thing; however it looks to 'forget' making a sysfs entry, making it look like
something incomplete.

Only the ill named perf_add_persistent_event_by_id() function looks
something that's usable outside of this.


What's with MAX_EVENTS ?



