Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbaGVJt5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 05:49:57 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:47699 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752869AbaGVJtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 05:49:55 -0400
X-Sasl-enc: csNKvqYXRYlsUMt/gP3i6YN6UREe2paozNlaDxiHstB7 1406022594
Message-ID: <1406022592.2407.9.camel@localhost>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: George Spelvin <linux@horizon.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 22 Jul 2014 11:49:52 +0200
In-Reply-To: <20140722044409.GE24960@thunk.org>
References: <20140721112102.19300.qmail@ns.horizon.com>
	 <1405956426.2319.37.camel@localhost> <1405990940.28229.4.camel@localhost>
	 <20140722044409.GE24960@thunk.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Di, 2014-07-22 at 00:44 -0400, Theodore Ts'o wrote:
> On Tue, Jul 22, 2014 at 03:02:20AM +0200, Hannes Frederic Sowa wrote:
> > 
> > Ted, would it make sense to specifiy a 512 byte upper bound limit for
> > random entropy extraction (I am not yet convinced to do that for
> > urandom) and in case the syscall should block we make sure that we
> > extract the amount of bytes the user requested?
> 
> On some systems, it's still possible that with a large /dev/random
> extraction, you could end up blocking for hours.  So either the
> getrandom(2) syscall needs to be uninterruptible, which has one set of
> problems (and not just the user typing ^C, but also things like being
> able to process alarms, which is highly problematic indeed), or you
> need to allow it to be interruptible by a signal, in which case
> userspace needs to check the error return for things like EINTR
> anyway.  And if you have to check the error return, you might as well
> check the number of bytes returned.

I think a lot of checks are of the type "if (getrandom() < 0)", so this
actually was the kind of programming errors I wanted to guard against. 
Also, on some systems it is very likely that we return a short write to
user space, so it prevents this very common situation. Even if one would
like to extract 64 bytes randomness, one would often need two calls to
getrandom() on my virtualized systems. Would be great to know that in
blocking mode, either I get a -1 or the buffer is always filled and I
won't need to do pointer arithmetic to fill the rest of the buffer.

I still think it is a good idea even without caring about the signal
interruptions.

> Yes, one could in theory set up a new variant of "uninterruptible"
> signals that only exited if the signal caused the process to exit, and
> otherwise, forced a system call restart even if SA_INTERRUPTIBLE was
> not set in sigalarim, but that's add *way* more complexity than this
> deserves.

I don't want to do that. It is totally ok if we return -1 and set errno
to EINTR in case of pending signals.

> Basically, I view /dev/random as an advanced call, and someone who
> uses it should know what they are doing.  It's not the default for a
> reason.

I agree, but I still think this would make the interface a bit more
friendly to use.

Thanks,
Hannes


