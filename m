Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab3IALKW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 07:10:22 -0400
Received: from imap.thunk.org ([74.207.234.97]:52733 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757192Ab3IALKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 07:10:17 -0400
Date: Sun, 1 Sep 2013 07:10:08 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: George Spelvin <linux@horizon.com>
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        waiman.long@hp.com, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
Message-ID: <20130901111008.GA28812@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	George Spelvin <linux@horizon.com>, torvalds@linux-foundation.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	viro@zeniv.linux.org.uk, waiman.long@hp.com,
	Steven Rostedt <rostedt@goodmis.org>,
	Frederic Weisbecker <fweisbec@gmail.com>
References: <CA+55aFz7k5zUvJdZxpZgCgfx_-PT+f-9J50hnC1i3x=8_dXkBw@mail.gmail.com>
 <20130901085049.21748.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130901085049.21748.qmail@science.horizon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Speaking of bool (and I'm not a fan of it either), is this warning
just noise (which is bad enough since it masks real warnings), or is
this going to cause serious problems?

  CHECK   /usr/projects/linux/ext4/kernel/trace/trace.c
/usr/projects/linux/ext4/kernel/trace/trace.c:559:6: warning: symbol 'free_snapshot' was not declared. Should it be static?
/usr/projects/linux/ext4/kernel/trace/trace.c:1489:14: warning: expression using sizeof bool
/usr/projects/linux/ext4/kernel/trace/trace.c:1489:14: warning: expression using sizeof bool
/usr/projects/linux/ext4/kernel/trace/trace.c:1489:14: warning: expression using sizeof bool
/usr/projects/linux/ext4/kernel/trace/trace.c:1489:14: warning: expression using sizeof bool
/usr/projects/linux/ext4/kernel/trace/trace.c:1492:9: warning: expression using sizeof bool
/usr/projects/linux/ext4/kernel/trace/trace.c:1492:9: warning: expression using sizeof bool
/usr/projects/linux/ext4/kernel/trace/trace.c:1492:9: warning: expression using sizeof bool
/usr/projects/linux/ext4/kernel/trace/trace.c:1492:9: warning: expression using sizeof bool
/usr/projects/linux/ext4/kernel/trace/trace.c:1539:9: warning: expression using sizeof bool
/usr/projects/linux/ext4/kernel/trace/trace.c:1539:9: warning: expression using sizeof bool
/usr/projects/linux/ext4/kernel/trace/trace.c:1539:9: warning: expression using sizeof bool
/usr/projects/linux/ext4/kernel/trace/trace.c:1539:9: warning: expression using sizeof bool

(i.e., is a C compiler allowed to pack multiple bools stored in a data
structure into a single byte, with potentially hilarious results for C
code trying to do magic utilizing sizeof and offsetof (which some of
our kernel macros do use, IIRC)?

				- Ted

P.S.  BTW, this is not the only set of sparse warnings that are
emitted by files in kernel/trace/*; maybe it would be good if the
ftrace maintianers worked on nuking them all?  There are also a bunch
of warnings like which I've only recently learned indicated potential
RCU bugs:

/usr/projects/linux/ext4/kernel/trace/trace.c:1885:17: warning: incorrect type in assignment (different address spaces)
/usr/projects/linux/ext4/kernel/trace/trace.c:1885:17:    expected struct trace_buffer_struct *buffers
/usr/projects/linux/ext4/kernel/trace/trace.c:1885:17:    got struct trace_buffer_struct [noderef] <asn:3>*<noident>
