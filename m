Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab3INExb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 00:53:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46243 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab3INExa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 00:53:30 -0400
Date: Sat, 14 Sep 2013 05:53:14 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: keescook@chromium.org, joe@perches.com, linux@horizon.com,
        akpm@linux-foundation.org, dan.carpenter@oracle.com,
        davem@davemloft.net, eldad@fogrefinery.com, jbeulich@suse.com,
        jkosina@suse.cz, linux-kernel@vger.kernel.org, rdunlap@infradead.org
Subject: Re: [PATCH] vsprintf: drop comment claiming %n is ignored
Message-ID: <20130914045313.GB13318@ZenIV.linux.org.uk>
References: <20130913195335.18955.qmail@science.horizon.com>
 <1379111268.2066.22.camel@joe-AO722>
 <CAGXu5jJxJVK7cu2Sc4Sdng_rLDL8ziC6aecAi7G0zL4fYnY-9Q@mail.gmail.com>
 <201309141149.HGF39054.QLJVHFtMFOSOOF@I-love.SAKURA.ne.jp>
 <20130914030521.GZ13318@ZenIV.linux.org.uk>
 <20130914034801.GA13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130914034801.GA13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 14, 2013 at 04:48:02AM +0100, Al Viro wrote:

> Overall: I suspect that Joe might be right.  The very few callers that
> use the return value and use it correctly can bloody well call
> seq_overflow(), preferably with a detailed comment about the reasons
> for doing so.  Anything that really wants the length of output (if we
> have such places at all) can use %n or see Figure 1.  I haven't
> crawled through lib/*, net/* and sound/* yet, but that's how the things
> look so far.

The same goes for seq_puts, seq_escape, seq_vprintf, seq_dentry,
seq_bitmap*, seq_cpumask*, seq_nodemask*, seq_putc, seq_put_decimal*

seq_puts() has one buggy user trying to return its return value from
->show().  seq_putc() has several such.

seq_path() returns length and in one case its return value is used
(right-padded pathname in /proc/swaps).

seq_path_root() returns what would be a valid return value for ->show()
(0 or 1, actually).

seq_write() return value is mostly ignored; kernel/trace/* is using it
to check for overflows, but its reaction to said overflows is odd.

The bottom line: most of these guys could as well return void; we have
few overflow checks and those could be made explicit.  As it is,
"return -1 on overflow" had been a mistake.  Mea culpa.
