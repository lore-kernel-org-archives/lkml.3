Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726AbaIDVWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 17:22:37 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:63175 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404AbaIDVWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 17:22:35 -0400
Message-ID: <5408D815.9090105@redhat.com>
Date: Thu, 04 Sep 2014 23:22:29 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, chris.j.arges@canonical.com,
        kvm@vger.kernel.org, John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH] KVM: x86: fix kvmclock breakage from timers branch merge
References: <1409835487-14371-1-git-send-email-pbonzini@redhat.com> <alpine.DEB.2.10.1409042230020.3333@nanos>
In-Reply-To: <alpine.DEB.2.10.1409042230020.3333@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 04/09/2014 22:58, Thomas Gleixner ha scritto:
> This is simply wrong.

It is.

> Now I have no idea why you think it needs to add xtime_sec. If the
> result is wrong, then we need to figure out which one of the supplied
> values is wrong and not blindly add xtime_sec just because that makes
> it magically correct.
> 
> Can you please provide a proper background why you think that adding
> xtime_sec is a good idea?

It's not a good idea indeed.  I didn't fully digest the 3.16->3.17
timekeeping changes and messed up this patch.

However, there is a bug in the "base_mono + offs_boot" formula, given
that:

- bisection leads to the merge commit of John's timers branch

- bisecting within John's timers branch, with a KVM commit on top to
  make the code much easier to trigger, leads to commit cbcf2dd3b3d4
  (x86: kvm: Make kvm_get_time_and_clockread() nanoseconds based,
  2014-07-16).

- I backported your patch to 3.16, using wall_to_monotonic +
  total_sleep_time + xtime_sec (wtm+xtime_sec as in pre-cbcf2dd3b3d4
  code, total_sleep_time from 3.16 monotonic_to_bootbased) and it works

- In v2 of the patch I fixed the bug by changing the formula
  "base_mono + offs_boot" to "offs_boot - offs_real" (and then adding
  xtime_sec separately as in the 3.16 backport), but the two formulas
  "base_mono + offs_boot" and "offs_boot - offs_real + xtime_sec" ought
  to be identical.

I find "offs_boot - offs_real + xtime" more readable than the
alternative "base_mono + offs_boot + xtime_nsec", so the fix doubles as
a cleanup for me and I'm fine with it.  But something must be wrong in
the timekeeping code.

Paolo
