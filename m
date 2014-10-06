Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383AbaJFEZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 00:25:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42047 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaJFEZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 00:25:23 -0400
Date: Mon, 6 Oct 2014 05:25:17 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, bfields@redhat.com,
        mszeredi@suse.cz, "Eric W. Biederman" <ebiederm@xmission.com>,
        hch@lst.de, Dave Jones <davej@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: dcache: NULL ptr deref in dentry_kill
Message-ID: <20141006042517.GB7996@ZenIV.linux.org.uk>
References: <5431E203.9070501@oracle.com>
 <20141006031355.GA7996@ZenIV.linux.org.uk>
 <54320FB0.7060403@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54320FB0.7060403@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 05, 2014 at 11:42:40PM -0400, Sasha Levin wrote:
> On 10/05/2014 11:13 PM, Al Viro wrote:
> > On Sun, Oct 05, 2014 at 08:27:47PM -0400, Sasha Levin wrote:
> > 
> >> [  434.580818] BUG: unable to handle kernel NULL pointer dereference at 0000000000000090
> >> [  434.582208] IP: do_raw_spin_trylock (./arch/x86/include/asm/spinlock.h:108 kernel/locking/spinlock_debug.c:143)
> > [snip]
> > spin_lock((void *)0x90)
> >> [  434.590025] ? _raw_spin_trylock (include/linux/spinlock_api_smp.h:89 kernel/locking/spinlock.c:135)
> >> [  434.590025] ? lockref_put_or_lock (lib/lockref.c:131)
> >> [  434.590025] dput (fs/dcache.c:513 fs/dcache.c:616)
> > 
> > ummm...  lockref_put_or_lock(&dentry->d_lockref) ending up with 0x90 passed
> > to lockref_put_or_lock()...  What offset does d_lockref have on your build?
> 
> 0x90

Huh???  It means that we got to that lockref_put_or_lock with dentry == NULL.
But that makes no sense at all - we have
void dput(struct dentry *dentry)
{
        if (unlikely(!dentry))
                return;

repeat:
        if (lockref_put_or_lock(&dentry->d_lockref))
                return;
	...
and the only branch to repeat: is
        if (dentry)
                goto repeat;

If we get to that lockref_put_or_lock() with dentry == NULL, something's
very wrong with compiler.  And the only other lockref_put_or_lock() in
there is
                while (dentry && !lockref_put_or_lock(&dentry->d_lockref)) {
which would also make NULL dentry a miscompile.

Could you put fs/dcache.s for your build on some anonftp?  That really
smells like compiler breakage; had the address it tried to access been
close but not equal to that offsetof(), we would be dealing with bogus
->f_path.dentry (close to, but not quite NULL).  As it is, it looks like
dput() somehow getting to that line with NULL dentry, which should've
been prevented by the checks there...
