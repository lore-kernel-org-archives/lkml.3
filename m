Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab3ENDF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 23:05:59 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:53599 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463Ab3ENDF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 23:05:57 -0400
Message-ID: <1368500924.11576.16.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH 3/3] target: simplify target_wait_for_sess_cmds()
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        target-devel <target-devel@vger.kernel.org>
Date: Mon, 13 May 2013 20:08:44 -0700
In-Reply-To: <20130513220057.GA24539@logfs.org>
References: <1368477007-25274-1-git-send-email-joern@logfs.org>
	 <1368477007-25274-4-git-send-email-joern@logfs.org>
	 <1368486003.4020.37.camel@haakon3.risingtidesystems.com>
	 <20130513220057.GA24539@logfs.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-13 at 18:00 -0400, Jörn Engel wrote:
> On Mon, 13 May 2013 16:00:03 -0700, Nicholas A. Bellinger wrote:
> > On Mon, 2013-05-13 at 16:30 -0400, Joern Engel wrote:
> > > The second parameter was always 0, leading to effectively dead code.  It
> > > called list_del() and se_cmd->se_tfo->release_cmd(), and had to set a
> > > flag to prevent target_release_cmd_kref() from doing the same.
> > 
> > Look again.  The call to transport_wait_for_tasks() was dead code, but
> > the wait_for_completion(&se_cmd->cmd_wait_comp) most certainly is not.
> 
> See "totally wrong" below.
> 
> > > But most
> > > of all, it iterated the list without taking se_sess->sess_cmd_lock,
> > > leading to races against ABORT and LUN_RESET.
> > 
> > Ugh.  You'll recall that target_wait_for_sess_cmds() originally did not
> > have to take the lock because the list was spliced into
> > sess_wait_list.  
> > 
> > When Roland removed sess_wait_list in commit 1c7b13fe, no one re-added
> > the lock here.
> 
> Interesting point.  That seems to imply that reverting 1c7b13fe would
> be an alternative approach.
> 
> > > Since the whole point of the function is to wait for the list to drain,
> > > and potentially print a bit of debug information in case that never
> > > happens, I've replaced the wait_for_completion() with 100ms sleep.  The
> > > only callpath that would get delayed by this is rmmod, afaics, so I
> > > didn't want the overhead of a waitqueue.
> > 
> > This seems totally wrong..
> 
> The wait_for_completion() was not dead code, but it was just one
> possible implementation of "wait for the list to drain".  I dislike
> that particular implementation because you have to drop the spinlock
> before waiting and at the same time wait for a specific command.
> Since you no longer hold any locks, the command can say *poof* and
> disappear from under you at any point.

So I'd rather re-instate the list splice within
target_sess_cmd_list_set_waiting(), keep target_wait_for_sess_cmds()
lock-less performing wait_for_completions() on cmd_wait_comp, and keep
the existing cmd_wait_set assignment + check in place.


> Indeed it has to.  So maybe
> you could take a refcount while waiting for this command to prevent
> that, which implies you have to check for this special refcount
> elsewhere and...

I don't think that will be necessary..

> 
> At this point most readers should shudder in disgust and look for some
> alternate implementation.  I don't say mine is perfect, but at least
> it does not care about any particular command.
> 
> > > -		if (!rc) {
> > > -			wait_for_completion(&se_cmd->cmd_wait_comp);
> > > -			pr_debug("After cmd_wait_comp: se_cmd: %p t_state: %d"
> > > -				" fabric state: %d\n", se_cmd, se_cmd->t_state,
> > > -				se_cmd->se_tfo->get_cmd_state(se_cmd));
> > > +	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
> > > +	while (!list_empty(&se_sess->sess_cmd_list)) {
> > > +		se_cmd = list_entry(se_sess->sess_cmd_list.next, struct se_cmd,
> > > +			se_cmd_list);
> > > +		if (se_cmd != last_cmd) { /* print this only once per command */
> > > +			pr_debug("Waiting for se_cmd: %p t_state: %d, fabric state: %d\n",
> > > +					se_cmd, se_cmd->t_state,
> > > +					se_cmd->se_tfo->get_cmd_state(se_cmd));
> > > +			last_cmd = se_cmd;
> > >  		}
> > > -
> > > -		se_cmd->se_tfo->release_cmd(se_cmd);
> > > +		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
> > > +		msleep_interruptible(100);
> > > +		spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
> > >  	}
> > > +	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
> > >  }
> > 
> > So what happens when the backend se_cmd I/O does not complete before the
> > msleep finishes..?
> 
> You take the lock, check list_empty() and go to sleep again.  Repeat
> until the backend I/O does complete or you get a hung task, whichever
> comes first.
> 
> Which is exactly the same behaviour you had before.
> 
> > It seems totally wrong to drop the initial cmd_wait_set =1 assignment,
> > target_release_cmd_kref() completion for cmd_wait_comp, and wait on
> > cmd_wait_comp to allow se_cmd to finish processing here.
> > 
> > Who cares about waitqueue overhead in a shutdown slow path when the
> > replacement doesn't address long outstanding commands..?
> 
> I agree that the overhead doesn't matter.  The msleep(100) spells this
> out rather explicitly.  What does matter is that a) the patch retains
> old behaviour with much simpler code and b) it fixes a race that kills
> the machine.  I can live without a, but very much want to keep b. ;)
> 

Fucking around with ->sess_cmd_lock during each loop of ->sess_cmd_list
in target_wait_for_sess_cmds is not simpler code..

Please re-spin a patch that re-instates the list splice part of commit
1c7b13fe6, and only drops the wait_for_tasks case check in
target_wait_for_sess_cmds()

--nab

