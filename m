Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab3KCIgs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 03:36:48 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:49904 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab3KCIgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 03:36:47 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFxeGaZjWM37e4p1tAhjwocpv0_iU0jTYUfaAFagvCBxmQ@mail.gmail.com>
References: <1383427599-1980-1-git-send-email-minipli@googlemail.com>
	<1383427599-1980-2-git-send-email-minipli@googlemail.com>
	<CA+55aFxeGaZjWM37e4p1tAhjwocpv0_iU0jTYUfaAFagvCBxmQ@mail.gmail.com>
Date: Sun, 3 Nov 2013 09:36:45 +0100
Message-ID: <CA+rthh8YB7vKKr1mJrx+1L+TcVMyfbN=yBL3xnTZt2xNcoFL5Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] ipc, msg: fix message length check for negative values
From: Mathias Krause <minipli@googlemail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Pax Team <pageexec@freemail.hu>,
        Brad Spengler <spender@grsecurity.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 November 2013 01:35, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Sat, Nov 2, 2013 at 2:26 PM, Mathias Krause <minipli@googlemail.com> wrote:
>> On 64 bit systems the test for negative message sizes is bogus as the
>> size, which may be positive when evaluated as a long, will get truncated
>> to an int when passed to load_msg().
>
> Quite frankly, wouldn't it be much nicer to just fix "load_msg()" instead?

I thought of that too, but declined it as I thought it would require
much more changes then my simple patch does. As we cannot change the
underlying structures for msgctl(MSG_INFO/IPC_INFO), msg_ctlmax still
needs to fit into an int. But, for sure, we can still limit the user
visible range albeit handling msg_ctlmax internally as an unsigned
type.

> Using "size_t" also gets rid of the games we play with DATALEN_MSG/SEG.
>
> IOW, something like the attached..

Looking at your patch, it looks like my concerns are invalid. I'll
check it out and do a respin of the series later the day.

> Of course, we *also* should fix ns->msg_ctlmax to make clear you can't
> use negative numbers there. No question about that.

Agreed.

> I think it would
> be better to even avoid INT_MAX, because there are memory use concerns
> and CPU usage ones too (we generate that list of
> smaller-than-page-size fragments).

I'm uncertain about that one as changing the sysctl requires having
UID 0. So one needs to be privileged to be able to trigger the OOM
situation. Also, there might be userland out there trying to send big
messages -- I don't know. Are we willing to break them? What would be
a sensible maximum value for msgmax -- 16 MiB (8 KiB is the current
default)? Also, should we limit msgmnb and msgmni too then? Otherwise
one could just create multiple queues (in multiple namespaces) and
queue multiple messages to park a lot of memory this way. Or, one just
ignores this OOM situation and relies on the fact the root won't raise
the sysctls to insane values. What do you think?


Mathias
