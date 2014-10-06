Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396AbaJFDmz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 23:42:55 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:22239 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbaJFDmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 23:42:53 -0400
Message-ID: <54320FB0.7060403@oracle.com>
Date: Sun, 05 Oct 2014 23:42:40 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>, bfields@redhat.com,
        mszeredi@suse.cz, "Eric W. Biederman" <ebiederm@xmission.com>,
        hch@lst.de, Dave Jones <davej@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: dcache: NULL ptr deref in dentry_kill
References: <5431E203.9070501@oracle.com> <20141006031355.GA7996@ZenIV.linux.org.uk>
In-Reply-To: <20141006031355.GA7996@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2014 11:13 PM, Al Viro wrote:
> On Sun, Oct 05, 2014 at 08:27:47PM -0400, Sasha Levin wrote:
> 
>> [  434.580818] BUG: unable to handle kernel NULL pointer dereference at 0000000000000090
>> [  434.582208] IP: do_raw_spin_trylock (./arch/x86/include/asm/spinlock.h:108 kernel/locking/spinlock_debug.c:143)
> [snip]
> spin_lock((void *)0x90)
>> [  434.590025] ? _raw_spin_trylock (include/linux/spinlock_api_smp.h:89 kernel/locking/spinlock.c:135)
>> [  434.590025] ? lockref_put_or_lock (lib/lockref.c:131)
>> [  434.590025] dput (fs/dcache.c:513 fs/dcache.c:616)
> 
> ummm...  lockref_put_or_lock(&dentry->d_lockref) ending up with 0x90 passed
> to lockref_put_or_lock()...  What offset does d_lockref have on your build?

0x90

> On my config it's 0x80 (i.e. that would mean dput((void *)0x10)); could you
> check it on yours?  Do you have CONFIG_DEBUG_LOCK_ALLOC and CONFIG_LOCK_STAT?

I have both of the config options.

>> [  434.590025] __fput (fs/file_table.c:235)
> 
> ... and here we have a struct file with ->f_path.dentry being a small positive
> number.
> 
> Might make sense to slap BUG_ON((unsigned long)dentry < PAGE_SIZE); into
> __fput() and try to reproduce.  And throw
> 	BUG_ON((unsigned long)file->f_path.dentry < PAGE_SIZE);
> into fput(), while we are at it, to see if that's bogus ->f_path.dentry at
> fput() time or if it's getting corrupted between task_work_add() and actual
> execution of __fput().

I'll put those BUG_ONs in and will update if they get hit.

> And the value of offsetof(struct dentry, d_lock) on your build would be
> interesting to see - that would tell us which value are we seeing passed
> to dput().

This is 0x90 as well.


Thanks,
Sasha
