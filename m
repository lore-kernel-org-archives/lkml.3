Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbaFJQ5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 12:57:39 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:51160 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbaFJQ5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 12:57:37 -0400
MIME-Version: 1.0
In-Reply-To: <20140610164641.GD1951@localhost.localdomain>
References: <1399626665-29817-1-git-send-email-pmladek@suse.cz>
	<alpine.LNX.2.00.1405290000350.17241@pobox.suse.cz>
	<20140529000909.GC6507@localhost.localdomain>
	<alpine.LNX.2.00.1405290959270.17241@pobox.suse.cz>
	<20140610164641.GD1951@localhost.localdomain>
Date: Tue, 10 Jun 2014 09:57:36 -0700
X-Google-Sender-Auth: buH_23OOX1q8RUFbgBxHiyaxCzs
Message-ID: <CA+55aFzseOqF-EpKMvwKpfhBJZQSLqKpJ3shzVee9s0+mvyCuA@mail.gmail.com>
Subject: Re: [RFC PATCH 00/11] printk: safe printing in NMI context
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Dave Anderson <anderson@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kay Sievers <kay@vrfy.org>, Michal Hocko <mhocko@suse.cz>,
        Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 9:46 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
> There is also a big risk that if we push back this bugfix, nobody will actually do
> that desired rewrite.
>
> Lets be crazy and Cc Linus on that.

Quite frankly, I hate seeing something like this:

 kernel/printk/printk.c              | 1218 +++++++++++++++++++++++++----------

for something that is stupid and broken. Printing from NMI context
isn't really supposed to work, and we all *know* it's not supposed to
work.

I'd much rather disallow it, and if there is one or two places that
really want to print a warning and know that they are in NMI context,
have a special workaround just for them, with something that does
*not* try to make printk in general work any better.

Dammit, NMI context is special. I absolutely refuse to buy into the
broken concept that we should make more stuff work in NMI context.
Hell no, we should *not* try to make more crap work in NMI. NMI people
should be careful.

Make a trivial "printk_nmi()" wrapper that tries to do a trylock on
logbuf_lock, and *maybe* the existing sequence of

        if (console_trylock_for_printk())
                console_unlock();

then works for actually triggering the printout. But the wrapper
should be 15 lines of code for "if possible, try to print things", and
*not* a thousand lines of changes.

             Linus
