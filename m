Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbaI1Vvm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 17:51:42 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51473 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbaI1Vvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 17:51:41 -0400
Date: Sun, 28 Sep 2014 22:51:38 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mikhail Efremov <sem@altlinux.org>
Subject: Re: [PATCH v2] vfs: Don't exchange "short" filenames unconditionally.
Message-ID: <20140928215138.GB7996@ZenIV.linux.org.uk>
References: <CA+55aFzTs5R_TzwdsBRAkw+mGLWF0XT9_sGeb_+ETUy-gJsY_w@mail.gmail.com>
 <20140924201813.GI7996@ZenIV.linux.org.uk>
 <20140925044601.GL7996@ZenIV.linux.org.uk>
 <20140926164442.GA26897@ZenIV.linux.org.uk>
 <20140927044555.GS7996@ZenIV.linux.org.uk>
 <CA+55aFyw8U94tYVB9Xbo7gh1SC_f9ecKSoFL509bXM122dC46Q@mail.gmail.com>
 <20140927183139.GT7996@ZenIV.linux.org.uk>
 <20140927191657.GU7996@ZenIV.linux.org.uk>
 <20140928074747.GZ7996@ZenIV.linux.org.uk>
 <20140928180556.GA7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140928180556.GA7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2014 at 07:05:56PM +0100, Al Viro wrote:

> One thing that worries me is the barriers that might be needed on assignments
> to ->d_name.name.  We should be no worse than we are right now - either RCU
> accessors are careful enough with ACCESS_ONCE() and everything's fine,
> or they are not, in which case we already have a bug in mainline - swapping
> ->d_name followed by dput() and freeing of target is no better than
> copying ->d_name from target to source followed by kfree_rcu() of what
> used to be ->d_name.name of source.  IOW, if RCU lookup could pick
> a value of ->d_name.name that got obsolete by d_move() happening
> before our read_lock_rcu(), we would be in trouble anyway - it might
> already have had its freeing RCU-scheduled and thus not delayed
> by read_lock_rcu() done afterwards.  So I think the patch below doesn't
> introduce new problems of that sort, but I'd really appreciate if RCU
> people would take a look at the situation with barriers in that area.
> Are those ACCESS_ONCE() in dentry_cmp() and prepend_name() enough, or
> do we need some barriers in switch_names() as well?

Hmm...  OK, dentry_cmp() is doing something similar to open-coded
rcu_dereference().  prepend_name() does not, and I really wonder if
that's correct...

I'm afraid that the answer is "should've been more careful when switching
d_path() to RCU", but maybe there's something subtle I'm missing there...

I really hate memory ordering rules on alpha ;-/
