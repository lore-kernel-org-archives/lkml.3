Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760381Ab3EBRFq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 13:05:46 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:58981 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758962Ab3EBRFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 13:05:44 -0400
MIME-Version: 1.0
In-Reply-To: <20130502124826.GE22618@amd.pavel.ucw.cz>
References: <1367271946-7239-1-git-send-email-ccross@android.com>
	<1367271946-7239-4-git-send-email-ccross@android.com>
	<20130502124826.GE22618@amd.pavel.ucw.cz>
Date: Thu, 2 May 2013 10:05:43 -0700
X-Google-Sender-Auth: 9VZEvJlqEOU8I2yHn_-nksoSFJg
Message-ID: <CAMbhsRRhcM=59xVgitYPyY-rzJTjV1mgwwusOzqFUqT2=__JDg@mail.gmail.com>
Subject: Re: [PATCH 03/10] freezer: add new freezable helpers using freezer_do_not_count()
From: Colin Cross <ccross@android.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Len Brown <len.brown@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 2, 2013 at 5:48 AM, Pavel Machek <pavel@ucw.cz> wrote:
> On Mon 2013-04-29 14:45:39, Colin Cross wrote:
>> Freezing tasks will wake up almost every userspace task from
>> where it is blocking and force it to run until it hits a
>> call to try_to_sleep(), generally on the exit path from the syscall
>> it is blocking in.  On resume each task will run again, usually
>> restarting the syscall and running until it hits the same
>> blocking call as it was originally blocked in.
>
> Ok, so you are optimizing suspend at the cost of runtime operations,
> right?
The runtime operations are negligible, it is setting a bit before
blocking, and then clearing the bit and checking a single global
counter as the fast-path after blocking.  Both will be lost in the
noise of the context switch that is happening.

> Would it make sense to do suspends entirely without freezer in your
> configurations? With the right drivers, it should work ok.

No, we need userspace tasks to freeze.  That is one of the main
reasons we go to suspend, to prevent recurring timers from firing.

> Actually, would it make sense to simply enter deep idle and do runtime
> powersaving in the drivers... n900 does that rather successfully and
> it is certainly cleaner design.

It depends on the SoC if that is even possible, and if we did do it we
would still use cgroup freezers to prevent apps from running and
eating the battery so this patch would still be applicable.

>> +/* Like schedule_timeout(), but should not block the freezer. */
>> +#define freezable_schedule_timeout(timeout)                          \
>> +({                                                                   \
>> +     long __retval;                                                  \
>> +     freezer_do_not_count();                                         \
>> +     __retval = schedule_timeout(timeout);                           \
>> +     freezer_count();                                                \
>> +     __retval;                                                       \
>> +})
>
> You plan to use this a lot during normal operation, right? Is it going
> to have some measureable impact?

It has a very measurable impact on suspend/resume operations (reducing
freeze time by a factor of 10, reducing context switches from 1000 to
25).  I haven't measured the impact on total energy used for a
suspend/resume cycle, but based on previous measurements I expect it
to be beneficial.

> Also, why not static inline?

I copied the style of the existing helpers.  I can change them all to
static inlines if you prefer.
