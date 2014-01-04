Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbaADC1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 21:27:24 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:49674 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815AbaADC1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 21:27:22 -0500
X-Nat-Received: from [202.181.97.72]:58422 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1388802386.16151
To: keescook@chromium.org, joe@perches.com, pavel@ucw.cz
Cc: akpm@linux-foundation.org, geert@linux-m68k.org, jkosina@suse.cz,
        viro@zeniv.linux.org.uk, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/vsprintf: add %pT[C012] format specifier
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1388626389.2259.57.camel@joe-AO722>
	<201401021349.JGJ78109.OOFtFFHJMLSOQV@I-love.SAKURA.ne.jp>
	<CAGXu5jL7RunQuAw1MjnUMgWeYMX35+YcGeaZYCx6dhND3YUmsQ@mail.gmail.com>
	<1388770748.14334.19.camel@joe-AO722>
	<CAGXu5j+gHtgx9MVCaJ2ogJ0WGCeTDkphsH3gm7S=+mTssicABg@mail.gmail.com>
In-Reply-To: <CAGXu5j+gHtgx9MVCaJ2ogJ0WGCeTDkphsH3gm7S=+mTssicABg@mail.gmail.com>
Message-Id: <201401041126.BHJ81291.VOHLOtMFOJFQFS@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 4 Jan 2014 11:26:22 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 04012014 #7241364, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm planning to convert task_struct->comm to use RCU so that they always get
consistent result. Inconsistent result (e.g. trailing '\0' byte is emitted when
printing string argument) is caused by breaking a rule that the string argument
must not change during the function when it is passed as "const char *" (e.g.
strcmp() and printf("%s")).

Although task_struct->comm is not modified so frequently, task_struct->comm
passed as a "const char *" argument can change at any moment unless we pass
task_struct->comm via get_task_comm().

Since there are a lot of current->comm readers, Andrew Morton suggested that
we might be able to omit passing the argument and I wrote a patch that adds a
second format-start character for omit passing the argument.

Kees Cook wrote:
> I'm on board with the idea of embedding comm/pid/whatever, but I
> either missed or do not understand why a second format-start character
> is being added. I think this will complicate audits and maybe trigger
> weird info leaks (imagine printing a string that was %-escaped, but
> not 0x1A-escaped?)

The second format-start character applies to only format string.
If we use a dynamically generated string that was %-escaped at run-time as a
format string, we will leak globally accessible variables. But are there such
users? Such users are rare because they are already problematic since compilers
cannot check for safety using __printf() attributes at build-time.

> Hrmpf. Yeah, on the fence about this.

But I'm fine even if we cannot agree with the second format-start character.
Since my purpose is to make reading of task_struct->comm consistent, %pT-like
extension is what I want for centralizing pointer dereferences.
