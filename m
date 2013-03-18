Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab3CRX5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 19:57:01 -0400
Received: from mail-da0-f41.google.com ([209.85.210.41]:43761 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756329Ab3CRX47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 19:56:59 -0400
Date: Mon, 18 Mar 2013 16:58:15 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Sasha Levin <levinsasha928@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH v5 26/44] tty: Add read-recursive, writer-prioritized rw
 semaphore
Message-ID: <20130318235815.GA5320@kroah.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
 <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
 <1363034704-28036-27-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363034704-28036-27-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 04:44:46PM -0400, Peter Hurley wrote:
> The semantics of a rw semaphore are almost ideally suited
> for tty line discipline lifetime management;  multiple active
> threads obtain "references" (read locks) while performing i/o
> to prevent the loss or change of the current line discipline
> (write lock).
> 
> Unfortunately, the existing rw_semaphore is ill-suited in other
> ways;
> 1) obtaining a "reference" can be recursive, ie., a reference holder
>    may attempt to obtain another "reference". Recursive read locks
>    are not supported by rwsem.

Why does a ldisc need to obtain this recursively?

> 2) TIOCSETD ioctl (change line discipline) expects to return an
>    error if the line discipline cannot be exclusively locked within
>    5 secs. Lock wait timeouts are not supported by rwsem.

Don't we have some other lock that can timeout?

> 3) A tty hangup is expected to halt and scrap pending i/o, so
>    exclusive locking must be prioritized without precluding
>    existing reference holders from obtaining recursive read locks.
>    Writer priority is not supported by rwsem.

But how bad is it really if we have to wait a bit for that write lock to
get through all of the existing readers?  Either way, we are supposed to
be dropping i/o, so it shouldn't be a big deal, right?

> Add ld_semaphore which implements these requirements in a
> semantically and operationally similar way to rw_semaphore.

I _really_ don't want to add a new lock to the kernel, especially one
that is only used by one "driver".  You are going to have to convince
the current lock authors that this really is needed, before I can take
it, sorry.

What is wrong with the existing ldisc code that the creation of this
lock is needed?  Is our current code that broken?

Ok, it is the tty layer, so it probably is, but it's made it this far
for the past 20 years...

greg k-h
