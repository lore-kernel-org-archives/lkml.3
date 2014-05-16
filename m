Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321AbaEPQ7m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 12:59:42 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34843 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbaEPQ7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 12:59:40 -0400
Message-ID: <537643F9.1030303@wwwdotorg.org>
Date: Fri, 16 May 2014 10:59:37 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        ARM kernel mailing list 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH cgroup/for-3.16] cgroup: introduce CSS_NO_REF and skip
 refcnting on normal root csses
References: <1399670015-23463-1-git-send-email-tj@kernel.org> <1399670015-23463-10-git-send-email-tj@kernel.org> <53751062.2050401@wwwdotorg.org> <53753823.2090402@wwwdotorg.org> <20140516143718.GA5379@htj.dyndns.org> <20140516154330.GB5379@htj.dyndns.org>
In-Reply-To: <20140516154330.GB5379@htj.dyndns.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2014 09:43 AM, Tejun Heo wrote:
> From 49035d695d8f1c4bbe4e37480e5d06812818947c Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Fri, 16 May 2014 11:40:33 -0400
> 
> 9395a4500404 ("cgroup: enable refcnting for root csses") enabled
> reference counting for root csses (cgroup_subsys_states) so that
> cgroup's self csses can be used to manage the lifetime of the
> containing cgroups.
> 
> Unfortunately, this change was incorrect.  cpu controller uses
> early_init and starts using css reference counts on its root css from
> then on.  percpu_ref can't initialized during early init and its
> initialization is deferred till cgroup_init() time.  This means that
> cpu was using percpu_ref which wasn't properly initialized.  Due to
> the way percpu variables are laid out on x86, this didn't blow up
> immediately on x86 but ended up incrementing and decrementing the
> percpu variable at offset zero, whatever it may be; however, on other
> archs, this caused fault and early boot failure.
> 
> As cgroup self csses still need working refcounting, we can't revert
> 9395a4500404.  This patch adds CSS_NO_REF which explicitly inhibits
> reference counting on the css and sets it on all normal (non-self)
> csses.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Stephen Warren <swarren@wwwdotorg.org>
> Fixes: 9395a4500404 ("cgroup: enable refcnting for root csses")
> ---
> Patch applied to cgroup/for-3.16.

Unfortunately, this patch doesn't seem to solve the problem for me. I
still get a hang/crash very early during boot, before earlyprintk stars.

I tried this patch on top of both next-20150115, and next-20150516. For
both those kernels, reverting the original problematic patch does
resolve the problem.

I'll try to investigate more later today.
