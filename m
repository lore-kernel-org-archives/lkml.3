Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063AbaEMVkB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 17:40:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55138 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbaEMVjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 17:39:55 -0400
Date: Tue, 13 May 2014 14:39:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>,
        Greg Thelen <gthelen@google.com>, LKML <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: Re: [PATCH] memcg: deprecate memory.force_empty knob
Message-Id: <20140513143953.0b91925ee1e81580a4025a2e@linux-foundation.org>
In-Reply-To: <1399994956-3907-1-git-send-email-mhocko@suse.cz>
References: <1399994956-3907-1-git-send-email-mhocko@suse.cz>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2014 17:29:16 +0200 Michal Hocko <mhocko@suse.cz> wrote:

> force_empty has been introduced primarily to drop memory before it gets
> reparented on the group removal. This alone doesn't sound fully
> justified because reparented pages which are not in use can be reclaimed
> also later when there is a memory pressure on the parent level.
> 
> Mark the knob CFTYPE_INSANE which tells the cgroup core that it
> shouldn't create the knob with the experimental sane_behavior. Other
> users will get informed about the deprecation and asked to tell us more
> because I do not expect most users will use sane_behavior cgroups mode
> very soon.
> Anyway I expect that most users will be simply cgroup remove handlers
> which do that since ever without having any good reason for it.
> 
> If somebody really cares because reparented pages, which would be
> dropped otherwise, push out more important ones then we should fix the
> reparenting code and put pages to the tail.
> 
> ...
>
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4793,6 +4793,10 @@ static int mem_cgroup_force_empty_write(struct cgroup_subsys_state *css,
>  
>  	if (mem_cgroup_is_root(memcg))
>  		return -EINVAL;
> +	pr_info("%s (%d): memory.force_empty is deprecated and will be removed.",
> +			current->comm, task_pid_nr(current));
> +	pr_cont(" Let us know if you know if it needed in your usecase at");
> +	pr_cont(" linux-mm@kvack.org\n");
>  	return mem_cgroup_force_empty(memcg);
>  }
>  

Do we really want to spam the poor user each and every time they use
this?  Using pr_info_once() is kinder and gentler?


From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-deprecate-memoryforce_empty-knob-fix

- s/pr_info/pr_info_once/
- fix garbled printk text

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    2 +-
 mm/memcontrol.c                  |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN Documentation/cgroups/memory.txt~memcg-deprecate-memoryforce_empty-knob-fix Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-deprecate-memoryforce_empty-knob-fix
+++ a/Documentation/cgroups/memory.txt
@@ -482,7 +482,7 @@ About use_hierarchy, see Section 6.
   memory.kmem.usage_in_bytes == memory.usage_in_bytes.
 
   Please note that this knob is considered deprecated and will be removed
-  in future.
+  in the future.
 
   About use_hierarchy, see Section 6.
 
diff -puN mm/memcontrol.c~memcg-deprecate-memoryforce_empty-knob-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-deprecate-memoryforce_empty-knob-fix
+++ a/mm/memcontrol.c
@@ -4799,10 +4799,10 @@ static int mem_cgroup_force_empty_write(
 
 	if (mem_cgroup_is_root(memcg))
 		return -EINVAL;
-	pr_info("%s (%d): memory.force_empty is deprecated and will be removed.",
-			current->comm, task_pid_nr(current));
-	pr_cont(" Let us know if you know if it needed in your usecase at");
-	pr_cont(" linux-mm@kvack.org\n");
+	pr_info_once("%s (%d): memory.force_empty is deprecated and will be "
+		     "removed.  Let us know if it is needed in your usecase at "
+		     "linux-mm@kvack.org\n",
+		     current->comm, task_pid_nr(current));
 	return mem_cgroup_force_empty(memcg);
 }
 
_

