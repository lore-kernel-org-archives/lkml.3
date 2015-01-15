Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbbAOS4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 13:56:35 -0500
Received: from forward-corp1m.cmail.yandex.net ([5.255.216.100]:60182 "EHLO
	forward-corp1m.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752885AbbAOS4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 13:56:30 -0500
X-Greylist: delayed 432 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Jan 2015 13:56:28 EST
Authentication-Results: smtpcorp1m.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Subject: [PATCHSET RFC 0/6] memcg: inode-based dirty-set controller
From: Konstantin Khebnikov <khlebnikov@yandex-team.ru>
To: linux-mm@kvack.org, cgroups@vger.kernel.org
Cc: Roman Gushchin <klamm@yandex-team.ru>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, linux-fsdevel@vger.kernel.org,
        koct9i@gmail.com
Date: Thu, 15 Jan 2015 21:49:10 +0300
Message-ID: <20150115180242.10450.92.stgit@buzz>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is ressurection of my old RFC patch for dirty-set accounting cgroup [1]
Now it's merged into memory cgroup and got bandwidth controller as a bonus.

That shows alternative solution: less accurate but much less monstrous than
accurate page-based dirty-set controller from Tejun Heo.

Memory overhead: +1 pointer into struct address_space.
Perfomance overhead is almost zero, no new locks added.

Idea is stright forward: link each inode to some cgroup when first dirty
page appers and account all dirty pages to it. Writeback is implemented
as single per-bdi writeback work which writes only inodes which belong
to memory cgroups where amount of dirty memory is beyond thresholds.

Third patch adds trick for handling shared inodes which have dirty pages
from several cgroups: it marks whole inode as shared and alters writeback
filter for it.

The rest is an example of bandwith and iops controller build on top of that.
Design is completely original, I bet nobody ever used task-works for that =)

[1] [PATCH RFC] fsio: filesystem io accounting cgroup
http://marc.info/?l=linux-kernel&m=137331569501655&w=2

Patches also available here:
https://github.com/koct9i/linux.git branch memcg_dirty_control

---

Konstantin Khebnikov (6):
      memcg: inode-based dirty and writeback pages accounting
      memcg: dirty-set limiting and filtered writeback
      memcg: track shared inodes with dirty pages
      percpu_ratelimit: high-performance ratelimiting counter
      delay-injection: resource management via procrastination
      memcg: filesystem bandwidth controller


 block/blk-core.c                 |    2 
 fs/direct-io.c                   |    2 
 fs/fs-writeback.c                |   22 ++
 fs/inode.c                       |    1 
 include/linux/backing-dev.h      |    1 
 include/linux/fs.h               |   14 +
 include/linux/memcontrol.h       |   27 +++
 include/linux/percpu_ratelimit.h |   45 ++++
 include/linux/sched.h            |    7 +
 include/linux/writeback.h        |    1 
 include/trace/events/sched.h     |    7 +
 include/trace/events/writeback.h |    1 
 kernel/sched/core.c              |   66 +++++++
 kernel/sched/fair.c              |   12 +
 lib/Makefile                     |    1 
 lib/percpu_ratelimit.c           |  168 +++++++++++++++++
 mm/memcontrol.c                  |  381 ++++++++++++++++++++++++++++++++++++++
 mm/page-writeback.c              |   32 +++
 mm/readahead.c                   |    2 
 mm/truncate.c                    |    1 
 mm/vmscan.c                      |    4 
 21 files changed, 787 insertions(+), 10 deletions(-)
 create mode 100644 include/linux/percpu_ratelimit.h
 create mode 100644 lib/percpu_ratelimit.c

--
Signature
