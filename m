Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934271AbaGXSg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 14:36:57 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37480 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbaGXSgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 14:36:55 -0400
Date: Thu, 24 Jul 2014 20:36:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Waiman Long <Waiman.Long@hp.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: Linux 3.16-rc6
Message-ID: <20140724183643.GM3935@laptop>
References: <CA+55aFzJKxzw_as9iGgeM=MdQ6trUkQLDuoEr8nxj88sOqQnQA@mail.gmail.com>
 <20140723095327.GA23131@pd.tnic>
 <CA+55aFzPs4uF=eR7jCnpyBtgWNRkX-uDfXeo5u34VEvT8_yyzw@mail.gmail.com>
 <20140724064353.GW9918@twins.programming.kicks-ass.net>
 <20140724084126.GB19239@pd.tnic>
 <20140724122513.GM19239@pd.tnic>
 <20140724125814.GX6758@twins.programming.kicks-ass.net>
 <CA+55aFynW5xSRQvY6xO+mxmt6yh7mFkMjy-pgJXpXNy8qDMcPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFynW5xSRQvY6xO+mxmt6yh7mFkMjy-pgJXpXNy8qDMcPA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 11:18:16AM -0700, Linus Torvalds wrote:
> On Thu, Jul 24, 2014 at 5:58 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > So going by the nifty picture rostedt made:
> >
> > [   61.454336]        CPU0                    CPU1
> > [   61.454336]        ----                    ----
> > [   61.454336]   lock(&(&p->alloc_lock)->rlock);
> > [   61.454336]                                local_irq_disable();
> > [   61.454336]                                lock(tasklist_lock);
> > [   61.454336]                                lock(&(&p->alloc_lock)->rlock);
> > [   61.454336]   <Interrupt>
> > [   61.454336]     lock(tasklist_lock);
> 
> So this *should* be fine. It always has been in the past, and it was
> certainly the *intention* that it should continue to work with
> qrwlock, even in the presense of pending writers on other cpu's.
> 
> The qrwlock rules are that a read-lock in an interrupt is still going
> to be unfair and succeed if there are other readers.

Ah, indeed. Should have checked :/

> So it sounds to me like the new lockdep rules in tip/master are too
> strict and are throwing a false positive.

Right. Waiman can you have a look?
