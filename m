Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbaIZUX2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 16:23:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47959 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047AbaIZUX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 16:23:27 -0400
Date: Fri, 26 Sep 2014 21:23:22 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mikhail Efremov <sem@altlinux.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Sage Weil <sage@inktank.com>
Subject: Re: [PATCH v2] vfs: Don't exchange "short" filenames unconditionally.
Message-ID: <20140926202322.GA11829@ZenIV.linux.org.uk>
References: <1411582473-29184-1-git-send-email-sem@altlinux.org>
 <20140924185521.GC7996@ZenIV.linux.org.uk>
 <CA+55aFzTs5R_TzwdsBRAkw+mGLWF0XT9_sGeb_+ETUy-gJsY_w@mail.gmail.com>
 <20140924201813.GI7996@ZenIV.linux.org.uk>
 <20140925044601.GL7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140925044601.GL7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 05:46:01AM +0100, Al Viro wrote:

> I really wonder if it's possible to get d_rehash() hitting the victim of
> (non-exchange) __d_move().  _Then_ this patch (as well as the historical
> behaviour it restores, all way back to 2.5, if not 2.3) would, indeed,
> be buggy.

More fun: what's going on in ceph_handle_notrace_create()?  AFAICS, this
        struct dentry *result = ceph_lookup(dir, dentry, 0);

        if (result && !IS_ERR(result)) {
                /*
                 * We created the item, then did a lookup, and found
                 * it was already linked to another inode we already
                 * had in our cache (and thus got spliced).  Link our
                 * dentry to that inode, but don't hash it, just in  
                 * case the VFS wants to dereference it.
                 */
                BUG_ON(!result->d_inode);
                d_instantiate(dentry, result->d_inode);
                return 0;
        }
is bogus.  What will happen if server goes nuts and that existing alias picked
by lookup turns out to be a directory?  And while we are at it, what's to
prevent a leak if we ever hit that codepath, directory or no directory?
Sage?
