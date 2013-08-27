Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab3H0Sdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 14:33:52 -0400
Received: from mail-qe0-f49.google.com ([209.85.128.49]:57314 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab3H0Sdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 14:33:51 -0400
Date: Tue, 27 Aug 2013 14:33:44 -0400
From: Tejun Heo <tj@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the cgroup tree
Message-ID: <20130827183344.GB12212@mtj.dyndns.org>
References: <20130827201716.528af63c96b66bb2446fc4b7@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130827201716.528af63c96b66bb2446fc4b7@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 08:17:16PM +1000, Stephen Rothwell wrote:
> Hi Tejun,
> 
> After merging the cgroup tree, today's linux-next build (i386 defconfig)
> produced this warning:
> 
> kernel/cgroup.c: In function 'css_from_id':
> kernel/cgroup.c:5723:3: warning: passing argument 2 of 'cgroup_css' makes pointer from integer without a cast [enabled by default]
> kernel/cgroup.c:237:36: note: expected 'struct cgroup_subsys *' but argument is of type 'int'
> 
> Introduced by commit ca8bdcaff0d7 ("cgroup: make cgroup_css() take
> cgroup_subsys * instead and allow NULL subsys").

Yeap, the conversion missed a newly added function, which BTW
currently doesn't have any users.  Applied the following fix.

Thanks a lot!

>From d1625964da51bda61306ad3ec45307a799c21f08 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Tue, 27 Aug 2013 14:27:23 -0400
Subject: [PATCH] cgroup: fix cgroup_css() invocation in css_from_id()

ca8bdcaff0 ("cgroup: make cgroup_css() take cgroup_subsys * instead
and allow NULL subsys") missed one conversion in css_from_id(), which
was newly added.  As css_from_id() doesn't have any user yet, this
doesn't break anything other than generating a build warning.

Convert it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
---
 kernel/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e76698d..b5f4989 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5729,7 +5729,7 @@ struct cgroup_subsys_state *css_from_id(int id, struct cgroup_subsys *ss)
 
 	cgrp = idr_find(&ss->root->cgroup_idr, id);
 	if (cgrp)
-		return cgroup_css(cgrp, ss->subsys_id);
+		return cgroup_css(cgrp, ss);
 	return NULL;
 }
 
-- 
1.8.3.1
