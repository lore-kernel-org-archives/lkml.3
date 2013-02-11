Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238Ab3BKR0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 12:26:18 -0500
Received: from mail-ia0-f181.google.com ([209.85.210.181]:38506 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757888Ab3BKR0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 12:26:15 -0500
MIME-Version: 1.0
In-Reply-To: <511905D7.3040209@parallels.com>
References: <1358849741-9611-4-git-send-email-avagin@openvz.org>
 <20130208191056.GA13674@redhat.com> <CAKgNAki0xt_wwixp7kdv04fKOCtCh-ObQjkFE9PiX6FapkO34A@mail.gmail.com>
 <201302111029.50998.vda.linux@googlemail.com> <20130211105941.GA26717@paralelels.com>
 <CAK1hOcMepaOD80GOvUv1xz3xibTG_iKMK-w7698K6KfRmcKGeA@mail.gmail.com> <511905D7.3040209@parallels.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Mon, 11 Feb 2013 18:25:54 +0100
Message-ID: <CAK1hOcNOYRWwrwZEpVza1CTSL_mHEj-Ur577QRnBNkOmdb=Bdw@mail.gmail.com>
Subject: Re: [CRIU] [PATCH 3/3] signalfd: add ability to read siginfo-s
 without dequeuing signals (v2)
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Andrew Vagin <avagin@parallels.com>, mtk.manpages@gmail.com,
        David Howells <dhowells@redhat.com>, linux-api@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        criu@openvz.org, Cyrill Gorcunov <gorcunov@openvz.org>,
        Andrey Wagin <avagin@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Dave Jones <davej@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 3:53 PM, Pavel Emelyanov <xemul@parallels.com> wrote:
> On 02/11/2013 06:46 PM, Denys Vlasenko wrote:
>> On Mon, Feb 11, 2013 at 11:59 AM, Andrew Vagin <avagin@parallels.com> wrote:
>>>>> I suppose I had wondered along similar lines, but in a slightly
>>>>> different direction: would the use of a /proc interface to get the
>>>>> queued signals make some sense?
>>>>
>>>> I think that /proc interface beats adding magic flags and magic semantic
>>>> to [p]read.
>>>>
>>>> It also has the benefit of being human-readable. You don't need
>>>> to write a special C program to "cat /proc/$$/foo".
>>>>
>>>> Andrey, I know that it is hard to let go of the code you invested time
>>>> and efforts in creating. But this isn't the last patch, is it?
>>>> You will need to retrieve yet more data for process checkpointing.
>>>> When you start working on the next patch for it, consider trying
>>>> /proc approach.
>>>
>>> I don't think that we need to convert siginfo into a human readable format
>>> in kernel.
>>
>> My point is that bolting hacks onto various bits of kernel API
>> in order to support process checkpointing makes those APIs
>> (their in-kernel implementation) ridden with special cases
>> and harder to support in the future.
>>
>> Process checkpointing needs to bite the bullet and
>> create its own API instead.
>
> This is bad approach as well. What we should do is come up with a sane
> API that makes sense without the checkpoint-restore project _when_ _possible_.

Coming up with a sane API in general isn't easy.

Consider numerous blunders enshrined in the Unix API,
such as O_NONBLOCK being a file's flag instead of being
a flag of read(), or waitpid, or sigwait,
(had to be fds which one can feed to select/poll)...

If you have your own playground in /proc/PID/foo,
you can mature your API without touching many other areas
of kernel, and without making mistakes permanent.
Later, when other people are interested, they can factor out
your code.


You are planning to use signalfd to extract pending signals
from the process being checkpointed.

This must be a quite convoluted method already, since you
need to create a signalfd and then read from it *in the context
of the process you are checkpointing*.

I presume you are ptrace-attaching to the process and then
play games with setting registers and injecting syscalls.
This does not look particularly sane to me, I'm afraid.

Compared to this, ptrace-attaching to the process
and then reading from /proc or issuing a new ptrace request
looks much cleaner. My opinion, of course.

-- 
vda
