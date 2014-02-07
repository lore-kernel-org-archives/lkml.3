Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbaBGShQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 13:37:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44609 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaBGShN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 13:37:13 -0500
Date: Fri, 7 Feb 2014 18:37:07 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Daniel Santos <danielfsantos@att.net>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Daniel Santos <daniel.santos@pobox.com>,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH 3.5 36/88] spidev: fix hang when transfer_one_message
 fails
Message-ID: <20140207183707.GD5499@hercules>
References: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
 <1391772205-22239-37-git-send-email-luis.henriques@canonical.com>
 <52F5234B.404@att.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F5234B.404@att.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 12:17:47PM -0600, Daniel Santos wrote:
> On 02/07/2014 05:22 AM, Luis Henriques wrote:
> >3.5.7.30 -stable review patch.  If anyone has any objections, please let me know.
> >
> >------------------
> >
> >From: Daniel Santos <daniel.santos@pobox.com>
> >
> >commit e120cc0dcf2880a4c5c0a6cb27b655600a1cfa1d upstream.
> >
> >This corrects a problem in spi_pump_messages() that leads to an spi
> >message hanging forever when a call to transfer_one_message() fails.
> >This failure occurs in my MCP2210 driver when the cs_change bit is set
> >on the last transfer in a message, an operation which the hardware does
> >not support.
> >
> >Rationale
> >Since the transfer_one_message() returns an int, we must presume that it
> >may fail.  If transfer_one_message() should never fail, it should return
> >void.  Thus, calls to transfer_one_message() should properly manage a
> >failure.
> >
> >Fixes: ffbbdd21329f3 (spi: create a message queueing infrastructure)
> >Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
> >Signed-off-by: Mark Brown <broonie@linaro.org>
> >Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
> >---
> >  drivers/spi/spi.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> >diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> >index 1041cb8..40f528b 100644
> >--- a/drivers/spi/spi.c
> >+++ b/drivers/spi/spi.c
> >@@ -574,7 +574,9 @@ static void spi_pump_messages(struct kthread_work *work)
> >  	ret = master->transfer_one_message(master, master->cur_msg);
> >  	if (ret) {
> >  		dev_err(&master->dev,
> >-			"failed to transfer one message from queue\n");
> >+			"failed to transfer one message from queue: %d\n", ret);
> >+		master->cur_msg->status = ret;
> >+		spi_finalize_current_message(master);
> >  		return;
> >  	}
> >  }
> 
> This isn't a good patch and is reverted by a later patch. I'm not
> sure what the protocol for this is, but either skip this patch or
> include the one that reverts it.

Great, thanks.  I will drop this patch both in the 3.5 and 3.11
kernels.

Cheers,
--
Luis
