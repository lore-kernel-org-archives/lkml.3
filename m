Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbaIEQj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 12:39:59 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:42126 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaIEQj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 12:39:57 -0400
Message-ID: <5409E755.4040905@redhat.com>
Date: Fri, 05 Sep 2014 18:39:49 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, chris.j.arges@canonical.com,
        kvm@vger.kernel.org, John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH] KVM: x86: fix kvmclock breakage from timers branch merge
References: <1409835487-14371-1-git-send-email-pbonzini@redhat.com> <alpine.DEB.2.10.1409042230020.3333@nanos> <5408D815.9090105@redhat.com> <alpine.DEB.2.10.1409050000570.3333@nanos>
In-Reply-To: <alpine.DEB.2.10.1409050000570.3333@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 05/09/2014 17:14, Thomas Gleixner ha scritto:
> So that means the code is correct. Now where is the bug?

In kernel/time/timekeeping.c?

We know that we should have

  base_mono             =     wall_to_monotonic + xtime_sec

Instead it is

  base_mono             = wall_to_monotonic + xtime_sec
                          - seconds from boot time

which is... zero.  Given this is the only use of base_mono in a
notifier, I wonder if it is as simple as this (which I don't have time
to test right now):

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index fb4a9c2cf8d9..f6807a85b8c9 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -443,9 +443,9 @@ static void timekeeping_update(struct timekeeper
*tk, unsigned int action)
 		ntp_clear();
 	}
 	update_vsyscall(tk);
-	update_pvclock_gtod(tk, action & TK_CLOCK_WAS_SET);

 	tk_update_ktime_data(tk);
+	update_pvclock_gtod(tk, action & TK_CLOCK_WAS_SET);

 	if (action & TK_MIRROR)
 		memcpy(&shadow_timekeeper, &tk_core.timekeeper,

:)

Paolo

> Well hidden and still so obvious that it's even visible through the
> brown paperpag I'm wearing ...

