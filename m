Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbaKYWHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 17:07:42 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:49964 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaKYWHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 17:07:40 -0500
MIME-Version: 1.0
In-Reply-To: <20141122181229.GB9698@katana>
References: <1416326695-13083-1-git-send-email-wsa@the-dreams.de>
	<1416326695-13083-3-git-send-email-wsa@the-dreams.de>
	<CAOY=C6FSXWn2AKn9gp0oU69U8VkkyJAE7MMUTZsToy0P_Tf6AA@mail.gmail.com>
	<20141122181229.GB9698@katana>
Date: Tue, 25 Nov 2014 23:07:38 +0100
Message-ID: <CAOY=C6F6TMyeDvNneBV6K5hVjoG+qk-1Y_R3oJkEiGxhLOoQ0A@mail.gmail.com>
Subject: Re: [PATCH 2/3] i2c: slave-eeprom: add eeprom simulator driver
From: Stijn Devriendt <highguy@gmail.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, Jean Delvare <jdelvare@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2014 at 7:12 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
> Hi,
>
> Please quote only relevant parts of the message (like I did). This
> improves readability a lot.
>

My bad, will minimize the overhead in the future.

>>
>> Would it make sense to have:
>> WRITE_START
>> WRITE_NEXT
>> WRITE_STOP
>> WRITE_REPEAT_START
>> READ_START
>> READ_NEXT
>> READ_STOP
>> READ_REPEAT_START
>>
>> Some devices may want different behavior for subsequent
>> reads when they are separate transactions, compared to
>> a single larger transaction.
>
> This can all be handled with I2C_SLAVE_STOP.
>

I think the goal is probably better covered by Uwe's idea for
returning a buffer. See below...

>> e.g. a single transaction may wraparound inside a >8bit
>> register (e.g. for 16bit: msb, lsb, msb, lsb, ...), but step
>> to the next register when a separate read/write is issued.
>> Alternatively, a WRITE/READ_NEXT may be implemented
>> more efficiently. This may not matter for current systems
>> compared to the low-frequency bus, but who knows what
>> IoT devices may bring to the table.
>
> Let's start simple until we have more use cases. WRITE_NEXT may be
> useful when you have an internal u8 pointer to be set before actually
> sending data, but already less useful if this is u16. Also, slaves may
> decide to handle stops at unexpected places differently. Furthermore, my
> feeling is that slave drivers will be more robust if they handle those
> simple primitives properly.
>

I think usable semantics could be that a slave driver can indicate at any
point during an I2C read transaction that the next X bytes should be
returned from a buffer and for a write transaction, that the next X bytes
should be buffered before passed on to the driver. When the transaction
ends or the adapter reaches the end of the buffer, it indicates this to
the driver which can then either cleanup or otherwise act accordingly.
For the EEPROM driver, this could mean that after the address is received,
the driver can pass the pointer + remaining size and have the adapter
driver take care of transmit. Upon end-of-buffer, it could just handle the
wraparound and let the adapter take care of the rest.

But as you say, this can be added later on when the need arises.

> What I could imagine, though, is that somewhen the eeprom simulator will
> be able to get data via other means than the shared memory, maybe via
> some callback. Then, the callback really only has to deal with "read
> this byte" or "write that byte" while for the outer world we have a
> proper well-known EEPROM like I2C interface.
>
> That being said, the list of I2C_SLAVE_* events is extensible, of
> course. Though, I rather see low-level stuff there like "General Call
> Adress received".
>
>>
>> Also, behavior may be different for repeat start versus
>> stop/start, although a repeat start could be a start
>> without a previous stop as well...
>
> IMO a repeated start is to ensure that two messages arrive at the slave
> without interruption from another master. I can't think why a slave
> should know which type of start that was. In fact, if it does that would
> raise an eyebrow for me. Do you have an example?
>

No, I'll have to pass on that one. Plenty of odd I2C behavior, but that's
not one of them. You're right on repeat start, so it would be quite
erratic behavior. But even if, it can probably be added later on.

>> Of course, if an I2C adapter cannot distinguish these
>> events, this is probably a futile attempt at adding
>> semantics that will silently break depending on the
>> actual hardware/driver used.
>
> That as well. I have not seen an I2C adapter which could provide this
> information so far.
>

Just checked components we're using and stop/repeated-start both
transition into the same state.

Regards,
Stijn

> Thanks,
>
>    Wolfram
>
