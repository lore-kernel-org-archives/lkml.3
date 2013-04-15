Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab3DOCf6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 22:35:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43139 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754746Ab3DOCf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 22:35:57 -0400
Date: Sun, 14 Apr 2013 19:35:52 -0700
From: Michal Hocko <mhocko@suse.cz>
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Tejun Heo <tj@kernel.org>, lizefan@huawei.com,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        vgoyal@redhat.com, cgroups@vger.kernel.org
Subject: Re: [PATCH 4/4] memcg: force use_hierarchy if sane_behavior
Message-ID: <20130415023552.GA9955@dhcp22.suse.cz>
References: <1365808259-31073-1-git-send-email-tj@kernel.org>
 <1365808259-31073-5-git-send-email-tj@kernel.org>
 <20130415011336.GF8408@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130415011336.GF8408@sergelap>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 14-04-13 20:13:36, Serge Hallyn wrote:
> Quoting Tejun Heo (tj@kernel.org):
> > Turn on use_hierarchy by default if sane_behavior is specified and
> > don't create .use_hierarchy file.
> > 
> > It is debatable whether to remove .use_hierarchy file or make it ro as
> > the former could make transition easier in certain cases; however, the
> > behavior changes which will be gated by sane_behavior are intensive
> > including changing basic meaning of certain control knobs in a few
> > controllers and I don't really think keeping this piece would make
> > things easier in any noticeable way, so let's remove it.
> 
> Hi Tejun,
> 
> this actually reminds me of something that's been on my todo list to
> report for some time, but I haven't had time to find the source of the
> bug...  And maybe it's already been reported...  but
> 
> If I do
> 
> 	cd /sys/fs/cgroup/memory
> 	mkdir b
> 	cd b
> 	echo 1 > memory.use_hierarchy
> 	echo 5000 > memory.limit_in_bytes
> 	cat memory.limit_in_bytes
> 8192
> 	mkdir c
> 	cd c
> 	cat memory.use_hierarchy
> 1
> 	cat memory.limit_in_bytes
> 9223372036854775807
> 	echo $$ > tasks
> 	bash
> <killed>
> 
> So it seems the hierarchy is being enforced, but not reported in
> child limit_in_bytes files.

This is an intended behavior. Limits are not propagated to the children
because they are enforced anyway (by reclaim). The behavior would
be quite inconsistent when the parent limit would be changed later
otherwise. We only inherit properties which are enforced hierarchically:
use_hierarchy, oom_disable and swappiness.

> (Last tested tonight on 3.8.0-17-generic #27-Ubuntu fwiw)
> 
> -serge

-- 
Michal Hocko
SUSE Labs
