Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbaAHOUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 09:20:18 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:63995 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433AbaAHOUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 09:20:15 -0500
X-Nat-Received: from [202.181.97.72]:62800 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1389190749.16929
To: pavel@ucw.cz, joe@perches.com
Cc: keescook@chromium.org, akpm@linux-foundation.org, geert@linux-m68k.org,
        jkosina@suse.cz, viro@zeniv.linux.org.uk, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/vsprintf: add %pT[C012] format specifier
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20140107001604.GD24243@amd.pavel.ucw.cz>
	<1389056635.2433.22.camel@joe-AO722>
	<20140107083740.GA5683@amd.pavel.ucw.cz>
	<1389116048.32137.14.camel@joe-AO722>
	<20140107175656.GB18316@amd.pavel.ucw.cz>
In-Reply-To: <20140107175656.GB18316@amd.pavel.ucw.cz>
Message-Id: <201401082319.FEC82827.JFFMOQSHOOVtFL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 8 Jan 2014 23:19:04 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 08012014 #7270042, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> > > > I'm not nacking this, just stating my view.
> > > 
> > > And I believe Andrew clearly stated his view, on the very topic you
> > > asked him on.
> > 
> > I believe Andrew's view:
> > 
> > On Sat, 2013-12-28 at 12:08 -0800, Andrew Morton wrote:
> > > On Sat, 28 Dec 2013 11:53:25 -0800 Joe Perches <joe@perches.com> wrote:
> > > > Tell me again, what's wrong with using p or current?
> > > > printk("%pt", current);
> > > 
> > > Nothing much.  It's just that all these callsites are generating the
> > > code to pass an argument which the callee already has access to. 
> > > Optimizing that will reduce text size a bit.
> > 
> > was that the argument passing was the primary issue.
> 
> Yes. He dislikes passing argument callee has already access
> to. "current". This patch does not do this, it just passes the NULL as
> a marker... and to keep printf() checkers happy.

Excuse me?
Compilers or kernel developers, which one does "printf() checkers" refer to?

The "%pT" patch is for printing tsk->comm consistently, but not always
tsk == current .

The "\x1A" patch is for printing tsk->xxx without passing tsk->xxx as
arguments, but always tsk == current .

These two patches have different purposes and do not overwrap.

Both patches are written not to confuse compilers when using
__attribute__((format(printf, a, b))) check. Therefore, I don't think that
the "\x1A" patch makes compilers unhappy. Rather, the "\x1A" patch would make
compilers more happy because it replaces cost of passing current or NULL
as arguments with cost of symbolic names (e.g. two bytes for
  #define EMBED_CURRENT_COMM "\x1A\xFF"
case) within the format string.

  (no patch applied)
  tsk = current;
  pr_info("%s[%d] trap %s ip:%lx sp:%lx error:%lx",
          tsk->comm, tsk->pid, str, regs->ip, regs->sp, error_code);

  (the "%pT" patch applied)
  tsk = current;
  pr_info("%pT[%d] trap %s ip:%lx sp:%lx error:%lx",
          NULL, tsk->pid, str, regs->ip, regs->sp, error_code);

  (the "\x1A" patch applied)
  pr_info(EMBED_CURRENT_COMM "[" EMBED_CURRENT_PID "] trap %s ip:%lx sp:%lx error:%lx",
          str, regs->ip, regs->sp, error_code);

By reducing number of function arguments, those who audit the correctness of
kernel source code would gain more readability.

  (no patch applied)
  tsk = current;
  pr_info("%s[%d] trap %s ip:%lx sp:%lx error:%lx",
          tsk->comm, tsk->pid, str, regs->ip, regs->sp, error_code);

  (the "\x1A" patch applied)
  pr_info(EMBED_CURRENT_COMM "[" EMBED_CURRENT_PID "] trap %s ip:%lx sp:%lx error:%lx",
          str, regs->ip, regs->sp, error_code);

There might be kernel developers who are using \x1A within the format string as
a literal byte, but we will be able to find and rewrite \x1A in the format
string like

  (before fixing problem)
  const chat *fmt = "aaa\x1Axxx\n";
  pr_debug(fmt);

  (after fixing problem)
  const char *str = "aaa\x1Axxx"
  pr_debug("%s\n", str);

as with we find and rewrite '%' in the format string like

  (before fixing problem)
  const chat *fmt = "aaa%xxx\n";
  pr_debug(fmt);

  (after fixing problem)
  const char *str = "aaa%xxx"
  pr_debug("%s\n", str);

.

It seems to me that we can agree with the "%pT" patch.
But how does the "\x1A" patch make compilers or kernel developers unhappy?
