Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933385Ab3EFXYC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:24:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36879 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170Ab3EFXNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:13:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>
Subject: [ 073/104] cgroup: fix an off-by-one bug which may trigger BUG_ON()
Date: Mon,  6 May 2013 16:12:32 -0700
Message-Id: <20130506230051.132165514@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506230043.526528358@linuxfoundation.org>
References: <20130506230043.526528358@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zefan <lizefan@huawei.com>

commit 3ac1707a13a3da9cfc8f242a15b2fae6df2c5f88 upstream.

The 3rd parameter of flex_array_prealloc() is the number of elements,
not the index of the last element.

The effect of the bug is, when opening cgroup.procs, a flex array will
be allocated and all elements of the array is allocated with
GFP_KERNEL flag, but the last one is GFP_ATOMIC, and if we fail to
allocate memory for it, it'll trigger a BUG_ON().

Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2066,7 +2066,7 @@ static int cgroup_attach_proc(struct cgr
 	if (!group)
 		return -ENOMEM;
 	/* pre-allocate to guarantee space while iterating in rcu read-side. */
-	retval = flex_array_prealloc(group, 0, group_size - 1, GFP_KERNEL);
+	retval = flex_array_prealloc(group, 0, group_size, GFP_KERNEL);
 	if (retval)
 		goto out_free_group_list;
 


