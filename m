Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab3KRX1v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 18:27:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59391 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab3KRX1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 18:27:47 -0500
Date: Mon, 18 Nov 2013 15:27:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: NeilBrown <neilb@suse.de>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        Marek Belisko <marek@goldelico.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH/RFC] wait_for_completion_timeout() considered harmful.
Message-Id: <20131118152746.937b2b7971d7a4bba4ef996d@linux-foundation.org>
In-Reply-To: <20131117080603.2a0d3b6d@notabene.brown>
References: <20131117080603.2a0d3b6d@notabene.brown>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Nov 2013 08:06:03 +1100 NeilBrown <neilb@suse.de> wrote:

> It would be reasonable to assume that
> 
>       wait_for_completion_timeout(&wm8350->auxadc_done, msecs_to_jiffies(5));
> 
> would wait at least 5 msecs for the auxadc_done to complete.  But it does not.
> With a HZ of 200 or less, msecs_to_jiffies(5) has value '1', and so this
> will only wait until the next "timer tick", which could happen immediately.
> 
> This can lead to incorrect results - and has done so in out-of-tree patches
> for drivers/misc/bmp085.c which uses a very similar construct to enable interrupt
> based result collection.
> 
> The documentation for several *_timeout* functions claim they will wait for
> "timeout jiffies" to have elapsed where this is not the case.  They will
> actually wait for "timeout" jiffies to have started implying an elapsed time
> between (timeout-1) and (timeout).
> 
> This patch corrects some of this documentation, and adds a collection of
>   wait_for_completion*_msecs()
> interfaces which wait at least the given number of milliseconds for the
> completion (or a signal).

Mutter.  wait_for_x(..., 5ms) should wait for a minimum of 5ms, no matter
what.

So I'd suggest we make that happen, rather than adding some new interfaces?
