Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbaIPOP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 10:15:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38705 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884AbaIPOPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 10:15:25 -0400
Date: Tue, 16 Sep 2014 12:55:47 +0200
From: Jan Kara <jack@suse.cz>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Weird character in kernel message
Message-ID: <20140916105547.GA1205@quack.suse.cz>
References: <20140914050905.GA296@x4>
 <20140914055450.GB296@x4>
 <CAMuHMdUmqvN3GZzfjjHc5W2Dxgx2b0gzVHFUR8P8yUs5iFt_tA@mail.gmail.com>
 <20140915163740.GA12408@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140915163740.GA12408@x4>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 15-09-14 18:37:40, Markus Trippelsdorf wrote:
> On 2014.09.14 at 11:13 +0200, Geert Uytterhoeven wrote:
> > On Sun, Sep 14, 2014 at 7:54 AM, Markus Trippelsdorf
> > <markus@trippelsdorf.de> wrote:
> > > On 2014.09.14 at 07:09 +0200, Markus Trippelsdorf wrote:
> > >> Just noticed this today:
> > >>
> > >> Sep 14 06:51:57 x4 kernel: [sched_delayed] ^a4CE: hpet increased min_delta_ns to 20115 nsec
> > >>
> > >> in hex:
> > >> 20 01 34 43 45 3A 20
> > >>
> > >> Must be a recent regression.
> > >
> > > It looks like a combination of commit 504d58745c9ca and commit
> > > 458df9fd4815b causes the issue.
> > > 458df9fd4815b changed the loglevel of printk_deferred to a hardcoded
> > > KERN_WARNING. And 504d58745c9ca changed the printk in
> > > kernel/time/clockevents.c to printk_deferred.
> > > But now the KERN_WARNING loglevel of printk_deferred in
> > > kernel/time/clockevents.c is redundant and responsible for the weird
> > > 01 34 character combination (KERN_SOH "4").
> > 
> > vprintk_emit() has:
> > 
> >         if (in_sched)
> >                 text_len = scnprintf(text, sizeof(textbuf),
> >                                      KERN_WARNING "[sched_delayed] ");
> > 
> >         text_len += vscnprintf(text + text_len,
> >                                sizeof(textbuf) - text_len, fmt, args);
> > 
> > Hence if in_sched, "[sched_delayed] " is inserted before the printed
> > message. As most printed messages have a KERN_* prefix, this
> > prefix now ends up in the middle of the message, causing the issue.
> > 
> > A simple solution is to print a newline after the "[sched_delayed]", but
> > this will break the line.
> > 
> > Better, but more complicated, would be to remove the KERN_* prefix
> > (if it exists) from the next message if in_sched is set.
> 
> Or just get rid of the "[sched_delayed] " thing. Does it really convey
> useful information to the user?
  Yeah, you're right the prefix isn't that useful IMHO. So feel free to
add:
Acked-by: Jan Kara <jack@suse.cz>

								Honza
> 
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index 1ce770687ea8..b13c8650a751 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -1680,12 +1680,8 @@ asmlinkage int vprintk_emit(int facility, int level,
>  	 * The printf needs to come first; we need the syslog
>  	 * prefix which might be passed-in as a parameter.
>  	 */
> -	if (in_sched)
> -		text_len = scnprintf(text, sizeof(textbuf),
> -				     KERN_WARNING "[sched_delayed] ");
>  
> -	text_len += vscnprintf(text + text_len,
> -			       sizeof(textbuf) - text_len, fmt, args);
> +	text_len = vscnprintf(text, sizeof(textbuf), fmt, args);
>  
>  	/* mark and strip a trailing newline */
>  	if (text_len && text[text_len-1] == '\n') {
> 
> -- 
> Markus
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
