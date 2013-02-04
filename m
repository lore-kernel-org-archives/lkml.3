Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab3BDL3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:29:40 -0500
Received: from na3sys010aog101.obsmtp.com ([74.125.245.70]:40316 "HELO
	na3sys010aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754007Ab3BDL3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:29:38 -0500
X-Greylist: delayed 446 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Feb 2013 06:29:38 EST
From: "Leonid Shatz" <leonid.shatz@ravellosystems.com>
To: "'Thomas Gleixner'" <tglx@linutronix.de>,
        "'Izik Eidus'" <izik.eidus@ravellosystems.com>
Cc: <linux-kernel@vger.kernel.org>, "'Andrea Arcangeli'" <aarcange@redhat.com>,
        "Mike Rapoport" <mike.rapoport@ravellosystems.com>
References: <510E58C2.9010207@ravellosystems.com> <alpine.LFD.2.02.1302041110160.11905@ionos>
In-Reply-To: <alpine.LFD.2.02.1302041110160.11905@ionos>
Subject: RE: hrtimer possible issue
Date: Mon, 4 Feb 2013 13:22:07 +0200
Message-ID: <030401ce02c9$e5139170$af3ab450$@ravellosystems.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQF0ILwKmJFBTDiDvqyx/BcHikXLFQFjuHE5mRIzlJA=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I assume the race can also happen between hrtimer cancel and start. In both
cases timer base switch can happen.

Izik, please check if you can arrange the patch in the standard format (do
we need to do it against latest kernel version?)

Leonid Shatz

> -----Original Message-----
> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Monday, February 04, 2013 12:13 PM
> To: Izik Eidus
> Cc: linux-kernel@vger.kernel.org; Andrea Arcangeli; Leonid Shatz
> Subject: Re: hrtimer possible issue
> 
> On Sun, 3 Feb 2013, Izik Eidus wrote:
> 
> > Hi,
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
> >
> > This can happen in virtualized environment where one thread can be
> > delayed by lower hypervisor, and due to time delay a different CPU is
> > taking care of missed timer start and runs the timer start logic on its
own.
> 
> Nice analysis.
> 
> > This simple patch (just to give example of a fix) refactor this
> > function to get rid of unneeded lock which immediately was followed by
> > the unlock (with possible undesired base switch).
> >
> > (Both the bug and the fixed were found/patched by Leonid Shatz)
> 
> The patch got mangled by your mail client and it is missing the proper
Signed-
> off-by annotation in the patch description. See
> Documentation/SubmittingPatches.
> 
> Can you please resend ?
> 
> Thanks,
> 
> 	tglx
> 


