Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab3FKLAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 07:00:52 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:56399 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505Ab3FKLAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 07:00:50 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20130611104800.GA29395@mithrandir>
References: <1368791388-31441-1-git-send-email-amerilainen@nvidia.com>
	<1368791388-31441-3-git-send-email-amerilainen@nvidia.com>
	<20130526101243.GB1652@mithrandir>
	<51A30372.6080907@nvidia.com>
	<20130528103927.GB11547@mithrandir>
	<86y5ay6hrn.fsf@miki.keithp.com>
	<20130611104800.GA29395@mithrandir>
Date: Tue, 11 Jun 2013 13:00:50 +0200
X-Google-Sender-Auth: RPOVWxwUd_Y9Du_G9DudSIVaZaA
Message-ID: <CAKMK7uF=A9zZ3VgdwzU3gfOjXaYsCqfCUSPmkLdL98nKX94jFQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] gpu: host1x: Fix syncpoint wait return value
From: Daniel Vetter <daniel@ffwll.ch>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Keith Packard <keithp@keithp.com>, Terje Bergstrom <tbergstrom@nvidia.com>,
        "X.Org development" <xorg-devel@lists.x.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 12:48 PM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Tue, May 28, 2013 at 01:12:12PM -0600, Keith Packard wrote:
>> Thierry Reding <thierry.reding@gmail.com> writes:
>>
>>
>> > That doesn't sound right. Maybe drmIoctl() needs fixing instead. Looking
>> > at the history, drmIoctl() was introduced to automatically loop if a
>> > signal was received (commit 8b9ab108ec1f2ba2b503f713769c4946849b3cb2).
>> > However the ioctl(3p) manpage doesn't mention that ioctl() returns
>> > EAGAIN in case it is interrupted by a signal.
>>
>> EAGAIN is being returned when the GPU is wedged to ask the application
>> to re-submit the request, which will presumably be held until the  GPU
>> is un-wedged.
>
> Isn't that a bit risky? What if something special needs to be done to
> unwedge the GPU other than re-submit the request, or if it just can't
> be reasonably unwedged. In that case drmIoctl() will keep looping
> indefinitely.
>
> If the above is indeed the expected behaviour for drivers, then we need
> a different error code for the SYNCPT_WAIT ioctl. EAGAIN is the best fit
> and anything else doesn't quite match the use-case. A different option
> might be not to use drmIoctl() on Tegra.

We don't use the EAGAIN ioctl restarting to resubmit the batchbuffer
which blew up the gpu (that one has been submitted already in a
different ioctl call), but to be able to restart the ioctl after the
reset has completed: We need to kick every thread which is potentially
holding GEM locks and make sure that we block them (at a point where
they don't hold any locks) until the reset handler completed. To avoid
a validation nightmare we use the same codepaths as we use for signal
interrupts, so ioctl restarting is a very natural fit for this.

Resubmitting victim workloads when a gpu crash happened is something
the reset handler would do (kernel work item currently), not any
userspace process doing an ioctl. But atm we don't resubmit victimized
workloads.
-Daniel
--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
