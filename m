Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbaL1Uad (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 15:30:33 -0500
Received: from gum.cmpxchg.org ([85.214.110.215]:55801 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbaL1Uab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 15:30:31 -0500
Date: Sun, 28 Dec 2014 15:30:23 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        Greg Thelen <gthelen@google.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/2] memcg: add memory and swap knobs to the default
 cgroup hierarchy
Message-ID: <20141228203023.GB9385@phnom.home.cmpxchg.org>
References: <dd99dc0de2ce6fd9aa18b25851819b71a58dca7d.1419782051.git.vdavydov@parallels.com>
 <9aeed65ee700e81abde90c20570415a40acb36e2.1419782051.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9aeed65ee700e81abde90c20570415a40acb36e2.1419782051.git.vdavydov@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 28, 2014 at 07:19:13PM +0300, Vladimir Davydov wrote:
> This patch adds the following files to the default cgroup hierarchy:
> 
>   memory.usage:         read memory usage
>   memory.limit:         read/set memory limit

These names are one hell of a lot better than what we currently have,
but I'm not happy with "usage" and "limit" as the basic memcg knobs.

Statically limiting groups as a means of partitioning a system doesn't
reflect the reality that a) memory consumption is elastic, b) varies
over the course of a workload, and c) working set estimation is
incredibly hard - and inaccurate.  We need gradual degredation on the
configuration, not OOM kills, to allow the admin to make it tight,
monitor groups and system, and intervene when performance degrades.

That's why in v2 the user should instead be able to configure the
groups' ranges of memory consumption, and then leave it to global
reclaim and memcg reclaim to balance memory pressure accordingly.
Groups that are below their normal range will be spared by global
pressure, as long as there are other groups available for reclaim.
The admin can monitor global overcommit by looking at allocation
latencies and how often groups get pushed below their comfort zone.
On the other hand, groups that exceed their normal range will be
throttled in direct reclaim.  The admin can monitor group overcommit
by looking at the charge latency.  A hard upper limit will still be
available, but only for emergency containment of buggy or malicious
workloads, where the admin/job scheduler is not considered fast enough
to protect the system from harm.  This allows packing groups very
tightly with monitorable gradual degredation, and at the same time
turns the OOM killer back into the last-resort measure it should be.

We could add those low and high boundary knobs to the usage and limit
knobs, but I really don't want the flawed assumptions of the old model
to be reflected in the new interface.  As such, my proposals would be:

  memory.low:        the expected lower end of the workload size
  memory.high:       the expected upper end
  memory.max:        the absolute OOM-enforced maximum size
  memory.current:    the current size

And then, in the same vein:

  swap.max
  swap.current

These names are short, but they should be unambiguous and descriptive
in their context, and users will have to consult the documentation on
how to configure this stuff anyway.
