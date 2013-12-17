Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab3LQPpy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 10:45:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58710 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754179Ab3LQPpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 10:45:52 -0500
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [RFC] memcg: some charge path cleanups + css offline vs. charge race fix
Date: Tue, 17 Dec 2013 16:45:25 +0100
Message-Id: <1387295130-19771-1-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.8.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
the first three patches are an attempt to clean up memcg charging path a
bit. I am already fed up about all the different combinations of mm vs.
memcgp parameters so I have split up the function into two parts:
	* charge mm
	* charge a known memcg
More details are in the patch 1. I think that this makes more sense.
It was also quite surprising that just the code reordering without any
functional changes made the code smaller by 600B.

Second patch is just a trivial follow up, shouldn't be controversial.

The third one tries to remove an exception (bypass) path which was there
from the early days but it never made any sense to me. It always made me
confused so I would more than happy to ditch it.

Finally patch#4 addresses memcg charge vs. memcg_offline race + #5
reverts the workaround which has been merged as a first aid.

What do you think?

Based on the current mmotm (mmotm-2013-12-16-14-29-6)
Michal Hocko (5):
      memcg: cleanup charge routines
      memcg: move stock charge into __mem_cgroup_try_charge_memcg
      memcg: mm == NULL is not allowed for mem_cgroup_try_charge_mm
      memcg: make sure that memcg is not offline when charging
      Revert "mm: memcg: fix race condition between memcg teardown and swapin"

Diffstat:
 mm/memcontrol.c | 361 +++++++++++++++++++++++++++++---------------------------
 1 file changed, 185 insertions(+), 176 deletions(-)
