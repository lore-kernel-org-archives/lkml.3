Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbbALQKR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:10:17 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:40319 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbbALQKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:10:15 -0500
Date: Mon, 12 Jan 2015 17:10:11 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "\\\"Rafael J. Wysocki\\\"" <rjw@rjwysocki.net>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Oleg Nesterov <oleg@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org
Subject: Re: [PATCH -v3 5/5] oom, PM: make OOM detection in the freezer path
 raceless
Message-ID: <20150112161011.GE4877@dhcp22.suse.cz>
References: <1420801555-22659-1-git-send-email-mhocko@suse.cz>
 <1420801555-22659-6-git-send-email-mhocko@suse.cz>
 <20150110194322.GE25319@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150110194322.GE25319@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 10-01-15 14:43:22, Tejun Heo wrote:
> On Fri, Jan 09, 2015 at 12:05:55PM +0100, Michal Hocko wrote:
> ...
> > @@ -142,7 +118,6 @@ static bool check_frozen_processes(void)
> >  int freeze_processes(void)
> >  {
> >  	int error;
> > -	int oom_kills_saved;
> >  
> >  	error = __usermodehelper_disable(UMH_FREEZING);
> >  	if (error)
> > @@ -157,29 +132,22 @@ int freeze_processes(void)
> >  	pm_wakeup_clear();
> >  	pr_info("Freezing user space processes ... ");
> >  	pm_freezing = true;
> > -	oom_kills_saved = oom_kills_count();
> >  	error = try_to_freeze_tasks(true);
> >  	if (!error) {
> >  		__usermodehelper_set_disable_depth(UMH_DISABLED);
> > -		oom_killer_disable();
> > -
> > -		/*
> > -		 * There might have been an OOM kill while we were
> > -		 * freezing tasks and the killed task might be still
> > -		 * on the way out so we have to double check for race.
> > -		 */
> > -		if (oom_kills_count() != oom_kills_saved &&
> > -		    !check_frozen_processes()) {
> > -			__usermodehelper_set_disable_depth(UMH_ENABLED);
> > -			pr_cont("OOM in progress.");
> > -			error = -EBUSY;
> > -		} else {
> > -			pr_cont("done.");
> > -		}
> > +		pr_cont("done.");
> >  	}
> >  	pr_cont("\n");
> >  	BUG_ON(in_atomic());
> >  
> > +	/*
> > +	 * Now that the whole userspace is frozen we need to disbale
> > +	 * the OOM killer to disallow any further interference with
> > +	 * killable tasks.
> > +	 */
> > +	if (!error && !oom_killer_disable())
> 
> So, previously, oom killer was disabled at the top of
> freeze_kernel_threads(), right?  I think that was the better spot to
> do that.  We don't want to disable oom killer before the system is
> just about to enter total quiescence which is freeze_kernel_threads().
> We want to delay this as long as possible.  Let's please disable oom
> killing in at the top of freeze_kernel_threads() and re-enable at the
> bottom of thaw_kernel_threads().

Yes I had it this way but it didn't work out because thaw_kernel_threads
is not called on the resume because it is only used as a fail
path when kernel threads freezing fails. I would rather keep the
enabling/disabling points as we had them. This is less risky IMHO.

-- 
Michal Hocko
SUSE Labs
