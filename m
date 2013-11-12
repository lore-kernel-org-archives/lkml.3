Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab3KLOYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:24:20 -0500
Received: from mx0.aculab.com ([213.249.233.131]:59906 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753088Ab3KLOYR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:24:17 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] ipvs: Remove unused variable ret from sync_thread_master()
Date: Tue, 12 Nov 2013 14:21:39 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B7405@saturn3.aculab.com>
In-Reply-To: <20131112141314.GQ5056@laptop.programming.kicks-ass.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] ipvs: Remove unused variable ret from sync_thread_master()
Thread-Index: Ac7fsTMp8KQE1BtvTQugX4IrVBIf2QAALmyA
References: <1384264396-14550-1-git-send-email-geert@linux-m68k.org> <20131112141314.GQ5056@laptop.programming.kicks-ass.net>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Peter Zijlstra" <peterz@infradead.org>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>
Cc: "Oleg Nesterov" <oleg@redhat.com>, "Ingo Molnar" <mingo@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -1637,7 +1637,7 @@ static int sync_thread_master(void *data)
> >  			continue;
> >  		}
> >  		while (ip_vs_send_sync_msg(tinfo->sock, sb->mesg) < 0) {
> > -			int ret = __wait_event_interruptible(*sk_sleep(sk),
> 
> So ideally there's be a comment here why we're using interruptible but
> then ignore interruptions.
> 
> Julian said (
> http://lkml.kernel.org/r/alpine.LFD.2.00.1310012245020.1782@ja.ssi.bg ):
> 
> " Yes, your patch looks ok to me. In the past
> we used ssleep() but IPVS users were confused why
> IPVS threads increase the load average. So, we
> switched to _interruptible calls and later the socket
> polling was added.  "

I've done this in the past so that the code sleeps interruptibly
unless there is a signal pending - which would cause it to return
early.

    /* Tell scheduler we are going to sleep... */
    if (signal_pending(current))
        /* We don't want waking immediately (again) */
        sleep_state = TASK_UNINTERRUPTIBLE;
    else
        sleep_state = TASK_INTERRUPTIBLE;
    set_current_state(sleep_state);

Shame there isn't a process flag to indicate that the process
will sleep uninterruptibly and that it doesn't matter.
So don't count to the load average and don't emit a warning
if it has been sleeping for a long time.

	David



