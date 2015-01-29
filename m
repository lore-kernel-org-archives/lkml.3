Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055AbbA2Lmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 06:42:33 -0500
Received: from svenfoo.org ([82.94.215.22]:44116 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756708AbbA2Lma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 06:42:30 -0500
Message-ID: <54CA1CA2.9060005@zonque.org>
Date: Thu, 29 Jan 2015 12:42:26 +0100
From: Daniel Mack <daniel@zonque.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Michael Kerrisk <mtk.manpages@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        "Theodore T'so" <tytso@mit.edu>, Linux API <linux-api@vger.kernel.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Tom Gundersen <teg@jklm.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Djalal Harouni <tixxdz@opendz.org>, Johannes Stezenbach <js@sig21.net>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/13] kdbus: add documentation
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org> <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org> <54BE5DC8.70706@gmail.com> <54BE9D08.7010804@zonque.org> <54BF805B.4000609@gmail.com> <54BFDAAA.50203@zonque.org> <54C0CE8A.5080805@gmail.com> <CANq1E4S=3qNw599L85uj-8aXwxeV+mcurB_Nu_rHH8opAeePjw@mail.gmail.com> <54C10DDC.9000503@gmail.com> <20150123160854.GA5210@kroah.com> <54C65346.5070504@gmail.com> <CANq1E4SkHhs1pWUe-TzG7bzk1M-Q++mB2vmQGuYx0RMF53wg4Q@mail.gmail.com> <CALCETrU1O6LjhrXSH2aXWFt2WGh=ssrq4K9HD10f_Z55iT=Otw@mail.gmail.com> <54C9F525.4040703@zonque.org> <CALCETrV6P+Lx5FRLyDNubG18tqCTLprkXJf=82aa5DsRHjkuKA@mail.gmail.com>
In-Reply-To: <CALCETrV6P+Lx5FRLyDNubG18tqCTLprkXJf=82aa5DsRHjkuKA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2015 12:25 PM, Andy Lutomirski wrote:
> On Jan 29, 2015 3:53 AM, "Daniel Mack" <daniel@zonque.org> wrote:

>> Also note that if a receiving peer opts in for a certain piece of
>> metadata, it should do that that for a good reason, because it needs
>> that data to process a request. Letting kdbus do the work of providing
>> such information is still a lot faster than having the receiving peer
>> gather it itself, as that would involve more syscalls and more context
>> switches (let alone the fact that doing so is inherently racy, as
>> explained in earlier threads).

> Given that I see almost no advantage to send-time metadata, and I see
> three disadvantages (slower, inconsistent with the basic POSIX model,
> and inconsistent with existing user-space dbus), I still don't see why
> you designed it this way.

Because effective information about tasks may change over time, and
D-Bus is a connection-less protocol that has no notion of peer-to-peer
connections.

As we explained before, currently, D-Bus peers do collect the same
information already if they need to have them, but they have to do deal
with the inherit races in such cases. kdbus is closing the gap by
optionally providing the same information along with each message, if
requested.

> There's an added disadvantage of the current design: if a kdbus user
> is communicating with a traditional d-bus user using the proxy, then
> IIUC the credentials at the time of connection get used.

That's not quite true any more. After our discussion in v2, we agreed on
dropping this detail. If you're using the proxy, no metadata is attached
to messages any more. Userspace has to gather this information in the
traditional, racy way in such cases. You are right - metadata about the
proxy task is of no interest here, and hence dropping the information
altogether is the most consistent thing we can do.

But again - that metadata thing just an optional feature. People
developing with the bare kernel-level API are free to ignore all that
and just just kdbus as low-level protocol for reliable multicast. Note
that in such cases, you would still be able to retrieve the connect-time
metadata if that's needed.


Thanks,
Daniel

