Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802Ab3LIO4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 09:56:40 -0500
Received: from mga01.intel.com ([192.55.52.88]:40797 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761102Ab3LIO4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 09:56:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,858,1378882800"; 
   d="scan'208";a="447005522"
Date: Mon, 9 Dec 2013 22:56:51 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: BUG: sleeping function called from invalid context at
 kernel/locking/rwsem.c:20
Message-ID: <20131209145651.GV5135@yliu-dev.sh.intel.com>
References: <20131205031051.GC5135@yliu-dev.sh.intel.com>
 <20131205225019.GA32005@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131205225019.GA32005@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 05:50:19PM -0500, Tejun Heo wrote:
> On Thu, Dec 05, 2013 at 11:10:51AM +0800, Yuanhan Liu wrote:
> > Greetings,
> > 
> > I got the below dmesg and the first bad commit is
> > 
> > commit 4b93dc9b1c684d0587fe44d36bbfdf45bd3bea9d
> > Author:     Tejun Heo <tj@kernel.org>
> > AuthorDate: Thu Nov 28 14:54:43 2013 -0500
> > Commit:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > CommitDate: Fri Nov 29 18:16:08 2013 -0800
> > 
> >     sysfs, kernfs: prepare mount path for kernfs
> 
> Oops, can you please try the following patch?

Sorry for being a bit late, but, it does work!

	--yliu
> 
> diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
> index e7e3aa8..8d07527 100644
> --- a/fs/sysfs/mount.c
> +++ b/fs/sysfs/mount.c
> @@ -45,8 +45,10 @@ static struct dentry *sysfs_mount(struct file_system_type *fs_type,
>  
>  static void sysfs_kill_sb(struct super_block *sb)
>  {
> +	void *ns = (void *)kernfs_super_ns(sb);
> +
>  	kernfs_kill_sb(sb);
> -	kobj_ns_drop(KOBJ_NS_TYPE_NET, (void *)kernfs_super_ns(sb));
> +	kobj_ns_drop(KOBJ_NS_TYPE_NET, ns);
>  }
>  
>  static struct file_system_type sysfs_fs_type = {
