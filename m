Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbaBTAaL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 19:30:11 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:61943 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbaBTAaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 19:30:01 -0500
Date: Wed, 19 Feb 2014 19:29:58 -0500
From: Tejun Heo <tj@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Lisa Du <chunlingdu1@gmail.com>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: work item migration bug when a CPU is disabled
Message-ID: <20140220002958.GX10134@htj.dyndns.org>
References: <alpine.LRH.2.02.1402182040100.28214@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1402182040100.28214@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Mikulas.

On Tue, Feb 18, 2014 at 08:57:11PM -0500, Mikulas Patocka wrote:
> Hi Tejun
> 
> Two years ago, I reported a bug in workqueues - a work item that is 
> supposed to be bound to a specific CPU can be migrated to a different CPU 
> when the origianl CPU is disabled by writing zero to 
> /sys/devices/system/cpu/cpu*/online
> 
> This causes crashes in dm-crypt, because it assumes that a work item stays 
> on the same CPU.

For better or worse, per-cpu workqueues have never guaranteed that
cpus won't go down while a work item is executing.  If a workqueue
user needs such guarantee, it's required to use one of the CPU down
hooks to cancel and flush such work items.  This is partly because
workqueue itself doesn't distinguish work items which need to be bound
for correctness and just use affinity as optimization.  The
distinction is made by the user.

It has certain benefits as it makes clear in the code local to the
specific user that it's incurring latency in CPU down operations which
happen to be fairly hot in certain configurations.  Besides, it's not
really clear what behavior workqueue can enforce - should it try to
drain as in wq shutdown sequence, or should it trigger WARN if work
items are requeueing, or should it just leave them hanging until CPU
comes back again?  If we do the last, what about the ones which are
using percpu workqeueus as optimization?

So, if dm-crypt is depending on affinity and not taking care of it via
cpu hotplug hooks, it's something which should be fixed from dm-crypt
side.

Thanks.

-- 
tejun
