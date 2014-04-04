Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbaDDWvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 18:51:09 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:60178 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbaDDWvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 18:51:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140404201750.GA10275@thunk.org>
References: <CA+55aFw7NyryF3F3x05rLjt6rFwD5xUoZB06CV2mpwwRxcVHxg@mail.gmail.com>
	<alpine.LNX.2.00.1404030145490.32122@pobox.suse.cz>
	<CA+55aFzo85-sdC_eDVRWcCdsK2p1JxCjswYidq-QSi5RieGmBA@mail.gmail.com>
	<CA+55aFyphF8kd4OwWdar4p5M1=Sxc54sfk0RWFPpO6zrezZwJA@mail.gmail.com>
	<20140403104308.GP13491@8bytes.org>
	<20140403170541.GA19010@thunk.org>
	<533EF832.1030902@mit.edu>
	<CA+55aFz=rnGo_DvtYa4aonm_JUyWe5cynLcsCYDfr+jMZ91+Sg@mail.gmail.com>
	<20140404115139.3ea3d53126094f41bc0579a0@linux-foundation.org>
	<20140404154426.6f099f7d@gandalf.local.home>
	<20140404201750.GA10275@thunk.org>
Date: Fri, 4 Apr 2014 15:45:08 -0700
Message-ID: <CAADnVQ+TZzmSpXcL7YTNGauWs4dYmNyS=sNYCYGAJbim04w9hA@mail.gmail.com>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>, Joerg Roedel <joro@8bytes.org>,
        Jiri Kosina <jkosina@suse.cz>, Mateusz Guzik <mguzik@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Kay Sievers <kay@vrfy.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 4, 2014 at 1:17 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Fri, Apr 04, 2014 at 03:44:26PM -0400, Steven Rostedt wrote:
>> I saw one commenter say that this was a kernel bug because writing to
>> kmsg shouldn't cause the system to hang.
>>
>> The rate-limit patch would go along with that idea, and I honestly
>> think it would be good to rate-limit it in case something else breaks
>> and starts spamming kmsg.
>
> I agree; the only question is what is the appropriate rate limits,
> which is the question Linus was asking.
>
> Personally, I like keeping the current limits (no more than ten
> messages every 5 seconds) because I don't think dmesg, which is a
> circular buffer and deliberately kept simple so that printk is
> guaranteed to work even when things go really bad (and if things do go
> really bad, there are ways of reading dmesg out from a crash dump, for
> example, so we want to keep things simple).
>
> Peter has argued that it might be cool if the Kernel had a
> purpose-built in-kernel syslogd sort of interface, that could accept
> arbitrarily large amounts of data, and presumably it would allocate
> memory as needed, and since the kernel knows this is log data, if we
> are under memory pressure, it could release some of the log data, even
> if the userspace hasn't picked it up yet, under extreme memory
> pressure.
>
> I don't know that it makes sense to do this, since IMHO we can just as
> easily do this in a user-space process.
>
> But I *do* think we should keep the facility used by printk to be as
> simple and as bulletproof as possible, which means we should really
> try to keep users of /dev/kmesg to the simple "I'm starting test
> <foo>", or similar messages.  And that argues for using things like
> the current ratelimit defaults.

can there be two bulletproof buffers: one for in kernel printk
and another ratelimited one for writes into /dev/kmsg.
On the read from /dev/kmsg they're combined by time.
