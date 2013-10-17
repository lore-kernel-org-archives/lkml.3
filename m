Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318Ab3JQVXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 17:23:21 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:51612 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932115Ab3JQVXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 17:23:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Savchenko <bircoph@gmail.com>, suspend-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [Suspend-devel] [BUG] 3.7-rc regression bisected: s2disk fails to resume image: Processes could not be frozen, cannot continue resuming
Date: Thu, 17 Oct 2013 23:35:12 +0200
Message-ID: <2906897.X51K0zWBHo@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130924002111.GB31569@amd.pavel.ucw.cz>
References: <20130812234415.7db639bb0d664e56b6ab2ab2@gmail.com> <20130918191607.GO13318@ZenIV.linux.org.uk> <20130924002111.GB31569@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the huge delay.

On Tuesday, September 24, 2013 02:21:11 AM Pavel Machek wrote:
> Hi!
> 
> > > And from suspend_ioctls.h:
> > > #define SNAPSHOT_IOC_MAGIC      '3'
> > > #define SNAPSHOT_FREEZE                 _IO(SNAPSHOT_IOC_MAGIC, 1)
> > > 
> > > My mistake, should be '3' instead of 3.
> > 
> > OK...  The thing to test, then, is what does __usermodehelper_disable()
> > return to freeze_processes().  If that's where this -EAGAIN comes from,
> > we at least have a plausible theory re what's going on.
> > 
> > freeze_processes() uses __usermodehelper_disable() to stop any new userland
> > processes spawned by UMH (modprobe, etc.) and waits for ones it might be
> > waiting for to complete.  Then it does try_to_freeze_tasks(), which
> > freezes remaining userland, carefully skipping the current thread.
> > However, it misses the possibility that current thread might have been
> > spawned by something that had been launched by UMH, with UMH waiting
> > for it.  Which is the case of everything spawned by linuxrc.
> > 
> > I'd try something like diff below, but I'm *NOT* familiar with swsusp at
> > all; it's not for mainline until ACKed by swsusp folks.
> > 
> > diff --git a/kernel/kmod.c b/kernel/kmod.c
> > index fb32636..d968882 100644
> > --- a/kernel/kmod.c
> > +++ b/kernel/kmod.c
> > @@ -571,7 +571,8 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
> >  	DECLARE_COMPLETION_ONSTACK(done);
> >  	int retval = 0;
> >  
> > -	helper_lock();
> > +	if (!(current->flags & PF_FREEZER_SKIP))
> > +		helper_lock();
> >  	if (!khelper_wq || usermodehelper_disabled) {
> >  		retval = -EBUSY;
> >  		goto out;
> > @@ -611,7 +612,8 @@ wait_done:
> >  out:
> >  	call_usermodehelper_freeinfo(sub_info);
> >  unlock:
> > -	helper_unlock();
> > +	if (!(current->flags & PF_FREEZER_SKIP))
> > +		helper_unlock();
> >  	return retval;
> >  }
> >  EXPORT_SYMBOL(call_usermodehelper_exec);
> 
> PF_FREEZER_SKIP flag is manipulated at about 1000 places, so I'm not
> sure this will nest correctly.

This is not exactly correct unless 1000 is about 50.  And none of them leads to
call_usermodehelper_exec() as far as I can say.

> They seem to be in form of 
> 
> |= FREEZER_SKIP
> schedule()
> &= ~FREEZER_SKIP
> 
> so this should be safe, but...

I think the patch is correct, so

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
