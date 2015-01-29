Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbbA2MKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 07:10:21 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:64872 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbbA2MKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 07:10:18 -0500
MIME-Version: 1.0
In-Reply-To: <54CA1CA2.9060005@zonque.org>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
 <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org>
 <54BE5DC8.70706@gmail.com> <54BE9D08.7010804@zonque.org> <54BF805B.4000609@gmail.com>
 <54BFDAAA.50203@zonque.org> <54C0CE8A.5080805@gmail.com> <CANq1E4S=3qNw599L85uj-8aXwxeV+mcurB_Nu_rHH8opAeePjw@mail.gmail.com>
 <54C10DDC.9000503@gmail.com> <20150123160854.GA5210@kroah.com>
 <54C65346.5070504@gmail.com> <CANq1E4SkHhs1pWUe-TzG7bzk1M-Q++mB2vmQGuYx0RMF53wg4Q@mail.gmail.com>
 <CALCETrU1O6LjhrXSH2aXWFt2WGh=ssrq4K9HD10f_Z55iT=Otw@mail.gmail.com>
 <54C9F525.4040703@zonque.org> <CALCETrV6P+Lx5FRLyDNubG18tqCTLprkXJf=82aa5DsRHjkuKA@mail.gmail.com>
 <54CA1CA2.9060005@zonque.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 29 Jan 2015 04:09:56 -0800
Message-ID: <CALCETrXD41=ohFSkCmBD8zPHFVUtr49QXMhYnChAxqQtmUjJYw@mail.gmail.com>
Subject: Re: [PATCH 01/13] kdbus: add documentation
To: Daniel Mack <daniel@zonque.org>
Cc: Arnd Bergmann <arnd@arndb.de>, "Ted Ts'o" <tytso@mit.edu>,
        Linux API <linux-api@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Tom Gundersen <teg@jklm.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Herrmann <dh.herrmann@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Djalal Harouni <tixxdz@opendz.org>, Johannes Stezenbach <js@sig21.net>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 29, 2015 6:42 AM, "Daniel Mack" <daniel@zonque.org> wrote:
>
> On 01/29/2015 12:25 PM, Andy Lutomirski wrote:
> > On Jan 29, 2015 3:53 AM, "Daniel Mack" <daniel@zonque.org> wrote:
>
> >> Also note that if a receiving peer opts in for a certain piece of
> >> metadata, it should do that that for a good reason, because it needs
> >> that data to process a request. Letting kdbus do the work of providing
> >> such information is still a lot faster than having the receiving peer
> >> gather it itself, as that would involve more syscalls and more context
> >> switches (let alone the fact that doing so is inherently racy, as
> >> explained in earlier threads).
>
> > Given that I see almost no advantage to send-time metadata, and I see
> > three disadvantages (slower, inconsistent with the basic POSIX model,
> > and inconsistent with existing user-space dbus), I still don't see why
> > you designed it this way.
>
> Because effective information about tasks may change over time, and
> D-Bus is a connection-less protocol that has no notion of peer-to-peer
> connections.
>
> As we explained before, currently, D-Bus peers do collect the same
> information already if they need to have them, but they have to do deal
> with the inherit races in such cases. kdbus is closing the gap by
> optionally providing the same information along with each message, if
> requested.

In all these discussions, no one ever gave a decent example use case.
If a process drops some privilege, it must close all fds it has that
captured its old privilege.  This has nothing to do with kdbus.  With
kdbus, you still need to close and reopen your kdbus fd, unless you've
disabled that bit of metadata, so using send-time metadata hasn't
bought you benefit that I can see.

I agree that the design seems to have improved to a state of being at
least decent, but that doesn't mean that using send-time metadata is a
good idea for systemd or for anything else.

>
> > There's an added disadvantage of the current design: if a kdbus user
> > is communicating with a traditional d-bus user using the proxy, then
> > IIUC the credentials at the time of connection get used.
>
> That's not quite true any more. After our discussion in v2, we agreed on
> dropping this detail. If you're using the proxy, no metadata is attached
> to messages any more. Userspace has to gather this information in the
> traditional, racy way in such cases. You are right - metadata about the
> proxy task is of no interest here, and hence dropping the information
> altogether is the most consistent thing we can do.
>
> But again - that metadata thing just an optional feature. People
> developing with the bare kernel-level API are free to ignore all that
> and just just kdbus as low-level protocol for reliable multicast. Note
> that in such cases, you would still be able to retrieve the connect-time
> metadata if that's needed.
>

It's an optional feature that will get used, non-optionally, thousands
of times on each boot, apparently.  Keep in mind that it's also a
scalability problem because it takes locks.  If it ever gets used
thousands of times per CPU on a big thousand-core machine, it's going
to suck, and you'll have backed yourself into a corner.

--Andy
