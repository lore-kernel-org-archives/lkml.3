Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbbAMBrg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 20:47:36 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:57594 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbbAMBre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 20:47:34 -0500
From: Paul Moore <paul@paul-moore.com>
To: Imre Palik <imrep.amz@gmail.com>
Cc: linux-audit@redhat.com, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, "Palik, Imre" <imrep@amazon.de>,
        Matt Wilson <msw@amazon.com>
Subject: Re: [PATCH RFC] audit: move the tree pruning to a dedicated thread
Date: Mon, 12 Jan 2015 20:47:31 -0500
Message-ID: <17550785.MypQ025Gqf@sifl>
User-Agent: KMail/4.14.3 (Linux/3.16.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <54B381A9.8080608@gmail.com>
References: <1420555880-4328-1-git-send-email-imrep.amz@gmail.com> <12579290.YG49FVpphz@sifl> <54B381A9.8080608@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 12, 2015 09:11:21 AM Imre Palik wrote:
> On 01/08/15 22:53, Paul Moore wrote:
> > On Tuesday, January 06, 2015 03:51:20 PM Imre Palik wrote:
> >> From: "Palik, Imre" <imrep@amazon.de>
> >> 
> >> When file auditing is enabled, during a low memory situation, a memory
> >> allocation with __GFP_FS can lead to pruning the inode cache.  Which can,
> >> in turn lead to audit_tree_freeing_mark() being called.  This can call
> >> audit_schedule_prune(), that tries to fork a pruning thread, and
> >> waits until the thread is created.  But forking needs memory, and the
> >> memory allocations there are done with __GFP_FS.
> >> 
> >> So we are waiting merrily for some __GFP_FS memory allocations to
> >> complete,
> >> while holding some filesystem locks.  This can take a while ...
> >> 
> >> This patch creates a single thread for pruning the tree from
> >> audit_add_tree_rule(), and thus avoids the deadlock that the on-demand
> >> thread creation can cause.
> >> 
> >> Reported-by: Matt Wilson <msw@amazon.com>
> >> Cc: Matt Wilson <msw@amazon.com>
> >> Signed-off-by: Imre Palik <imrep@amazon.de>
> > 
> > Thanks for sticking with this and posting a revised patch, my comments are
> > inline with the patch below ... also as a FYI, when sending a revised
> > patch it is often helpful to put a revision indicator in the subject
> > line, as an> 
> > example:
> >   "[RFC PATCH v2] audit: make audit less awful"
> > 
> > It's not strictly necessary, but it makes my life just a little bit
> > easier.
> 
> Sorry for that.  I realised that I botched the subject immediately after
> sending the mail :-(

No worries, you'll take care of it next time.

> >> diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
> >> index 0caf1f8..0ada577 100644
> >> --- a/kernel/audit_tree.c
> >> +++ b/kernel/audit_tree.c
> > 
> > ...
> > 
> >> +static int launch_prune_thread(void)
> >> +{
> >> +	prune_thread = kthread_create(prune_tree_thread, NULL,
> >> +				"audit_prune_tree");
> >> +	if (IS_ERR(prune_thread)) {
> >> +		audit_panic("cannot start thread audit_prune_tree");
> > 
> > I'm not certain audit_panic() is warranted here, pr_err() might be a
> > better choice.  What is the harm if the thread doesn't start and we return
> > an error code?
> 
> I thought disabling the bigger part of the file auditing would warrant a
> bigger bang than pr_err().  If you think, it is an overkill, then I can
> change it.
>
> But see my comment below in audit_schedule_prune()

My concern with audit_panic() is that it only generates a panic() in the 
*very* rare circumstance that someone has configured it that way.  While there 
are some users who do configure their systems with AUDIT_FAIL_PANIC, I think 
it is safe to say that most do not.  Further, audit_panic() can be rate 
limited or even silenced in the case of AUDIT_FAIL_SILENT.

The choice of pr_err() is not perfect for all scenarios, but I think it is the 
better choice for most of the common scenarios. 

> >> +		prune_thread = NULL;
> >> +		return -ENOSYS;
> > 
> > Out of curiosity, why ENOSYS?
> 
> I thought it is a bit less confusing than ESRCH.

Originally I was thinking about -ENOMEM, thoughts?

> >> +	} else {
> >> +		wake_up_process(prune_thread);
> >> +		return 0;
> >> +	}
> >> +}
> > 
> > See my comments below in audit_schedule_prune().
> > 
> >>  /* called with audit_filter_mutex */
> >>  int audit_add_tree_rule(struct audit_krule *rule)
> >>  {
> >> 
> >> @@ -663,6 +713,12 @@ int audit_add_tree_rule(struct audit_krule *rule)
> >> 
> >>  	/* do not set rule->tree yet */
> >>  	mutex_unlock(&audit_filter_mutex);
> >> 
> >> +	if (unlikely(!prune_thread)) {
> >> +		err = launch_prune_thread();
> >> +		if (err)
> >> +			goto Err;
> >> +	}
> >> +
> > 
> > Why not put this at the top of audit_add_tree_rule()?
> 
> I would like to do this without holding audit_filter_mutex.

Sorry, I forgot that audit_add_tree_rule() is called with the 
audit_filter_mutex locked.

> >>  	err = kern_path(tree->pathname, 0, &path);
> >>  	if (err)
> >>  	
> >>  		goto Err;
> >> 
> >> @@ -713,6 +769,9 @@ int audit_tag_tree(char *old, char *new)
> >> 
> >>  	struct vfsmount *tagged;
> >>  	int err;
> >> 
> >> +	if (!prune_thread)
> >> +		return -ENOSYS;
> > 
> > Help me out - why?

Still, why?

> >>  	err = kern_path(new, 0, &path2);
> >>  	if (err)
> >>  	
> >>  		return err;
> >> 
> >> @@ -800,36 +859,11 @@ int audit_tag_tree(char *old, char *new)
> >> 
> >>  	return failed;
> >>  
> >>  }
> >> 
> >> -/*
> >> - * That gets run when evict_chunk() ends up needing to kill audit_tree.
> >> - * Runs from a separate thread.
> >> - */
> >> -static int prune_tree_thread(void *unused)
> >> -{
> >> -	mutex_lock(&audit_cmd_mutex);
> >> -	mutex_lock(&audit_filter_mutex);
> >> -
> >> -	while (!list_empty(&prune_list)) {
> >> -		struct audit_tree *victim;
> >> -
> >> -		victim = list_entry(prune_list.next, struct audit_tree, list);
> >> -		list_del_init(&victim->list);
> >> -
> >> -		mutex_unlock(&audit_filter_mutex);
> >> -
> >> -		prune_one(victim);
> >> -
> >> -		mutex_lock(&audit_filter_mutex);
> >> -	}
> >> -
> >> -	mutex_unlock(&audit_filter_mutex);
> >> -	mutex_unlock(&audit_cmd_mutex);
> >> -	return 0;
> >> -}
> >> 
> >>  static void audit_schedule_prune(void)
> >>  {
> >> 
> >> -	kthread_run(prune_tree_thread, NULL, "audit_prune_tree");
> >> +	BUG_ON(!prune_thread);
> >> +	wake_up_process(prune_thread);
> >> 
> >>  }
> > 
> > First, I probably wasn't clear last time so I'll be more clear now: no
> > BUG_ON() here, handle the error.
> 
> As far as I see, I disabled all the codepaths that can reach this point with
> !prune_thread.  So I thought leaving the BUG_ON() here doesn't really
> matter.

If it doesn't do anything, then you can remove it ;)

BUG_ON()/BUG() does have its uses, but I'm not sure this in one of those 
cases.

> > Second, and closely related to the last sentence, perhaps the right
> > approach is to merge the launch_prune_thread() code with
> > audit_schedule_prune() such that we only have one function which starts
> > the thread if it isn't present, and wakes it up if it is, something like
> > the following:
> >
> > 	static int audit_schedule_prune(void)
> > 	{
> > 	
> > 		if (!prune_thread) {
> > 		
> > 			prune_thread = kthread_create(...);
> > 			if (IS_ERR(prune_thread)) {
> > 			
> > 				pr_err("cannot start thread audit_prune_tree");
> > 				prune_thread = NULL;
> > 				return -ENOSYS;
> > 			
> > 			}
> > 		
> > 		}
> > 		
> > 		wake_up_process(prune_thread);
> > 		return 0;
> > 	
> > 	}
> 
> if we do the thread creation in audit_schedule_prune, we won't necessarily
> need the dedicated thread.  This would be the alternative approach I
> mentioned in the comment part of my original mail.  Sorry if I was not
> clear enough.

The code in the snippet I provided starts the thread if it doesn't exist, and 
wakes the thread if it exists.  I don't understand how that is different from 
what you were doing, I just happen to think it is a little more robust.

> Basically I see the following approaches:
> 
> 1) dedicated thread created on syscall entry, with disabling file auditing
> as long as the thread cannot be created.
> 
> 2) on-demand thread-creation/destruction with some serialisation to ensure
>    that we won't create too many threads.
> 
> 3) dedicated thread created on syscall entry, with fallback to thread
> creation at cleanup time, if original thread creation fails.
> 
> Am I right that you would like to see the third one?

I don't want #2, and I think in general we should do whatever we can to 
recover from errors such that we don't disable auditing.  That is just good 
practice.

> >>  /*
> >> 
> >> @@ -896,9 +930,10 @@ static void evict_chunk(struct audit_chunk *chunk)
> >> 
> >>  	for (n = 0; n < chunk->count; n++)
> >>  	
> >>  		list_del_init(&chunk->owners[n].list);
> >>  	
> >>  	spin_unlock(&hash_lock);
> >> 
> >> +	mutex_unlock(&audit_filter_mutex);
> >> 
> >>  	if (need_prune)
> >>  	
> >>  		audit_schedule_prune();
> >> 
> >> -	mutex_unlock(&audit_filter_mutex);
> >> +
> >> 
> >>  }
> > 
> > Remove that trailing empty vertical whitespace please.  If you aren't
> > using it already, you should look into scripts/checkpatch.pl to sanity
> > check your patches before sending.
> 
> Could you point me to that whitespace?  I cannot see it in the patch, and
> scripts/checkpatch.pl was not complaining either.

In your patch it looks like there is a blank empty line at the end of 
evict_chunk(); it appears like you are replacing the last mutex_unlock() with 
blank line.

-- 
paul moore
www.paul-moore.com

