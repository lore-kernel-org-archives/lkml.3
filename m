Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaE0UWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 16:22:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:45454 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656AbaE0UWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 16:22:47 -0400
Message-ID: <1401222098.20915.77.camel@pasglop>
Subject: Re: [PATCH v2 00/18] Cross-architecture definitions of relaxed MMIO
 accessors
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "monstr@monstr.eu" <monstr@monstr.eu>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Date: Wed, 28 May 2014 06:21:38 +1000
In-Reply-To: <20140527193219.GB30751@arm.com>
References: <1400777250-17335-1-git-send-email-will.deacon@arm.com>
	 <1401054363.3958.28.camel@pasglop> <20140527193219.GB30751@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-27 at 20:32 +0100, Will Deacon wrote:

> Why would you need two barriers? I would have though an mmiowb() inlined
> into writel after the store operation would be sufficient. Or is this to
> ensure a non-relaxed write is ordered with respect to a relaxed write?

Well, so the non-relaxed writel would have to do:

	sync
	store
	sync

The first sync is to synchronize with DMAs, so that a sequence of

	store to mem
	writel

Remains ordered vs. the device (ie, when the writel causes the device
to do a DMA, it will see the previous store to mem).

The second sync is needed as mmiowb, to order with unlocks.
 
At this point, I'm keen on keeping my per-cpu trick to avoid that
second one in most cases.

> Anyway, we may need something similar for other architectures with mmiowb
> implementations:
> 
>   blackfin
>   frv
>   ia64
>   mips
>   sh
> 
> so I'm anticipating some more discussion when I try to push that patch :)
> 
> Cheers,
> 
> Will


