Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbaFTTKc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:10:32 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:60324 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaFTTKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:10:30 -0400
Date: Fri, 20 Jun 2014 15:10:25 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 3/5] cgroup: fix mount failure in a corner case
Message-ID: <20140620191025.GA28324@mtj.dyndns.org>
References: <53994943.60703@huawei.com>
 <5399496D.6060003@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5399496D.6060003@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 02:32:13PM +0800, Li Zefan wrote:
> @@ -1677,6 +1679,22 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
>  		goto out_unlock;
>  	}
>  
> +	/*
> +	 * If some subsystems have been bound to existing cgroup hierarchies,
> +	 * but those hierachies are being destroyed, let's wait a little bit
> +	 * and retry.
> +	 */
> +	for_each_subsys(ss, i) {
> +		if (!(opts.subsys_mask & (1 << i)))
> +			continue;
> +		if (!percpu_ref_alive(&ss->root->cgrp.self.refcnt)) {

Can't we just do tryget_live() instead and then put before retrying?
It's not exactly a hot path and the operations are dirt cheap anyway.

Thanks.

-- 
tejun
