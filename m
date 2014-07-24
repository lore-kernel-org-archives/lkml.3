Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700AbaGXLSI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 07:18:08 -0400
Received: from mx6-phx2.redhat.com ([209.132.183.39]:41307 "EHLO
	mx6-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbaGXLSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 07:18:06 -0400
Date: Thu, 24 Jul 2014 07:18:05 -0400 (EDT)
From: Ulrich Obergfell <uobergfe@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, dzickus@redhat.com, akpm@linux-foundation.org,
        mingo@redhat.com
Message-ID: <1140033921.17233579.1406200685037.JavaMail.zimbra@redhat.com>
In-Reply-To: <53D0E3F3.6050206@redhat.com>
References: <1406196811-5384-1-git-send-email-drjones@redhat.com> <1406196811-5384-3-git-send-email-drjones@redhat.com> <53D0E3F3.6050206@redhat.com>
Subject: Re: [PATCH 2/3] watchdog: control hard lockup detection default
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.7]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - FF22 (Linux)/8.0.6_GA_5922)
Thread-Topic: watchdog: control hard lockup detection default
Thread-Index: HiZCwsNMPv2nFG98L0gT5mCO8QG/PA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ----- Original Message -----
> From: "Paolo Bonzini" <pbonzini@redhat.com>
> To: "Andrew Jones" <drjones@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
> Cc: uobergfe@redhat.com, dzickus@redhat.com, akpm@linux-foundation.org, mingo@redhat.com
> Sent: Thursday, July 24, 2014 12:46:11 PM
> Subject: Re: [PATCH 2/3] watchdog: control hard lockup detection default
>
>Il 24/07/2014 12:13, Andrew Jones ha scritto:
>> 
>> The running kernel still has the ability to enable/disable at any
>> time with /proc/sys/kernel/nmi_watchdog us usual. However even
>> when the default has been overridden /proc/sys/kernel/nmi_watchdog
>> will initially show '1'. To truly turn it on one must disable/enable
>> it, i.e.
>>   echo 0 > /proc/sys/kernel/nmi_watchdog
>>   echo 1 > /proc/sys/kernel/nmi_watchdog
>
> Why is it hard to make this show the right value? :)
>
> Paolo

'echo 1 > /proc/sys/kernel/nmi_watchdog' enables both - hard lockup and
soft lockup detection. watchdog_enable_all_cpus() starts a 'watchdog/N'
thread for each CPU. If the kernel runs on a bare metal system where the
processor does not have a PMU, or when perf_event_create_kernel_counter()
returns failure to watchdog_nmi_enable(), or when the kernel runs as a
guest on a hypervisor that does not emulate a PMU, then the 'watchdog/N'
threads are still active for soft lockup detection. Patch 2/3 essentially
makes watchdog_nmi_enable() behave in the same way as if -ENOENT would
have been returned by perf_event_create_kernel_counter(). This is then
reported via a console message.

  NMI watchdog: disabled (cpu0): hardware events not enabled

It's hard say what _is_ 'the right value' (because lockup detection is
then enabled 'partially'), regardless of whether patch 2/3 is applied
or not.

Regards,

Uli
