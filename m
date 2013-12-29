Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690Ab3L2CHY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:07:24 -0500
Received: from smtprelay0253.hostedemail.com ([216.40.44.253]:38244 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751334Ab3L2CHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:07:22 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2553:2559:2562:2693:2828:2894:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3870:3871:3872:4321:4605:5007:6119:7652:7903:10004:10400:10848:10967:11026:11232:11473:11658:11914:12295:12296:12438:12517:12519:12533:12740:13138:13160:13229:13231,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: size59_7a367f9d50145
X-Filterd-Recvd-Size: 3228
Message-ID: <1388282837.24123.24.camel@joe-AO722>
Subject: Re: [PATCH] lib/vsprintf: add %pT[C012] format specifier
From: Joe Perches <joe@perches.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: akpm@linux-foundation.org, geert@linux-m68k.org, jkosina@suse.cz,
        viro@zeniv.linux.org.uk, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Date: Sat, 28 Dec 2013 18:07:17 -0800
In-Reply-To: <201312290932.GGH35442.JFVFFHSOMOQOtL@I-love.SAKURA.ne.jp>
References: <20131228112509.8a62548c.akpm@linux-foundation.org>
	 <CAMuHMdWfi4mSQLA01_fYrs1ybQ5YysO2EF4q1EBNy+7nbKXN6g@mail.gmail.com>
	 <1388260405.24123.18.camel@joe-AO722>
	 <20131228120815.31f7d378.akpm@linux-foundation.org>
	 <1388262293.24123.22.camel@joe-AO722>
	 <201312290932.GGH35442.JFVFFHSOMOQOtL@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-12-29 at 09:32 +0900, Tetsuo Handa wrote:
> Joe Perches wrote:
> > On Sat, 2013-12-28 at 12:08 -0800, Andrew Morton wrote:
> > > On Sat, 28 Dec 2013 11:53:25 -0800 Joe Perches <joe@perches.com> wrote:
> > > 
> > > > > > #define PRINTK_PID      "\002"
> > > > > > #define PRINTK_TASK_ID  "\003"  /* "comm:pid" */
> > 
> > > > > >
> > > > > >         printk(PRINTK_TASK_ID ": hair on fire\n");
> > > > > >
> > > > > > It's certainly compact.  I doubt if there's any existing code which
> > > > > > deliberately prints control chars?
> 
> What about using bytes from \x7F to \xFF ?
> 
> We are not passing multibyte characters like UTF-8 in the format string (are
> we?) because the non-first byte of multibyte characters by error matching %
> will cause security problem (format string bug) because the format string is
> parsed as char array.
> 
> Then, we could do something like below.
> 
>   pr_info("%s", current->comm);   => pr_info("\x7F\x80");
>   pr_info("%d", current->pid);    => pr_info("\x7F\x81");
>   pr_info("%10d", current->pid);  => pr_info("\x7F10\x81");
> 
> If precision field support is unnecessary, we could use only \x80 to \xFF .
> 
>   pr_info("%s", current->comm);   => pr_info("\x80");
>   pr_info("%d", current->pid);    => pr_info("\x81");

My preference would be to do something like:

$ cat include/asm-generic/current.h
#ifndef __ASM_GENERIC_CURRENT_H
#define __ASM_GENERIC_CURRENT_H

#include <linux/thread_info.h>

#define get_current() (current_thread_info()->task)
#define current get_current()

#define CURRENT_SUB		"\032"
#define CURRENT_SUB_ASCII	'\032'

#define CURRENT_ID		CURRENT_SUB "1"
#define CURRENT_COMM		CURRENT_SUB "2"
#define CURRENT_TASK_STATE	CURRENT_SUB "3"
#define CURRENT_TASK_PID	CURRENT_SUB "4"
#define CURRENT_TASK_GID	CURRENT_SUB "5"
#define CURRENT_TASK_UID	CURRENT_SUB "6"
#define CURRENT_TASK_FSUID	CURRENT_SUB "7"
#define CURRENT_TASK_FSGID	CURRENT_SUB "8"
/* add more as necessary */

#endif /* __ASM_GENERIC_CURRENT_H */


