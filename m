Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbaDROzH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 10:55:07 -0400
Received: from fujitsu25.fnanic.fujitsu.com ([192.240.6.15]:60230 "EHLO
	fujitsu25.fnanic.fujitsu.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752263AbaDROzC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 10:55:02 -0400
From: Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>
To: Manfred Spraul <manfred@colorfullife.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Motohiro Kosaki JP <kosaki.motohiro@jp.fujitsu.com>,
        "gthelen@google.com" <gthelen@google.com>,
        "aswin@hp.com" <aswin@hp.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>
Date: Fri, 18 Apr 2014 07:54:36 -0700
Subject: RE: [PATCH] ipc/shm: Increase the defaults for SHMALL, SHMMAX to
 infinity
Thread-Topic: [PATCH] ipc/shm: Increase the defaults for SHMALL, SHMMAX to
 infinity
Thread-Index: Ac9a5z2umjBksE+wSTKA+wv1IS9RrAALr2nA
Message-ID: <6B2BA408B38BA1478B473C31C3D2074E30986F0FF0@SV-EXCHANGE1.Corp.FC.LOCAL>
References: <1397812720-5629-1-git-send-email-manfred@colorfullife.com>
In-Reply-To: <1397812720-5629-1-git-send-email-manfred@colorfullife.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-18_01:2014-04-18,2014-04-18,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Manfred Spraul [mailto:manfred@colorfullife.com]
> Sent: Friday, April 18, 2014 2:19 AM
> To: Andrew Morton; Davidlohr Bueso
> Cc: LKML; KAMEZAWA Hiroyuki; Motohiro Kosaki JP; gthelen@google.com; aswin@hp.com; linux-mm@kvack.org; Manfred Spraul;
> mtk.manpages@gmail.com
> Subject: [PATCH] ipc/shm: Increase the defaults for SHMALL, SHMMAX to infinity
> 
> System V shared memory
> 
> a) can be abused to trigger out-of-memory conditions and the standard
>    measures against out-of-memory do not work:
> 
>     - it is not possible to use setrlimit to limit the size of shm segments.
> 
>     - segments can exist without association with any processes, thus
>       the oom-killer is unable to free that memory.
> 
> b) is typically used for shared information - today often multiple GB.
>    (e.g. database shared buffers)
> 
> The current default is a maximum segment size of 32 MB and a maximum total size of 8 GB. This is often too much for a) and not
> enough for b), which means that lots of users must change the defaults.
> 
> This patch increases the default limits to ULONG_MAX, which is perfect for case b). The defaults are used after boot and as the initial
> value for each new namespace.
> 
> Admins/distros that need a protection against a) should reduce the limits and/or enable shm_rmid_forced.
> 
> Further notes:
> - The patch only changes the boot time default, overrides behave as before:
> 	# sysctl kernel/shmall=33554432
>   would recreate the previous limit for SHMMAX (for the current namespace).
> 
> - Disabling sysv shm allocation is possible with:
> 	# sysctl kernel.shmall=0
>   (not a new feature, also per-namespace)
> 
> - ULONG_MAX is not really infinity, but 18 Exabyte segment size and
>   75 Zettabyte total size. This should be enough for the next few weeks.
>   (assuming a 64-bit system with 4k pages)
> 
> Risks:
> - The patch breaks installations that use "take current value and increase
>   it a bit". [seems to exist, http://marc.info/?l=linux-mm&m=139638334330127]
>   After a:
> 	# CUR=`sysctl -n kernel.shmmax`
> 	# NEW=`echo $CUR+1 | bc -l`
> 	# sysctl -n kernel.shmmax=$NEW
>   shmmax ends up as 0, which disables shm allocations.
> 
> - There is no wrap-around protection for ns->shm_ctlall, i.e. the 75 ZB
>   limit is not enforced.
> 
> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
> Reported-by: Davidlohr Bueso <davidlohr@hp.com>
> Cc: mtk.manpages@gmail.com

I'm ok either ULONG_MAX or 0 (special value of infinity).

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
