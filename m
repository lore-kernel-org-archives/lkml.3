Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935006Ab3DKNqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:46:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:43423 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab3DKNqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:46:51 -0400
Date: Thu, 11 Apr 2013 15:46:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
cc: Dave Hansen <dave@sr71.net>, Borislav Petkov <bp@alien8.de>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        dhillf@gmail.com, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] kthread: Prevent unpark race which puts threads on the
 wrong cpu
In-Reply-To: <51669510.2040200@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.02.1304111545120.21884@ionos>
References: <515F457E.5050505@sr71.net> <515FCAC6.8090806@linux.vnet.ibm.com> <alpine.LFD.2.02.1304061019000.21884@ionos> <alpine.LFD.2.02.1304071119100.21884@ionos> <20130407095025.GA31307@pd.tnic> <alpine.LFD.2.02.1304081122040.21884@ionos>
 <20130408115553.GA4395@pd.tnic> <alpine.LFD.2.02.1304081415570.21884@ionos> <alpine.LFD.2.02.1304091635430.21884@ionos> <516439DF.3050901@sr71.net> <alpine.LFD.2.02.1304092036431.21884@ionos> <alpine.LFD.2.02.1304092126150.21884@ionos> <51647C30.3050109@sr71.net>
 <alpine.LFD.2.02.1304101024010.21884@ionos> <alpine.LFD.2.02.1304101250320.21884@ionos> <5165C087.4060404@sr71.net> <alpine.LFD.2.02.1304111020520.21884@ionos> <51669510.2040200@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Apr 2013, Srivatsa S. Bhat wrote:
> The reason why we can't get rid of the bind in the unpark code is because,
> the threads are parked during CPU offline *after* calling CPU_DOWN_PREPARE.
> And during CPU_DOWN_PREPARE, the scheduler removes the CPU from the cpu_active_mask.
> So on any subsequent wakeup of these threads before they are parked, the scheduler
> will force migrate them to some other CPU (but alas it wont print this event
> because of the p->mm != NULL check in select_fallback_rq()). So during unpark
> during the next online operation we need to bind it again. But that's fine, IMHO.

No, it's not fine. If we do not have TASK_PARKED a wakeup which
happens after onlining the task and races with the unpark code will
cause the task to end up on the wrong CPU. Borislav showed traces
which prove that with ksoftirqd. So no, TASK_PARKED is going to stay.

Thanks,

	tglx
