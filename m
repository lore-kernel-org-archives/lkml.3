Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbaJFEjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 00:39:32 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:41907 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaJFEj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 00:39:29 -0400
Message-ID: <54321CF4.9070101@oracle.com>
Date: Mon, 06 Oct 2014 00:39:16 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>, bfields@redhat.com,
        mszeredi@suse.cz, "Eric W. Biederman" <ebiederm@xmission.com>,
        hch@lst.de, Dave Jones <davej@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: dcache: NULL ptr deref in dentry_kill
References: <5431E203.9070501@oracle.com> <20141006031355.GA7996@ZenIV.linux.org.uk> <54320FB0.7060403@oracle.com> <20141006042517.GB7996@ZenIV.linux.org.uk>
In-Reply-To: <20141006042517.GB7996@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2014 12:25 AM, Al Viro wrote:
> On Sun, Oct 05, 2014 at 11:42:40PM -0400, Sasha Levin wrote:
>> On 10/05/2014 11:13 PM, Al Viro wrote:
>>> On Sun, Oct 05, 2014 at 08:27:47PM -0400, Sasha Levin wrote:
>>>
>>>> [  434.580818] BUG: unable to handle kernel NULL pointer dereference at 0000000000000090
>>>> [  434.582208] IP: do_raw_spin_trylock (./arch/x86/include/asm/spinlock.h:108 kernel/locking/spinlock_debug.c:143)
>>> [snip]
>>> spin_lock((void *)0x90)
>>>> [  434.590025] ? _raw_spin_trylock (include/linux/spinlock_api_smp.h:89 kernel/locking/spinlock.c:135)
>>>> [  434.590025] ? lockref_put_or_lock (lib/lockref.c:131)
>>>> [  434.590025] dput (fs/dcache.c:513 fs/dcache.c:616)
>>>
>>> ummm...  lockref_put_or_lock(&dentry->d_lockref) ending up with 0x90 passed
>>> to lockref_put_or_lock()...  What offset does d_lockref have on your build?
>>
>> 0x90
> 
> Huh???  It means that we got to that lockref_put_or_lock with dentry == NULL.
> But that makes no sense at all - we have
> void dput(struct dentry *dentry)
> {
>         if (unlikely(!dentry))
>                 return;
> 
> repeat:
>         if (lockref_put_or_lock(&dentry->d_lockref))
>                 return;
> 	...
> and the only branch to repeat: is
>         if (dentry)
>                 goto repeat;
> 
> If we get to that lockref_put_or_lock() with dentry == NULL, something's
> very wrong with compiler.  And the only other lockref_put_or_lock() in
> there is
>                 while (dentry && !lockref_put_or_lock(&dentry->d_lockref)) {
> which would also make NULL dentry a miscompile.
> 
> Could you put fs/dcache.s for your build on some anonftp?  That really
> smells like compiler breakage; had the address it tried to access been
> close but not equal to that offsetof(), we would be dealing with bogus
> ->f_path.dentry (close to, but not quite NULL).  As it is, it looks like
> dput() somehow getting to that line with NULL dentry, which should've
> been prevented by the checks there...

I think you've misread the stack trace. The lockref_put_or_lock isn't reliable
(probably just a derelict from the previous, successful call to it), and the
stack trace's reliable symbols takes us elsewhere.

Stack trace shows that:

[  434.590025] dput (fs/dcache.c:513 fs/dcache.c:616)
[  434.590025] __fput (fs/file_table.c:235)
[  434.590025] ____fput (fs/file_table.c:253)

Looking at fs/dcache.c:616 we see:

	kill_it:
	        dentry = dentry_kill(dentry); <=== This
        	if (dentry)
                	goto repeat;

And within dentry_kill() (fs/dcache.c:513):

        if (!IS_ROOT(dentry)) {
                parent = dentry->d_parent;
                if (unlikely(!spin_trylock(&parent->d_lock))) { <=== here
                        if (inode)
                                spin_unlock(&inode->i_lock);
                        goto failed;

We're trying to deref a NULL 'parent'.

Looking at git history, this check was slightly changed to remove the
'parent != NULL' condition in e55fd01154 ("split dentry_kill()"):

	-       }
	        if (!IS_ROOT(dentry))
	                parent = dentry->d_parent;
	-       if (parent && !spin_trylock(&parent->d_lock)) {
	-               if (inode)
	-                       spin_unlock(&inode->i_lock);
	[...]
	+       if (!IS_ROOT(dentry)) {
	+               parent = dentry->d_parent;
	+               if (unlikely(!spin_trylock(&parent->d_lock))) {
	+                       if (inode)
	+                               spin_unlock(&inode->i_lock);
	+                       goto failed;
	+               }
	+       }

So this is a case where dentry is not root, but has parent set to NULL.

Although I don't see how that can happen.


Thanks,
Sasha


