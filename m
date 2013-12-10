Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab3LJNcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 08:32:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40126 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905Ab3LJNcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 08:32:23 -0500
Message-ID: <52A717E2.6040907@suse.cz>
Date: Tue, 10 Dec 2013 14:32:18 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:20
References: <20131205031051.GC5135@yliu-dev.sh.intel.com> <20131205225019.GA32005@mtj.dyndns.org>
In-Reply-To: <20131205225019.GA32005@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2013 11:50 PM, Tejun Heo wrote:
> On Thu, Dec 05, 2013 at 11:10:51AM +0800, Yuanhan Liu wrote:
>> Greetings,
>>
>> I got the below dmesg and the first bad commit is
>>
>> commit 4b93dc9b1c684d0587fe44d36bbfdf45bd3bea9d
>> Author:     Tejun Heo <tj@kernel.org>
>> AuthorDate: Thu Nov 28 14:54:43 2013 -0500
>> Commit:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> CommitDate: Fri Nov 29 18:16:08 2013 -0800
>>
>>      sysfs, kernfs: prepare mount path for kernfs
>
> Oops, can you please try the following patch?
>
> Thanks.
>
> diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
> index e7e3aa8..8d07527 100644
> --- a/fs/sysfs/mount.c
> +++ b/fs/sysfs/mount.c
> @@ -45,8 +45,10 @@ static struct dentry *sysfs_mount(struct file_system_type *fs_type,
>
>   static void sysfs_kill_sb(struct super_block *sb)
>   {
> +	void *ns = (void *)kernfs_super_ns(sb);
> +
>   	kernfs_kill_sb(sb);
> -	kobj_ns_drop(KOBJ_NS_TYPE_NET, (void *)kernfs_super_ns(sb));
> +	kobj_ns_drop(KOBJ_NS_TYPE_NET, ns);
>   }
>
>   static struct file_system_type sysfs_fs_type = {

I've had the same problem with linux-next-20131209 and this patch fixed 
it. Feel free to add if appropriate:

Tested-by: Vlastimil Babka <vbabka@suse.cz>

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

