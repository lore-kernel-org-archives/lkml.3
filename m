Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbaJTRDG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 13:03:06 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:61755 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaJTRDC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 13:03:02 -0400
MIME-Version: 1.0
In-Reply-To: <9034CBD80F070943B59700D7F8149ED9024EB81CC6@SC-VEXCH4.marvell.com>
References: <1413775748-22478-1-git-send-email-zhangwm@marvell.com>
 <20141020044340.GA9589@kroah.com> <9034CBD80F070943B59700D7F8149ED9024EB81CAF@SC-VEXCH4.marvell.com>
 <20141020064826.GA4064@kroah.com> <9034CBD80F070943B59700D7F8149ED9024EB81CC6@SC-VEXCH4.marvell.com>
From: Dan Streetman <ddstreet@ieee.org>
Date: Mon, 20 Oct 2014 13:02:39 -0400
X-Google-Sender-Auth: 45bOJD_YHeFrktPxbl9t4fUmLkM
Message-ID: <CALZtONDEdFbx+zTWYdmz3HsfCnV+RtTPAuY4p-RK1DN3g2CwrQ@mail.gmail.com>
Subject: Re: [PATCH] drivers: base: update cpu offline info when do hotplug
To: Neil Zhang <zhangwm@marvell.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 3:40 AM, Neil Zhang <zhangwm@marvell.com> wrote:
> Greg,
>
>
> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: 2014年10月20日 14:48
> To: Neil Zhang
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] drivers: base: update cpu offline info when do hotplug
>
> On Sun, Oct 19, 2014 at 11:39:23PM -0700, Neil Zhang wrote:
>>> How much noise is this going to cause on a big/little system that
>>> constantly hot unplug/plugs processors all of the time?
>>
>> Can you explain more what kind of noise will be introduced on a big/little system?
>
> Have you tested this on such a machine?
>
> I didn't have such kind of machine on hand.
> Can anyone has such machine to verify it?
> Thanks!

I tested this on a ppc PowerVM system, using dlpar operations to
remove/add cpus.

Without this patch the cpu online nodes get out of sync with the main
online node (and the actual state of the cpus), because they aren't
updated as the cpus are brought up/down:

[root@br10p02 cpu]$ pwd
/sys/devices/system/cpu
[root@br10p02 cpu]$ cat online
0-39
[root@br10p02 cpu]$ for n in {0..47} ; do test $( cat cpu$n/online )
-eq 1 && echo -n "$n " ; done ; echo ""
0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26
27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47


While with the patch, the cpu online nodes are kept up to date as the
cpus are brought up/down:

[root@br10p02 cpu]$ pwd
/sys/devices/system/cpu
[root@br10p02 cpu]$ cat online
0-39
[root@br10p02 cpu]$ for n in {0..47} ; do test $( cat cpu$n/online )
-eq 1 && echo -n "$n " ; done ; echo ""
0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26
27 28 29 30 31 32 33 34 35 36 37 38 39


Feel free to add

Tested-by: Dan Streetman <ddstreet@ieee.org>

>
>> As I know IKS on arm will use cpu_suspend way to power down a core.
>
> Are you sure that it also doesn't use that same functionality to drop a processor to save power?
>
> As I know it use cpu_suspend to switch out a processor in IKS and there is no cpu hotplug notifier in this procedure.
>
>
> Why do you need/want this notification?  What are you going to do with this information that you don't already have?
>
> The offline won't be updated if an in kernel hotplug governor plug in / out a core which cause the sysfs interface report a wrong status.
>
>
> thanks,
>
> greg k-h
>
>
> Best Regards,
> Neil Zhang
