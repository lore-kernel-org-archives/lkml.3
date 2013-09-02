Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758937Ab3IBT0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 15:26:20 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:20538 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757112Ab3IBT0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 15:26:18 -0400
Message-ID: <5224E647.80303@hp.com>
Date: Mon, 02 Sep 2013 15:25:59 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
References: <5220E56A.80603@hp.com> <CA+55aFzv9BZ2+B2NrNRRtTqnfgbH3LRSvSsUZVsy-g9OpM-8HA@mail.gmail.com> <5220F090.5050908@hp.com> <20130830194059.GC13318@ZenIV.linux.org.uk> <5220F811.9060902@hp.com> <20130830202608.GD13318@ZenIV.linux.org.uk> <52210225.60805@hp.com> <20130830204852.GE13318@ZenIV.linux.org.uk> <52214EBC.90100@hp.com> <20130831023516.GI13318@ZenIV.linux.org.uk> <20130831024233.GJ13318@ZenIV.linux.org.uk>
In-Reply-To: <20130831024233.GJ13318@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2013 10:42 PM, Al Viro wrote:
> On Sat, Aug 31, 2013 at 03:35:16AM +0100, Al Viro wrote:
>
>> Aha...  OK, I see what's going on.  We end up with shm_mnt *not* marked
>> as long-living vfsmount, even though it lives forever.  See if the
>> following helps; if it does (and I very much expect it to), we want to
>> put it in -stable.  As it is, you get slow path in mntput() each time
>> a file created by shmem_file_setup() gets closed.  For no reason whatsoever...
> We still want MS_NOUSER on shm_mnt, so we'd better make sure that
> shmem_fill_super() sets it on the internal instance...  Fixed variant
> follows:
>
> Signed-off-by: Al Viro<viro@zeniv.linux.org.uk>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index e43dc55..5261498 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2615,13 +2615,15 @@ int shmem_fill_super(struct super_block *sb, void *data, int silent)
>   	 * tmpfs instance, limiting inodes to one per page of lowmem;
>   	 * but the internal instance is left unlimited.
>   	 */
> -	if (!(sb->s_flags&  MS_NOUSER)) {
> +	if (!(sb->s_flags&  MS_KERNMOUNT)) {
>   		sbinfo->max_blocks = shmem_default_max_blocks();
>   		sbinfo->max_inodes = shmem_default_max_inodes();
>   		if (shmem_parse_options(data, sbinfo, false)) {
>   			err = -EINVAL;
>   			goto failed;
>   		}
> +	} else {
> +		sb->s_flags |= MS_NOUSER;
>   	}
>   	sb->s_export_op =&shmem_export_ops;
>   	sb->s_flags |= MS_NOSEC;
> @@ -2831,8 +2833,7 @@ int __init shmem_init(void)
>   		goto out2;
>   	}
>
> -	shm_mnt = vfs_kern_mount(&shmem_fs_type, MS_NOUSER,
> -				 shmem_fs_type.name, NULL);
> +	shm_mnt = kern_mount(&shmem_fs_type);
>   	if (IS_ERR(shm_mnt)) {
>   		error = PTR_ERR(shm_mnt);
>   		printk(KERN_ERR "Could not kern_mount tmpfs\n");

Yes, that patch worked. It eliminated the lglock as a bottleneck in the 
AIM7 workload. The lg_global_lock did not show up in the perf profile, 
whereas the lg_local_lock was only 0.07%.

Regards,
Longman
