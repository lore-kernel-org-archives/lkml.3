Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311AbaD1Oh4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 10:37:56 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:58107 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175AbaD1OhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:37:16 -0400
Message-ID: <1398695832.14475.10.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.14-rt1
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Nicholas Mc Guire <der.herr@hofr.at>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>
Date: Mon, 28 Apr 2014 16:37:12 +0200
In-Reply-To: <20140428101805.75032f45@gandalf.local.home>
References: <20140411185739.GA6644@linutronix.de>
	 <1397918766.5436.16.camel@marge.simpson.net>
	 <1398411635.11930.45.camel@marge.simpson.net>
	 <1398501491.12941.5.camel@marge.simpson.net>
	 <1398520699.28726.22.camel@marge.simpson.net>
	 <1398661784.30930.33.camel@marge.simpson.net>
	 <1398676186.30930.49.camel@marge.simpson.net>
	 <20140428101805.75032f45@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-28 at 10:18 -0400, Steven Rostedt wrote: 
> On Mon, 28 Apr 2014 11:09:46 +0200
> Mike Galbraith <umgwanakikbuti@gmail.com> wrote:
>  
> > migrate_disable-pushd-down-in-atomic_dec_and_spin_lo.patch
> > 
> > bug: migrate_disable() after blocking is too late.
> > 
> > @@ -1028,12 +1028,12 @@ int atomic_dec_and_spin_lock(atomic_t *a
> >         /* Subtract 1 from counter unless that drops it to 0 (ie. it was 1) */
> >         if (atomic_add_unless(atomic, -1, 1))
> >                 return 0;
> > -       migrate_disable();
> >         rt_spin_lock(lock);
> > -       if (atomic_dec_and_test(atomic))
> > +       if (atomic_dec_and_test(atomic)){
> > +               migrate_disable();
> 
> Makes sense, as the CPU can go offline right after the lock is grabbed
> and before the migrate_disable() is called.
> 
> Seems that migrate_disable() must be called before taking the lock as
> it is done in every other location.

And for tasklist_lock, seems you also MUST do that prior to trylock as
well, else you'll run afoul of the hotplug beast.

-Mike


