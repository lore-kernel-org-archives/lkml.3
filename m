Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab3GINyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 09:54:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45123 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734Ab3GINyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 09:54:53 -0400
Date: Tue, 9 Jul 2013 15:54:50 +0200
From: Michal Hocko <mhocko@suse.cz>
To: azurIt <azurit@pobox.sk>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, cgroups mailinglist <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH for 3.2] memcg: do not trap chargers with full callstack
 on OOM
Message-ID: <20130709135450.GI20281@dhcp22.suse.cz>
References: <20130619132614.GC16457@dhcp22.suse.cz>
 <20130622220958.D10567A4@pobox.sk>
 <20130624201345.GA21822@cmpxchg.org>
 <20130628120613.6D6CAD21@pobox.sk>
 <20130705181728.GQ17812@cmpxchg.org>
 <20130705210246.11D2135A@pobox.sk>
 <20130705191854.GR17812@cmpxchg.org>
 <20130708014224.50F06960@pobox.sk>
 <20130709131029.GH20281@dhcp22.suse.cz>
 <20130709151921.5160C199@pobox.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130709151921.5160C199@pobox.sk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 09-07-13 15:19:21, azurIt wrote:
[...]
> Now i realized that i forgot to remove UID from that cgroup before
> trying to remove it, so cgroup cannot be removed anyway (we are using
> third party cgroup called cgroup-uid from Andrea Righi, which is able
> to associate all user's processes with target cgroup). Look here for
> cgroup-uid patch:
> https://www.develer.com/~arighi/linux/patches/cgroup-uid/cgroup-uid-v8.patch
> 
> ANYWAY, i'm 101% sure that 'tasks' file was empty and 'under_oom' was
> permanently '1'.

This is really strange. Could you post the whole diff against stable
tree you are using (except for grsecurity stuff and the above cgroup-uid
patch)?

Btw. the bellow patch might help us to point to the exit path which
leaves wait_on_memcg without mem_cgroup_oom_synchronize:
---
diff --git a/kernel/exit.c b/kernel/exit.c
index e6e01b9..ad472e0 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -895,6 +895,7 @@ NORET_TYPE void do_exit(long code)
 
 	profile_task_exit(tsk);
 
+	WARN_ON(current->memcg_oom.wait_on_memcg);
 	WARN_ON(blk_needs_flush_plug(tsk));
 
 	if (unlikely(in_interrupt()))
-- 
Michal Hocko
SUSE Labs
