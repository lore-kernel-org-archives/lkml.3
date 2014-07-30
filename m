Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbaG3M4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:56:40 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44873 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754173AbaG3M4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:56:37 -0400
Message-ID: <1406724992.4865.65.camel@jarvis>
Subject: Re: [PATCH v2 13/29] nios2: DMA mapping API
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ley Foon Tan <lftan@altera.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        lftan.linux@gmail.com, cltang@codesourcery.com
Date: Wed, 30 Jul 2014 16:56:32 +0400
In-Reply-To: <4843763.ps2D25LEeM@wuerfel>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
	 <1405413956-2772-14-git-send-email-lftan@altera.com>
	 <4843763.ps2D25LEeM@wuerfel>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-15 at 11:38 +0200, Arnd Bergmann wrote:
> More importantly: you do the same operation for both _for_cpu and _for_device.
> I assume your CPU can never do speculative cache prefetches, so it's not
> incorrect, but you do twice the number of invalidations and flushes that
> you need. 

That's not necessarily a correct assumption.  A lot of CPUs (x86, arm,
parisc) feel entitled to speculate provided they have a TLB entry.
Usually they don't just do it for a whim, so the cpu has to be doing
something to cause the speculation, like reading from an adjacent page.
However, for DMA you always have to assume the possibility (unless you
really, really know the architecture cannot).

Therefore the pattern should be (assuming your bus doesn't need some
kind of flush and all flushes are only for the CPU).

DMA_TO_DEVICE: flush before (_for_device) do nothing after (_for_cpu)

DMA_FROM_DEVICE: do nothing before (_for_device), invalidate after
(_for_cpu)

DMA_BIDIRECTIONAL: flush before (_for_device) and invalidate after
(_for_cpu).

James


