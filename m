Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122Ab3EMX2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 19:28:51 -0400
Received: from longford.logfs.org ([213.229.74.203]:59181 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab3EMX2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 19:28:49 -0400
Date: Mon, 13 May 2013 18:00:57 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        target-devel <target-devel@vger.kernel.org>
Subject: Re: [PATCH 3/3] target: simplify target_wait_for_sess_cmds()
Message-ID: <20130513220057.GA24539@logfs.org>
References: <1368477007-25274-1-git-send-email-joern@logfs.org>
 <1368477007-25274-4-git-send-email-joern@logfs.org>
 <1368486003.4020.37.camel@haakon3.risingtidesystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1368486003.4020.37.camel@haakon3.risingtidesystems.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 May 2013 16:00:03 -0700, Nicholas A. Bellinger wrote:
> On Mon, 2013-05-13 at 16:30 -0400, Joern Engel wrote:
> > The second parameter was always 0, leading to effectively dead code.  It
> > called list_del() and se_cmd->se_tfo->release_cmd(), and had to set a
> > flag to prevent target_release_cmd_kref() from doing the same.
> 
> Look again.  The call to transport_wait_for_tasks() was dead code, but
> the wait_for_completion(&se_cmd->cmd_wait_comp) most certainly is not.

See "totally wrong" below.

> > But most
> > of all, it iterated the list without taking se_sess->sess_cmd_lock,
> > leading to races against ABORT and LUN_RESET.
> 
> Ugh.  You'll recall that target_wait_for_sess_cmds() originally did not
> have to take the lock because the list was spliced into
> sess_wait_list.  
> 
> When Roland removed sess_wait_list in commit 1c7b13fe, no one re-added
> the lock here.

Interesting point.  That seems to imply that reverting 1c7b13fe would
be an alternative approach.

> > Since the whole point of the function is to wait for the list to drain,
> > and potentially print a bit of debug information in case that never
> > happens, I've replaced the wait_for_completion() with 100ms sleep.  The
> > only callpath that would get delayed by this is rmmod, afaics, so I
> > didn't want the overhead of a waitqueue.
> 
> This seems totally wrong..

The wait_for_completion() was not dead code, but it was just one
possible implementation of "wait for the list to drain".  I dislike
that particular implementation because you have to drop the spinlock
before waiting and at the same time wait for a specific command.
Since you no longer hold any locks, the command can say *poof* and
disappear from under you at any point.  Indeed it has to.  So maybe
you could take a refcount while waiting for this command to prevent
that, which implies you have to check for this special refcount
elsewhere and...

At this point most readers should shudder in disgust and look for some
alternate implementation.  I don't say mine is perfect, but at least
it does not care about any particular command.

> > -		if (!rc) {
> > -			wait_for_completion(&se_cmd->cmd_wait_comp);
> > -			pr_debug("After cmd_wait_comp: se_cmd: %p t_state: %d"
> > -				" fabric state: %d\n", se_cmd, se_cmd->t_state,
> > -				se_cmd->se_tfo->get_cmd_state(se_cmd));
> > +	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
> > +	while (!list_empty(&se_sess->sess_cmd_list)) {
> > +		se_cmd = list_entry(se_sess->sess_cmd_list.next, struct se_cmd,
> > +			se_cmd_list);
> > +		if (se_cmd != last_cmd) { /* print this only once per command */
> > +			pr_debug("Waiting for se_cmd: %p t_state: %d, fabric state: %d\n",
> > +					se_cmd, se_cmd->t_state,
> > +					se_cmd->se_tfo->get_cmd_state(se_cmd));
> > +			last_cmd = se_cmd;
> >  		}
> > -
> > -		se_cmd->se_tfo->release_cmd(se_cmd);
> > +		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
> > +		msleep_interruptible(100);
> > +		spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
> >  	}
> > +	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
> >  }
> 
> So what happens when the backend se_cmd I/O does not complete before the
> msleep finishes..?

You take the lock, check list_empty() and go to sleep again.  Repeat
until the backend I/O does complete or you get a hung task, whichever
comes first.

Which is exactly the same behaviour you had before.

> It seems totally wrong to drop the initial cmd_wait_set =1 assignment,
> target_release_cmd_kref() completion for cmd_wait_comp, and wait on
> cmd_wait_comp to allow se_cmd to finish processing here.
> 
> Who cares about waitqueue overhead in a shutdown slow path when the
> replacement doesn't address long outstanding commands..?

I agree that the overhead doesn't matter.  The msleep(100) spells this
out rather explicitly.  What does matter is that a) the patch retains
old behaviour with much simpler code and b) it fixes a race that kills
the machine.  I can live without a, but very much want to keep b. ;)

Jörn

--
Sometimes, asking the right question is already the answer.
-- Unknown
