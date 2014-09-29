Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbaI2TE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 15:04:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53347 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbaI2TE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 15:04:26 -0400
Date: Mon, 29 Sep 2014 20:04:21 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mikhail Efremov <sem@altlinux.org>
Subject: Re: [PATCH v2] vfs: Don't exchange "short" filenames unconditionally.
Message-ID: <20140929190421.GK7996@ZenIV.linux.org.uk>
References: <CA+55aFyw8U94tYVB9Xbo7gh1SC_f9ecKSoFL509bXM122dC46Q@mail.gmail.com>
 <20140927183139.GT7996@ZenIV.linux.org.uk>
 <20140927191657.GU7996@ZenIV.linux.org.uk>
 <20140928074747.GZ7996@ZenIV.linux.org.uk>
 <20140928180556.GA7996@ZenIV.linux.org.uk>
 <CA+55aFxZDsD94CSDYfyw9g3WWNkVApZDKxHVhK2zy0ycRsjcmA@mail.gmail.com>
 <20140929155918.GG7996@ZenIV.linux.org.uk>
 <CA+55aFyveyOABqssxLinsmHkBg9=95TwEGC1ZT1POe+RmTbj+A@mail.gmail.com>
 <20140929162714.GH7996@ZenIV.linux.org.uk>
 <CA+55aFxeD-m0ddKrYr9-A804rqvdvPB-aczV=HV=5hqpK7-XyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxeD-m0ddKrYr9-A804rqvdvPB-aczV=HV=5hqpK7-XyQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 10:54:59AM -0700, Linus Torvalds wrote:
> On Mon, Sep 29, 2014 at 9:27 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > What we get in free_dentry() is:
> >         * external name not shared: refcount driven to 0, RCU-delayed
> > call of "free dentry, free ext name"
> >         * external name still shared: refcount positive after decrement,
> > no freeing ext name
> >         * no external name: no ext name to free
> > In the last two cases we do what dentry_free() used to do, except that now
> > __d_free() doesn't even look for ext name.  Just frees the dentry.  If
> > it never had been hashed - directly called, otherwise - via call_rcu().
> >
> > Does that look OK for you?
> 
> Yes. That looks fairly straightforward.
> 
> Although please rename that "ext" in ext_name/__d_free_ext() to
> something else. "ext" to me says not "external", but "extended". I
> think we can just write out "external", like we already do in
> "dname_external()".

That we do...  Why is it in dcache.h, BTW?  No users outside of fs/dcache.c
and I can't imagine a valid use for it in a module, let alone out-of-tree
one...

ObAnnoyance: gcc not figuring out that this container_of() isn't going to be
NULL...  Sure, somebody might put (char *)16 into dentry->d_name.name, but...
As it is, it makes for messier code generation; I can work around that, of
course, but it's uglier than it ought to be ;-/

OK, see vfs.git#copy_name.  Warning: it does need testing.  Two commits in
there, one adding data dependency barrier in prepend_name(), another - this
thing.  Comments would be welcome...
