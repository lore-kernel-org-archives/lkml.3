Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbaJOVhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 17:37:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37430 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaJOVhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 17:37:46 -0400
Date: Wed, 15 Oct 2014 14:37:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
        ebiederm@xmission.com, adobriyan@gmail.com, rui.xiang@huawei.com,
        viro@zeniv.linux.org.uk, oleg@redhat.com, gorcunov@openvz.org,
        kirill.shutemov@linux.intel.com, grant.likely@secretlab.ca,
        tytso@mit.edu
Subject: Re: [PATCH linux v3 1/1] fs/proc: use a rb tree for the directory
 entries
Message-Id: <20141015143745.6b00efce5bf8a302d2befca3@linux-foundation.org>
In-Reply-To: <1412672559-5256-2-git-send-email-nicolas.dichtel@6wind.com>
References: <20141006.181448.1696747135961247651.davem@davemloft.net>
	<1412672559-5256-1-git-send-email-nicolas.dichtel@6wind.com>
	<1412672559-5256-2-git-send-email-nicolas.dichtel@6wind.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  7 Oct 2014 11:02:39 +0200 Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:

> The current implementation for the directories in /proc is using a single
> linked list. This is slow when handling directories with large numbers of
> entries (eg netdevice-related entries when lots of tunnels are opened).
> 
> This patch replaces this linked list by a red-black tree.
> 
> ...
>
> --- a/fs/proc/root.c
> +++ b/fs/proc/root.c
> @@ -166,6 +166,7 @@ void __init proc_root_init(void)
>  {
>  	int err;
>  
> +	proc_root.subdir = RB_ROOT;
>  	proc_init_inodecache();
>  	err = register_filesystem(&proc_fs_type);
>  	if (err)

This can be done at compile time can't it?

--- a/fs/proc/root.c~fs-proc-use-a-rb-tree-for-the-directory-entries-fix
+++ a/fs/proc/root.c
@@ -166,7 +166,6 @@ void __init proc_root_init(void)
 {
 	int err;
 
-	proc_root.subdir = RB_ROOT;
 	proc_init_inodecache();
 	err = register_filesystem(&proc_fs_type);
 	if (err)
@@ -252,6 +251,7 @@ struct proc_dir_entry proc_root = {
 	.proc_iops	= &proc_root_inode_operations, 
 	.proc_fops	= &proc_root_operations,
 	.parent		= &proc_root,
+	.subdir		= RB_ROOT,
 	.name		= "/proc",
 };
 
_

