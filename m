Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab3CLC2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 22:28:39 -0400
Received: from mail-ia0-f175.google.com ([209.85.210.175]:61042 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543Ab3CLC2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 22:28:37 -0400
MIME-Version: 1.0
In-Reply-To: <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
	<1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
Date: Mon, 11 Mar 2013 19:28:36 -0700
Message-ID: <CANN689HvZK3gHyxRBPZyXwz2cJfheiEoQMA23oRARMCp=7GUCQ@mail.gmail.com>
Subject: Re: [PATCH v5 00/44] ldisc patchset
From: Michel Lespinasse <walken@google.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Sasha Levin <levinsasha928@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 1:44 PM, Peter Hurley <peter@hurleysoftware.com> wrote:
> Greg,
> This patchset includes
>   'tty: Drop lock contention stat from ldsem trylocks'
> so no need to apply that on this series. Also, I noticed you
> kept the 'tty is NULL' removal on a different branch so I left
> my patch in this series that removes it.
>
> This series applies cleanly to tty-next.
>
> v5 changes:
>
> After completing an audit of the recursive use of ldisc
> references, I discovered the _blocking_ recursive acquisition
> of ldisc references was limited to line disciplines misusing
> the tty_perform_flush() function.
> With that now resolved in,
>   'tty: Fix recursive deadlock in tty_perform_flush()'
> the recursion design in ldsem has been removed.
>
> The recursion removal is in its own patch,
>   'tty: Remove ldsem recursion support'
> to ease review for those that have already reviewed the
> ldsem implementation.
>
> In addition, this patchset implements lock stealing derived
> from the work of Michel Lespinasse <walken@google.com> on
> writer lock stealing in rwsem.
>
> Although the rwsem write lock stealing changes are motivated
> by performance criteria, these changes are motivated by reduced
> code line count and simplicity of design.
>
> *** Edited below to remove recursion discussion ***
>
> Back in early December I realized that a classic read/write semaphore
> with writer priority was the ideal mechanism for handling the
> line discipline referencing.
>
> Line discipline references act as "readers"; closing or changing the
> line discipline is prevented while these references are outstanding.
> Conversely, line discipline references should not be granted while
> the line discipline is closing or changing; these are the "writers".
>
> Unfortunately, the existing rwsem uses a FIFO priority for
> waiting threads and does not support timeouts.
>
> So this implements just that: a writer-priority
> read/write semaphore with timed waits.

Thanks for eliminating the recursion requirement. I think this really
helps - I didn't like that multiple readers with a colliding current
hash could basically starve out a writer forever.

Not knowing anything about the tty layer, I am curious about the
context for your other requirements. What are ldisc references taken
for and for how long are they held ? I am surprised that the writers
may hit a 5 second timeout (because I didn't expect the references to
be held for very long).

Also why the write-priority requirement rather than reader-writer
fairness ? Is it to make it less likely to hit the writer timeouts ?

In short: I am worried about the introduciton of a new lock type, and
would be happier if rwsem could be made to fit. BTW, extending rwsem
itself to add writer timeouts seems quite doable (but making it work
as a write priority lock would seem like a bad idea).

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
