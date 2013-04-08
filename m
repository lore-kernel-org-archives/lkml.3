Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936561Ab3DHPs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:48:59 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:56026 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936458Ab3DHPsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:48:55 -0400
Date: Mon, 8 Apr 2013 08:48:47 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH 2/8] cgroup: implement cgroup_from_id()
Message-ID: <20130408154847.GE3021@htj.dyndns.org>
References: <51627DA9.7020507@huawei.com>
 <51627DEB.4090104@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51627DEB.4090104@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, one more thing.

On Mon, Apr 08, 2013 at 04:20:59PM +0800, Li Zefan wrote:
> -	cgrp->id = ida_simple_get(&root->cgroup_ida, 1, 0, GFP_KERNEL);
> +	cgrp->id = idr_alloc(&root->cgroup_idr, cgrp, 1, 0, GFP_KERNEL);

This will allow lookups to return half-initialized cgroup, which
shouldn't happen.  Either idr_alloc() should be moved to after
initialization of other fields are finished, or it should be called
with NULL @ptr with idr_replace() added at the end to install @cgrp.

Similarly, the removal path should guarantee that the object is
removed from idr *before* its grace period starts.

Thanks.

-- 
tejun
