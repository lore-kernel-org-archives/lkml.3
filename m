Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751030AbaHOLhW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 07:37:22 -0400
Received: from relay.parallels.com ([195.214.232.42]:35237 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaHOLhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 07:37:16 -0400
Message-ID: <53EDF0E9.6050908@parallels.com>
Date: Fri, 15 Aug 2014 15:37:13 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: fuse-devel <fuse-devel@lists.sourceforge.net>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fuse: do not evict dirty inodes
References: <20140603114827.3188.35705.stgit@localhost.localdomain> <CAJfpegsee+n14g6JoLOxq5DKy_9cptWR200W1aH3vr65wjZjqQ@mail.gmail.com>
In-Reply-To: <CAJfpegsee+n14g6JoLOxq5DKy_9cptWR200W1aH3vr65wjZjqQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.22.200]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos,

On 08/13/2014 02:32 PM, Miklos Szeredi wrote:
> On Tue, Jun 3, 2014 at 1:49 PM, Maxim Patlasov <MPatlasov@parallels.com> wrote:
>> Commit 1e18bda8 added .write_inode method to the fuse super_operations. This
>> allowed fuse to use the kernel infrastructure for writing out dirty metadata
>> (mtime and ctime for now). However, given that .drop_inode was not redefined
>> from the legacy generic_delete_inode(), on umount(2) generic_shutdown_super()
>> led to the eviction of all inodes disregarding their state.
>>
>> The patch removes .drop_inode definition from the fuse super_operations. This
>> works because now iput_final() calls generic_drop_inode() and returns w/o
>> evicting inode. This, in turn, allows generic_shutdown_super() to write dirty
>> inodes by calling sync_filesystem().
>>
>> Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
>> ---
>>   fs/fuse/inode.c |    1 -
>>   1 file changed, 1 deletion(-)
>>
>> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
>> index 754dcf2..ee017be 100644
>> --- a/fs/fuse/inode.c
>> +++ b/fs/fuse/inode.c
>> @@ -791,7 +791,6 @@ static const struct super_operations fuse_super_operations = {
>>          .destroy_inode  = fuse_destroy_inode,
>>          .evict_inode    = fuse_evict_inode,
>>          .write_inode    = fuse_write_inode,
>> -       .drop_inode     = generic_delete_inode,
>>          .remount_fs     = fuse_remount_fs,
>>          .put_super      = fuse_put_super,
>>          .umount_begin   = fuse_umount_begin,
>>
> (Sorry about the late answer)
>
> Big problem with this is that I don't want to make umount(2) and
> sync(2) wait on userspace filesystem.  Generally this would make
> umount() hang if a fuse daemon was stuck for any reason.

I think we must honour interests both privileged and unprivileged 
mounts. In case of trusted environment where only sysad decides which 
fuse daemons are eligible to run, blocking umount() is completely fine. 
And more than that, after settling down that sync-close feature, I 
intend to take on synchronous umount (it's a shame that users have no 
tools to find out when umount completed better than monitoring of fuse 
daemon in proc table waiting for daemon termination). So we could put 
such a behaviour under control of a tunable parameter.

>
> But is this really necessary?
>
> We are talking about just regular files: mtime is only updated by
> write(2) and friends. ctime is updated by write(2) as well as some
> other ops.  For write, we can sync the times on FLUSH (close), for
> other ops we could flush the ctime synchronously.  E.g. unlink would
> trigger UNLINK and SETATTR.
>
> Long term, much better solution would be to add a timestamp to
> fuse_in_header which would remove the duplicate requests and then we
> could also extend the kernel caching of timestamps from just regular
> files to everything, which would make the protocol conceptually
> simpler.

I like the idea of extending fuse_in_header. But if we'll extend it, why 
not go further adding timestamps for mtime and atime as well? Because 
pushing mtime along with data modifications is more reliable than 
postponing flush to write_inode call. Also, this would simplify the code 
a lot -- no more fuse_write_inode and fuse_flush_times needed. And who 
knows, may be someone will request proper atime handling at some point 
in future. If you're OK about:

> @@ -675,10 +675,15 @@ struct fuse_in_header {
>         uint32_t        opcode;
>         uint64_t        unique;
>         uint64_t        nodeid;
> +       uint64_t        atime;
> +       uint64_t        mtime;
> +       uint64_t        ctime;
> +       uint32_t        atimensec;
> +       uint32_t        mtimensec;
> +       uint32_t        ctimensec;
>         uint32_t        uid;
>         uint32_t        gid;
>         uint32_t        pid;
> -       uint32_t        padding;
>  };

I could work on the patch.

Thanks,
Maxim
