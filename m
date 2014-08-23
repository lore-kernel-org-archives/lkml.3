Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbaHWAXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 20:23:30 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:38518 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365AbaHWAX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 20:23:29 -0400
Date: Fri, 22 Aug 2014 17:23:21 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: mingo@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        ak@linux.intel.com, peterz@infradead.org, eranian@google.com,
        dev@codyps.com, Michael Ellerman <michaele@au1.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 00/14] Add support for parameterized events from sysfs
Message-ID: <20140823002321.GA22172@us.ibm.com>
References: <1408087583-32239-1-git-send-email-sukadev@linux.vnet.ibm.com>
 <20140820141545.GA3242@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140820141545.GA3242@krava.brq.redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082300-5806-0000-0000-00000048EB85
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa [jolsa@redhat.com] wrote:

<snip>
| > Description of the sysfs contents when events are parameterized (copied from an
| > included patch):
| > 
| > 	Examples:
| > 
| > 		domain=0x1,offset=0x8,starting_index=phys_cpu
| > 
| > 	In the case of the last example, a value replacing "phys_cpu"
| > 	would need to be provided by the user selecting the particular
| > 	event. This is refered to as "event parameterization". All
| > 	non-numerical values indicate an event parameter.
| > 
| > Notes on how perf-list displays parameterized events (and how to use them,
| > again culled from an included patch):
| > 
| > 	PARAMETERIZED EVENTS
| > 	--------------------
| > 
| > 	Some pmu events listed by 'perf-list' will be displayed with '?' in
| > 	them. For example:
| > 
| > 	  hv_gpci/dtbp_ptitc,phys_processor_idx=?/
| > 
| > 	This means that when provided as an event, a value for
| > 	phys_processor_idx must also be supplied. For example:
| > 
| > 	  perf stat -e 'hv_gpci/dtbp_ptitc,phys_processor_idx=0x2/' ...
| 
| hi,
| is the reason for this to document this field for event
| in "events/<event>" file?

We are trying to document that for the parameters that have the ? in
perf list, the parameter must be specified otherwise the event will
not be recognized.

| 
| Because once you have the field (phys_processor_idx) defined in
| "formats/phys_processor_idx" you should be able to use it as in
| your example:
| 
|    perf stat -e 'hv_gpci/dtbp_ptitc,phys_processor_idx=0x2/'
| 
| without any changes

For some events 'starting_index' refers to physical processor index
as shown in the sysfs entry:

	$ cd /sys/bus/event_source/devices/hv_gpci/events
 	$ cat dispatch_timebase_by_processor_processor_time_in_timebase_cycles
	request=0x10,starting_index=phys_processor_idx,counter_info_version=0x8,length=8,offset=0

and 'perf list' for this entry shows 'starting_index' with a ?
indicating it is a requireed parameter.

IIUC, rather than have the user specify a value for 'phys_processor_idx'

	-e hv_gpci/dtbp_ptitc,phys_processor_idx=4/'

we would use following right ?

	-e hv_gpci/dtbp_ptitc,starting_index=4/'

If so, I think the interface change makes sense.  perf list would also
show 'starting_index=?' for the event. 

But in the sysfs entry, rather than show 'starting_index=?', should we
leave it as:

	'starting_index=phys_processor_idx' 

For some events 'startind_index' refers to a physical processor id
and for others it is virtual processor id. So, showing phys_processor_idx
could serve as a hint.

Michael, Cody, Ingo, Peter, let me know if you agree or have other
comments on the inteface.

Thanks,

Sukadev



| 
| thanks,
| jirka

