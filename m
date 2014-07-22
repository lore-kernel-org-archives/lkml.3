Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbaGVEoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 00:44:34 -0400
Received: from imap.thunk.org ([74.207.234.97]:48907 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbaGVEoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 00:44:32 -0400
Date: Tue, 22 Jul 2014 00:44:09 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: George Spelvin <linux@horizon.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Message-ID: <20140722044409.GE24960@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Hannes Frederic Sowa <hannes@stressinduktion.org>,
	George Spelvin <linux@horizon.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20140721112102.19300.qmail@ns.horizon.com>
 <1405956426.2319.37.camel@localhost>
 <1405990940.28229.4.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405990940.28229.4.camel@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 03:02:20AM +0200, Hannes Frederic Sowa wrote:
> 
> Ted, would it make sense to specifiy a 512 byte upper bound limit for
> random entropy extraction (I am not yet convinced to do that for
> urandom) and in case the syscall should block we make sure that we
> extract the amount of bytes the user requested?

On some systems, it's still possible that with a large /dev/random
extraction, you could end up blocking for hours.  So either the
getrandom(2) syscall needs to be uninterruptible, which has one set of
problems (and not just the user typing ^C, but also things like being
able to process alarms, which is highly problematic indeed), or you
need to allow it to be interruptible by a signal, in which case
userspace needs to check the error return for things like EINTR
anyway.  And if you have to check the error return, you might as well
check the number of bytes returned.

Yes, one could in theory set up a new variant of "uninterruptible"
signals that only exited if the signal caused the process to exit, and
otherwise, forced a system call restart even if SA_INTERRUPTIBLE was
not set in sigalarim, but that's add *way* more complexity than this
deserves.

Basically, I view /dev/random as an advanced call, and someone who
uses it should know what they are doing.  It's not the default for a
reason.

						- Ted
