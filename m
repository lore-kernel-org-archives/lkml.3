Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab3FLLAf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 07:00:35 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:55295 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3FLLAe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 07:00:34 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <51B84D4E.30703@nvidia.com>
References: <1368791388-31441-1-git-send-email-amerilainen@nvidia.com>
	<1368791388-31441-3-git-send-email-amerilainen@nvidia.com>
	<20130526101243.GB1652@mithrandir>
	<51A30372.6080907@nvidia.com>
	<20130528103927.GB11547@mithrandir>
	<86y5ay6hrn.fsf@miki.keithp.com>
	<20130611104800.GA29395@mithrandir>
	<CAKMK7uF=A9zZ3VgdwzU3gfOjXaYsCqfCUSPmkLdL98nKX94jFQ@mail.gmail.com>
	<51B70D52.9060601@nvidia.com>
	<CAKMK7uGRW4uqsSaDEehTZwknZH+mNEgyKB6-4TgfgUOaTOcoLA@mail.gmail.com>
	<51B84D4E.30703@nvidia.com>
Date: Wed, 12 Jun 2013 13:00:33 +0200
X-Google-Sender-Auth: eXRI7vs1j3533s5Gom5yN5vDDmc
Message-ID: <CAKMK7uHdw76f-b2gzykP6Qz2Phw4kbTg3C+S40s7+6f5AdLxAA@mail.gmail.com>
Subject: Re: [PATCH 2/6] gpu: host1x: Fix syncpoint wait return value
From: Daniel Vetter <daniel@ffwll.ch>
To: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Keith Packard <keithp@keithp.com>,
        "X.Org development" <xorg-devel@lists.x.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 12:28 PM, Terje Bergström <tbergstrom@nvidia.com> wrote:
> On 11.06.2013 15:09, Daniel Vetter wrote:
>> Maybe it wasn't clear, but -EAGAIN does _not_ resubmit work. -EAGAIN
>> is used to restart the ioctl if we had to kick a thread (to make sure
>> it doesn't hold any locks), e.g. for a blocking wait on oustanding
>> rendering. The codepaths taken work exactly as if the thread is
>> interrupt with a signal.
>
> You did make it clear that there's no resubmission, but other parts
> confused me.
>
> So this is used so that a legacy driver which does not do fine-grained
> locking can interrupt all waits for completion for a wedged submit. This
> way a driver-wide lock get unlocked, cleanup code acquires locks, does
> the magic to unwedge GPU, and unlocks. Then user space can re-submit the
> waits as it got -EAGAIN.

I think this is not just for drivers without fine-grained locking, at
least I expect that we'll keep the same mechanism when switching over
to per-object locking - we simply have too many places where a thread
could arbitrarily block while holding locks that the gpu reset handler
also needs to grab. You could of course restructure the code massively
and drop all locks while waiting, but that means adding tons of
special-purpose code which is only really exercises when a gpu hang
occurs. Our approach with the ioctl restart otoh reuses codepaths
which are all heavily used by X (due to X constantly getting interrupt
by timers and input events).
-Daniel
--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
