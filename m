Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbaCAMkh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 07:40:37 -0500
Received: from 212-186-180-163.dynamic.surfer.at ([212.186.180.163]:44496 "EHLO
	cgate.sperl.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbaCAMkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 07:40:35 -0500
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Mar 2014 07:40:35 EST
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH] spi: core: make zero length transfer valid again
From: Martin Sperl <kernel@martin.sperl.org>
In-Reply-To: <20140301041330.GO29849@sirena.org.uk>
Date: Sat, 1 Mar 2014 12:40:39 +0100
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, iivanov@mm-sol.com, gsi@denx.de,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <4D0588EB-C20C-4B24-B656-6175C2309352@martin.sperl.org>
References: <1393596196-8652-1-git-send-email-anemo@mba.ocn.ne.jp> <20140301041330.GO29849@sirena.org.uk>
To: Mark Brown <broonie@kernel.org>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.03.2014, at 05:13, Mark Brown <broonie@kernel.org> wrote:
> On Fri, Feb 28, 2014 at 11:03:16PM +0900, Atsushi Nemoto wrote:
>> Zero length transfer becomes invalid since
>> "spi: core: Validate length of the transfers in message" commit,
>> but it should be valid to support an odd device, for example, which
>> requires long delay between chipselect and the first transfer, etc.

This "odd-device support" described sounds a like a work-arround
for missing functionality in spi_core.

Would it not be better to implement this as a separate member -
say: spi_transfer.pre_transfer_delay_usecs - and keep the 
spi_transfer.len > 0 requirement? 
Initially maybe make it a warning to find those odd-devices...

I am not sure if it might make some bus-drivers more complicated
/inefficient just to support this zero length.

For example: the spi-bcm2835.c driver would do the following with a 
spi_transfer.len == 0 in the transfer_on method:
* enables SPI and wait for interrupt completion
* the above which will trigger an interrupt
** in the interrupt we find out that there is nothing to transfer,
    so we signal completion to transfer_one, so it may continue.
* the main transfer_one will get woken up
** it will do a delay_usecs
** it will handle CS_CHANGE
** it will disable SPI/reset HW again

So this implementation shows that there is a lot of inefficient 
overhead/delay just to trigger a delay...
This example requires 2 context switches (dwait for completion)
and its corresponding delays to get back to processing - so the
effective delay may be longer than 2ms just because of the delays 
introduced via the scheduler and thus way above the delay requested
by the transfer...

OK - for the spi-bcm2835.c driver the following in 
bcm2835_spi_start_transfer:
    if (xfer->len == 0) 
	return 0;
would solve it, but then we might implement this:
    if (xfer->pre_transfer_delay_usecs)
        udelay(xfer->pre_transfer_delay_usecs);
instead and be more explicit about this delay.

I guess other drivers will show similar code-artefacts and
some may even make the implicit assumption it has to be non-zero,
which would break functionality those odd devices.


Martin


