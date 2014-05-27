Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbaE0Tc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 15:32:59 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57415 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752142AbaE0Tc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 15:32:57 -0400
Date: Tue, 27 May 2014 20:32:19 +0100
From: Will Deacon <will.deacon@arm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "monstr@monstr.eu" <monstr@monstr.eu>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 00/18] Cross-architecture definitions of relaxed MMIO
 accessors
Message-ID: <20140527193219.GB30751@arm.com>
References: <1400777250-17335-1-git-send-email-will.deacon@arm.com>
 <1401054363.3958.28.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401054363.3958.28.camel@pasglop>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Sun, May 25, 2014 at 10:46:03PM +0100, Benjamin Herrenschmidt wrote:
> On Thu, 2014-05-22 at 17:47 +0100, Will Deacon wrote:
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
> I agree on the proposed semantics, though for us that does mean we still need
> that per-cpu flag tracking non-relaxed MMIO stores and corresponding added barrier
> in unlock. Eventually, if the use of the relaxed accessors becomes pervasive
> enough I suppose I can just make the ordered ones unconditionally do 2 barriers.

Why would you need two barriers? I would have though an mmiowb() inlined
into writel after the store operation would be sufficient. Or is this to
ensure a non-relaxed write is ordered with respect to a relaxed write?

Anyway, we may need something similar for other architectures with mmiowb
implementations:

  blackfin
  frv
  ia64
  mips
  sh

so I'm anticipating some more discussion when I try to push that patch :)

Cheers,

Will
