Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbaHRKoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 06:44:46 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:50799 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaHRKoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 06:44:44 -0400
Date: Mon, 18 Aug 2014 06:44:41 -0400 (EDT)
From: Ulrich Obergfell <uobergfe@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Don Zickus <dzickus@redhat.com>, akpm@linux-foundation.org,
        kvm@vger.kernel.org, pbonzini@redhat.com, mingo@redhat.com,
        LKML <linux-kernel@vger.kernel.org>, Andrew Jones <drjones@redhat.com>
Message-ID: <949451551.32876011.1408358681791.JavaMail.zimbra@redhat.com>
In-Reply-To: <20140818091644.GE25495@gmail.com>
References: <1407768567-171794-1-git-send-email-dzickus@redhat.com> <1407768567-171794-5-git-send-email-dzickus@redhat.com> <20140818091644.GE25495@gmail.com>
Subject: Re: [PATCH 4/5] watchdog: control hard lockup detection default
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.7]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - FF22 (Linux)/8.0.6_GA_5922)
Thread-Topic: watchdog: control hard lockup detection default
Thread-Index: 7BJhTpLvqVn4q1q1P+mTvhJdMAC3+g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>----- Original Message -----
>From: "Ingo Molnar" <mingo@kernel.org>
>To: "Don Zickus" <dzickus@redhat.com>
>Cc: akpm@linux-foundation.org, kvm@vger.kernel.org, pbonzini@redhat.com, mingo@redhat.com, "LKML" <linux-kernel@vger.kernel.org>, "Ulrich >Obergfell" <uobergfe@redhat.com>, "Andrew Jones" <drjones@redhat.com>
>Sent: Monday, August 18, 2014 11:16:44 AM
>Subject: Re: [PATCH 4/5] watchdog: control hard lockup detection default
>
>
> * Don Zickus <dzickus@redhat.com> wrote:
>
>> The running kernel still has the ability to enable/disable at any
>> time with /proc/sys/kernel/nmi_watchdog us usual. However even
>> when the default has been overridden /proc/sys/kernel/nmi_watchdog
>> will initially show '1'. To truly turn it on one must disable/enable
>> it, i.e.
>>   echo 0 > /proc/sys/kernel/nmi_watchdog
>>   echo 1 > /proc/sys/kernel/nmi_watchdog
>
> This looks like a bug, why is this so?
>
> Thanks,
>
>	Ingo


This is because the hard lockup detector and the soft lockup detector are
enabled and disabled at the same time - there isn't a separate 'knob' for
each of them. Both are controlled via the 'watchdog_user_enabled' variable
which is 1 by default.

  lockup_detector_init
    if (watchdog_user_enabled)
        watchdog_enable_all_cpus
          smpboot_register_percpu_thread(&watchdog_threads)

At boot time, the above code path lauches a 'watchdog/N' thread for each
online CPU. The watchdog_enable() function is executed in the context of
these threads, and this attempts to enable the hard lockup detector and
the soft lockup detector. [Note: Soft lockup detection is implemented in
watchdog_timer_fn().]

  watchdog_enable
    hrtimer_init(hrtimer, ...)
    hrtimer->function = watchdog_timer_fn

    watchdog_nmi_enable
      perf_event_create_kernel_counter(..., watchdog_overflow_callback)

    hrtimer_start(hrtimer, ...)

On bare metal systems or in virtual environments where the hypervisor
does not emulate a PMU, watchdog_nmi_enable() can fail to allocate and
enable a PMU counter. This is reported by a console message:

  NMI watchdog: disabled (cpu0): hardware events not enabled

Hence, we can end up with a situation where the soft lockup detector is
enabled and the hard lockup detector is not enabled. However, the output
of 'cat /proc/sys/kernel/nmi_watchdog' is 1 because it merely shows the
state of the 'watchdog_user_enabled' variable.

The above is the behaviour even without the proposed patch. The patch
merely adds the following hunk in watchdog_nmi_enable() to 'fake' a
-ENOENT error return from perf_event_create_kernel_counter().

  +        if (!watchdog_hardlockup_detector_is_enabled()) {
  +                event = ERR_PTR(-ENOENT);
  +                goto handle_err;
  +        }

The patch does not break the output of 'cat /proc/sys/kernel/nmi_watchdog'
since the discrepancy between the output and the actual state of the hard
lockup detector is nothing new.


Regards,

Uli
