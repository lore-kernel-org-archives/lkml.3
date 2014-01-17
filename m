Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbaAQTlD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 14:41:03 -0500
Received: from hofr.at ([212.69.189.236]:45827 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592AbaAQTlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 14:41:00 -0500
Date: Fri, 17 Jan 2014 20:40:58 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users@vger.kernel.org,
        Sami Pietikainen <Sami.Pietikainen@wapice.com>,
        Jouko Haapaluoma <jouko.haapaluoma@wapice.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RT] add missing local serialization in ip_output.c
Message-ID: <20140117194058.GA20157@opentech.at>
References: <20131229171154.GA23586@opentech.at> <20140117144729.GB5785@linutronix.de> <20140117145955.GA5637@opentech.at> <52D94891.80109@linutronix.de> <20140117153323.GA23566@opentech.at> <20140117113218.7392363d@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140117113218.7392363d@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jan 2014, Steven Rostedt wrote:

> On Fri, 17 Jan 2014 16:33:23 +0100
> Nicholas Mc Guire <der.herr@hofr.at> wrote:
> 
> > On Fri, 17 Jan 2014, Sebastian Andrzej Siewior wrote:
> > 
> > > On 01/17/2014 03:59 PM, Nicholas Mc Guire wrote:
> > > > On Fri, 17 Jan 2014, Sebastian Andrzej Siewior wrote:
> > > > 
> > > >> This is what I am going to apply. It also dropped the get_cpu_light()
> > > >> call which was added in a patch to remove the get_cpu_var() and is now
> > > >> no longer required since we have the get_locked_var() thingy now.
> > > >>
> > > > 
> > > > I do not think you can drop that - what is preventing migration now ?
> > > 
> > > Nothing but I do not see the need for it.
> > > 
> > > > 
> > > > #define get_locked_var(lvar, var)                                       \
> > > >         (*({                                                            \
> > > >                 local_lock(lvar);                                       \
> > > >                 &__get_cpu_var(var);                                    \
> > > >         }))
> > > > 
> > q> > No migrate_disable here - so how is this protected against migration ?
> 
> I was just about to reply to this, that local_lock() grabs a spinlock
> which does do a migrate disable. But you also noticed that the
> get_local_var() does a migrate disable too. We now have double the
> protection, so we are safe as Sebastion has done it.
>
...well that motivates a further migration cleanup patch replacing
the spin_*lock* by spin_*lock*_local variants to drop that recursive call
and while checking call paths - do a little API cleanup for softirq_lock

thx!
hofrat
