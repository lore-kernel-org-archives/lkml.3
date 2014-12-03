Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933705AbaLCAlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 19:41:18 -0500
Received: from www.linutronix.de ([62.245.132.108]:50564 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933456AbaLCAlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 19:41:16 -0500
Date: Wed, 3 Dec 2014 01:40:53 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Waiman Long <Waiman.Long@hp.com>
cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Scott J Norton <scott.norton@hp.com>,
        Douglas Hatch <doug.hatch@hp.com>
Subject: Re: [PATCH v13 10/11] pvqspinlock, x86: Enable PV qspinlock for
 KVM
In-Reply-To: <1414613951-32532-11-git-send-email-Waiman.Long@hp.com>
Message-ID: <alpine.DEB.2.11.1412030115100.16275@nanos>
References: <1414613951-32532-1-git-send-email-Waiman.Long@hp.com> <1414613951-32532-11-git-send-email-Waiman.Long@hp.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2014, Waiman Long wrote:
>                 AIM7 XFS Disk Test (no overcommit)
>   kernel                 JPM    Real Time   Sys Time    Usr Time
>   -----                  ---    ---------   --------    --------
>   PV ticketlock         2542373    7.08       98.95       5.44
>   PV qspinlock          2549575    7.06       98.63       5.40
>   unfairlock	        2616279    6.91       97.05       5.42
> 
>                 AIM7 XFS Disk Test (200% overcommit)
>   kernel                 JPM    Real Time   Sys Time    Usr Time
>   -----                  ---    ---------   --------    --------
>   PV ticketlock         644468    27.93      415.22       6.33
>   PV qspinlock          645624    27.88      419.84       0.39

That number is made up by what? ----------------------------^^^^

>   unfairlock	        695518    25.88      377.40       4.09
> 
>                 AIM7 EXT4 Disk Test (no overcommit)
>   kernel                 JPM    Real Time   Sys Time    Usr Time
>   -----                  ---    ---------   --------    --------
>   PV ticketlock         1995565    9.02      103.67       5.76
>   PV qspinlock          2011173    8.95      102.15       5.40
>   unfairlock	        2066590    8.71       98.13       5.46
> 
>                 AIM7 EXT4 Disk Test (200% overcommit)
>   kernel                 JPM    Real Time   Sys Time    Usr Time
>   -----                  ---    ---------   --------    --------
>   PV ticketlock         478341    37.63      495.81      30.78
>   PV qspinlock          474058    37.97      475.74      30.95
>   unfairlock	        560224    32.13      398.43      26.27
> 
> For the AIM7 disk workload, both PV ticketlock and qspinlock have
> about the same performance. The unfairlock performs slightly better
> than the PV lock.

Slightly?

Taking the PV locks, which are basically the same for the existing
ticket locks and your new fangled qlocks as a reference then the so
called 'unfair locks' which are just the native locks w/o the PV
nonsense are fundamentally better up to a whopping 18% in the
ext4/200% overcommit case. See below.
 
>                 EBIZZY-m Test (no overcommit)
>   kernel                Rec/s   Real Time   Sys Time    Usr Time
>   -----                 -----   ---------   --------    --------
>   PV ticketlock         3255      10.00       60.65       3.62
>   PV qspinlock          3318      10.00       54.27       3.60
>   unfairlock	        2833      10.00       26.66       3.09
> 
>                 EBIZZY-m Test (200% overcommit)
>   kernel                Rec/s   Real Time   Sys Time    Usr Time
>   -----                 -----   ---------   --------    --------
>   PV ticketlock          841      10.00       71.03       2.37
>   PV qspinlock           834      10.00       68.27       2.39
>   unfairlock	         865      10.00       27.08       1.51
> 
>   futextest (no overcommit)
>   kernel               kops/s
>   -----                ------
>   PV ticketlock        11523
>   PV qspinlock         12328
>   unfairlock	        9478
> 
>   futextest (200% overcommit)
>   kernel               kops/s
>   -----                ------
>   PV ticketlock         7276
>   PV qspinlock          7095
>   unfairlock	        5614
> 
> The ebizzy and futextest have much higher spinlock contention than
> the AIM7 disk workload. In this case, the unfairlock performs worse
> than both the PV ticketlock and qspinlock. The performance of the 2
> PV locks are comparable.

While I can see that the PV lock stuff performs 13% better for the
ebizzy no overcommit case, what about the very interresting numbers
for the same test with 200% overcommit?

The regular lock has a slightly better performance, but significantly
less sys/usr time. How do you explain that?

'Lies, damned lies and statistics' comes to my mind.

Thanks,

	tglx
