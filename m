Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502Ab3L2AdN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 19:33:13 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:58701 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab3L2AdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 19:33:12 -0500
X-Nat-Received: from [202.181.97.72]:50572 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1388277169.6033
To: joe@perches.com, akpm@linux-foundation.org
Cc: geert@linux-m68k.org, jkosina@suse.cz, viro@zeniv.linux.org.uk,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/vsprintf: add %pT[C012] format specifier
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20131228112509.8a62548c.akpm@linux-foundation.org>
	<CAMuHMdWfi4mSQLA01_fYrs1ybQ5YysO2EF4q1EBNy+7nbKXN6g@mail.gmail.com>
	<1388260405.24123.18.camel@joe-AO722>
	<20131228120815.31f7d378.akpm@linux-foundation.org>
	<1388262293.24123.22.camel@joe-AO722>
In-Reply-To: <1388262293.24123.22.camel@joe-AO722>
Message-Id: <201312290932.GGH35442.JFVFFHSOMOQOtL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 29 Dec 2013 09:32:44 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 28122013 #7186739, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Sat, 2013-12-28 at 12:08 -0800, Andrew Morton wrote:
> > On Sat, 28 Dec 2013 11:53:25 -0800 Joe Perches <joe@perches.com> wrote:
> > 
> > > > > #define PRINTK_PID      "\002"
> > > > > #define PRINTK_TASK_ID  "\003"  /* "comm:pid" */
> 
> > > > >
> > > > >         printk(PRINTK_TASK_ID ": hair on fire\n");
> > > > >
> > > > > It's certainly compact.  I doubt if there's any existing code which
> > > > > deliberately prints control chars?

What about using bytes from \x7F to \xFF ?

We are not passing multibyte characters like UTF-8 in the format string (are
we?) because the non-first byte of multibyte characters by error matching %
will cause security problem (format string bug) because the format string is
parsed as char array.

Then, we could do something like below.

  pr_info("%s", current->comm);   => pr_info("\x7F\x80");
  pr_info("%d", current->pid);    => pr_info("\x7F\x81");
  pr_info("%10d", current->pid);  => pr_info("\x7F10\x81");

If precision field support is unnecessary, we could use only \x80 to \xFF .

  pr_info("%s", current->comm);   => pr_info("\x80");
  pr_info("%d", current->pid);    => pr_info("\x81");
