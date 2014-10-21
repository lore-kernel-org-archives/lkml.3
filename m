Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbaJUH1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 03:27:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43402 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbaJUH1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 03:27:23 -0400
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>,
        "\\\"Rafael J. Wysocki\\\"" <rjw@rjwysocki.net>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, David Rientjes <rientjes@google.com>,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 0/4 -v2] OOM vs. freezer interaction fixes
Date: Tue, 21 Oct 2014 09:27:11 +0200
Message-Id: <1413876435-11720-1-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew, Rafael,

this has been originally discussed here [1] and previously posted here [2].
I have updated patches according to feedback from Oleg.

The first and third patch are regression fixes and they are a stable
material IMO. The second and fourth patch are simple cleanups.

The 1st patch is fixing a regression introduced in 3.3 since when OOM
killer is not able to kill any frozen task and live lock as a result.
The fix gets us back to the 3.2. As it turned out during the discussion [3]
this was still not 100% sufficient and that's why we need the 3rd patch.

I was thinking about the proper 1st vs. 3rd patch ordering because
the 1st patch basically opens a race window considerably reduced by the
later patch. This path is hard to do completely race free without a complete
synchronization of OOM path (including the allocator) and freezer which is not
worth the trouble.

Original patch from Cong Wang has covered this by checking
cgroup_freezing(current) in __refrigarator path [4]. But this approach
still suffers from OOM vs. PM freezer interaction (OOM killer would
still live lock waiting for a PM frozen task this time).

So I think the most straight forward way is to address only OOM vs.
frozen task interaction in the first patch, mark it for stable 3.3+ and
leave the race to a separate follow up patch which is applicable to
stable 3.2+ (before a3201227f803 made it inefficient).

Switching 1st and 3rd patches would make some sense as well but then
it might end up even more confusing because we would be fixing a
non-existent issue in upstream first...

Cong Wang (2):
      freezer: Do not freeze tasks killed by OOM killer
      freezer: remove obsolete comments in __thaw_task()

Michal Hocko (2):
      OOM, PM: OOM killed task shouldn't escape PM suspend
      PM: convert do_each_thread to for_each_process_thread

And diffstat says:
 include/linux/oom.h    |  3 +++
 kernel/freezer.c       |  9 +++------
 kernel/power/process.c | 47 ++++++++++++++++++++++++++++++++++++++---------
 mm/oom_kill.c          | 17 +++++++++++++++++
 mm/page_alloc.c        |  8 ++++++++
 5 files changed, 69 insertions(+), 15 deletions(-)

---
[1] http://marc.info/?l=linux-kernel&m=140986986423092
[2] http://marc.info/?l=linux-mm&m=141277728508500&w=2
[3] http://marc.info/?l=linux-kernel&m=141074263721166
[4] http://marc.info/?l=linux-kernel&m=140986986423092
