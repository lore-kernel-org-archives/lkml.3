Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbaADWnH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 17:43:07 -0500
Received: from mga03.intel.com ([143.182.124.21]:10647 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754790AbaADWnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 17:43:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,604,1384329600"; 
   d="scan'208";a="453708437"
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
Thread-Index: AQHPCMNUDB9LRbk7GE+jzVKI+L/oYZp1Q6cAgABthYA=
Date: Sat, 4 Jan 2014 22:43:00 +0000
Message-ID: <1388875369.9761.25.camel@ppwaskie-mobl.amr.corp.intel.com>
References: <1388781285-18067-1-git-send-email-peter.p.waskiewicz.jr@intel.com>
	 <20140104161050.GA24306@htj.dyndns.org>
In-Reply-To: <20140104161050.GA24306@htj.dyndns.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.12.89]
Content-Type: text/plain; charset="utf-8"
Content-ID: <8B0348237BEE1143A5E490EC6FA26B12@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s04MhCCq026913

On Sat, 2014-01-04 at 11:10 -0500, Tejun Heo wrote:
> Hello,

Hi Tejun,

> On Fri, Jan 03, 2014 at 12:34:41PM -0800, Peter P Waskiewicz Jr wrote:
> > The CPU features themselves are relatively straight-forward, but
> > the presentation of the data is less straight-forward.  Since this
> > tracks cache usage and occupancy per process (by swapping Resource
> > Monitor IDs, or RMIDs, when processes are rescheduled), perf would
> > not be a good fit for this data, which does not report on a
> > per-process level.  Therefore, a new cgroup subsystem, cacheqos, has
> > been added.  This operates very similarly to the cpu and cpuacct
> > cgroup subsystems, where tasks can be grouped into sub-leaves of the
> > root-level cgroup.
> 
> I don't really understand why this is implemented as part of cgroup.
> There doesn't seem to be anything which requires cgroup.  Wouldn't
> just doing it per-process make more sense?  Even grouping would be
> better done along the traditional process hierarchy, no?  And
> per-cgroup accounting can be trivially achieved from userland by just
> accumulating the stats according to the process's cgroup membership.
> What am I missing here?

Thanks for the quick response!  I knew the approach would generate
questions, so let me explain.

The feature I'm enabling in the Xeon processors is fairly simple.  It
has a set of Resource Monitoring ID's (RMIDs), and those are used by the
CPU cores to track the cache usage while any process associated with the
RMID is running.  The more complicated part is how to present the
interface of creating RMID groups and assigning processes to them for
both tracking, and for stat collection.

We discussed (internally) a few different approaches to implement this.
The first natural thought was this is similar to other PMU features, but
this deals with processes and groups of processes, not overall CPU core
or uncore state.  Given the way processes in a cgroup can be grouped
together and treated as single entities, this felt like a natural fit
with the RMID concept.

Simply put, when we want to allocate an RMID for monitoring httpd
traffic, we can create a new child in the subsystem hierarchy, and
assign the httpd processes to it.  Then the RMID can be assigned to the
subsystem, and each process inherits that RMID.  So instead of dealing
with assigning an RMID to each and every process, we can leverage the
existing cgroup mechanisms for grouping processes and their children to
a group, and they inherit the RMID.

Please let me know if this is a better explanation, and gives a better
picture of why we decided to approach the implementation this way.  Also
note that this feature, Cache QoS Monitoring, is the first in a series
of Platform QoS Monitoring features that will be coming.  So this isn't
a one-off feature, so however this first piece gets accepted, we want to
make sure it's easy to expand and not impact userspace tools repeatedly
(if possible).

Cheers,
-PJ Waskiewicz

--------------
Intel Open Source Technology Center
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
