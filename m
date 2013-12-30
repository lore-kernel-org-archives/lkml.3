Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab3L3Qzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 11:55:51 -0500
Received: from smtprelay0209.hostedemail.com ([216.40.44.209]:52590 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756051Ab3L3Qzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 11:55:49 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1543:1593:1594:1605:1711:1730:1747:1777:1792:2393:2525:2553:2560:2563:2682:2685:2828:2859:2901:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3165:3622:3770:3865:3866:3867:3868:3870:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4605:5007:6119:7652:7903:8603:8985:9025:9040:9388:10004:10400:10848:10967:11026:11232:11473:11658:11914:12043:12294:12295:12296:12438:12517:12519:12533:12663:12682:12740:13149:13230,0,RBL:none,CacheI
X-HE-Tag: milk09_4f9d2ac846305
X-Filterd-Recvd-Size: 4671
Message-ID: <1388422545.26796.36.camel@joe-AO722>
Subject: Re: [PATCH] lib/vsprintf: add %pT[C012] format specifier
From: Joe Perches <joe@perches.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: akpm@linux-foundation.org, geert@linux-m68k.org, jkosina@suse.cz,
        viro@zeniv.linux.org.uk, davem@davemloft.net, keescook@chromium.org,
        linux-kernel@vger.kernel.org
Date: Mon, 30 Dec 2013 08:55:45 -0800
In-Reply-To: <201312292113.FIJ60946.tFOVOJOHLQSFFM@I-love.SAKURA.ne.jp>
References: <1388260405.24123.18.camel@joe-AO722>
	 <20131228120815.31f7d378.akpm@linux-foundation.org>
	 <1388262293.24123.22.camel@joe-AO722>
	 <201312290932.GGH35442.JFVFFHSOMOQOtL@I-love.SAKURA.ne.jp>
	 <1388282837.24123.24.camel@joe-AO722>
	 <201312292113.FIJ60946.tFOVOJOHLQSFFM@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-12-29 at 21:13 +0900, Tetsuo Handa wrote:
> Tetsuo Handa wrote:
> > Joe Perches wrote:
> > > On Sat, 2013-12-28 at 12:08 -0800, Andrew Morton wrote:
> > > > On Sat, 28 Dec 2013 11:53:25 -0800 Joe Perches <joe@perches.com> wrote:
> > > > 
> > > > > > > #define PRINTK_PID      "\002"
> > > > > > > #define PRINTK_TASK_ID  "\003"  /* "comm:pid" */
> > > 
> > > > > > >
> > > > > > >         printk(PRINTK_TASK_ID ": hair on fire\n");
> > > > > > >
> > > > > > > It's certainly compact.  I doubt if there's any existing code which
> > > > > > > deliberately prints control chars?
> > 
> > What about using bytes from \x7F to \xFF ?
> 
> Here is a draft patch. With this approach, we can embed whatever variables
> vsnprintf() can access (not only current thread's attributes seen from init and
> current namespace but also other variables like current time) into the format
> string without passing corresponding argument.
> 
> Is this approach acceptable? (Of course, I'll add lines like
> 
>   #define PRINT_FORMAT    "\x7F"
>   #define PRINT_TASK_COMM "\x80"
>   #define PRINT_TASK_PID  "\x81"
> 
> for final version.) What variables (e.g. current->comm, current->pid,
> task_tgid_vnr(current)) do we want to pass using builtin tokens?
[]
> The vast majority of ->comm accesses are accessing current->comm, for
> debug reasons. I'm counting 350-odd sites. At all these sites it's
> pointless passing `current' to the printk function at all!

I get:

$ grep-2.5.4 -rP --include=*.[ch] -oh \
  "\b(?:printk|[a-z_]+_(?:printk|emerg|alert|crit|err|warn|notice|info|debug|dbg))[^;]*\bcurrent->[\w_]+" * | \
  grep -P -oh "\bcurrent->[\w_]+"| sort | uniq -c | sort -rn
    380 current->pid
    267 current->comm
     34 current->mm
     25 current->thread
     17 current->journal_info
      8 current->flags
      7 current->tgid
      5 current->active_mm
      2 current->sas_ss_sp
      2 current->addr_limit
      1 current->uid
      1 current->signal
      1 current->sas_ss_size
      1 current->ret_stack
      1 current->memcg_batch
      1 current->kernel_stack_page
      1 current->group_leader
      1 current->exit_code
      1 current->cred
      1 current->blocked

> This patch introduces a set of vsprintf tokens for embedding globally visible
> arguments into the format string, so that we can reduce text size a bit (and
> in the future make reading of task_struct->comm consistent) by stop generating
> the code to pass an argument which the callee already has access to, with an
> assumption that we can avoid using bytes >= 0x7F within the format string.
> 
> Some examples for converting direct ->comm users are shown below.
> 
>   pr_info("comm=%s\n", current->comm); => pr_info("comm=\x80\n");
>   pr_info("pid=%d\n", current->pid);   => pr_info("pid=\x81\n");
>   pr_info("%s(%d)\n", current->comm, current->pid); => pr_info("\x80(\x81)\n");
>   pr_info("[%-6.6s]\n", current->comm); => pr_info("\x7F-6.6\x80\n");

I too prefer using the #define CURRENT_<FOO> string approach
rather than direct embedding of string.

	pr_info("comm=" CURRENT_COMM "\n");

Also I prefer using ASCII SUB (26 \x1a \032 ^z) or maybe
PU1 - 145 or PU2 - 146, as an initiator byte as it takes
up much less of the control word space instead of using
multiple values like \x80, \x81, \x82, etc.  Using an
initiator byte seems more extensible too.

http://en.wikipedia.org/wiki/C0_and_C1_control_codes


