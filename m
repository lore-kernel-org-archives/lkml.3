Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750902AbaAEFXM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 00:23:12 -0500
Received: from mga14.intel.com ([143.182.124.37]:62029 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747AbaAEFXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 00:23:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,606,1384329600"; 
   d="scan'208";a="453775393"
From: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
To: Tejun Heo <tj@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Li Zefan <lizefan@huawei.com>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] x86: Add Cache QoS Monitoring (CQM) support
Thread-Topic: [PATCH 0/4] x86: Add Cache QoS Monitoring (CQM) support
Thread-Index: AQHPCMNUDB9LRbk7GE+jzVKI+L/oYZp1Q6cAgABthYCAAAJHAIAAbYMA
Date: Sun, 5 Jan 2014 05:23:07 +0000
Message-ID: <1388899376.9761.45.camel@ppwaskie-mobl.amr.corp.intel.com>
References: <1388781285-18067-1-git-send-email-peter.p.waskiewicz.jr@intel.com>
	 <20140104161050.GA24306@htj.dyndns.org>
	 <1388875369.9761.25.camel@ppwaskie-mobl.amr.corp.intel.com>
	 <20140104225058.GC24306@htj.dyndns.org>
In-Reply-To: <20140104225058.GC24306@htj.dyndns.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.15.231]
Content-Type: text/plain; charset="utf-8"
Content-ID: <51AB66FD75509C4BA22EEC20FFB5A68D@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s055Njwt027683

On Sat, 2014-01-04 at 17:50 -0500, Tejun Heo wrote:
> Hello,

Hi Tejun,

> On Sat, Jan 04, 2014 at 10:43:00PM +0000, Waskiewicz Jr, Peter P wrote:
> > Simply put, when we want to allocate an RMID for monitoring httpd
> > traffic, we can create a new child in the subsystem hierarchy, and
> > assign the httpd processes to it.  Then the RMID can be assigned to the
> > subsystem, and each process inherits that RMID.  So instead of dealing
> > with assigning an RMID to each and every process, we can leverage the
> > existing cgroup mechanisms for grouping processes and their children to
> > a group, and they inherit the RMID.
> 
> Here's one thing that I don't get, possibly because I'm not
> understanding the processor feature too well.  Why does the processor
> have to be aware of the grouping?  ie. why can't it be done
> per-process and then aggregated?  Is there something inherent about
> the monitored events which requires such peculiarity?  Or is it that
> accessing the stats data is noticieably expensive to do per context
> switch?

The processor doesn't need to understand the grouping at all, but it
also isn't tracking things per-process that are rolled up later.
They're tracked via the RMID resource in the hardware, which could
correspond to a single process, or 500 processes.  It really comes down
to the ease of management of grouping tasks in groups for two consumers,
1) the end user, and 2) the process scheduler.

I think I still may not be explaining how the CPU side works well
enough, in order to better understand what I'm trying to do with the
cgroup.  Let me try to be a bit more clear, and if I'm still sounding
vague or not making sense, please tell me what isn't clear and I'll try
to be more specific.  The new Documentation addition in patch 4 also has
a good overview, but let's try this:

A CPU may have 32 RMID's in hardware.  This is for the platform, not per
core.  I may want to have a single process assigned to an RMID for
tracking, say qemu to monitor cache usage of a specific VM.  But I also
may want to monitor cache usage of all MySQL database processes with
another RMID, or even split specific processes of that database between
different RMID's.  It all comes down to how the end-user wants to
monitor their specific workloads, and how those workloads are impacting
cache usage and occupancy.

With this implementation I've sent, all tasks are in RMID 0 by default.
Then one can create a subdirectory, just like the cpuacct cgroup, and
then add tasks to that subdirectory's task list.  Once that
subdirectory's task list is enabled (through the cacheqos.monitor_cache
handle), then a free RMID is assigned from the CPU, and when the
scheduler switches to any of the tasks in that cgroup under that RMID,
the RMID begins monitoring the usage.

The CPU side is easy and clean.  When something in the software wants to
monitor when a particular task is scheduled and started, write whatever
RMID that task is assigned to (through some mechanism) to the proper MSR
in the CPU.  When that task is swapped out, clear the MSR to stop
monitoring of that RMID.  When that RMID's statistics are requested by
the software (through some mechanism), then the CPU's MSRs are written
with the RMID in question, and the value is read of what has been
collected so far.  In my case, I decided to use a cgroup for this
"mechanism" since so much of the grouping and task/group association
already exists and doesn't need to be rebuilt or re-invented.

> > Please let me know if this is a better explanation, and gives a better
> > picture of why we decided to approach the implementation this way.  Also
> > note that this feature, Cache QoS Monitoring, is the first in a series
> > of Platform QoS Monitoring features that will be coming.  So this isn't
> > a one-off feature, so however this first piece gets accepted, we want to
> > make sure it's easy to expand and not impact userspace tools repeatedly
> > (if possible).
> 
> In general, I'm quite strongly opposed against using cgroup as
> arbitrary grouping mechanism for anything other than resource control,
> especially given that we're moving away from multiple hierarchies.

Just to clarify then, would the mechanism in the cpuacct cgroup to
create a group off the root subsystem be considered multi-hierarchical?
If not, then the intent for this new cacheqos subsystem is to be
identical in that regard to cpuacct in the behavior.

This is a resource controller, it just happens to be tied to a hardware
resource instead of an OS resource.

Cheers,
-PJ

--
PJ Waskiewicz				Open Source Technology Center
peter.p.waskiewicz.jr@intel.com		Intel Corp.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
