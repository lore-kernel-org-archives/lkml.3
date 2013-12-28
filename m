Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab3L1TXP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 14:23:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36869 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab3L1TXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 14:23:14 -0500
Date: Sat, 28 Dec 2013 11:25:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lib/vsprintf: add %pT[C012] format specifier
Message-Id: <20131228112509.8a62548c.akpm@linux-foundation.org>
In-Reply-To: <CAMuHMdXVrL-9Fq3ixCZvh1TubGg7HFc0HKPbq-YYu+Q1zxWcEA@mail.gmail.com>
References: <201312252137.IDC43215.OLtJQFHOFMVFSO@I-love.SAKURA.ne.jp>
	<20131227150211.61328c02d61722cb212649e9@linux-foundation.org>
	<201312281243.CCB82366.tMHFVQFSOOFJOL@I-love.SAKURA.ne.jp>
	<CAMuHMdXVrL-9Fq3ixCZvh1TubGg7HFc0HKPbq-YYu+Q1zxWcEA@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Dec 2013 19:57:50 +0100 Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> > If we introduce a character which compiler does not know that follows the %
> > character, compiler would be confused when checking type of corresponding
> > argument.
> >
> >> I wonder if there's some way in which we can invent a vsprintf token
> >> which means "insert corrent->comm here" and which doesn't require that
> >> the caller pass in the additional argument?
> >
> > Therefore, if we want to omit passing corresponding argument, we should not
> > introduce new character which compiler does not know that follows the %
> > character.
> >
> > Also, % is the only character which everybody knows that it is reserved for the
> > beginning of format specifier and %% is the only characters which everybody
> > knows that it is reserved for literal % character.
> >
> > Therefore, what we could do for printing current thread's attributes would be
> > either reserve a new character and add EXTENSION like
> >
> >   pr_warn("$comm$: hair on fire\n");
> >   pr_warn("Process $pid$: hair on fire\n");
> >
> > or add EXTENSION after the %% characters like
> >
> >   pr_warn("%%comm%%: hair on fire\n");
> >   pr_warn("Process %%pid%%: hair on fire\n");
> 
> ESC sequences? So far printk() doesn't parse them (a bit unfortunate, as I
> always liked the idea of printing error messages in red, warnings in yellow,
> etc.).
> 
> Is any of the "\x" (backslash + character) unused and thus available?

I guess control characters would work.

#define PRINTK_COMM	"\001"
#define PRINTK_PID	"\002"
#define PRINTK_TASK_ID	"\003"	/* "comm:pid" */

	printk(PRINTK_TASK_ID ": hair on fire\n");

It's certainly compact.  I doubt if there's any existing code which
deliberately prints control chars?

