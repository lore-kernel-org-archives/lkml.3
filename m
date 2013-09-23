Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab3IWXIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 19:08:12 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:51963 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab3IWXIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 19:08:10 -0400
MIME-Version: 1.0
In-Reply-To: <5240AF20.8030301@wwwdotorg.org>
References: <1379528245-6283-1-git-send-email-rklein@nvidia.com>
	<52408DC8.3020407@wwwdotorg.org>
	<52409B1E.3030405@nvidia.com>
	<52409D63.3020909@wwwdotorg.org>
	<5240AC3A.9060206@nvidia.com>
	<5240AF20.8030301@wwwdotorg.org>
Date: Mon, 23 Sep 2013 16:08:09 -0700
Message-ID: <CA+7tXiiNMwyQh9sCsW4Qkid9Tn8RTcQ-uUmNse+kK-PZro1pyQ@mail.gmail.com>
Subject: Re: [RESEND] spi/tegra114: Correct support for cs_change
From: Trent Piepho <tpiepho@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Rhyland Klein <rklein@nvidia.com>, Simon Glass <sjg@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 2:14 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>
> That sounds broken. Normally, shouldn't CS assert before a transaction,
> stay asserted during a transaction, then deassert after the transaction?
> It shouldn't rise and fall very quickly in between parts of the transaction.

That is normal, where a transaction is a spi_message made up of
multiple spi_transfers.  The cs_change bit for a transfer will insert
a de-asserted pulse after a transfer or leave CS de-asserted after the
last transfer.

>>>> need to generate a falling-edge to trigger the beginning of a SPI
>>>> transaction. Doing this write with the default value of SPI_COMMAND1
>>>> causes a brief rise and fall of CS, giving us our falling-edge.

I wonder, is the real problem that the spi layer allows CS to possibly
remain asserted between transactions to the same device?  Normally you
would expect it to be de-asserted at the end of a spi_message, but I
believe the Linux spi semantics are that it may or may not actually be
de-asserted at that time.  It only guarantees that is will be
de-asserted before a message to a different device starts.

I guess this is supposed to be an optimization.  Some drivers, like
gpio bit-banging, probably have a cost associated with any CS change.
Usually many messages in a row are to the same device.  Most devices
don't care if CS pulses between messages.  Thus not pulsing CS between
each message is faster.

>>
>> Otherwise, this logic allows us to skip the spi of COMMAND1 which would
>> normally be used to create the falling edge to start a new transaction,
>> leaving the previous one open for more transfers.
>
> This sounds like something the SPI core should be managing. If a driver
> is using the SPI bus to communicate with a device in a way that needs CS
> left active while outside a transaction, it shouldn't be possible for
> another driver to come along and communicate with another device before
> the first transaction is all complete. The bus should be locked.
> Allowing anything else could corrupt the protocol that required specific
> CS states outside the transaction.

If the transaction is one message, which can be multiple transfers and
multiple CS pulses, then the spi core always does it atomically.  The
limitation is the driver can't get the result of the transaction until
the entire transaction is finished.

If a driver needs to get part of a transaction to complete the rest,
e.g. read a 16-bit length from the device and then read that many
bytes, it can still be done.  It doesn't seem to be documented in
spi-summary, but the way to do this is with spi_bus_(un)lock() and
spi_(a)sync_locked() calls.  The driver must lock the bus, used the
_locked versions to issue spi_messages, then unlock when done.  This
should prevent another device on the bus from getting a messages, and
thus CS pulses, in the middle of the transaction.
