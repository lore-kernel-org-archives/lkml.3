Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbaKRGav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 01:30:51 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:31254 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbaKRGau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 01:30:50 -0500
Message-ID: <546AE794.5070902@huawei.com>
Date: Tue, 18 Nov 2014 14:30:44 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH cgroup/for-3.19 3/3] cgroup: fix the async css offline
 wait logic in cgroup_subtree_control_write()
References: <20141113215813.GA2598@htj.dyndns.org> <20141113215848.GB2598@htj.dyndns.org> <20141113215921.GC2598@htj.dyndns.org>
In-Reply-To: <20141113215921.GC2598@htj.dyndns.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A02020A.546AE798.0072,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: c6c5444880ca8b284f28de0fbfa67bfb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/14 5:59, Tejun Heo wrote:
> When a subsystem is offlined, its entry on @cgrp->subsys[] is cleared
> asynchronously.  If cgroup_subtree_control_write() is requested to
> enable the subsystem again before the entry is cleared, it has to wait
> for the previous offlining to finish and clear the @cgrp->subsys[]
> entry before trying to enable the subsystem again.
> 
> This is currently done while verifying the input enable / disable
> parameters.  This used to be correct but f63070d350e3 ("cgroup: make
> interface files visible iff enabled on cgroup->subtree_control")
> breaks it.  The commit is one of the commits implementing subsystem
> dependency.
> 
> Through subsystem dependency, some subsystems may be enabled and
> disabled implicitly in addition to the explicitly requested ones.  The
> actual subsystems to be enabled and disabled are determined during
> @css_enable/disable calculation.  The current offline wait logic skips
> the ones which are already implicitly enabled and then waits for
> subsystems in @enable; however, this misses the subsystems which may
> be implicitly enabled through dependency from @enable.  If such
> implicitly subsystem hasn't yet finished offlining yet, the function
> ends up trying to create a css when its @cgrp->subsys[] slot is
> already occupied triggering BUG_ON() in init_and_link_css().
> 
> Fix it by moving the wait logic after @css_enable is calculated and
> waiting for all the subsystems in @css_enable.  This fixes the above
> bug as the mask contains all subsystems which are to be enabled
> including the ones enabled through dependencies.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Fixes: f63070d350e3 ("cgroup: make interface files visible iff enabled on cgroup->subtree_control")

For all 3 patches:

Acked-by: Zefan Li <lizefan@huawei.com>

