Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbaDPEUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 00:20:40 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:54242 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396AbaDPEUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 00:20:37 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1404152042480.22697@ionos.tec.linutronix.de>
References: <cover.1397537986.git.viresh.kumar@linaro.org>
	<80afb18a494b0bd9710975bcc4de134ae323c74f.1397537987.git.viresh.kumar@linaro.org>
	<alpine.DEB.2.02.1404152042480.22697@ionos.tec.linutronix.de>
Date: Wed, 16 Apr 2014 09:50:36 +0530
Message-ID: <CAKohponkb+FovSTLuQ0cxEdVMU7JTHYPauhU07=20otAoDiAZA@mail.gmail.com>
Subject: Re: [PATCH V1 Resend 4/5] tick-sched: don't call update_wall_time()
 when delta is lesser than tick_period
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>,
        Linaro Networking <linaro-networking@linaro.org>,
        John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 April 2014 00:14, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 15 Apr 2014, Viresh Kumar wrote:
>
>> In tick_do_update_jiffies64() we are processing ticks only if delta is greater
>> than tick_period. This is what we are supposed to do here and it broke a bit
>> with this patch:
>>
>> commit 47a1b796306356f358e515149d86baf0cc6bf007
>> Author: John Stultz <john.stultz@linaro.org>
>> Date:   Thu Dec 12 13:10:55 2013 -0800
>>
>>     tick/timekeeping: Call update_wall_time outside the jiffies lock
>
> Please look how I massaged the change log. There is no point in
> copying the whole gunk.

I see.. Nice.

>> With above patch, we might end up calling update_wall_time() even if delta is
>> found to be smaller that tick_period. Fix this by reversing the check and
>> returning early.
>
> Well.
>
>> Cc: <stable@vger.kernel.org> # v3.14+
>> Cc: John Stultz <john.stultz@linaro.org>
>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>> ---
>>  kernel/time/tick-sched.c | 32 +++++++++++++++++---------------
>>  1 file changed, 17 insertions(+), 15 deletions(-)
>
> That's not how we do bug fixes if they can be done with 3 lines of
> change. See the commit.

I tried that initially but with these changes as well (which must
be done now ??), which probably makes it more clear ?:

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 3cafe7d..0e70b1c 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -84,12 +84,12 @@ static void tick_do_update_jiffies64(ktime_t now)

                /* Keep the tick_next_period variable up to date */
                tick_next_period = ktime_add(last_jiffies_update, tick_period);
+
+               write_sequnlock(&jiffies_lock);
+               update_wall_time();
        } else {
                write_sequnlock(&jiffies_lock);
-               return;
        }
-       write_sequnlock(&jiffies_lock);
-       update_wall_time();
 }

 /*
