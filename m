Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933013AbaDVPDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:03:52 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:59096 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932828AbaDVPDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:03:40 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrWOTVk6wK7e5CwLCRS9XN=5oDT+QtSAPPi_eTMDKgYRFQ@mail.gmail.com>
References: <cover.1398097304.git.luto@amacapital.net>
	<430cfc67aae9b9ad5eab4d293107285ad44c5fd9.1398097304.git.luto@amacapital.net>
	<CANq1E4T1P-g+wA6bZQe6=79-+QLmXReu4namcPifw-SZViqW-Q@mail.gmail.com>
	<CALCETrUZfSrBPZ0Fok5WrG2zM5h3LchEfqnWP4nK37-0sQ8=6g@mail.gmail.com>
	<CANq1E4T+5Yekm1CpzM40D3C-4XDr+5PYU8d6ud3Zw7k5dcrmUA@mail.gmail.com>
	<CALCETrWOTVk6wK7e5CwLCRS9XN=5oDT+QtSAPPi_eTMDKgYRFQ@mail.gmail.com>
Date: Tue, 22 Apr 2014 17:03:39 +0200
Message-ID: <CANq1E4QWMw2oLakm-YAdbCsCNHrgfU=66U5Ox-tHzDroFN6avA@mail.gmail.com>
Subject: Re: [RFC 2/2] fs,proc: Respect FMODE_WRITE when opening /proc/pid/fd/N
From: David Herrmann <dh.herrmann@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Tue, Apr 22, 2014 at 4:33 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Tue, Apr 22, 2014 at 7:17 AM, David Herrmann <dh.herrmann@gmail.com> wrote:
>> I think it's safe to assume that any object you create is never
>> world-accessible. So the worst you can get is 0600.
>
> Can you explain what you mean?  I think that it's completely *unsafe*
> to make this assumption unless you actually take some explicit action
> to make sure it's correct.

Which kernel-interface creates world-writable objects if a reasonable
umask like 022 is set?

>> So if we now take
>> your example, your patch doesn't fix the problem at all. Imagine two
>> processes, $sender and $receiver. If the receiver runs as a different
>> user as the sender, it cannot open /proc/self/fd/ writable due to
>> 0600. So the only problematic case is if both run as the same user.
>> However, in that case, the receiver can _always_ access
>> /proc/$sender/fd/ and thus still gain writable access to the object,
>> even if its own fd is read-only and your patch was applied. (ignoring
>> the fact that they can kill() and ptrace each other..)
>
> Incorrect.  That is exactly what my patch changes.

Are you sure? Note I wrote /proc/$sender/fd/ not /proc/$receiver/fd/.
The lookup on /proc/$sender/fd/ is done with the file of the _sender_,
which obviously is writable.

Thanks
David
