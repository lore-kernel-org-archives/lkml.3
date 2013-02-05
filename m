Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab3BEKoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 05:44:25 -0500
Received: from www.linutronix.de ([62.245.132.108]:48457 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab3BEKoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 05:44:22 -0500
Date: Tue, 5 Feb 2013 11:44:20 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Izik Eidus <izik.eidus@ravellosystems.com>
cc: Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        leonid Shatz <leonid.shatz@ravellosystems.com>
Subject: Re: [PATCH] fix hrtimer_enqueue_reprogram race
In-Reply-To: <1359981217-389-1-git-send-email-izik.eidus@ravellosystems.com>
Message-ID: <alpine.LFD.2.02.1302051138370.11905@ionos>
References: <1359981217-389-1-git-send-email-izik.eidus@ravellosystems.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Feb 2013, Izik Eidus wrote:

> From: leonid Shatz <leonid.shatz@ravellosystems.com>
> 
> it seems like hrtimer_enqueue_reprogram contain a race which could result in
> timer.base switch during unlock/lock sequence.
> 
> See the code at __hrtimer_start_range_ns where it calls
> hrtimer_enqueue_reprogram. The later is releasing lock protecting the timer
> base for a short time and timer base switch can occur from a different CPU
> thread. Later when __hrtimer_start_range_ns calls unlock_hrtimer_base, a base
> switch could have happened and this causes the bug
> 
> Try to start the same hrtimer from two different threads in kernel running
> each one on a different CPU. Eventually one of the calls will cause timer base
> switch while another thread is not expecting it.

Aside of the bug in the hrtimer code being a real one, writing code
which fiddles with the same resource (hrtimer) unserialized is broken
on its own.
 
> This can happen in virtualized environment where one thread can be delayed by
> lower hypervisor, and due to time delay a different CPU is taking care of
> missed timer start and runs the timer start logic on its own.

Without noticing that something else already takes care of it? So
you're saying that the code in question relies on magic serialization
in the hrtimer code. Doesn't look like a brilliant design.

Thanks,

	tglx
