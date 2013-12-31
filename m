Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab3LaQYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 11:24:32 -0500
Received: from smtprelay0212.hostedemail.com ([216.40.44.212]:54269 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753767Ab3LaQYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 11:24:31 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2693:2731:2828:3138:3139:3140:3141:3142:3355:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:4605:5007:6119:7652:7903:8526:10004:10400:10848:11026:11232:11473:11658:11914:12043:12295:12296:12438:12517:12519:12533:12679:12740:13138:13141:13161:13229:13230:13231,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bike07_9f03a50ed053
X-Filterd-Recvd-Size: 4169
Message-ID: <1388507067.2259.24.camel@joe-AO722>
Subject: Re: [PATCH] lib/vsprintf: add %pT[C012] format specifier
From: Joe Perches <joe@perches.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: akpm@linux-foundation.org, geert@linux-m68k.org, jkosina@suse.cz,
        viro@zeniv.linux.org.uk, davem@davemloft.net, keescook@chromium.org,
        linux-kernel@vger.kernel.org
Date: Tue, 31 Dec 2013 08:24:27 -0800
In-Reply-To: <201312311553.IGG09071.HLJtFVSQFFOOOM@I-love.SAKURA.ne.jp>
References: <1388262293.24123.22.camel@joe-AO722>
	 <201312290932.GGH35442.JFVFFHSOMOQOtL@I-love.SAKURA.ne.jp>
	 <1388282837.24123.24.camel@joe-AO722>
	 <201312292113.FIJ60946.tFOVOJOHLQSFFM@I-love.SAKURA.ne.jp>
	 <1388422545.26796.36.camel@joe-AO722>
	 <201312311553.IGG09071.HLJtFVSQFFOOOM@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-31 at 15:53 +0900, Tetsuo Handa wrote:
> Joe Perches wrote:
> > Also I prefer using ASCII SUB (26 \x1a \032 ^z) or maybe
> > PU1 - 145 or PU2 - 146, as an initiator byte as it takes
> > up much less of the control word space instead of using
> > multiple values like \x80, \x81, \x82, etc.  Using an
> > initiator byte seems more extensible too.
> 
> My format and rules are:
> 
>   #define EMBED_FORMAT        "0x7F"
>   #define EMBED_CURRENT_COMM  "0x80"
>   #define EMBED_CURRENT_PID   "0x81"
> 
>   We need to use EMBED_FORMAT prefix only when you want to specify one (or
>   more) of flags, field width and precision options. That is,
> 
>     pr_info("%s(%d)\n", current->comm, current->pid);
>       => pr_info(EMBED_CURRENT_COMM "(" EMBED_CURRENT_PID ")\n");
> 
>     pr_info("[%-6.6s]\n", current->comm);
>       => pr_info(EMBED_FORMAT "-6.6" EMBED_CURRENT_COMM "\n");
> 
> But I can't imagine what your format and rules are because
> 
>   #define CURRENT_SUB		"\032"
>   #define CURRENT_SUB_ASCII	'\032'
> 
> are ' ' character which is also used within the format string.
> Also, if you assign one of ('0' to '9', '-', '.') for variable name like
> 
>   #define CURRENT_ID		CURRENT_SUB "1"
>   #define CURRENT_COMM		CURRENT_SUB "2"
> 
> you will need a separating byte in order to distinguish end of
> flags, field width and precision options.

The goal of a single leading char is simply resource
economy.  Using fewer chars from the available pool may be
better than using more.  Using a couple more bytes in the
format string doesn't seem an excessive overhead.

> Please describe your format and rules (e.g. what byte starts a built-in token;
> what bytes are used for representing variable name, what separates flags, field
> width and precision options from variable name if these options are specified,
> what byte terminates a built-in token) using examples below.
> 
>     pr_info("%s(%d)\n", current->comm, current->pid);

	pr_info(CURRENT_COMM "(" CURRENT_PID ")\n");

>     pr_info("[%-6.6s]\n", current->comm);

I think using formatting controls for field widths and
such shouldn't be supported but if it is, then using yet
another macro form like below is possible

either:
#define CURRENT_COMM_FORMAT(fmt)		\
	CURRENT_SUB fmt "2"
or
#define CURRENT_COMM_FORMATTED(fmt)		\
	CURRENT_SUB __stringify(fmt) "2"

So maybe,
	pr_info(CURRENT_COMM_FORMAT("-6.6") "\n");
or
	pr_info(CURRENT_COMM_FORMATTED(-6.6) "\n");

depending on taste could work.

"2" would need changing to something like "t2" so any
leading format directives like field width and precision
could be done properly.

In other words: using a separating byte may be necessary if
some formatting directive support is required.

This wouldn't/couldn't work with formats where field length
is specified via "*" with a separate int.

Perhaps that's a good enough reason not to support using
format directives.

