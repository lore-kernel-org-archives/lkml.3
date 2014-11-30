Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbaK3RWx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 12:22:53 -0500
Received: from albireo.enyo.de ([46.237.207.196]:45573 "EHLO albireo.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbaK3RWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 12:22:51 -0500
From: Florian Weimer <fw@deneb.enyo.de>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Tom Gundersen <teg@jklm.no>, Jiri Kosina <jkosina@suse.cz>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Mack <daniel@zonque.org>, Djalal Harouni <tixxdz@opendz.org>
Subject: Re: kdbus: add documentation
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org>
	<1416546149-24799-2-git-send-email-gregkh@linuxfoundation.org>
	<CALCETrWUekPq6pquuiVperBihQHgcvCF=WzVJTZziHhUJYsh4Q@mail.gmail.com>
	<87tx1hxdgy.fsf@mid.deneb.enyo.de>
	<CANq1E4QJhbypbs1PueKdW7AmBPiiYEg1dN-fsAewDJap82feyg@mail.gmail.com>
Date: Sun, 30 Nov 2014 18:22:31 +0100
In-Reply-To: <CANq1E4QJhbypbs1PueKdW7AmBPiiYEg1dN-fsAewDJap82feyg@mail.gmail.com>
	(David Herrmann's message of "Sun, 30 Nov 2014 18:12:39 +0100")
Message-ID: <87zjb8txgo.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Herrmann:

> poll(2) and friends cannot return data for changed descriptors. I
> think a single trap for each KDBUS_CMD_MSG_RECV is acceptable. If this
> turns out to be a bottleneck, we can provide bulk-operations in the
> future. Anyway, I don't see how a _shared_ pool would change any of
> this?

I responded to Andy's messages because it seemed to be about
generalizing the pool functionality.

>> kernel could also queue the data for one specific recipient,
>> addressing the same issue that SO_REUSEPORT tries to solve (on poll
>> notification, the kernel does not know which recipient will eventually
>> retrieve the data, so it has to notify and wake up all of them).
>
> We already queue data only for the addressed recipients. We *do* know
> all recipients of a message at poll-notification time. We only wake up
> recipients that actually got a message queued.

Exactly, but poll on, say, UDP sockets, does not work this way.  What
I'm trying to say is that this functionality is interesting for much
more than kdbus.

> Not sure how this is related to SO_REUSEPORT. Can you elaborate on
> your optimizations?

Without something like SO_REUSEPORT, it is a bad idea to have multiple
threads polling the same socket.  The semantics are such that the
kernel has to wake *all* the waiting threads, and one of them will
eventually pick up the datagram with a separate system call.  But the
kernel does not know which thread this will be.

With SO_REUSEPORT and a separately created socket for each polling
thread, the kernel will only signal one poll operation because it
assumes that any of the waiting threads will process the datagram, so
it's sufficient just to notify one of them.

kdbus behaves like the latter, but also saves the need to separately
obtain the datagram and related data from the kernel.
