Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbaFYLEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 07:04:43 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:58127 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbaFYLEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 07:04:42 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1406251200051.15939@pobox.suse.cz>
References: <20140619213329.478113470@goodmis.org>
	<alpine.LNX.2.00.1406192349400.15014@pobox.suse.cz>
	<20140619185810.4137e14b@gandalf.local.home>
	<alpine.LNX.2.00.1406200100520.15014@pobox.suse.cz>
	<20140619191923.1365850a@gandalf.local.home>
	<alpine.LNX.2.00.1406200123220.15014@pobox.suse.cz>
	<20140619193635.1949b469@gandalf.local.home>
	<alpine.LNX.2.00.1406200137310.15014@pobox.suse.cz>
	<20140620143525.GB8769@pathway.suse.cz>
	<CALYGNiM3OH64ULh63cCarTitbjUatZP0mckJ3N9CDusP3mFMRg@mail.gmail.com>
	<alpine.LNX.2.00.1406251200051.15939@pobox.suse.cz>
Date: Wed, 25 Jun 2014 15:04:41 +0400
Message-ID: <CALYGNiOT9XkiE1Q=AimOt42UkQ430Qy89cseNLVaMf96O9=FJw@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/3] x86/nmi: Print all cpu stacks from NMI safely
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: =?UTF-8?B?UGV0ciBNbMOhZGVr?= <pmladek@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 2:01 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Tue, 24 Jun 2014, Konstantin Khlebnikov wrote:
>
>> Originally I thought that seizing all cpus one by one and printing from
>> the initiator is a best approach and I've started preparing arguments
>> against over-engineered printk...
>
> By "seizing" I guess you mean sending IPI, right?
>
> What do you do if you'd interrupt it in the middle of printk() in order
> not to deadlock by trying to take the buffer lock on the initiator CPU?

Yep, under "seize" I mean NMI IPI which gathering state of registers from cpu.
Also it can keep cpu in nmi handler while initiator cpu unwinds its stack trace.
Code of dump-all-stack in arch/sparc does something like that.

You're right, moving printk from one cpu to another doesn't fixes recursion,
but we could send NMI IPI under logbuf_lock. I don't think that this is good
approach, but it seems realistic. Of course all printing from other NMI
handlers must be done in some weird way.


I like that context-depend printk routing from this patchset.
I'm just not quite happy with this straight forward implementation.
Rerouting flow into different buffers might serve different purposes,
it must make code simpler instead of adding yet another knot.
For example printk continuation might use it too.

>
> --
> Jiri Kosina
> SUSE Labs
