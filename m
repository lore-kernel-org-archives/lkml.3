Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465AbaAFVeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 16:34:19 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51835 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756340AbaAFVeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 16:34:16 -0500
Date: Mon, 6 Jan 2014 22:34:14 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: joe@perches.com, keescook@chromium.org, akpm@linux-foundation.org,
        geert@linux-m68k.org, jkosina@suse.cz, viro@zeniv.linux.org.uk,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/vsprintf: add %pT[C012] format specifier
Message-ID: <20140106213414.GB14927@amd.pavel.ucw.cz>
References: <1388770748.14334.19.camel@joe-AO722>
 <CAGXu5j+gHtgx9MVCaJ2ogJ0WGCeTDkphsH3gm7S=+mTssicABg@mail.gmail.com>
 <201401041126.BHJ81291.VOHLOtMFOJFQFS@I-love.SAKURA.ne.jp>
 <201401051215.ACJ30759.MJSHtFFFVOOOQL@I-love.SAKURA.ne.jp>
 <1388945392.5808.19.camel@joe-AO722>
 <201401062300.GFE12908.FOQLFFJOSOMVHt@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201401062300.GFE12908.FOQLFFJOSOMVHt@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-01-06 23:00:56, Tetsuo Handa wrote:
> Joe Perches wrote:
> > On Sun, 2014-01-05 at 12:15 +0900, Tetsuo Handa wrote:
> > > > Since my purpose is to make reading of task_struct->comm consistent, %pT-like
> > > > extension is what I want for centralizing pointer dereferences.
> > > 
> > > If we have no objections for %pT[C012] patch,
> > 
> > I still believe emitting different output styles using
> > %pT[012] is not ideal.
> > 
> > Is this really necessary?
> 
> No problem. %pT[012] are simply optimization (reducing number of function
> arguments for saving text size) and therefore I can drop them.
> What about below patch?
> ----------
> >From f69a1db69a9ad6e14235edbb5a9b7d720530a2be Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Mon, 6 Jan 2014 22:22:00 +0900
> Subject: [PATCH] lib/vsprintf: add %pT format specifier
> 
> Since task_struct->comm can be modified by other threads while the current
> thread is reading it, it is recommended to use get_task_comm() for reading it.
> 
> However, since get_task_comm() holds task_struct->alloc_lock spinlock,
> some users cannot use get_task_comm(). Also, a lot of users are directly
> reading from task_struct->comm even if they can use get_task_comm().
> Such users might obtain inconsistent result.
> 
> This patch introduces %pT format specifier for printing task_struct->comm.
> Currently %pT does not provide consistency. I'm planning to change to use RCU
> in the future. By using RCU, the comm name read from task_struct->comm will be
> guaranteed to be consistent. But before modifying set_task_comm() to use RCU,
> we need to kill direct ->comm users who do not use get_task_comm().
> 
> An example for converting direct ->comm users is shown below. Since many debug
> printings use p == current, you can pass NULL instead of p if p == current.
> 
>   pr_info("comm=%s\n", p->comm);       => pr_info("comm=%pT\n", p);
>   pr_info("comm=%s\n", current->comm); => pr_info("comm=%pT\n", NULL);
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

Reviewed-by: Pavel Machek <pavel@ucw.cz>
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
