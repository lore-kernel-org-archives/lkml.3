Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab3HUSxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 14:53:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502Ab3HUSxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 14:53:19 -0400
Date: Wed, 21 Aug 2013 20:47:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "security@kernel.org" <security@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Willy Tarreau <w@1wt.eu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Subject: Re: [PATCH] vfs: Tighten up linkat(..., AT_EMPTY_PATH)
Message-ID: <20130821184706.GA20591@redhat.com>
References: <CALCETrXMQdjRyvP8RHOd5xjciurS7-hKUOExvkvQ1RWmdRdypA@mail.gmail.com> <0be9da18c0ca360773a397de3063d01019ff88d8.1377107508.git.luto@amacapital.net> <20130821182053.GA19624@redhat.com> <CALCETrXtJBDqkvO3mHxDrHL3whCWX_B-LAXOnue7r90nyyWY_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXtJBDqkvO3mHxDrHL3whCWX_B-LAXOnue7r90nyyWY_A@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21, Andy Lutomirski wrote:
>
> On Wed, Aug 21, 2013 at 11:20 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > Can't really comment the patch, just a nit:
> >
> > On 08/21, Andy Lutomirski wrote:
> >>
> >> +static bool may_flink(const struct path *path)
> >> +{
> >> +     bool ret;
> >> +     struct inode *inode = path->dentry->d_inode;
> >> +
> >> +     /*
> >> +      * This is racy: I_LINKABLE could be cleared between this check
> >> +      * and the actual link operation.
> >
> > OK,
> >
> >> +     spin_lock(&inode->i_lock);
> >> +     ret = !!(inode->i_state & I_LINKABLE);
> >> +     spin_unlock(&inode->i_lock);
> >
> > so why do we need to take a lock ?
> >
>
> We probably don't.  But other accesses to this field take that lock,

Not if you only need to check ->i_lock,

> (In principle, someone could take the lock, write I_LINKABLE, clear
> it, and unlock, and we'd get confused if we didn't take the lock
> ourselves.)

Or it can be cleared right after we drop i_lock, I do not think there
is any difference.

But OK, I won't argue.

Oleg.

