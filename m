Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbaDRTOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 15:14:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954AbaDRTNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 15:13:37 -0400
Date: Fri, 18 Apr 2014 21:13:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>
Cc: Peter Chiang <pchiang@nvidia.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "ccross@android.com" <ccross@android.com>,
        "lizefan@huawei.com" <lizefan@huawei.com>,
        "tj@kernel.org" <tj@kernel.org>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "guillaume@morinfr.org" <guillaume@morinfr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] memcg: kill start_kernel()->mm_init_owner(init_mm)
Message-ID: <20140418191322.GB7413@redhat.com>
References: <1397617379-26895-1-git-send-email-pchiang@nvidia.com> <80341664FB79C2419999599F48F738410227327881@HKMAIL01.nvidia.com> <80341664FB79C2419999599F48F738410227327888@HKMAIL01.nvidia.com> <20140416135741.GA9407@redhat.com> <80341664FB79C2419999599F48F7384102273279C3@HKMAIL01.nvidia.com> <20140418162359.GA4398@redhat.com> <20140418172631.GA13323@redhat.com> <20140418182444.GB22235@dhcp22.suse.cz> <20140418184441.GA26046@redhat.com> <20140418191259.GA7413@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140418191259.GA7413@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove start_kernel()->mm_init_owner(&init_mm, &init_task).

This doesn't really hurt but unnecessary and misleading. init_task
is the "swapper" thread == current, its ->mm is always NULL. And
init_mm can only be used as ->active_mm, not as ->mm.

mm_init_owner() has a single caller with this patch, perhaps it
should die. mm_init() can initialize ->owner under #ifdef.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 init/main.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/init/main.c b/init/main.c
index 3815895..17090bb 100644
--- a/init/main.c
+++ b/init/main.c
@@ -507,7 +507,6 @@ asmlinkage void __init start_kernel(void)
 	page_address_init();
 	pr_notice("%s", linux_banner);
 	setup_arch(&command_line);
-	mm_init_owner(&init_mm, &init_task);
 	mm_init_cpumask(&init_mm);
 	setup_command_line(command_line);
 	setup_nr_cpu_ids();
-- 
1.5.5.1


