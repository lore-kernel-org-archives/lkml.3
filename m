Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbaHTDmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 23:42:53 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35606 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751636AbaHTDmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 23:42:52 -0400
X-Sasl-enc: 4f4H5vqmHQAMttE9304lqJpz9GMRNTEBzNPYv2CEW5Op 1408506170
Message-ID: <1408506167.11028.32.camel@perseus.themaw.net>
Subject: Re: [PATCH 0/5] RCU-walk support for autofs
From: Ian Kent <raven@themaw.net>
To: NeilBrown <neilb@suse.de>
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 20 Aug 2014 11:42:47 +0800
In-Reply-To: <20140820131352.2aad3ca5@notabene.brown>
References: <20140818062844.9860.43007.stgit@notabene.brown>
	 <1408350340.2533.3.camel@perseus.fritz.box>
	 <1408442547.11314.9.camel@perseus.themaw.net>
	 <20140819211654.5ec3853a@notabene.brown>
	 <1408451815.11314.15.camel@perseus.themaw.net>
	 <20140820131352.2aad3ca5@notabene.brown>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-08-20 at 13:13 +1000, NeilBrown wrote:
> On Tue, 19 Aug 2014 20:36:55 +0800 Ian Kent <raven@themaw.net> wrote:
> 
> > On Tue, 2014-08-19 at 21:16 +1000, NeilBrown wrote:
> > > On Tue, 19 Aug 2014 18:02:27 +0800 Ian Kent <raven@themaw.net> wrote:
> > > 
> > > > On Mon, 2014-08-18 at 16:25 +0800, Ian Kent wrote:
> > > > > On Mon, 2014-08-18 at 16:33 +1000, NeilBrown wrote:
> > > > > > Hi Ian,
> > > > > >  Have you had a chance to run your tests in these patches yet?
> > > > > >  I've done what testing I can think of and cannot fault them.
> > > > > 
> > > > > I haven't, I've been plagued with illness so I'm not getting nearly
> > > > > enough done. I'll try to put a kernel together and run the test in the
> > > > > next week or so.
> > > > 
> > > > Just to let you know that I managed to spend some time on this. I built
> > > > a kernel (3.17.0-rc1) with the series and ran a couple of tests.
> > > > 
> > > > I'm not certain that the patches I used are identical to your posting, I
> > > > saw one difference, after the fact, that shouldn't matter, I'll have to
> > > > check that.
> > > > 
> > > > It isn't possible to test expire to mount races because the mounts in
> > > > the tree never expire.
> > > > 
> > > > At first I thought it was because so many processes were accessing the
> > > > tree all the time but manually constructing the maps and mounting the
> > > > mounts shows that nothing ever expires, at least for this tree.
> > > > 
> > > > However, issuing a shut down does expire all the mounts and shuts down
> > > > autofs cleanly.
> > > > 
> > > > So there is something not quite right with the expire check or my
> > > > patches have mistakes.
> > > 
> > > Ahh.. I bet I know what it is.
> > > autofs4_can_expire() isn't idempotent.
> > > Because we call should_expire twice, autofs4_can_expire() is called twice and
> > > the second time it failed because  the first time it resets ->last_used.
> > > 
> > > diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
> > > index eb4b770a4bf6..80133a9d9427 100644
> > > --- a/fs/autofs4/expire.c
> > > +++ b/fs/autofs4/expire.c
> > > @@ -26,6 +26,9 @@ static inline int autofs4_can_expire(struct dentry *dentry,
> > >  	if (ino == NULL)
> > >  		return 0;
> > >  
> > > +	if (ino->flags & AUTOFS_INF_NO_RCU)
> > > +		/* Already performed this test */
> > > +		return 1;
> > 
> > Wouldn't it be better to perform this check, or similar, further down
> > where the last_used time is updated? After all it's only updated to
> > prevent rapid fire expires on dentrys that refuse to umount for some
> > reason.
> > 
> 
> How about the follow approach instead?

Great minds think alike.
I have basically the exact same patch and I'm testing now.
It probably should be folded into "autofs4: avoid taking fs_lock during
rcu-walk".

It takes ages though, the test has two configurations to test and each
one takes about 70 minutes.

fyi, my criteria for the test is if it runs through to completion once
then that's essentially a pass. If not then there is a race that needs
to be fixed before merge. If it fails on runs two or three then there's
a hard to find race that needs attention but is not serious enough to
block merging. I usually stop after three runs but if fails are seen
later then, they too need to be resolved in the fullness of time.

The reason for this is that in heavy use sites we rarely see more than
about three processes concurrently accessing mount points and the test
run uses 10 client instances (currently on a 6 CPU machine) that all
access the mount tree at the same time so that should be somewhat more
pressure than is seen under heavy use.

And indeed this rule of has proven reliable so far.

> Though I must admit that I find the 'now' global variable feels a bit
> clumsy...
> Is there a reason for not just using "jiffies" everywhere?

Yeah, changing to use jiffies probably won't make any difference.
TBH, I can't remember why I did that.

> 
> I've created a tag 'autofs4' in git://neil.brown.name/md/ which has this in
> with all the others, in case that is useful.

I think I have all the patches but I may need to refer to that at some
point.

> 
> Thanks,
> NeilBrown
> 
> 
> 
> From 201f75bc25906e8f64e28b37f1bb478958bf2987 Mon Sep 17 00:00:00 2001
> From: NeilBrown <neilb@suse.de>
> Date: Wed, 20 Aug 2014 12:40:06 +1000
> Subject: [PATCH] autofs4: make "autofs4_can_expire" idempotent.
> 
> Have a "test" function change the value it is testing can
> be confusing, particularly as a future patch will be calling
> this function twice.
> 
> So move the update for 'last_used' to avoid repeat expiry
> to the place where the final determination on what to expire is known.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> 
> diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
> index bee939efca2b..af09dada91bc 100644
> --- a/fs/autofs4/expire.c
> +++ b/fs/autofs4/expire.c
> @@ -30,12 +30,6 @@ static inline int autofs4_can_expire(struct dentry *dentry,
>  		/* Too young to die */
>  		if (!timeout || time_after(ino->last_used + timeout, now))
>  			return 0;
> -
> -		/* update last_used here :-
> -		   - obviously makes sense if it is in use now
> -		   - less obviously, prevents rapid-fire expire
> -		     attempts if expire fails the first time */
> -		ino->last_used = now;
>  	}
>  	return 1;
>  }
> @@ -541,6 +535,8 @@ int autofs4_expire_run(struct super_block *sb,
>  
>  	spin_lock(&sbi->fs_lock);
>  	ino = autofs4_dentry_ino(dentry);
> +	/* avoid rapid-fire expire attempts if expiry fails */
> +	ino->last_used = now;
>  	ino->flags &= ~AUTOFS_INF_EXPIRING;
>  	complete_all(&ino->expire_complete);
>  	spin_unlock(&sbi->fs_lock);
> @@ -567,6 +563,8 @@ int autofs4_do_expire_multi(struct super_block *sb, struct vfsmount *mnt,
>  		ret = autofs4_wait(sbi, dentry, NFY_EXPIRE);
>  
>  		spin_lock(&sbi->fs_lock);
> +		/* avoid rapid-fire expire attempts if expiry fails */
> +		ino->last_used = now;
>  		ino->flags &= ~AUTOFS_INF_EXPIRING;
>  		complete_all(&ino->expire_complete);
>  		spin_unlock(&sbi->fs_lock);


