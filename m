Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbbA2IyD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:54:03 -0500
Received: from svenfoo.org ([82.94.215.22]:42857 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbbA2IyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:54:00 -0500
Message-ID: <54C9F525.4040703@zonque.org>
Date: Thu, 29 Jan 2015 09:53:57 +0100
From: Daniel Mack <daniel@zonque.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: David Herrmann <dh.herrmann@gmail.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Tom Gundersen <teg@jklm.no>, "Theodore T'so" <tytso@mit.edu>,
        Linux API <linux-api@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Djalal Harouni <tixxdz@opendz.org>, Johannes Stezenbach <js@sig21.net>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/13] kdbus: add documentation
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org> <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org> <54BE5DC8.70706@gmail.com> <54BE9D08.7010804@zonque.org> <54BF805B.4000609@gmail.com> <54BFDAAA.50203@zonque.org> <54C0CE8A.5080805@gmail.com> <CANq1E4S=3qNw599L85uj-8aXwxeV+mcurB_Nu_rHH8opAeePjw@mail.gmail.com> <54C10DDC.9000503@gmail.com> <20150123160854.GA5210@kroah.com> <54C65346.5070504@gmail.com> <CANq1E4SkHhs1pWUe-TzG7bzk1M-Q++mB2vmQGuYx0RMF53wg4Q@mail.gmail.com> <CALCETrU1O6LjhrXSH2aXWFt2WGh=ssrq4K9HD10f_Z55iT=Otw@mail.gmail.com>
In-Reply-To: <CALCETrU1O6LjhrXSH2aXWFt2WGh=ssrq4K9HD10f_Z55iT=Otw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On 01/27/2015 05:03 PM, Andy Lutomirski wrote:
> On Tue, Jan 27, 2015 at 7:05 AM, David Herrmann <dh.herrmann@gmail.com> wrote:

>> A 16byte copy does not affect the performance of kdbus message
>> transactions in any way that matters.

> What are the performance goals of kdbus?  How fast is it ever intended
> to be?

One of the design goals of kdbus is to speed up a typical D-Bus message
turnaround. That is, to minimize the number of context switches it
currently takes to get a message across the bus, and to avoid
unnecessary extra payload copies.

Even though I'm sure there's still room for future improvement, the
benchmark test we provided in the kernel self-tests shows that basic
data transmission performance is roughly comparable to that of UDS for
smaller payloads. For payloads of bigger sizes (>128kb), kdbus is
actually faster due to its zero-copy mechanism.

> The reason I ask is that, in the current design, kdbus
> collects "metadata" (credentials and other identifying information,
> collected in kdbus_meta_proc_collect) from the sender of every message
> *at send time*. [1]  This is slow, and it will always be slow.  The
> slowness of this operation will, in my personal system performance
> crystal ball, overshadow the cost of a 16 byte copy by several orders
> of magnitude.

That's certainly true, but that's not a contradiction to the performance
argument. Please keep in mind that if a receiving peer does not request
any metadata, the kernel doesn't collect and attach any. We know that
gathering of some of the metadata comes at a price, which is why we
split up the information is such fine-grained pieces.

Also note that if a receiving peer opts in for a certain piece of
metadata, it should do that that for a good reason, because it needs
that data to process a request. Letting kdbus do the work of providing
such information is still a lot faster than having the receiving peer
gather it itself, as that would involve more syscalls and more context
switches (let alone the fact that doing so is inherently racy, as
explained in earlier threads).

So, yes, collecting metadata can slow down message exchange, but after
all, that's an optional feature that has to be used with sense. I'll add
some words on that to the man-pages.


HTH,
Daniel

