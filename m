Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab3FOFJq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 01:09:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34510 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab3FOFJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 01:09:43 -0400
Date: Sat, 15 Jun 2013 06:09:39 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Chiluk <chiluk@canonical.com>
Cc: Petr Vandrovec <petr@vandrovec.name>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ncpfs: fix rmdir returns Device or resource busy
Message-ID: <20130615050939.GO4165@ZenIV.linux.org.uk>
References: <1369781410-24473-1-git-send-email-chiluk@canonical.com>
 <51A918B8.20303@canonical.com>
 <CA+i2_De5HHw2H9SvZ=W+QAOcy0M7jFac88OK6aeYdJVCGL6b+A@mail.gmail.com>
 <51AF9D77.2000901@canonical.com>
 <CA+i2_DfEhn_CPRBmyy4scG7UEL5bGsjodcq00Nyx4JZjnuSBGQ@mail.gmail.com>
 <51B205A1.4040405@canonical.com>
 <20130607161452.GI13110@ZenIV.linux.org.uk>
 <20130613020122.GA20274@ZenIV.linux.org.uk>
 <20130613064235.GK4165@ZenIV.linux.org.uk>
 <51BA99CE.8000902@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51BA99CE.8000902@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 11:19:26PM -0500, Dave Chiluk wrote:

> I'm afraid you are way beyond my current vfs experience level on this
> one.  While you're getting rid of things you might consider
> dentry_unhash as well, as only hpfs_unlink, ncp_rmdir, and ncp_rename
> call that.

The trouble is, hpfs_unlink() really wants it, so we probably won't be
able to kill that off.

> If you get a patch together, I'll do my best to test it.  Looks like
> only ncp_readdir calls that, so afaik, a few varying ls commands should
> be all that's needed for a test.

... combined with memory pressure and changes to directory, to test the
invalidation logics.

> Dave.
> p.s. are you sure you don't just want to just deprecate all of ncpfs?

Don't tempt me ;-)  As far as I'm concerned, everything NetWare-related is
best dealt by fine folks from Miskatonic University, with all the precautions
due when working with spawn of the Old Ones...

Speaking of the madness and perversion: take a look at ncp_fill_cache().
What happens there is that we try to find or create a dentry according
to the directory entry we've got from server, then stuff a reference to
it into page cache of directory inode and call filldir for that sucker.
	* if dentry allocation fails, we skip stuffing a reference into
page cache.  Result: garbage pointer left there.  _Another_ result:
if that happens more than page size / sizeof(pointer) times and then
we finally manage to allocate an entry (or just find one already in
dcache), we hit this:
        if (ctl.idx >= NCP_DIRCACHE_SIZE) {
                if (ctl.page) {
                        kunmap(ctl.page);
                        SetPageUptodate(ctl.page);
                        unlock_page(ctl.page);
                        page_cache_release(ctl.page);
                }
                ctl.cache = NULL;
                ctl.idx  -= NCP_DIRCACHE_SIZE;
                ctl.ofs  += 1;
                ctl.page  = grab_cache_page(&dir->i_data, ctl.ofs);
                if (ctl.page)
                        ctl.cache = kmap(ctl.page);
        }
ctx.idx was being incrmented on each entry, so now we are past
NCP_DIRCACHE_SIZE * 2.  We subtract NCP_DIRCACHE_SIZE, increment
ctl.ofs (page number), grab that page... and proceed to
        if (ctl.cache) {
                ctl.cache->dentry[ctl.idx] = newdent;
                valid = 1;
        }
which stuffs pointer past the end of that page.  And no, the caller
won't stop calling that on the first failure - if ->f_pos is large
enough, we'll record the failure in ctl.valid and have ncp_fill_cache()
return true - ctl.filled is false (== filldir hadn't told us to stop,
since we hadn't called it at all), so ctl.valid || !ctl.filled is
true.  IOW, the loop in caller will keep calling that sucker.

What's more, if ctl.valid is set to 0, there's no point bothering with
page cache anymore - it won't be used at all and on the next readdir()
we'll reread from scratch.

Even better, OOM for inode allocation is treated differently - we stuff
a reference to negative dentry into page cache, so that ncp_dget_fpos()
will find it, notice that it's negative and return NULL.  At which
point the caller will invalidate the damn cache and reread everything
from scratch.  Why bother stuffing it there at all?

BTW, in ncp_fill_cache() we have a provably pointless
                if (!ino)
                        ino = find_inode_number(dentry, &qname);
Check it out - any path that can lead there with ino == 0 will *not*
have a positive dentry with such name, so this find_inode_number()
call is just "waste some time and return 0".  Cargo-cult, plain and
simple...

Grr...  When has that code been read the last time?
