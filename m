Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbaEPQak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 12:30:40 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:36841 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757863AbaEPQai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 12:30:38 -0400
Date: Fri, 16 May 2014 12:30:34 -0400
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>
Subject: [linux-next / akpm] Heads up on minor conflicts in mm/memcontrol.c
Message-ID: <20140516163034.GF5379@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Today's cgroup/for-next contains aa190dd36dad ("cgroup: remove
css_parent()").  The wrapper was added while transitioning
cgroup-based hierarchy to css-based one.  css-based hierarchy is
mostly getting into the shape now and the parent field is exported and
expected to remain stable, so the patch removes the wrapper before
updating the rest of hierarchy to be css-based.  This causes two
trivial conflicts in mm/memcontrol.c with
"f51add3a5415edbd2160f8c80ca338edebbaa734".

  static int mem_cgroup_oom_control_write(struct cgroup_subsys_state *css,
	  struct cftype *cft, u64 val)
  {
	  struct mem_cgroup *memcg = mem_cgroup_from_css(css);
  <<<<<<< HEAD
  =======
	  struct mem_cgroup *parent = mem_cgroup_from_css(memcg->css.parent);
  >>>>>>> 141fdfadf18c10fed33624bbd414fcc0cb74d7ca

	  /* cannot set to root cgroup and only 0 and 1 are allowed */
	  if (!css_parent(css) || !((val == 0) || (val == 1)))
		  return -EINVAL;

	  memcg->oom_kill_disable = val;
	  if (!val)
		  memcg_oom_recover(memcg);

	  return 0;
  }

  ...

  static int mem_cgroup_swappiness_write(struct cgroup_subsys_state *css,
					 struct cftype *cft, u64 val)
  {
	  struct mem_cgroup *memcg = mem_cgroup_from_css(css);
  <<<<<<< HEAD
  =======
	  struct mem_cgroup *parent = mem_cgroup_from_css(memcg->css.parent);

	  if (val > 100 || !parent)
		  return -EINVAL;

	  mutex_lock(&memcg_create_mutex);
  >>>>>>> 141fdfadf18c10fed33624bbd414fcc0cb74d7ca

	  if (val > 100)
		  return -EINVAL;

	  if (css_parent(css))
		  memcg->swappiness = val;
	  else
		  vm_swappiness = val;

	  return 0;
  }

For both cases, the resolution is simple.  Take the code from akpm and
change css_parent(css) to css->parent.

  static int mem_cgroup_oom_control_write(struct cgroup_subsys_state *css,
	  struct cftype *cft, u64 val)
  {
	  struct mem_cgroup *memcg = mem_cgroup_from_css(css);

	  /* cannot set to root cgroup and only 0 and 1 are allowed */
	  if (!css->parent || !((val == 0) || (val == 1)))
		  return -EINVAL;

	  memcg->oom_kill_disable = val;
	  if (!val)
		  memcg_oom_recover(memcg);

	  return 0;
  }

  ...

  static int mem_cgroup_swappiness_write(struct cgroup_subsys_state *css,
					 struct cftype *cft, u64 val)
  {
	  struct mem_cgroup *memcg = mem_cgroup_from_css(css);

	  if (val > 100)
		  return -EINVAL;

	  if (css->parent)
		  memcg->swappiness = val;
	  else
		  vm_swappiness = val;

	  return 0;
  }
										
Thanks.

-- 
tejun
