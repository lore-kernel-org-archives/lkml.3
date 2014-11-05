Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaKEUOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 15:14:19 -0500
Received: from imap.thunk.org ([74.207.234.97]:40945 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbaKEUOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 15:14:09 -0500
Date: Wed, 5 Nov 2014 15:14:04 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Martin Tournoij <martin@arp242.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] The SIGINFO signal from BSD
Message-ID: <20141105201404.GH27083@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Austin S Hemmelgarn <ahferroin7@gmail.com>,
	Martin Tournoij <martin@arp242.net>, linux-kernel@vger.kernel.org
References: <1415200663.3247743.187387481.75CE9317@webmail.messagingengine.com>
 <545A7B00.1040309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545A7B00.1040309@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 02:31:12PM -0500, Austin S Hemmelgarn wrote:
> >
> >SIGINFO prints the status of the process to the terminal; BSD cp, for example,
> >shows show much data it's copied:
> >
> >     $ cp large_file /dev/null
> >     <press ^t>
> >     load: 1.39  cmd: cp 85837 [running] 3.91r 0.00u 0.98s 8% 2340k
> >     large_file -> /dev/null  15%
> >
> >As you see, it shows the current load, pid, process status, memory usage, as
> >well as how much of the file has been copied. Many other BSD tools print similar
> >statistics (mv, tar, dd, sleep, fetch, etc.).
> 
> You have to understand however, that the reason that SIGINFO works like that
> on *BSD is that the kernel and core userspace are developed together,
> whereas on Linux, they are maintained entirely separately. Outside of core
> userspace components, using SIGINFO that way on *BSD is just convention.

Actually, the first line:

	load: 1.39  cmd: cp 85837 [running] 3.91r 0.00u 0.98s 8% 2340k

is actually printed by the kernel.  It's actually something which is
implemented in the BSD N_TTY line displine.  We never implemented it
(at least when I was maintaining the tty subsystem) mostly out of
laziness.  Part of the reason is that the main reason was that main
reason why people (at least systems programmers / kernel programers
like me) used ^T was to debug an apparently hung system, and for
Linux, we had a much more powerful system using the magic-sysrq key.

Changing various userspace utilities to set up a signal handler for
SIGINFO and then printing some extra information, such as:

	large_file -> /dev/null  15%

is a much more recent innovation (at least, newer than BSD 4.3 in the
early 90's, which is the last time I hacked on BSD :-), and is largely
separate from the question of implementing ^T in the N_TTY line
displine.

In a world where we have a GUI desktop, I suspect implementing ^T is
much less interesting, but if someone were to submit a patch to at
least make ^T send a SIGINFO, I can't think of a reason why it
wouldn't be accepted.  (BTW, if you're going to do this, note that ^T
could be remapped to any control character via stty; so to do this we
would need to define an extra index in c_cc[] array in the struct
termios.)

Cheers,

					- Ted
