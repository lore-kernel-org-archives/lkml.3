Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932538AbaICJ6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:58:41 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:50362 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932504AbaICJ6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:58:37 -0400
Date: Wed, 3 Sep 2014 11:58:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Hugh Dickins <hughd@google.com>
Cc: Chintan Pandya <cpandya@codeaurora.org>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v4 2/2] ksm: provide support to use deferrable timers for
 scanner thread
Message-ID: <20140903095815.GK4783@worktop.ger.corp.intel.com>
References: <1408536628-29379-1-git-send-email-cpandya@codeaurora.org>
 <1408536628-29379-2-git-send-email-cpandya@codeaurora.org>
 <alpine.LSU.2.11.1408272258050.10518@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1408272258050.10518@eggly.anvils>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 11:02:20PM -0700, Hugh Dickins wrote:
> Sorry for holding you up, I'm slow. and needed to think about this more,
> 
> On Wed, 20 Aug 2014, Chintan Pandya wrote:
> 
> > KSM thread to scan pages is scheduled on definite timeout. That wakes up
> > CPU from idle state and hence may affect the power consumption. Provide
> > an optional support to use deferrable timer which suites low-power
> > use-cases.
> > 
> > Typically, on our setup we observed, 10% less power consumption with some
> > use-cases in which CPU goes to power collapse frequently. For example,
> > playing audio on Soc which has HW based Audio encoder/decoder, CPU
> > remains idle for longer duration of time. This idle state will save
> > significant CPU power consumption if KSM don't wakes them up
> > periodically.
> > 
> > Note that, deferrable timers won't be deferred if any CPU is active and
> > not in IDLE state.
> > 
> > By default, deferrable timers is enabled. To disable deferrable timers,
> > $ echo 0 > /sys/kernel/mm/ksm/deferrable_timer
> 
> I have now experimented.  And, much as I wanted to eliminate the
> tunable, and just have deferrable timers on, I have come right back
> to your original position.
> 
> I was impressed by how quiet ksmd goes when there's nothing much
> happening on the machine; but equally, disappointed in how slow
> it then is to fulfil the outstanding merge work.  I agree with your
> original assessment, that not everybody will want deferrable timer,
> the way it is working at present.
> 
> I expect that can be fixed, partly by doing more work on wakeup from
> a deferred timer, according to how long it has been deferred; and
> partly by not deferring on idle until two passes of the list have been
> completed.  But that's easier said than done, and might turn out to

So why not have the timer cancel itself when there is no more work to do
and start itself up again when there's work added?
