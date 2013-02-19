Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933073Ab3BSOzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 09:55:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932958Ab3BSOzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 09:55:22 -0500
Date: Tue, 19 Feb 2013 15:18:39 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, Ben Chan <benchan@chromium.org>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 5/5] coredump: ignore non-fatal signals when core
	dumping to a pipe
Message-ID: <20130219141839.GA5462@redhat.com>
References: <1361008406-2307-1-git-send-email-msb@chromium.org> <1361008406-2307-5-git-send-email-msb@chromium.org> <20130216171010.GE4910@redhat.com> <20130216194643.GA31569@redhat.com> <CACBanvqTmrQX2a885MjtjW02-+JE9ERBW8z1LL=aYObir+2Dwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACBanvqTmrQX2a885MjtjW02-+JE9ERBW8z1LL=aYObir+2Dwg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18, Mandeep Singh Baines wrote:
>
> On Sat, Feb 16, 2013 at 11:46 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >>
> >> Why? __fatal_signal_pending() is enough, you do not need to check
> >> ->shared_pending. And once again, ignoring the freezer problems I
> >> do not think we need this check at all.
> >>
>
> The problem is that the kill signal remains in shared pending since
> it'll never get dequeued.
>
> localhost ~ # kill -KILL $!
> localhost ~ # cat /proc/$!/status | grep -A4 SigPnd
> SigPnd: 0000000000000000
> ShdPnd: 0000000000000100
> SigBlk: 0000000000000000
> SigIgn: 0000000000000000
> SigCgt: 0000000000000000
>
> Normally a fatal signal will get propagated to the whole group but
> that doesn't happen here because GROUP_EXIT is set:

Exactly!

>From the changelog in
"[PATCH 2/3] coredump: ensure that SIGKILL always kills the dumping thread"

	even if the dumping process is single-threaded
	...
	the group-wide SIGKILL is not recorded in task->pending
	and thus __fatal_signal_pending() won't be true.

Another reason why I think we should fix the underlying problem(s)
instead of adding more hacks,

> What if complete_signal was changed to propagate KILL even if
> SIGNAL_GROUP_EXIT is set?

See above, I think we can do better. And once again, 1/3 alone should
fix this problem with the non-fatal signals.

Oleg.

