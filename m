Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756AbaIJV0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 17:26:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58189 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbaIJV03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 17:26:29 -0400
Date: Wed, 10 Sep 2014 14:26:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, peterz@infradead.org, cxie@redhat.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] printk: Print cpu number along with time
Message-Id: <20140910142627.fcbf8c2fd7a8e6e5a8f5a69d@linux-foundation.org>
In-Reply-To: <20140909171658.GB14429@logfs.org>
References: <20140423125352.704f9fb2@annuminas.surriel.com>
	<alpine.LRH.2.00.1404232329020.1491@twin.jikos.cz>
	<20140424005247.GA17713@logfs.org>
	<20140424194024.GA25446@logfs.org>
	<20140428234039.GC6358@logfs.org>
	<20140428172219.4be61cf7.akpm@linux-foundation.org>
	<20140604231506.GA31276@logfs.org>
	<20140909171658.GB14429@logfs.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2014 13:16:58 -0400 J__rn Engel <joern@logfs.org> wrote:

> On Wed, 4 June 2014 19:15:06 -0400, J__rn Engel wrote:
> > On Mon, 28 April 2014 17:22:19 -0700, Andrew Morton wrote:
> > > On Mon, 28 Apr 2014 19:40:39 -0400 J__rn Engel <joern@logfs.org> wrote:
> > > > On Thu, 24 April 2014 15:40:24 -0400, J__rn Engel wrote:
> > > > > On Wed, 23 April 2014 20:52:47 -0400, J__rn Engel wrote:
> > > > > > 
> > > > > > I use the patch below for some time now.  While it doesn't avoid the
> > > > > > log pollution in the first place, it lessens the impact somewhat.
> > > > > 
> > > > > Added a config option and ported it to current -linus.  Andrew, would
> > > > > you take this patch?
> > > > 
> > > > Andrew?  Did you dislike this patch for some reason or just miss it in
> > > > the thread?
> > > 
> > > Neither ;) I try to respond in some way to all patches unless I think it's clear
> > > to the originator why I took no action.  And I think I'm pretty good at
> > > not losing stuff.
> > > 
> > > otoh, it has only been four days, three of which I spent offline...
> > 
> > Ping.
> 
> Ping.

It needs a resend please.

A few thoughts:

On Thu, 24 Apr 2014 15:40:24 -0400 J__rn Engel <joern@logfs.org> wrote:
> 
> Sometimes the printk log is heavily interleaving between different cpus.
> This is particularly bad when you have two backtraces at the same time,
> but can be annoying in other cases as well.  With an explicit cpu
> number, a simple grep can disentangle the mess for you.
> 
> Signed-off-by: Joern Engel <joern@logfs.org>
> ---
>  kernel/printk/printk.c | 19 ++++++++++++++++---
>  lib/Kconfig.debug      |  9 +++++++++
>  2 files changed, 25 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index a45b50962295..b9e464924825 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -200,6 +200,7 @@ struct printk_log {
>  	u16 len;		/* length of entire record */
>  	u16 text_len;		/* length of text buffer */
>  	u16 dict_len;		/* length of dictionary buffer */
> +	u16 cpu;		/* cpu the message was generated on */
>  	u8 facility;		/* syslog facility */
>  	u8 flags:5;		/* internal record flags */
>  	u8 level:3;		/* syslog level */
> @@ -346,6 +347,7 @@ static void log_store(int facility, int level,
>  	msg->facility = facility;
>  	msg->level = level & 7;
>  	msg->flags = flags & 0x1f;
> +	msg->cpu = smp_processor_id();

Are you sure this won't generate smp_processor_id-in-preemptible
warnings?  log_store has several callers..

>  	if (ts_nsec > 0)
>  		msg->ts_nsec = ts_nsec;
>  	else
> @@ -859,7 +861,7 @@ static bool printk_time;
>  #endif
>  module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
>  
> -static size_t print_time(u64 ts, char *buf)
> +static size_t print_time(u64 ts, u16 cpu, char *buf)

The name is now wrong - it prints cpu number as well as time.

>  {
>  	unsigned long rem_nsec;
>  
> @@ -868,11 +870,20 @@ static size_t print_time(u64 ts, char *buf)
>  
>  	rem_nsec = do_div(ts, 1000000000);
>  
> +#ifdef CONFIG_PRINTK_CPU

This is regrettable.  If someone wants the CPU number they have to
compile and install a new kernel?  That's often impractical so we have
to hope that everyone enables the feature.  And if they do that, why
did we need the Kconfigurability?

We have a printk.time boot parameter, so adding printk.cpu seems natural?

+		return snprintf(NULL, 0, "[%5lu.000000,%02x] ",

Printing hex numbers without 0x is just nasty.  "11" = 17, surprise!
