Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529Ab3BPBUI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 20:20:08 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:35521 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab3BPBUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 20:20:06 -0500
MIME-Version: 1.0
In-Reply-To: <20130215150117.GB30829@redhat.com>
References: <1360885096-21207-1-git-send-email-msb@chromium.org>
	<1360885096-21207-5-git-send-email-msb@chromium.org>
	<20130215150117.GB30829@redhat.com>
Date: Fri, 15 Feb 2013 17:20:04 -0800
X-Google-Sender-Auth: EOQ0FlNyRvF0FIZi5eshflR23S4
Message-ID: <CACBanvrdpJ=MZGgF1-562pJ4_7ZLFY5w83ZnY-NaS6E+AgyVPg@mail.gmail.com>
Subject: Re: [PATCH 5/5] coredump: abort core dump piping only due to a fatal signal
From: Mandeep Singh Baines <msb@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ben Chan <benchan@chromium.org>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 7:01 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 02/14, Mandeep Singh Baines wrote:
>>
>> This patch makes wait_for_dump_helpers() not to abort piping the core
>> dump data when the crashing process has received any but a fatal signal
>> (SIGKILL). The rationale is that a crashing process may still receive
>> uninteresting signals such as SIGCHLD when its core dump data is being
>> redirected to a helper application.
>
> You already sent this change in the past ;) and I already reviewed it.
>
> It is not enough and imho not good. Damn, I'll try very much to make the
> patches on weekend...
>
>> -     while ((pipe->readers > 1) && (!signal_pending(current))) {
>> +     while ((pipe->readers > 1) && (!fatal_signal_pending(current))) {
>
> This turns pipe_wait() belowe into the busy-wait loop if signal_pending().

D'oh. Thanks for catching that.

Fixed in v3 by blocking non-fatal signals.

> Not good. And not enough, there are other reasons why coredump can fail
> if the signal is pending.

What other reasons did you have in mind?

Since applying an earlier version of this patch, truncated/missing
coredumps are no longer any issue for us.

Maybe it could fail in binfmt->core_dump().

Could the other reasons be addressed in another patch?

>
>>               wake_up_interruptible_sync(&pipe->wait);
>>               kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
>>               pipe_wait(pipe);
>> +             pipe_unlock(pipe);
>> +             try_to_freeze();
>
> Oh, yes. One of the problems with coredump/signals is freezer. Not sure
> what should we do...
>
> But if we add try_to_freeze() here, we need to add more try_to_freeze's,
> think about dumping the huge core on the slow media.
>

We could add more try_to_freeze()s in the dump_write paths to work
even better with freezer. Do you see any issues with just adding it
here for a start. It fixes the non-slow media case.

Thanks much for reviewing this patch.

Regards,
Mandeep

> Oleg.
>
