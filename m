Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab3LLShl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 13:37:41 -0500
Received: from relay.parallels.com ([195.214.232.42]:60845 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab3LLShk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 13:37:40 -0500
Message-ID: <52AA026C.3040605@parallels.com>
Date: Thu, 12 Dec 2013 22:37:32 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130922 Icedove/17.0.9
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <devel@openvz.org>, Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH] cgroup: fix fail path in cgroup_load_subsys()
References: <1386403085-24866-1-git-send-email-vdavydov@parallels.com> <20131212153536.GD32683@htj.dyndns.org> <20131212155523.GF32683@htj.dyndns.org>
In-Reply-To: <20131212155523.GF32683@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.24.25.135]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 07:55 PM, Tejun Heo wrote:
> On Thu, Dec 12, 2013 at 10:35:36AM -0500, Tejun Heo wrote:
>> On Sat, Dec 07, 2013 at 11:58:05AM +0400, Vladimir Davydov wrote:
>>> We should not call cgroup_unload_subsys() if online_css() fails, because
>>> online_css() does not assign css to cgroup on failure, while
>>> offline_css() called from cgroup_unload_subsys() expects it is assigned.
>>> So let's call everything we need to rollback inline without involving
>>> cgroup_unload_subsys().
>>>
>>> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
>>> Cc: Tejun Heo <tj@kernel.org>
>>> Cc: Li Zefan <lizefan@huawei.com>
>> Applied to cgroup/for-3.13-fixes.
> Scrap that.  I don't think we can fail css_online for the root css in
> 3.13-fixes and this would cause conflict with 3.14, so let's not
> commit it to 3.13-fixes.  Vladimir, can you please respin the patch on
> top of cgroup/for-3.14

No problem.

> but make cgroup_unload_subsys() check whether
> css is actually there before calling offline so that it matches the
> usual offline path better?

You want me to add something like this to the patch, don't you?

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 402f7aa..bc03b97 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4680,6 +4680,7 @@ EXPORT_SYMBOL_GPL(cgroup_load_subsys);
 void cgroup_unload_subsys(struct cgroup_subsys *ss)
 {
     struct cgrp_cset_link *link;
+    struct cgroup_subsys_state *css;
 
     BUG_ON(ss->module == NULL);
 
@@ -4693,7 +4694,9 @@ void cgroup_unload_subsys(struct cgroup_subsys *ss)
     mutex_lock(&cgroup_mutex);
     mutex_lock(&cgroup_root_mutex);
 
-    offline_css(cgroup_css(cgroup_dummy_top, ss));
+    css = cgroup_css(cgroup_dummy_top, ss);
+    if (css)
+        offline_css(css);
 
     /* deassign the subsys_id */
     cgroup_subsys[ss->subsys_id] = NULL;


If so, I don't mind, but why? cgroup_unload_subsys() should never be
called without properly initialized css.

Thanks.
