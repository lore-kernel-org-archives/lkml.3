Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab3LGIAI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 03:00:08 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:59531 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab3LGIAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 03:00:07 -0500
MIME-Version: 1.0
Date: Sat, 7 Dec 2013 03:00:05 -0500
X-Google-Sender-Auth: BqSaSIVKXHvZ3yX44dRBXGF8vNk
Message-ID: <CAJvTdK=+aNN66mYpCGgbHGCHhYQAKx-vB0kJSWjVpsNb_hOAtQ@mail.gmail.com>
Subject: 50 Watt idle power regression bisected to Linux-3.10
From: Len Brown <lenb@kernel.org>
To: tglx@linutronix.de, Peter Zijlstra <peterz@infradead.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Eder <jeder@redhat.com>, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

An idle WSM-EX box (40 Xeon cores) runs 50 Watts hotter after this patch:

commit 7d1a941731fabf27e5fb6edbebb79fe856edb4e5
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Thu Mar 21 22:50:03 2013 +0100

    x86: Use generic idle loop

ie. the commit before this patch (aba92c9e2cf3042bf6efc68fa2e4235ba01bf499)
runs at 50 watts less, as do Linux 3.7, 3.8 and 3.9.

The difference is that the good kernels allow about 98% residence
in the package C6 state, while the bad kernel is so noisy that it
gets into pc6 0% of the time.
(indeed, even core C6 is reduced to about 50% from over 99%)

No, Linux-3.13-rc3 does not fix this issue, even though it contains
the following patch, claiming to address an issue with the commit above:

commit ea8117478918a4734586d35ff530721b682425be
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Wed Sep 11 12:43:13 2013 +0200

    sched, idle: Fix the idle polling state logic

    Mike reported that commit 7d1a9417 ("x86: Use generic idle loop")
    regressed several workloads and caused excessive reschedule
    interrupts.

    The patch in question failed to notice that the x86 code had an
    inverted sense of the polling state versus the new generic code (x86:
    default polling, generic: default !polling).

    Fix the two prominent x86 mwait based idle drivers and introduce a few
    new generic polling helpers (fixing the wrong smp_mb__after_clear_bit
    usage).

    Also switch the idle routines to using tif_need_resched() which is an
    immediate TIF_NEED_RESCHED test as opposed to need_resched which will
    end up being slightly different.

    Reported-by: Mike Galbraith <bitbucket@online.de>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Cc: lenb@kernel.org
    Cc: tglx@linutronix.de
    Link: http://lkml.kernel.org/n/tip-nc03imb0etuefmzybzj7sprf@git.kernel.org
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

How shall we proceed?

thanks,
-Len Brown, Intel Open Source Technology Center
