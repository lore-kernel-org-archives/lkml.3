Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601AbaJUNT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 09:19:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50123 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932452AbaJUNT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 09:19:56 -0400
Date: Tue, 21 Oct 2014 15:19:53 +0200
From: Michal Hocko <mhocko@suse.cz>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 4/4] PM: convert do_each_thread to for_each_process_thread
Message-ID: <20141021131953.GD9415@dhcp22.suse.cz>
References: <1413876435-11720-1-git-send-email-mhocko@suse.cz>
 <1413876435-11720-5-git-send-email-mhocko@suse.cz>
 <2670728.8H9BNSArM8@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2670728.8H9BNSArM8@vostro.rjw.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 21-10-14 14:10:18, Rafael J. Wysocki wrote:
> On Tuesday, October 21, 2014 09:27:15 AM Michal Hocko wrote:
> > as per 0c740d0afc3b (introduce for_each_thread() to replace the buggy
> > while_each_thread()) get rid of do_each_thread { } while_each_thread()
> > construct and replace it by a more error prone for_each_thread.
> > 
> > This patch doesn't introduce any user visible change.
> > 
> > Suggested-by: Oleg Nesterov <oleg@redhat.com>
> > Signed-off-by: Michal Hocko <mhocko@suse.cz>
> 
> ACK
> 
> Or do you want me to handle this series?

I don't know, I hoped either you or Andrew to pick it up.

> > ---
> >  kernel/power/process.c | 16 ++++++++--------
> >  1 file changed, 8 insertions(+), 8 deletions(-)
> > 
> > diff --git a/kernel/power/process.c b/kernel/power/process.c
> > index a397fa161d11..7fd7b72554fe 100644
> > --- a/kernel/power/process.c
> > +++ b/kernel/power/process.c
> > @@ -46,13 +46,13 @@ static int try_to_freeze_tasks(bool user_only)
> >  	while (true) {
> >  		todo = 0;
> >  		read_lock(&tasklist_lock);
> > -		do_each_thread(g, p) {
> > +		for_each_process_thread(g, p) {
> >  			if (p == current || !freeze_task(p))
> >  				continue;
> >  
> >  			if (!freezer_should_skip(p))
> >  				todo++;
> > -		} while_each_thread(g, p);
> > +		}
> >  		read_unlock(&tasklist_lock);
> >  
> >  		if (!user_only) {
> > @@ -93,11 +93,11 @@ static int try_to_freeze_tasks(bool user_only)
> >  
> >  		if (!wakeup) {
> >  			read_lock(&tasklist_lock);
> > -			do_each_thread(g, p) {
> > +			for_each_process_thread(g, p) {
> >  				if (p != current && !freezer_should_skip(p)
> >  				    && freezing(p) && !frozen(p))
> >  					sched_show_task(p);
> > -			} while_each_thread(g, p);
> > +			}
> >  			read_unlock(&tasklist_lock);
> >  		}
> >  	} else {
> > @@ -219,11 +219,11 @@ void thaw_processes(void)
> >  	thaw_workqueues();
> >  
> >  	read_lock(&tasklist_lock);
> > -	do_each_thread(g, p) {
> > +	for_each_process_thread(g, p) {
> >  		/* No other threads should have PF_SUSPEND_TASK set */
> >  		WARN_ON((p != curr) && (p->flags & PF_SUSPEND_TASK));
> >  		__thaw_task(p);
> > -	} while_each_thread(g, p);
> > +	}
> >  	read_unlock(&tasklist_lock);
> >  
> >  	WARN_ON(!(curr->flags & PF_SUSPEND_TASK));
> > @@ -246,10 +246,10 @@ void thaw_kernel_threads(void)
> >  	thaw_workqueues();
> >  
> >  	read_lock(&tasklist_lock);
> > -	do_each_thread(g, p) {
> > +	for_each_process_thread(g, p) {
> >  		if (p->flags & (PF_KTHREAD | PF_WQ_WORKER))
> >  			__thaw_task(p);
> > -	} while_each_thread(g, p);
> > +	}
> >  	read_unlock(&tasklist_lock);
> >  
> >  	schedule();
> > 
> 
> -- 
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.

-- 
Michal Hocko
SUSE Labs
