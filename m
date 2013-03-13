Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932907Ab3CMLhR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 07:37:17 -0400
Received: from mail-ia0-f172.google.com ([209.85.210.172]:46206 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474Ab3CMLg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 07:36:57 -0400
MIME-Version: 1.0
In-Reply-To: <1363106846.27803.174.camel@thor.lan>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
	<1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
	<CANN689HvZK3gHyxRBPZyXwz2cJfheiEoQMA23oRARMCp=7GUCQ@mail.gmail.com>
	<1363106846.27803.174.camel@thor.lan>
Date: Wed, 13 Mar 2013 04:36:56 -0700
Message-ID: <CANN689HX1VAURYZL4=ixOSwim2LdYDgZyORtfUffrc4JCqK4xQ@mail.gmail.com>
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

On Tue, Mar 12, 2013 at 9:47 AM, Peter Hurley <peter@hurleysoftware.com> wrote:
> On Mon, 2013-03-11 at 19:28 -0700, Michel Lespinasse wrote:
>> Also why the write-priority requirement rather than reader-writer
>> fairness ? Is it to make it less likely to hit the writer timeouts ?
>
> Since tty i/o can be really [painfully] slow, allowing waiting future
> references to succeed is not an option.

All right, that makes sense after your explanation.

> I understand the concern regarding the potential proliferation of new
> lock types. Lock implementations are hard to get right, and no one wants
> to debug 7 different lock policy implementations of a read/write
> semaphore.
>
> OTOH, a lack of existing options has spawned a DIY approach without
> higher-order locks that is rarely correct, but which goes largely
> unnoticed exactly because it's not a new lock. A brief review of the
> hangs, races, and deadlocks fixed by this patchset should be convincing
> enough of that fact. In my opinion, this is the overriding concern.

Agree that having a suitable lock for your usage is much nicer than
having ad-hoc solutions.

> The two main problems with a one-size-fits-all lock policy is that,
> 1) lock experts can't realistically foresee the consequences of policy
> changes without already being experts in the subsystems in which that
> lock is used. Even domain experts may miss potential consequences, and
> 2) domain experts typically wouldn't even consider writing a new lock.
> So they make do with atomic bit states, spinlocks, reference counts,
> mutexes, and waitqueues, making a mostly-functional, higher-order lock.

Have you considered building your ldlock based on lib/rwsem-spinlock.c
instead ? i.e. having an internal spinlock to protect the ldisc
reference count and the reader and writer queues. This would seem much
simpler get right. The downside would be that a spinlock would be
taken for a short time whenever an ldisc reference is taken or
released. I don't expect that the internal spinlock would get
significant contention ?

> Perhaps a future direction for rwsem would be to provide a selectable
> lock policy (fifo, mostly-fair, writer-first) on initialization so that
> the different use cases can be easily accomodated?

Probably makes more sense to have different locks for the different
usage models IMO...

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
