Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbaI0TRC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 15:17:02 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49839 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbaI0TRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 15:17:00 -0400
Date: Sat, 27 Sep 2014 20:16:57 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mikhail Efremov <sem@altlinux.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] vfs: Don't exchange "short" filenames unconditionally.
Message-ID: <20140927191657.GU7996@ZenIV.linux.org.uk>
References: <1411582473-29184-1-git-send-email-sem@altlinux.org>
 <20140924185521.GC7996@ZenIV.linux.org.uk>
 <CA+55aFzTs5R_TzwdsBRAkw+mGLWF0XT9_sGeb_+ETUy-gJsY_w@mail.gmail.com>
 <20140924201813.GI7996@ZenIV.linux.org.uk>
 <20140925044601.GL7996@ZenIV.linux.org.uk>
 <20140926164442.GA26897@ZenIV.linux.org.uk>
 <20140927044555.GS7996@ZenIV.linux.org.uk>
 <CA+55aFyw8U94tYVB9Xbo7gh1SC_f9ecKSoFL509bXM122dC46Q@mail.gmail.com>
 <20140927183139.GT7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140927183139.GT7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 27, 2014 at 07:31:39PM +0100, Al Viro wrote:

> We can get the long name cases right, and I agree that it'll make the
> things nicer, but it might take a couple of days to get right.  The thing
> I'm concerned about is not screwing DCACHE_RCUACCESS up.

FWIW, I suspect that the right approach is to put refcount + rcu_head in
front of external name and do the following:
	* __d_free() checks if we have an external name, gets its containing
structure and does if (atomic_dec_and_test(&name->count)) kfree(name);
	* switch_names() in non-exchange case (I'd probably call it copy_name,
not move_names, but anyway) sets DCACHE_RCUACCESS on target (source has
already gotten it from __d_rehash()), increments refcount on target's name
if external and, if the source old name is external, decrements its refcount
and calls kfree_rcu() if it has hit zero.

AFAICS, it guarantees that we'll schedule an RCU callback on name's rch_head
at most once, that we won't free it while RCU callback on it is scheduled
and we won't free it until a grace period has expired since the last time
it had been referenced by observable dentries.  Do you see any holes in that?

