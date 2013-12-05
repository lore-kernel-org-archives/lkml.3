Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab3LEWuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 17:50:25 -0500
Received: from mail-yh0-f52.google.com ([209.85.213.52]:45891 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab3LEWuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 17:50:23 -0500
Date: Thu, 5 Dec 2013 17:50:19 -0500
From: Tejun Heo <tj@kernel.org>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: BUG: sleeping function called from invalid context at
 kernel/locking/rwsem.c:20
Message-ID: <20131205225019.GA32005@mtj.dyndns.org>
References: <20131205031051.GC5135@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131205031051.GC5135@yliu-dev.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 11:10:51AM +0800, Yuanhan Liu wrote:
> Greetings,
> 
> I got the below dmesg and the first bad commit is
> 
> commit 4b93dc9b1c684d0587fe44d36bbfdf45bd3bea9d
> Author:     Tejun Heo <tj@kernel.org>
> AuthorDate: Thu Nov 28 14:54:43 2013 -0500
> Commit:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CommitDate: Fri Nov 29 18:16:08 2013 -0800
> 
>     sysfs, kernfs: prepare mount path for kernfs

Oops, can you please try the following patch?

Thanks.

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index e7e3aa8..8d07527 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -45,8 +45,10 @@ static struct dentry *sysfs_mount(struct file_system_type *fs_type,
 
 static void sysfs_kill_sb(struct super_block *sb)
 {
+	void *ns = (void *)kernfs_super_ns(sb);
+
 	kernfs_kill_sb(sb);
-	kobj_ns_drop(KOBJ_NS_TYPE_NET, (void *)kernfs_super_ns(sb));
+	kobj_ns_drop(KOBJ_NS_TYPE_NET, ns);
 }
 
 static struct file_system_type sysfs_fs_type = {
