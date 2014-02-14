Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbaBNMeb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 07:34:31 -0500
Received: from www.linutronix.de ([62.245.132.108]:41451 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbaBNMe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 07:34:28 -0500
Date: Fri, 14 Feb 2014 13:34:27 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: linux-rt-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Carsten Emde <C.Emde@osadl.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andreas Platschek <platschek@ict.tuwien.ac.at>
Subject: Re: [PATCH RT 1/5] allow preemption in add_timer_randomness
Message-ID: <20140214123427.GC28438@linutronix.de>
References: <20140210153728.GB20017@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140210153728.GB20017@opentech.at>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nicholas Mc Guire | 2014-02-10 16:37:28 [+0100]:

>allow preemption in add_timer_randomness
>
>This patch replaced the preempt_disable by migrate_disable in 
>add_timer_randomness.
>
>Does this really need even migration protection at all ? 
>if one would even drop migration protection - what would happen ?
>
>        /* if over the trickle threshold, use only 1 in 4096 samples */
>        if (input_pool.entropy_count > trickle_thresh &&
>            ((__this_cpu_inc_return(trickle_count) - 1) & 0xfff)) {
>                return;
>        }
>
>trickle_thresh and input_pool.entropy_count are global, so the only thing
>that would happen if this got migrated would be that the 1/4096 could be
>a bit less precise locally (the probability of being migrted here is not 
>very high this is a window of a few instructions at best) 
>
>If we got migrated away - so what ? that only would mean that it would be
>checking the trickle_count on the "wrong" cpu - in sum the cpus would though
>still not contribute more bits, the one countdown wouuld speed up only as
>much as some other countdown slowed down.
>
>In any case, even for precise 1/4096 when over threshhold we would not need
>more than a migration protection.
>
>patch is against 3.12.10-rt15
>
>Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>

Ingo added this preempt_disable() in v2.6.9-rc4 because:
|A certain codepath in the random driver relied on vt_ioctl() being under
|the BKL and implicitly disabling preemption.  The code wasn't buggy
|upstream but it's slighly unrobust so I think we want the fix upstream too,
|independently of the remove-bkl patch.

later in -RT he made the preempt disable region smaller. Looking at the
code path I'm not sure if we need that preempt_disable() here or
upstream at all. It looks like a global lock which does not protect
much.

Applied.

Sebastian
