Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbbAMWuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 17:50:51 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:36475 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbbAMWut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 17:50:49 -0500
Message-ID: <54B5A145.6060108@oracle.com>
Date: Tue, 13 Jan 2015 17:50:45 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jeff Layton <jeff.layton@primarydata.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: fs: locks: WARNING: CPU: 16 PID: 4296 at fs/locks.c:236 locks_free_lock_context+0x10d/0x240()
References: <54B4A909.9060206@oracle.com> <20150113164441.5b210f48@tlielax.poochiereds.net>
In-Reply-To: <20150113164441.5b210f48@tlielax.poochiereds.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2015 04:44 PM, Jeff Layton wrote:
> On Tue, 13 Jan 2015 00:11:37 -0500
> Sasha Levin <sasha.levin@oracle.com> wrote:
> 
>> Hey Jeff,
>>
>> While fuzzing with trinity inside a KVM tools guest running the latest -next
>> kernel, I've stumbled on the following spew:
>>
>> [  887.078606] WARNING: CPU: 16 PID: 4296 at fs/locks.c:236 locks_free_lock_context+0x10d/0x240()
>> [  887.079703] Modules linked in:
>> [  887.080288] CPU: 16 PID: 4296 Comm: trinity-c273 Not tainted 3.19.0-rc4-next-20150112-sasha-00053-g23c147e02e-dirty #1710
>> [  887.082229]  0000000000000000 0000000000000000 0000000000000000 ffff8804c9f4f8e8
>> [  887.083773]  ffffffff9154e0a6 0000000000000000 ffff8804cad98000 ffff8804c9f4f938
>> [  887.085280]  ffffffff8140a4d0 0000000000000001 ffffffff81bf0d2d ffff8804c9f4f988
>> [  887.086792] Call Trace:
>> [  887.087320] dump_stack (lib/dump_stack.c:52)
>> [  887.088247] warn_slowpath_common (kernel/panic.c:447)
>> [  887.089342] ? locks_free_lock_context (fs/locks.c:236 (discriminator 3))
>> [  887.090514] warn_slowpath_null (kernel/panic.c:481)
>> [  887.091629] locks_free_lock_context (fs/locks.c:236 (discriminator 3))
>> [  887.092782] __destroy_inode (fs/inode.c:243)
>> [  887.093817] destroy_inode (fs/inode.c:268)
>> [  887.094833] evict (fs/inode.c:574)
>> [  887.095808] iput (fs/inode.c:1503)
>> [  887.096687] __dentry_kill (fs/dcache.c:323 fs/dcache.c:508)
>> [  887.097683] ? _raw_spin_trylock (kernel/locking/spinlock.c:136)
>> [  887.098733] ? dput (fs/dcache.c:545 fs/dcache.c:648)
>> [  887.099672] dput (fs/dcache.c:649)
>> [  887.100552] __fput (fs/file_table.c:227)
> 
> So, looking at this a bit more...
> 
> It's clear that we're at the dput in __fput at this point. Much earlier
> in __fput, we call locks_remove_file to remove all of the locks that
> are associated with the file description.
> 
> Evidently though, something didn't go right there. The two most likely
> scenarios to my mind are:
> 
> A) a lock raced onto the list somehow after that point. That seems
> unlikely since presumably the fcheck should have failed at that point.
> 
> ...or...
> 
> B) the CPU that called locks_remove_file mistakenly thought that
> inode->i_flctx was NULL when it really wasn't (stale cache, perhaps?).
> That would make it skip trying to remove any flock locks.
> 
> B seems more likely to me, and if it's the case then that would seem to
> imply that we need some memory barriers (or maybe some ACCESS_ONCE
> calls) in these codepaths. I'll have to sit down and work through it to
> see what makes the most sense.
> 
> If your debugging seems to jive with this, then one thing that might be
> interesting would be to comment out these two lines in
> locks_remove_flock:
> 
>         if (!file_inode(filp)->i_flctx)
>                 return;
> 
> ...and see if it's still reproducible. That's obviously not a real fix
> for this problem, but it might help prove whether the above suspicion
> is correct.

Removing those two lines makes the issue go away.

I'm guessing that figuring out which filesystem we were abusing isn't
interesting anymore...


Thanks,
Sasha

