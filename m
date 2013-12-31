Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab3LaGy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 01:54:26 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:60580 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab3LaGyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 01:54:25 -0500
X-Nat-Received: from [202.181.97.72]:58979 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1388472812.29927
To: joe@perches.com
Cc: akpm@linux-foundation.org, geert@linux-m68k.org, jkosina@suse.cz,
        viro@zeniv.linux.org.uk, davem@davemloft.net, keescook@chromium.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/vsprintf: add %pT[C012] format specifier
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1388262293.24123.22.camel@joe-AO722>
	<201312290932.GGH35442.JFVFFHSOMOQOtL@I-love.SAKURA.ne.jp>
	<1388282837.24123.24.camel@joe-AO722>
	<201312292113.FIJ60946.tFOVOJOHLQSFFM@I-love.SAKURA.ne.jp>
	<1388422545.26796.36.camel@joe-AO722>
In-Reply-To: <1388422545.26796.36.camel@joe-AO722>
Message-Id: <201312311553.IGG09071.HLJtFVSQFFOOOM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 31 Dec 2013 15:53:29 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 31122013 #7206063, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> I get:
> 
> $ grep-2.5.4 -rP --include=*.[ch] -oh \
>   "\b(?:printk|[a-z_]+_(?:printk|emerg|alert|crit|err|warn|notice|info|debug|dbg))[^;]*\bcurrent->[\w_]+" * | \
>   grep -P -oh "\bcurrent->[\w_]+"| sort | uniq -c | sort -rn
>     380 current->pid
>     267 current->comm

We also have cases like

  struct task_struct *tsk = current;
  printk("%s/%d", tsk->comm, tsk->pid);
  printk("%d", task_pid_nr(tsk));
  snprintf(buf, sizeof(buf), "%d", task_pid_nr(current));

which are not counted with your grep rule.
But anyway, let's start with ->comm and ->pid .

> Also I prefer using ASCII SUB (26 \x1a \032 ^z) or maybe
> PU1 - 145 or PU2 - 146, as an initiator byte as it takes
> up much less of the control word space instead of using
> multiple values like \x80, \x81, \x82, etc.  Using an
> initiator byte seems more extensible too.

My format and rules are:

  #define EMBED_FORMAT        "0x7F"
  #define EMBED_CURRENT_COMM  "0x80"
  #define EMBED_CURRENT_PID   "0x81"

  We need to use EMBED_FORMAT prefix only when you want to specify one (or
  more) of flags, field width and precision options. That is,

    pr_info("%s(%d)\n", current->comm, current->pid);
      => pr_info(EMBED_CURRENT_COMM "(" EMBED_CURRENT_PID ")\n");

    pr_info("[%-6.6s]\n", current->comm);
      => pr_info(EMBED_FORMAT "-6.6" EMBED_CURRENT_COMM "\n");

But I can't imagine what your format and rules are because

  #define CURRENT_SUB		"\032"
  #define CURRENT_SUB_ASCII	'\032'

are ' ' character which is also used within the format string.
Also, if you assign one of ('0' to '9', '-', '.') for variable name like

  #define CURRENT_ID		CURRENT_SUB "1"
  #define CURRENT_COMM		CURRENT_SUB "2"

you will need a separating byte in order to distinguish end of
flags, field width and precision options.

Please describe your format and rules (e.g. what byte starts a built-in token;
what bytes are used for representing variable name, what separates flags, field
width and precision options from variable name if these options are specified,
what byte terminates a built-in token) using examples below.

    pr_info("%s(%d)\n", current->comm, current->pid);

    pr_info("[%-6.6s]\n", current->comm);
