Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759157Ab3GaIQn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 04:16:43 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:29589 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759063Ab3GaIQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 04:16:39 -0400
Message-ID: <51F8C7DC.8060306@huawei.com>
Date: Wed, 31 Jul 2013 16:16:28 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 1/7] cgroup: fix a leak when percpu_ref_init() fails
References: <51F8C7C5.9040608@huawei.com>
In-Reply-To: <51F8C7C5.9040608@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ss->css_free() is not called when perfcpu_ref_init() fails.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a64b7b8..e60eba2 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4274,8 +4274,10 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 		}
 
 		err = percpu_ref_init(&css->refcnt, css_release);
-		if (err)
+		if (err) {
+			ss->css_free(cgrp);
 			goto err_free_all;
+		}
 
 		init_cgroup_css(css, ss, cgrp);
 	}
-- 
1.8.0.2
