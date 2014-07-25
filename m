Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759989AbaGYIc7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 04:32:59 -0400
Received: from mx6-phx2.redhat.com ([209.132.183.39]:37689 "EHLO
	mx6-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756912AbaGYIc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 04:32:57 -0400
Date: Fri, 25 Jul 2014 04:32:55 -0400 (EDT)
From: Ulrich Obergfell <uobergfe@redhat.com>
To: Andrew Jones <drjones@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, dzickus@redhat.com,
        pbonzini@redhat.com, akpm@linux-foundation.org, mingo@redhat.com
Message-ID: <615371508.17867577.1406277175913.JavaMail.zimbra@redhat.com>
In-Reply-To: <1406196811-5384-3-git-send-email-drjones@redhat.com>
References: <1406196811-5384-1-git-send-email-drjones@redhat.com> <1406196811-5384-3-git-send-email-drjones@redhat.com>
Subject: Re: [PATCH 2/3] watchdog: control hard lockup detection default
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.6]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - FF22 (Linux)/8.0.6_GA_5922)
Thread-Topic: watchdog: control hard lockup detection default
Thread-Index: hTUQI6rttOPP3UePAETJtlpDtd5W8w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ----- Original Message -----
> From: "Andrew Jones" <drjones@redhat.com>
> To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
> Cc: uobergfe@redhat.com, dzickus@redhat.com, pbonzini@redhat.com, akpm@linux-foundation.org, mingo@redhat.com
> Sent: Thursday, July 24, 2014 12:13:30 PM
> Subject: [PATCH 2/3] watchdog: control hard lockup detection default

[...]

> The running kernel still has the ability to enable/disable at any
> time with /proc/sys/kernel/nmi_watchdog us usual. However even
> when the default has been overridden /proc/sys/kernel/nmi_watchdog
> will initially show '1'. To truly turn it on one must disable/enable
> it, i.e.
>   echo 0 > /proc/sys/kernel/nmi_watchdog
>   echo 1 > /proc/sys/kernel/nmi_watchdog

[...]

> @@ -626,15 +665,17 @@ int proc_dowatchdog(struct ctl_table *table, int write,
>          * disabled. The 'watchdog_running' variable check in
>          * watchdog_*_all_cpus() function takes care of this.
>          */
> -        if (watchdog_user_enabled && watchdog_thresh)
> +        if (watchdog_user_enabled && watchdog_thresh) {
> +                watchdog_enable_hardlockup_detector(true);
>                  err = watchdog_enable_all_cpus(old_thresh != watchdog_thresh);
> -        else
> +        } else

[...]


I just realized a possible issue in the above part of the patch:

If we would want to give the user the option to override the effect of patch 3/3
via /proc, I think proc_dowatchdog() should enable hard lockup detection _only_
in case of a state transition from 'NOT watchdog_running' to 'watchdog_running'.
                                                          |
   if (watchdog_user_enabled && watchdog_thresh) {        | need to add this
       if (!watchdog_running) <---------------------------'
           watchdog_enable_hardlockup_detector(true);
       err = watchdog_enable_all_cpus(old_thresh != watchdog_thresh);
   } else
       ...

The additional 'if (!watchdog_running)' would _require_ the user to perform the
sequence of commands

   echo 0 > /proc/sys/kernel/nmi_watchdog
   echo 1 > /proc/sys/kernel/nmi_watchdog

to enable hard lockup detection explicitly.

I think changing the 'watchdog_thresh' while 'watchdog_running' is true should
_not_ enable hard lockup detection as a side-effect, because a user may have a
'sysctl.conf' entry such as

   kernel.watchdog_thresh = ...

or may only want to change the 'watchdog_thresh' on the fly.

I think the following flow of execution could cause such undesired side-effect.

   proc_dowatchdog
     if (watchdog_user_enabled && watchdog_thresh) {

         watchdog_enable_hardlockup_detector
           hardlockup_detector_enabled = true

         watchdog_enable_all_cpus
           if (!watchdog_running) {
               ...
           } else if (sample_period_changed)
                      update_timers_all_cpus
                        for_each_online_cpu
                            update_timers
                              watchdog_nmi_disable
                              ...
                              watchdog_nmi_enable

                                watchdog_hardlockup_detector_is_enabled
                                  return true

                                enable perf counter for hard lockup detection

Regards,

Uli
