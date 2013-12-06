Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049Ab3LFQNU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 11:13:20 -0500
Received: from mail-yh0-f54.google.com ([209.85.213.54]:52766 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab3LFQNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 11:13:18 -0500
Date: Fri, 6 Dec 2013 11:13:12 -0500
From: Tejun Heo <tj@kernel.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Li Zefan <lizefan@huawei.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH cgroup/for-3.13-fixes] cgroup: fix oops in cgroup init
 failure path
Message-ID: <20131206161312.GC13373@htj.dyndns.org>
References: <1386234006-1633-1-git-send-email-vdavydov@parallels.com>
 <20131205211814.GA29598@mtj.dyndns.org>
 <52A1766F.5090808@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A1766F.5090808@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vladimir.

On Fri, Dec 06, 2013 at 11:02:07AM +0400, Vladimir Davydov wrote:
> This patch fixes this bug, but I have a couple of questions regarding it.
> 
> First, cgroup_load_subsys() also calls css_online(), and if it fails, it
> calls cgroup_unload_subsys() to rollback. The latter function executes
> the following command:
> 
>     offline_css(cgroup_css(cgroup_dummy_top, ss));
> 
> But since we failed to online_css(), cgroup_css() will return NULL
> resulting in another oops.

I don't think the root css onlining fails for any existing controllers
but yeah that looks wrong.  Can you please send a patch?

> Second, it's not clear to me why we need the CSS_ONLINE flag at all if
> we never assign css's that we fail to online to a cgroup. AFAIU we will
> never see such css's, because in all places we call offline_css(),
> namely cgroup_destroy_locked() (via kill_css()) and
> cgroup_unload_subsys(), we use cgroup_css() which will return NULL for them.

The whole thing is in flux and will look very different in near
future.  I actually had patches queued which deal with the issue you
spotted but they are being blocked on other changes ATM.  So, yeah,
there are some spurious stuff now.

> Before we get here, we call
> 
>     /* each css holds a ref to the cgroup's dentry and the parent css */
>     for_each_root_subsys(root, ss) {
>         struct cgroup_subsys_state *css = css_ar[ss->subsys_id];
> 
>         dget(dentry);
>         css_get(css->parent);
>     }
> 
> If we fail to online a css, we will only call
> 
>     ss->css_free(css);
> 
> on it skipping css_put() on parent.
> 
> css_put() is called on parent in css_release() on normal destroy path.

You're right.  I'll revise the patch.

Thanks.

-- 
tejun
