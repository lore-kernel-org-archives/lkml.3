Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab3BEKzU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 05:55:20 -0500
Received: from na3sys010aog108.obsmtp.com ([74.125.245.84]:33455 "HELO
	na3sys010aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754002Ab3BEKzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 05:55:15 -0500
From: "Leonid Shatz" <leonid.shatz@ravellosystems.com>
To: "'Thomas Gleixner'" <tglx@linutronix.de>,
        "'Izik Eidus'" <izik.eidus@ravellosystems.com>
Cc: "'Andrea Arcangeli'" <aarcange@redhat.com>, <linux-kernel@vger.kernel.org>
References: <1359981217-389-1-git-send-email-izik.eidus@ravellosystems.com> <alpine.LFD.2.02.1302051138370.11905@ionos>
In-Reply-To: <alpine.LFD.2.02.1302051138370.11905@ionos>
Subject: RE: [PATCH] fix hrtimer_enqueue_reprogram race
Date: Tue, 5 Feb 2013 12:55:17 +0200
Message-ID: <03b201ce038f$4a2db840$de8928c0$@ravellosystems.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQFOdIG7lHacNtBAA3jpV21GXL0XcAIvDDp7mVi6nhA=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The explanation were submitted as possible scenario which could explain how
the bug in kernel could happen and it does not mean that serious designer
could do exactly that. As I said before, it's also possible that a race
between hrtimer_cancel and hrtimer_start can trigger the bug. The idea is to
have kernel more robust. There are already locks used inside hrtimer code,
so why should users of the hrtimer add another layer of locks and get
involved in the intricacy of which cases are protected by internal hrtimer
lock and which are not?

Leonid Shatz

> -----Original Message-----
> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Tuesday, February 05, 2013 12:44 PM
> To: Izik Eidus
> Cc: Andrea Arcangeli; linux-kernel@vger.kernel.org; leonid Shatz
> Subject: Re: [PATCH] fix hrtimer_enqueue_reprogram race
> 
> On Mon, 4 Feb 2013, Izik Eidus wrote:
> 
> > From: leonid Shatz <leonid.shatz@ravellosystems.com>
> >
> > it seems like hrtimer_enqueue_reprogram contain a race which could
> > result in timer.base switch during unlock/lock sequence.
> >
> > See the code at __hrtimer_start_range_ns where it calls
> > hrtimer_enqueue_reprogram. The later is releasing lock protecting the
> > timer base for a short time and timer base switch can occur from a
> > different CPU thread. Later when __hrtimer_start_range_ns calls
> > unlock_hrtimer_base, a base switch could have happened and this causes
> > the bug
> >
> > Try to start the same hrtimer from two different threads in kernel
> > running each one on a different CPU. Eventually one of the calls will
> > cause timer base switch while another thread is not expecting it.
> 
> Aside of the bug in the hrtimer code being a real one, writing code which
> fiddles with the same resource (hrtimer) unserialized is broken on its
own.
> 
> > This can happen in virtualized environment where one thread can be
> > delayed by lower hypervisor, and due to time delay a different CPU is
> > taking care of missed timer start and runs the timer start logic on its
own.
> 
> Without noticing that something else already takes care of it? So you're
> saying that the code in question relies on magic serialization in the
hrtimer
> code. Doesn't look like a brilliant design.
> 
> Thanks,
> 
> 	tglx

