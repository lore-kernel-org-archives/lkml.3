Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab3HQURJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 16:17:09 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:40104 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab3HQURH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 16:17:07 -0400
Date: Sat, 17 Aug 2013 13:17:02 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-mtd@lists.infradead.org, Marek Vasut <marex@denx.de>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 2/4] mtd: m25p80: make CONFIG_M25PXX_USE_FAST_READ safe
 to enable
Message-ID: <20130817201702.GD11210@norris.computersforpeace.net>
References: <1376302946-11534-1-git-send-email-s.hauer@pengutronix.de>
 <1376302946-11534-3-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376302946-11534-3-git-send-email-s.hauer@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 12:22:24PM +0200, Sascha Hauer wrote:
> This patch adds a flag to struct flash_info indicating that
> fast_read is not supported. This now gives the following logic
> when determing whether to enable fastread:
> 
> 1) enable fast_read if device node contains m25p,fast-read
> 2) enable fast_read unconditionally if forced in Kconfig
> 3) Disable fast_read if the chip does not support it

This logic is either unclear or incorrect.

> This makes enabling CONFIG_M25PXX_USE_FAST_READ a safe option
> since we no longer enable the fast_read option unconditionally.

This statement seems to contradict 2 above, depending on the reading
(how can 2 enable "unconditionally", yet CONFIG_..._FAST_READ "no longer
enable[s] ... unconditionally"?).

The problem I have with this description is that it is assuming that
1, 2, and 3 are applied sequentially, so that later items in the
sequence have higher precedence. So it's describing code ordering, not
really logic. And statement 3 weakens the "unconditionally" of 2.

And to avoid simply complaining, I propose an alternative explanation:

  If the flash chip does not support fast_read, then disable it.
  Otherwise:
  1) enable fast_read if device node contains m25p,fast-read
  2) enable fast_read if forced in Kconfig

If we correct this description, then:

  Acked-by: Brian Norris <computersforpeace@gmail.com>

I can edit the patch and push the whole thing if this is acceptable.

One related question (not required for this series): do we even need
Kconfig M25PXX_USE_FAST_READ any more? Are there any SPI controllers
that can't use FAST_READ? Or perhaps if they have a slow clock, it's
preferable to use normal read?

If there are no restrictions from the controller side, I think this
NO_FR flag gives enough information to determine everything at runtime,
not compile-time.

Brian
