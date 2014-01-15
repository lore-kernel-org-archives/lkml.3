Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbaAOPBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 10:01:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50817 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962AbaAOPBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 10:01:17 -0500
From: Michal Hocko <mhocko@suse.cz>
To: <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC PATCH 0/3] memcg OOM notifications and PF_EXITING checks
Date: Wed, 15 Jan 2014 16:01:05 +0100
Message-Id: <1389798068-19885-1-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
this is an attempt to restart discussions regarding memcg OOM
notifications and break out conditions.

"memcg: do not hang on OOM when killed by userspace OOM access to memory
reserves" which was a first patch in the series was already merged to -mm
tree (http://www.ozlabs.org/~akpm/mmotm/broken-out/memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch)
but it didn't see ack from neither David nor Johannes. I would be happy
if we agreed on that one as well.

The first patch in this series implements and extends an idea proposed
by David to not notify userspace when the OOM killer might back out and
prevent from killing. Johannes was not fond of the idea because this
changes userspace interface in a subtle way because somebody might be
relying on notifications as a signal that the memcg is getting into
troubles. It has been argued that there are memory thresholds and
vmpressure notifications for such an use case.

I am in favor to make change the notification and draw the line when to
notify to "kernel or userspace has to perform an action". It makes sense
to me, it is still racy though. Something might have exiting millisecond
after notification fired but it at least is consistent.

The second patch is trivial and it removes PF_EXITING check for the
current in mem_cgroup_out_of_memory because it is no longer needed when
we have the check in the charging path.

The last patch is just an attempt and might be totally wrong. I've
noticed that we are not checking for the killed tasks in
mem_cgroup_out_of_memory which might break usecases where a task was
killed by vmpressure or thresholds handlers but the killed task cannot
terminate in time. We should rather not kill something else.

