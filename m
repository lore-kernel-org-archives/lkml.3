Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbaI2P7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 11:59:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52762 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbaI2P7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 11:59:19 -0400
Date: Mon, 29 Sep 2014 16:59:18 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mikhail Efremov <sem@altlinux.org>
Subject: Re: [PATCH v2] vfs: Don't exchange "short" filenames unconditionally.
Message-ID: <20140929155918.GG7996@ZenIV.linux.org.uk>
References: <20140924201813.GI7996@ZenIV.linux.org.uk>
 <20140925044601.GL7996@ZenIV.linux.org.uk>
 <20140926164442.GA26897@ZenIV.linux.org.uk>
 <20140927044555.GS7996@ZenIV.linux.org.uk>
 <CA+55aFyw8U94tYVB9Xbo7gh1SC_f9ecKSoFL509bXM122dC46Q@mail.gmail.com>
 <20140927183139.GT7996@ZenIV.linux.org.uk>
 <20140927191657.GU7996@ZenIV.linux.org.uk>
 <20140928074747.GZ7996@ZenIV.linux.org.uk>
 <20140928180556.GA7996@ZenIV.linux.org.uk>
 <CA+55aFxZDsD94CSDYfyw9g3WWNkVApZDKxHVhK2zy0ycRsjcmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxZDsD94CSDYfyw9g3WWNkVApZDKxHVhK2zy0ycRsjcmA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 08:15:51AM -0700, Linus Torvalds wrote:
> On Sun, Sep 28, 2014 at 11:05 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Folks, care to review and test the following?
> 
> No testing, but having thought about this some more, I'm personally
> getting quite convinced that doing the RCU delaying of the external
> name freeing in the __d_free() path is entirely pointless.
> 
> So I think the *only* rcu_free() you need is for just the "free old
> name" case in copy_name().
> 
> In __d_free(), the name pointer has gone through the same grace period
> that the dentry pointer itself went through. If it's not safe to free
> the external name, then it damn well wouldn't be safe to free the
> dentry itself either.
> 
> IOW, I think your games in __d_free() are totally unnecessary.
> 
> Now you can tell me why I'm wrong.

Sure.  Three dentries.  move the first over the second, dput the second.
The name is shared, the second dentry unhashed and the last reference
dropped.  free_dentry(second) does call_rcu(__d_free, ...).

Now RCU lookup starts.  And on another CPU we move the first dentry over
the third one.  copy_name() is called, it decrements the refcount down
to 1 (__d_free() hasn't happened yet) and doesn't schedule any freeing.

RCU lookup sees first dentry, still with the old name (what used to be the
name of the second dentry).

... and __d_free() on the second dentry is called.  call_rcu() has happened
before RCU lookup has done its rcu_read_lock(), so it's not required to
wait.  We decrement the refcount on ext name, it reaches 0 and we kfree()
it.  Right under dentry_cmp().  Oops...

We really need to decrement refcount before RCU-delaying.  IOW, the decrement
should be in dentry_free(), not in __d_free()...
