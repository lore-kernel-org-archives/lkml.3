Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbaDXKWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:22:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48813 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754611AbaDXKSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:18:46 -0400
Date: Thu, 24 Apr 2014 12:18:43 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        pmladek@suse.cz, Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/8] printk: Release lockbuf_lock before calling
 console_trylock_for_printk()
Message-ID: <20140424101843.GN17824@quack.suse.cz>
References: <1395770101-24534-1-git-send-email-jack@suse.cz>
 <1395770101-24534-3-git-send-email-jack@suse.cz>
 <20140423135606.d727fe5eb38bd8805ad3a5c3@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140423135606.d727fe5eb38bd8805ad3a5c3@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 23-04-14 13:56:06, Andrew Morton wrote:
> On Tue, 25 Mar 2014 18:54:55 +0100 Jan Kara <jack@suse.cz> wrote:
> 
> > There's no reason to hold lockbuf_lock when entering
> > console_trylock_for_printk(). The first thing this function does is
> > calling down_trylock(console_sem) and if that fails it immediately
> > unlocks lockbuf_lock. So lockbuf_lock isn't needed for that branch.
> > When down_trylock() succeeds, the rest of console_trylock() is OK
> > without lockbuf_lock (it is called without it from other places), and
> > the only remaining thing in console_trylock_for_printk() is
> > can_use_console() call. For that call console_sem is enough (it
> > iterates all consoles and checks CON_ANYTIME flag).
> > 
> > So we drop logbuf_lock before entering console_trylock_for_printk()
> > which simplifies the code.
> > 
> 
> I suppose we should document have_callable_console()'s locking
> requirements, and I don't think that "early in boot" part is true?
> 
> --- a/kernel/printk/printk.c~printk-release-lockbuf_lock-before-calling-console_trylock_for_printk-fix
> +++ a/kernel/printk/printk.c
> @@ -1377,7 +1377,9 @@ static void zap_locks(void)
>  	sema_init(&console_sem, 1);
>  }
>  
> -/* Check if we have any console registered that can be called early in boot. */
> +/*
> + * Check if we have any console registered.  Requires console_sem.
  So "early in boot" wasn't really exact but what you did isn't right
either. What I'd put there is:

/*
 * Check if we have any console that is capable of printing while cpu is
 * booting or shutting down. Requires console_sem.
 */

Maybe the function name could be changed to reflect better what it does but
I don't have any clever idea...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
