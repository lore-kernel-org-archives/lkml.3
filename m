Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbbAUK20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:28:26 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:40890 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbbAUK2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:28:17 -0500
Message-ID: <54BF7F38.9000106@gmail.com>
Date: Wed, 21 Jan 2015 11:28:08 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>
CC: mtk.manpages@gmail.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Tom Gundersen <teg@jklm.no>, Jiri Kosina <jkosina@suse.cz>,
        Andy Lutomirski <luto@amacapital.net>,
        Linux API <linux-api@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Daniel Mack <daniel@zonque.or>, Djalal Harouni <tixxdz@opendz.org>,
        Daniel Mack <daniel@zonque.org>, Johannes Stezenbach <js@sig21.net>
Subject: Re: [PATCH 01/13] kdbus: add documentation
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>	<1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org>	<54BE5DC8.70706@gmail.com> <CANq1E4SjfZOKqTsdkt519vKc1Poeah5McVJBb_spdHjbKv4=7g@mail.gmail.com>
In-Reply-To: <CANq1E4SjfZOKqTsdkt519vKc1Poeah5McVJBb_spdHjbKv4=7g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On 01/20/2015 03:31 PM, David Herrmann wrote:
> Hi Michael
> 
> On Tue, Jan 20, 2015 at 2:53 PM, Michael Kerrisk (man-pages)
> <mtk.manpages@gmail.com> wrote:
>> On 01/16/2015 08:16 PM, Greg Kroah-Hartman wrote:
>>> From: Daniel Mack <daniel@zonque.org>
>>>
>>> kdbus is a system for low-latency, low-overhead, easy to use
>>> interprocess communication (IPC).
>>>
>>> The interface to all functions in this driver is implemented via ioctls
>>> on files exposed through a filesystem called 'kdbusfs'. The default
>>> mount point of kdbusfs is /sys/fs/kdbus. This patch adds detailed
>>> documentation about the kernel level API design.
>>
>> I have some details feedback on the contents of this file, and some
>> bigger questions. I'll split them out into separate mails.
>>
>> So here, the bigger, general questions to start with. I've arrived late
>> to this, so sorry if they've already been discussed, but the answers to
>> some of the questions should actually be in this file, I would have
>> expected.
>>
>> This is an enormous and complex API. Why is the API ioctl() based,
>> rather than system-call-based? Have we learned nothing from the hydra
>> that the futex() multiplexing syscall became? (And kdbus is an order
>> of magnitude more complex, by the look of things.) At the very least,
>> a *good* justification of why the API is ioctl()-based should be part
>> of this documentation file.
>>
>> An observation: The documentation below is substantial, but this API is
>> enormous, so the documentation still feels rather thin. What would
>> really help would be some example code in the doc.
>>
>> And on the subject of code examples... Are there any (prototype)
>> working user-space applications that exercise the current kdbus
>> implementation? That is, can I install these kdbus patches, and
>> then find a simple example application somewhere that does
>> something to exercise kdbus?
> 
> If you run a 3.18 kernel, you can install kdbus.ko from our repository
> and boot a full Fedora system running Gnome3 with kdbus, given that
> you compiled systemd with --enable-kdbus (which is still
> experimental). No legacy dbus1 daemon is running. Instead, we have a
> bus-proxy that converts classic dbus1 to kdbus, so all
> bus-communication runs on kdbus.

Good to hear.  I think that some info like this should go out in 
the "00/" covering mails for future patch revisions, so that people
can get some sense of the testing that has been done.

>> And then: is there any substantial real-world application (e.g., a
>> full D-Bus port) that is being developed in tandem with this kernel
>> side patch? (I don't mean a user-space library; I mean a seriously
>> large application.) This is an incredibly complex API whose
>> failings are only going to become evident through real-world use.
>> Solidifying an API in the kernel and then discovering the API
>> problems later when writing real-world applications would make for
>> a sad story. A story something like that of inotify, an API which
>> is an order of magnitude less complex than kdbus. (I can't help but
>> feel that many of inotify problems that I discuss at
>> https://lwn.net/Articles/605128/ might have been fixed or mitigated
>> if a few real-world applications had been implemented before the
>> API  was set in stone.)
> 
> I think running a whole Gnome3 stack counts as "substantial real-world
> application", right? 

Yes, I'll give you that ;-).

>  Sure, it's a dbus1-to-kdbus layer, but all the
> systemd tools use kdbus natively and it works just fine. In fact, we
> all run kdbus on our main-systems every day.
> 
> We've spent over a year fixing races and API misdesigns, we've talked
> to other toolkit developers (glib, qt, ..) and made sure we're
> backwards compatible to dbus1. I don't think the API is perfect,
> everyone makes mistakes. But with bus-proxy and systemd we have two
> huge users of kdbus that put a lot of pressure on API design.

I'll say more about that in another mail in a moment. I'm not enthusiastic
about the API.

>>> +For a kdbus specific userspace library implementation please refer to:
>>> +  http://cgit.freedesktop.org/systemd/systemd/tree/src/systemd/sd-bus.h
>>
>> Is this library intended just for systemd? More generally, is there an
>> intention to provide a general purpose library API for kdbus? Or is the
>> intention that each application will roll a library suitable to its
>> needs? I think an answer to that question would be useful in this
>> Documentation file.
> 
> kdbus is in no way bound to systemd. There are ongoing efforts to port
> glib and qt to kdbus natively. The API is pretty simple 
                                 ^^^^^^^^^^^^^^^^^^^^^^^^
I think you and I must have quite different definitions of "simple"...
(For more on this point, see my reply to Daniel in a moment.)

> and I don't
> see how a libkdbus would simplify things. In fact, even our tests only
> have slim wrappers around the ioctls to simplify error-handling in
> test-scenarios.

Again, the above info would be useful in the Documentation file.

> Note that most of the toolkit work is on the marshaling level, which
> is independent of kdbus. kdbus just provides the transport level. DBus
> is just one, yet significant, application-layer on top of kdbus. Our
> test-cases use kdbus exclusively to transport raw byte streams.

Okay. Thanks for the info.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
