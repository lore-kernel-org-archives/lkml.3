Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058AbaHTDus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 23:50:48 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36336 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751699AbaHTDur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 23:50:47 -0400
X-Sasl-enc: QAt5Tze9qmL5T8FV4wwdlVSbcRXQhHx9gRAt8Hk0TN9T 1408506646
Message-ID: <1408506642.11028.36.camel@perseus.themaw.net>
Subject: Re: [PATCH 0/5] RCU-walk support for autofs
From: Ian Kent <raven@themaw.net>
To: NeilBrown <neilb@suse.de>
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 20 Aug 2014 11:50:42 +0800
In-Reply-To: <1408506167.11028.32.camel@perseus.themaw.net>
References: <20140818062844.9860.43007.stgit@notabene.brown>
	 <1408350340.2533.3.camel@perseus.fritz.box>
	 <1408442547.11314.9.camel@perseus.themaw.net>
	 <20140819211654.5ec3853a@notabene.brown>
	 <1408451815.11314.15.camel@perseus.themaw.net>
	 <20140820131352.2aad3ca5@notabene.brown>
	 <1408506167.11028.32.camel@perseus.themaw.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-08-20 at 11:42 +0800, Ian Kent wrote:
> > 
> > From 201f75bc25906e8f64e28b37f1bb478958bf2987 Mon Sep 17 00:00:00 2001
> > From: NeilBrown <neilb@suse.de>
> > Date: Wed, 20 Aug 2014 12:40:06 +1000
> > Subject: [PATCH] autofs4: make "autofs4_can_expire" idempotent.
> > 
> > Have a "test" function change the value it is testing can
> > be confusing, particularly as a future patch will be calling
> > this function twice.
> > 
> > So move the update for 'last_used' to avoid repeat expiry
> > to the place where the final determination on what to expire is known.
> > 
> > Signed-off-by: NeilBrown <neilb@suse.de>
> > 
> > diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
> > index bee939efca2b..af09dada91bc 100644
> > --- a/fs/autofs4/expire.c
> > +++ b/fs/autofs4/expire.c
> > @@ -30,12 +30,6 @@ static inline int autofs4_can_expire(struct dentry *dentry,
> >  		/* Too young to die */
> >  		if (!timeout || time_after(ino->last_used + timeout, now))
> >  			return 0;
> > -
> > -		/* update last_used here :-
> > -		   - obviously makes sense if it is in use now
> > -		   - less obviously, prevents rapid-fire expire
> > -		     attempts if expire fails the first time */
> > -		ino->last_used = now;
> >  	}
> >  	return 1;
> >  }
> > @@ -541,6 +535,8 @@ int autofs4_expire_run(struct super_block *sb,
> >  
> >  	spin_lock(&sbi->fs_lock);
> >  	ino = autofs4_dentry_ino(dentry);
> > +	/* avoid rapid-fire expire attempts if expiry fails */
> > +	ino->last_used = now;
> >  	ino->flags &= ~AUTOFS_INF_EXPIRING;
> >  	complete_all(&ino->expire_complete);
> >  	spin_unlock(&sbi->fs_lock);
> > @@ -567,6 +563,8 @@ int autofs4_do_expire_multi(struct super_block *sb, struct vfsmount *mnt,
> >  		ret = autofs4_wait(sbi, dentry, NFY_EXPIRE);
> >  
> >  		spin_lock(&sbi->fs_lock);
> > +		/* avoid rapid-fire expire attempts if expiry fails */
> > +		ino->last_used = now;
> >  		ino->flags &= ~AUTOFS_INF_EXPIRING;
> >  		complete_all(&ino->expire_complete);
> >  		spin_unlock(&sbi->fs_lock);
> 

On looking a little closer I've set last_used at slightly different
locations. It is still does the same thing though.

I'm not fussy where we actually do this, so your call.

autofs - fix last_used usage

From: Ian Kent <ikent@redhat.com>

Signed-off-by: Ian Kent <ikent@redhat.com>
---
 fs/autofs4/expire.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index cca5d1e..d97a761 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -30,12 +30,6 @@ static inline int autofs4_can_expire(struct dentry *dentry,
 		/* Too young to die */
 		if (!timeout || time_after(ino->last_used + timeout, now))
 			return 0;
-
-		/* update last_used here :-
-		   - obviously makes sense if it is in use now
-		   - less obviously, prevents rapid-fire expire
-		     attempts if expire fails the first time */
-		ino->last_used = now;
 	}
 	return 1;
 }
@@ -341,6 +335,8 @@ struct dentry *autofs4_expire_direct(struct super_block *sb,
 			ino->flags |= AUTOFS_INF_EXPIRING;
 			smp_mb();
 			ino->flags &= ~AUTOFS_INF_NO_RCU;
+			/* Prevent rapid fire expire events */
+			ino->last_used = now;
 			init_completion(&ino->expire_complete);
 			spin_unlock(&sbi->fs_lock);
 			return root;
@@ -496,6 +492,8 @@ found:
 	ino->flags |= AUTOFS_INF_EXPIRING;
 	smp_mb();
 	ino->flags &= ~AUTOFS_INF_NO_RCU;
+	/* Prevent rapid fire expire events */
+	ino->last_used = now;
 	init_completion(&ino->expire_complete);
 	spin_unlock(&sbi->fs_lock);
 	spin_lock(&sbi->lookup_lock);




