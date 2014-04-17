Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaDQORY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 10:17:24 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50424 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751992AbaDQORU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 10:17:20 -0400
Date: Thu, 17 Apr 2014 15:15:41 +0100
From: Will Deacon <will.deacon@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "monstr@monstr.eu" <monstr@monstr.eu>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/18] Cross-architecture definitions of relaxed MMIO
 accessors
Message-ID: <20140417141541.GC30553@arm.com>
References: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
 <20140417140036.GK11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140417140036.GK11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Thu, Apr 17, 2014 at 03:00:36PM +0100, Peter Zijlstra wrote:
> On Thu, Apr 17, 2014 at 02:44:03PM +0100, Will Deacon wrote:
> > In actual fact, the relaxed accessors *are* ordered with respect to LOCK/UNLOCK
> > operations on ARM[64], but I have added this constraint for the benefit of
> > PowerPC, which has expensive I/O barriers in the spin_unlock path for the
> > non-relaxed accessors.
> > 
> > A corollary to this is that mmiowb() probably needs rethinking. As it currently
> > stands, an mmiowb() is required to order MMIO writes to a device from multiple
> > CPUs, even if that device is protected by a lock. However, this isn't often used
> > in practice, leading to PowerPC implementing both mmiowb() *and* synchronising
> > I/O in spin_unlock.
> > 
> > I would propose making the non-relaxed I/O accessors ordered with respect to
> > LOCK/UNLOCK, leaving mmiowb() to be used with the relaxed accessors, if
> > required, but would welcome thoughts/suggestions on this topic.
> 
> So the non-relaxed ops already imply the expensive I/O barrier (mmiowb?)
> and therefore, PPC can drop it from spin_unlock()?

Ben can probably help out here, but if my proposal went ahead (that is,
only the non-relaxed ops would imply mmiowb()), then it would actually
be implemented on PPC by having only those accessors call IO_SET_SYNC_FLAG,
which is checked during unlock (in SYNC_IO).

> Also, I read mmiowb() as MMIO-write-barrier(), what do we have to
> order/contain mmio-reads?

My understanding is that this is related to posted stores from different
CPUs being re-ordered on the bus, so I wouldn't expect reads to suffer
(although, since this isn't permitted on ARM, I'm guessing here).

Will
