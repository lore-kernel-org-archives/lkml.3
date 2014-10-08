Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196AbaJHOIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 10:08:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49069 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438AbaJHOID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 10:08:03 -0400
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>,
        "\\\"Rafael J. Wysocki\\\"" <rjw@rjwysocki.net>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, David Rientjes <rientjes@google.com>,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: [PATCH 0/3] OOM vs. freezer interaction fixes
Date: Wed,  8 Oct 2014 16:07:43 +0200
Message-Id: <1412777266-8251-1-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew, Rafael,

this has been originally discussed here [1] but didn't lead anywhere AFAICS
so I would like to resurrect them.

The first and third patch are regression fixes and they are a stable
material IMO. The second patch is a simple cleanup.

The 1st patch is fixing a regression introduced in 3.3 since when OOM
killer is not able to kill any frozen task and live lock as a result.
The fix gets us back to the 3.2. As it turned out during the discussion [2]
this was still not 100% sufficient and that's why we need the 3rd patch.

I was thinking about the proper 1st vs. 3rd patch ordering because
the 1st patch basically opens a race window fixed by the later patch.
Original patch from Cong Wang has covered this by cgroup_freezing(current)
check in should_thaw_current(). But this approach still suffers from OOM
vs. PM freezer interaction (OOM killer would still live lock waiting for a
PM frozen task this time).

So I think the most straight forward way is to address only OOM vs.
frozen task interaction in the first patch, mark it for stable 3.3+ and
leave the race to a separate follow up patch which is applicable to
stable 3.2+ (before a3201227f803 made it inefficient).

Switching 1st and 3rd patches would make some sense as well but then
it might end up even more confusing because we would be fixing a
non-existent issue in upstream first...

---
[1] http://marc.info/?l=linux-kernel&m=140986986423092
[2] http://marc.info/?l=linux-kernel&m=141074263721166

