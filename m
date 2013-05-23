Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759850Ab3EWWY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 18:24:56 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:17087 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759819Ab3EWWYx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 18:24:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 23 May 2013 15:24:53 -0700
From: Peter Boonstoppel <pboonstoppel@nvidia.com>
To: Mike Galbraith <bitbucket@online.de>,
        Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Walmsley <pwalmsley@nvidia.com>
Date: Thu, 23 May 2013 15:24:52 -0700
Subject: RE: [PATCH RFC] sched/rt: preserve global runtime/period ratio in
 do_balance_runtime()
Thread-Topic: [PATCH RFC] sched/rt: preserve global runtime/period ratio in
 do_balance_runtime()
Thread-Index: Ac5WyNql03wpe7xkTEC/tUA2Pmm2awBLOKW2
Message-ID: <5FBF8E85CA34454794F0F7ECBA79798F37AE45046B@HQMAIL04.nvidia.com>
References: <5FBF8E85CA34454794F0F7ECBA79798F37ADA53CA7@HQMAIL04.nvidia.com>
	 <20130522081601.GP26912@twins.programming.kicks-ass.net>,<1369212383.5916.28.camel@marge.simpson.net>
In-Reply-To: <1369212383.5916.28.camel@marge.simpson.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think my patch was aiming at enabling rt_runtime borrowing, while preserving the global invariant of not allowing 100% allocation of time to rt_rq. Disabling RT_RUNTIME_SHARE definitely addresses the safety mechanism concern.

However, I'd like to understand the original goal of this rt_runtime borrowing a little bit better. At a high level it seems to me that bandwidth allocation (with possible borrowing of unused bandwidth) and providing a safety mechanism against rogue rt threads are two independent goals, which just happen to share the same mechanism. And if you'd want both, you'd have to provision some amount of bandwidth that cannot be borrowed.

Other than that I second Mike's change for flipping the default.


Peter



________________________________________
From: Mike Galbraith [bitbucket@online.de]
Sent: Wednesday, May 22, 2013 1:46 AM
To: Peter Zijlstra
Cc: Peter Boonstoppel; Ingo Molnar; linux-kernel@vger.kernel.org; Paul Walmsley
Subject: Re: [PATCH RFC] sched/rt: preserve global runtime/period ratio in do_balance_runtime()

On Wed, 2013-05-22 at 10:16 +0200, Peter Zijlstra wrote:

> I thought we already had a knob for that; RT_RUNTIME_SHARE. And as Mike
> said, we might consider flipping the default on that.


sched,rt: disable rt_runtime borrowing by default

Make the default RT_RUNTIME_SHARE setting reflect the most common
throttle role, that of safety mechanism to protect the box.

Signed-off-by: Mike Galbraith <bitbucket@online.de>

diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index 99399f8..0945d38 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -57,7 +57,7 @@ SCHED_FEAT(NONTASK_POWER, true)
 SCHED_FEAT(TTWU_QUEUE, true)

 SCHED_FEAT(FORCE_SD_OVERLAP, false)
-SCHED_FEAT(RT_RUNTIME_SHARE, true)
+SCHED_FEAT(RT_RUNTIME_SHARE, false)
 SCHED_FEAT(LB_MIN, false)

 /*


