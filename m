Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbaLHJSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 04:18:35 -0500
Received: from smtprelay0233.hostedemail.com ([216.40.44.233]:50689 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752151AbaLHJSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 04:18:33 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:4250:4321:4605:5007:6119:6261:7903:10004:10400:10429:10430:10431:10450:10455:10848:11026:11232:11473:11658:11914:12296:12438:12517:12519:12679:12740:13069:13311:13357:19903:19904:19997:19999:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: burn76_2d4b625e63b15
X-Filterd-Recvd-Size: 2853
Message-ID: <1418030309.31745.37.camel@perches.com>
Subject: Re: [PATCH 6/20] TTY: fix misspelling of current function in string
From: Joe Perches <joe@perches.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel-janitors@vger.kernel.org, linux@rasmusvillemoes.dk,
        linux-kernel@vger.kernel.org
Date: Mon, 08 Dec 2014 01:18:29 -0800
In-Reply-To: <548565FC.1020908@suse.cz>
References: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1417980062-25151-7-git-send-email-Julia.Lawall@lip6.fr>
	 <548565FC.1020908@suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-08 at 09:49 +0100, Jiri Slaby wrote:
> On 12/07/2014, 08:20 PM, Julia Lawall wrote:
> > Replace the last argument of serial_paranoia_check by the actual function
> > name.
[]
> > diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
[]
> > @@ -931,7 +931,7 @@ static void rs_send_xchar(struct tty_struct *tty, char ch)
> >  	struct serial_state *info = tty->driver_data;
> >          unsigned long flags;
> >  
> > -	if (serial_paranoia_check(info, tty->name, "rs_send_char"))
> > +	if (serial_paranoia_check(info, tty->name, "rs_send_xchar"))
> 
> I wonder, why not to use __func__ here too?

Nearly identical functions are used in amiserial and cyclades.
Disabled in amiserial, enabled in cyclades.

It might be better to add it to some file like
drivers/tty/debug_utils.h

It'd probably be better to change:

static inline int serial_paranoia_check(struct serial_state *info,
					char *name, const char *routine)
{
#ifdef SERIAL_PARANOIA_CHECK
	static const char *badmagic =
		"Warning: bad magic number for serial struct (%s) in %s\n";
	static const char *badinfo =
		"Warning: null async_struct for (%s) in %s\n";

	if (!info) {
		printk(badinfo, name, routine);
		return 1;
	}
	if (info->magic != SERIAL_MAGIC) {
		printk(badmagic, name, routine);
		return 1;
	}
#endif
	return 0;
}

to something like:

static inline int serial_paranoia_check(struct serial_state *info, char *name)
{
#ifdef SERIAL_PARANOIA_CHECK
	if (!info) {
		pr_warn("async_struct for (%s) is NULL in %pf\n",
			name, __builtin_return_address(0));
		return 1;
	}
	if (info->magic != SERIAL_MAGIC) {
		pr_warn("serial struct (%s) has bad magic number in %pf\n",
			name, __builtin_return_address(0));
		return 1;
	}
#endif
	return 0;
}

and remove all the function names from the callers.


