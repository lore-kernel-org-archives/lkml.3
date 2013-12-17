Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab3LQSLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:11:06 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:59360 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab3LQSLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:11:04 -0500
MIME-Version: 1.0
From: David Timothy Strauss <david@davidstrauss.net>
Date: Tue, 17 Dec 2013 10:10:42 -0800
Message-ID: <CAKz8sYWmmmdwKTKUGdoyaMD_v9_7yQydG+UNAb2r-KoO4L+6Ng@mail.gmail.com>
Subject: NUMA, migrate/N, and tuned-adm
To: Mel Gorman <mgorman@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Our system gets storms of migrate/N (and sometimes kswapd) tasks from
the kernel, based on what we've seen in top [1]. This issue is unique
to our hardware application servers; we run hundreds of application
servers on Xen virtual hardware without this issue and the same
kernel. We also have no issues with identical kernels and hardware
servers while running databases.

System specs:
 * Fedora 19 with the 3.11.10-200.fc19.x86_64 kernel (just the stock RPM)
 * Bare-metal servers with 128GB RAM split between two NUMA regions,
each region with one hex-core processor
 * More than 700 processes, a couple hundred of which are active
fairly frequently. The systems were at 7000 processes, but we've
dropped it while we dive into this issue.
 * Many of the processes are short-lived. The long-lived ones
experience spikes in CPU and memory usage while processing requests.

Here's what we've tried, to no avail:
 * tuned-adm on latency-performance and virtual-host profiles; this
places the system on the deadline scheduler, but this problem occurred
on the default one too
 * kernel.sched_migration_cost_ns=5000000 (which tuned will do for
those profiles in v3.3/Fedora 20)
 * numad to balance between regions
 * Global use of sched_relax_domain_level=1 and sched_relax_domain_level=2
 * Splitting the system with cpuset into management tasks (6 virtual
cores) and workload tasks (18 virtual cores) with
sched_relax_domain_level=2. This is based on recommendations for NUMA
systems in the cpuset man page.

Here's what we've used for analysis:
 * powertop
 * top/htop
 * perf record -a -g
 * SystemTap with code to print out migrations occurring
 * numatop

[1] https://gist.github.com/davidstrauss/3ff0b29c4d3766bedd49

David Strauss
Pantheon Systems
Fedora Server Working Group

P.S. Josh Boyer (jwb) referred me here from the Fedora kernel side.
