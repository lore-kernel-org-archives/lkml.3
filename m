Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbaDVShd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 14:37:33 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:62624 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855AbaDVSh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 14:37:29 -0400
MIME-Version: 1.0
In-Reply-To: <20140422111143.74a426009ee37027c948aebc@linux-foundation.org>
References: <1397780183-24633-1-git-send-email-keescook@chromium.org>
	<1397780183-24633-4-git-send-email-keescook@chromium.org>
	<20140421154505.eef405f0a23e2ff8a1c7536e@linux-foundation.org>
	<CAGXu5jLBJynt81Y0HqWkPzFpa6ToR4SZk2ZLLjS3SPNNczTXNw@mail.gmail.com>
	<20140422111143.74a426009ee37027c948aebc@linux-foundation.org>
Date: Tue, 22 Apr 2014 11:37:28 -0700
X-Google-Sender-Auth: tLZLSNzHl5AYGJ-uny7WUVANEBQ
Message-ID: <CAGXu5jJ=YKN6--tvSibmX_UUwUP0LDzkk-YZ=fR_Khgb2JRdWQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] sysctl: allow for strict write position handling
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Li Zefan <lizefan@huawei.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Aaron Tomlin <atomlin@redhat.com>, Dario Faggioli <raistlin@linux.it>,
        Andrew Shewmaker <agshew@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        Jens Axboe <axboe@fb.com>, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        Michael Ellerman <michael@ellerman.id.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 11:11 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 21 Apr 2014 21:52:48 -0700 Kees Cook <keescook@chromium.org> wrote:
>
>> >> This provides CONFIG_PROC_SYSCTL_STRICT_WRITES as a way to make this
>> >> behavior act in a less surprising manner for strings, and disallows
>> >> non-zero file position when writing numeric sysctls (similar to what is
>> >> already done when reading from non-zero file positions).
>> >
>> > Adding a Kconfig knob to alter the behavior of procfs writes creeps me
>> > out.  I wonder why.
>> >
>> > - I doubt if many people have a sufficient amount of control over
>> >   their entire systems to be able to confidently set
>> >   CONFIG_PROC_SYSCTL_STRICT_WRITES.
>> >
>> > - Software will be shipped which runs OK with one setting but breaks
>> >   with the other setting.
>> >
>> > So what to do?
>> >
>> > I think we can *detect* this situation easily enough.  So some options are
>> >
>> > a) change the behaviour and add code which detects when userspace is
>> >    doing a write whose behaviour is now altered.  Print a warning.   Or
>> >
>> > b) leave the behaviour as-is.  Add a detector which tells people
>> >    "hey, your userspace is probably broken - please fix".  Wait N
>> >    years.  Then alter the behaviour as in a).
>> >
>> > In either case the detector should display current->comm, the procfs
>> > pathname and the contents of the write, to aid people in hunting down
>> > and fixing their userspace.
>>
>> How about a tri-state sysctl (har har control sysctl behavior with a
>> sysctl) that defaults ("1") to existing behavior (to not break
>> anything) with a warning. Mode "2" uses new behavior, and mode "0"
>> uses existing behavior without a warning? Then we can wait N years and
>> switch the default to "2"?
>
> Yes, I suppose that's more flexible.
>
> I do have my doubts about whether we'll ever be able to change the
> behaviour.  There will be soooo many random proc-pokers out there and
> the amount of dusty-deck software will only increase over time.

Yeah. Though at least in all the configurations I've tested, this
doesn't produce any hits:
$ sudo lsof -n | grep /proc/sys

It's by no means a definitive survey, but at least the trivial cases
aren't a problem.

> I suppose the first thing to do is to get the warning in there and see
> if we can get an understanding of how much code is likely to be
> affected by the change.  Add "please email Kees" to the printk ;) I did
> that once, many years ago.  I got a lot of email.  Didn't do it again.

Yeah, I was figuring putting the new sysctl knob name in the printk
would be more educational and less inbox-filling. :)

-Kees

-- 
Kees Cook
Chrome OS Security
