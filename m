Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798AbbA2L0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 06:26:06 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:47692 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831AbbA2LZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 06:25:50 -0500
MIME-Version: 1.0
In-Reply-To: <54C9F525.4040703@zonque.org>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
 <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org>
 <54BE5DC8.70706@gmail.com> <54BE9D08.7010804@zonque.org> <54BF805B.4000609@gmail.com>
 <54BFDAAA.50203@zonque.org> <54C0CE8A.5080805@gmail.com> <CANq1E4S=3qNw599L85uj-8aXwxeV+mcurB_Nu_rHH8opAeePjw@mail.gmail.com>
 <54C10DDC.9000503@gmail.com> <20150123160854.GA5210@kroah.com>
 <54C65346.5070504@gmail.com> <CANq1E4SkHhs1pWUe-TzG7bzk1M-Q++mB2vmQGuYx0RMF53wg4Q@mail.gmail.com>
 <CALCETrU1O6LjhrXSH2aXWFt2WGh=ssrq4K9HD10f_Z55iT=Otw@mail.gmail.com> <54C9F525.4040703@zonque.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 29 Jan 2015 03:25:28 -0800
Message-ID: <CALCETrV6P+Lx5FRLyDNubG18tqCTLprkXJf=82aa5DsRHjkuKA@mail.gmail.com>
Subject: Re: [PATCH 01/13] kdbus: add documentation
To: Daniel Mack <daniel@zonque.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 29, 2015 3:53 AM, "Daniel Mack" <daniel@zonque.org> wrote:
>
> Hi Andy,
>
> On 01/27/2015 05:03 PM, Andy Lutomirski wrote:
> > On Tue, Jan 27, 2015 at 7:05 AM, David Herrmann <dh.herrmann@gmail.com> wrote:
>
> >> A 16byte copy does not affect the performance of kdbus message
> >> transactions in any way that matters.
>
> > What are the performance goals of kdbus?  How fast is it ever intended
> > to be?
>
> One of the design goals of kdbus is to speed up a typical D-Bus message
> turnaround. That is, to minimize the number of context switches it
> currently takes to get a message across the bus, and to avoid
> unnecessary extra payload copies.
>
> Even though I'm sure there's still room for future improvement, the
> benchmark test we provided in the kernel self-tests shows that basic
> data transmission performance is roughly comparable to that of UDS for
> smaller payloads. For payloads of bigger sizes (>128kb), kdbus is
> actually faster due to its zero-copy mechanism.
>
> > The reason I ask is that, in the current design, kdbus
> > collects "metadata" (credentials and other identifying information,
> > collected in kdbus_meta_proc_collect) from the sender of every message
> > *at send time*. [1]  This is slow, and it will always be slow.  The
> > slowness of this operation will, in my personal system performance
> > crystal ball, overshadow the cost of a 16 byte copy by several orders
> > of magnitude.
>
> That's certainly true, but that's not a contradiction to the performance
> argument. Please keep in mind that if a receiving peer does not request
> any metadata, the kernel doesn't collect and attach any. We know that
> gathering of some of the metadata comes at a price, which is why we
> split up the information is such fine-grained pieces.
>
> Also note that if a receiving peer opts in for a certain piece of
> metadata, it should do that that for a good reason, because it needs
> that data to process a request. Letting kdbus do the work of providing
> such information is still a lot faster than having the receiving peer
> gather it itself, as that would involve more syscalls and more context
> switches (let alone the fact that doing so is inherently racy, as
> explained in earlier threads).

All this is true, but if you used connect-time metadata, this would be
a non-issue.

Given that I see almost no advantage to send-time metadata, and I see
three disadvantages (slower, inconsistent with the basic POSIX model,
and inconsistent with existing user-space dbus), I still don't see why
you designed it this way.

There's an added disadvantage of the current design: if a kdbus user
is communicating with a traditional d-bus user using the proxy, then
IIUC the credentials at the time of connection get used.

In summary, the current design is (a) unlike almost everything else
that uses file descriptors, (b) much slower, (c) different from
traditional d-bus, and (d) gives inconsistent behavior to new clients
depending on what server they're connecting to.

--Andy

>
> So, yes, collecting metadata can slow down message exchange, but after
> all, that's an optional feature that has to be used with sense. I'll add
> some words on that to the man-pages.
>
>
> HTH,
> Daniel
>
