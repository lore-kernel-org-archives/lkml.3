Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737AbaJUNWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 09:22:00 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:64442 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932518AbaJUNV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 09:21:58 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 3/4] OOM, PM: OOM killed task shouldn't escape PM suspend
Date: Tue, 21 Oct 2014 15:42:23 +0200
Message-ID: <2156351.pWp6MNRoWm@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141021131445.GC9415@dhcp22.suse.cz>
References: <1413876435-11720-1-git-send-email-mhocko@suse.cz> <3778374.avm26S62SZ@vostro.rjw.lan> <20141021131445.GC9415@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 21, 2014 03:14:45 PM Michal Hocko wrote:
> On Tue 21-10-14 14:09:27, Rafael J. Wysocki wrote:
> [...]
> > > @@ -131,12 +132,40 @@ int freeze_processes(void)
> > >  
> > >  	printk("Freezing user space processes ... ");
> > >  	pm_freezing = true;
> > > +	oom_kills_saved = oom_kills_count();
> > >  	error = try_to_freeze_tasks(true);
> > >  	if (!error) {
> > > -		printk("done.");
> > >  		__usermodehelper_set_disable_depth(UMH_DISABLED);
> > >  		oom_killer_disable();
> > > +
> > > +		/*
> > > +		 * There might have been an OOM kill while we were
> > > +		 * freezing tasks and the killed task might be still
> > > +		 * on the way out so we have to double check for race.
> > > +		 */
> > > +		if (oom_kills_count() != oom_kills_saved) {
> > > +			struct task_struct *g, *p;
> > > +
> > > +			read_lock(&tasklist_lock);
> > > +			for_each_process_thread(g, p) {
> > > +				if (p == current || freezer_should_skip(p) ||
> > > +				    frozen(p))
> > > +					continue;
> > > +				error = -EBUSY;
> > > +				goto out_loop;
> > > +			}
> > > +out_loop:
> > 
> > Well, it looks like this will work here too:
> > 
> > 			for_each_process_thread(g, p)
> > 				if (p != current && !frozen(p) &&
> > 				    !freezer_should_skip(p)) {
> > 					error = -EBUSY;
> > 					break;
> > 				}
> > 
> > or I am helplessly misreading the code.
> 
> break will not work because for_each_process_thread is a double loop.

I see.  In that case I'd do:

                        for_each_process_thread(g, p)
                                if (p != current && !frozen(p) &&
                                    !freezer_should_skip(p)) {

					read_unlock(&tasklist_lock);

					__usermodehelper_set_disable_depth(UMH_ENABLED);
					printk("OOM in progress.");
                                        error = -EBUSY;
                                        goto done;
                                }

to avoid adding the new label that looks odd.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
