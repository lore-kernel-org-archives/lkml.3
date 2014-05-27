Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbaE0UdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 16:33:25 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58389 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751710AbaE0UdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 16:33:23 -0400
Date: Tue, 27 May 2014 21:32:49 +0100
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
Message-ID: <20140527203249.GB31850@arm.com>
References: <1400777250-17335-1-git-send-email-will.deacon@arm.com>
 <1401054363.3958.28.camel@pasglop>
 <20140527193219.GB30751@arm.com>
 <1401222098.20915.77.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401222098.20915.77.camel@pasglop>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 09:21:38PM +0100, Benjamin Herrenschmidt wrote:
> On Tue, 2014-05-27 at 20:32 +0100, Will Deacon wrote:
> 
> > Why would you need two barriers? I would have though an mmiowb() inlined
> > into writel after the store operation would be sufficient. Or is this to
> > ensure a non-relaxed write is ordered with respect to a relaxed write?
> 
> Well, so the non-relaxed writel would have to do:
> 
> 	sync
> 	store
> 	sync
> 
> The first sync is to synchronize with DMAs, so that a sequence of
> 
> 	store to mem
> 	writel
> 
> Remains ordered vs. the device (ie, when the writel causes the device
> to do a DMA, it will see the previous store to mem).
> 
> The second sync is needed as mmiowb, to order with unlocks.

Ah yeah, thanks. I was so hung up on the ordering against locks that I
completely forgot about DMA!

> At this point, I'm keen on keeping my per-cpu trick to avoid that
> second one in most cases.

Makes sense. The alternative is dropping that requirement and instead
relying on drivers to use mmiowb() even with the non-relaxed accessors,
but I think that's going to be fairly painful (and hence why you have the
trick to start with).

Will
