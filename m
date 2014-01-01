Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804AbaAAFfA (ORCPT <rfc822;list-kernel77@spinics.net>);
	Wed, 1 Jan 2014 00:35:00 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:50459 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbaAAFe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 00:34:59 -0500
X-Nat-Received: from [202.181.97.72]:55081 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1388554449.30138
To: joe@perches.com
Cc: akpm@linux-foundation.org, geert@linux-m68k.org, jkosina@suse.cz,
        viro@zeniv.linux.org.uk, davem@davemloft.net, keescook@chromium.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/vsprintf: add %pT[C012] format specifier
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1388282837.24123.24.camel@joe-AO722>
	<201312292113.FIJ60946.tFOVOJOHLQSFFM@I-love.SAKURA.ne.jp>
	<1388422545.26796.36.camel@joe-AO722>
	<201312311553.IGG09071.HLJtFVSQFFOOOM@I-love.SAKURA.ne.jp>
	<1388507067.2259.24.camel@joe-AO722>
In-Reply-To: <1388507067.2259.24.camel@joe-AO722>
Message-Id: <201401011434.GAF34360.FFQOVtFOHJSMLO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 1 Jan 2014 14:34:03 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 31122013 #7214915, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> > Please describe your format and rules (e.g. what byte starts a built-in token;
> > what bytes are used for representing variable name, what separates flags, field
> > width and precision options from variable name if these options are specified,
> > what byte terminates a built-in token) using examples below.
> > 
> >     pr_info("%s(%d)\n", current->comm, current->pid);
> 
> 	pr_info(CURRENT_COMM "(" CURRENT_PID ")\n");
> 
> >     pr_info("[%-6.6s]\n", current->comm);
> 
> I think using formatting controls for field widths and
> such shouldn't be supported but if it is, then using yet
> another macro form like below is possible
> 
> either:
> #define CURRENT_COMM_FORMAT(fmt)		\
> 	CURRENT_SUB fmt "2"
> or
> #define CURRENT_COMM_FORMATTED(fmt)		\
> 	CURRENT_SUB __stringify(fmt) "2"
> 
> So maybe,
> 	pr_info(CURRENT_COMM_FORMAT("-6.6") "\n");
> or
> 	pr_info(CURRENT_COMM_FORMATTED(-6.6) "\n");
> 
> depending on taste could work.
> 
> "2" would need changing to something like "t2" so any
> leading format directives like field width and precision
> could be done properly.
> 
> In other words: using a separating byte may be necessary if
> some formatting directive support is required.
> 

I think we want formatting directive support because we have users shown below.

  fs/afs/internal.h:         printk("[%-6.6s] "FMT"\n", current->comm ,##__VA_ARGS__)
  fs/cachefiles/internal.h:  printk(KERN_DEBUG "[%-6.6s] "FMT"\n", current->comm, ##__VA_ARGS__)
  fs/fscache/internal.h:     printk(KERN_DEBUG "[%-6.6s] "FMT"\n", current->comm, ##__VA_ARGS__)

Though I think that

> This wouldn't/couldn't work with formats where field length
> is specified via "*" with a separate int.
> 
> Perhaps that's a good enough reason not to support using
> format directives.

we don't need to support complete set like '*'.

> The goal of a single leading char is simply resource
> economy.  Using fewer chars from the available pool may be
> better than using more.  Using a couple more bytes in the
> format string doesn't seem an excessive overhead.

Then, I think we can choose as

  Byte for beginning of built-in token:

    '\xFF'

  Bytes for specifying flags, field width, precision options:

    '0' to '9', '-' and '.'

  Bytes for specifying built-in variable:

    All but '\xFF', '0' to '9', '-', '.', '%' and '\x00'

and define 241 built-in variables, while using only single leading char (i.e.
'\xFF') from the available pool (all but '%' and '\x00').

  #define EMBED_FORMAT        "\xFF"
  #define EMBED_CURRENT_COMM  "\xFF" "\x80"
  #define EMBED_CURRENT_PID   "\xFF" "\x81"

  pr_info("%s(%d)\n", current->comm, current->pid);
    => pr_info(EMBED_CURRENT_COMM "(" EMBED_CURRENT_PID ")\n");

  pr_info("[%-6.6s]\n", current->comm);
    => pr_info(EMBED_FORMAT "-6.6" EMBED_CURRENT_COMM "\n");

Since I assume that 241 built-in variables are sufficient, I'm laying
"Bytes for specifying built-in variable" under obligation of also acting as
"Bytes for ending of built-in token".

This choice works because once format_decode() encounters '\xFF' byte, it can
continue reading until it encounters one of "Bytes for ending of built-in
token", and split them into "Bytes for specifying flags, field width, precision
options" and "Bytes for specifying built-in variable" without any fuzziness.

  \xFF\x80(\xFF\x80)\n
  ^   ^    ^   ^
  |   |    |   +- Decoder interprets as variable name and understands that this
  |   |    |      is a trailing byte.
  |   |    +----- Decoder interprets as a leading byte because decoder sees
  |   |           this byte for the first time.
  |   +---------- Decoder interprets as variable name and understands that this
  |               is a trailing byte.
  +-------------- Decoder interprets as a leading byte because decoder sees
                  this byte for the first time.

  [\xFF-6.6\xFF\x80]\n
   ^   ^   ^   ^
   |   |   |   +- Decoder interprets as variable name and understands that
   |   |   |      this is a trailing byte.
   |   |   +----- Decoder ignores this byte because decoder already saw
   |   |          this byte.
   |   +--------- Decoder interprets as format specifier.
   +------------- Decoder interprets as leading byte because decoder sees
                  this byte for the first time.

This choice (i.e. reserve only '\xFF') is more resource economy than my
previous choice (i.e. reserve '\x7F' to '\xFF') at the cost of wasting only
one byte compared to my previous choice.
