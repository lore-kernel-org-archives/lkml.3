Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbaAVXZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 18:25:14 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:40331 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbaAVXZM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 18:25:12 -0500
MIME-Version: 1.0
In-Reply-To: <20140122164115.211a819d@ipc1.ka-ro>
References: <1389608739-10945-1-git-send-email-LW@KARO-electronics.de>
	<20140122150959.78cf2827@ipc1.ka-ro>
	<CAC5umyhC+9zwwX7Mswo2uAc0pFqp7Np1D+nFwr7Y3TS3OLT6-A@mail.gmail.com>
	<20140122164115.211a819d@ipc1.ka-ro>
Date: Thu, 23 Jan 2014 08:25:11 +0900
Message-ID: <CAC5umyjU5xoFJ1piLoWGciT=Y+H3-nqr38FGVMR-vdKhkOO-Qw@mail.gmail.com>
Subject: Re: [PATCH] mtd: mtd_oobtest: fix verify errors due to incorrect use
 of prandom_bytes_state()
From: Akinobu Mita <akinobu.mita@gmail.com>
To: =?ISO-8859-1?Q?Lothar_Wa=DFmann?= <LW@karo-electronics.de>
Cc: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Shijie <b32955@freescale.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014/1/23 Lothar Waﬂmann <LW@karo-electronics.de>:
> Hi,
>
> Akinobu Mita wrote:
>> 2014/1/22 Lothar Waﬂmann <LW@karo-electronics.de>:
>> > Hi,
>> >
>> > Is anyone taking care of this?
>> >
>> > Lothar Waﬂmann wrote:
>> >> When using prandom_bytes_state() it is critical to use the same block
>> >> size in all invocations that are to produce the same random sequence.
>> >> Otherwise the state of the PRNG will be out of sync if the blocksize
>> >> is not divisible by 4.
>> >> This leads to bogus verification errors in several tests which use
>> >> different block sizes to initialize the buffer for writing and
>> >> comparison.
>> >>
>> >> Signed-off-by: Lothar Waﬂmann <LW@KARO-electronics.de>
>> >> ---
>> >>  drivers/mtd/tests/oobtest.c |   14 ++++++++++++--
>> >>  1 files changed, 12 insertions(+), 2 deletions(-)
>> >>
>> >> diff --git a/drivers/mtd/tests/oobtest.c b/drivers/mtd/tests/oobtest.c
>> >> index 2e9e2d1..72c7359 100644
>> >> --- a/drivers/mtd/tests/oobtest.c
>> >> +++ b/drivers/mtd/tests/oobtest.c
>> >> @@ -213,8 +213,15 @@ static int verify_eraseblock_in_one_go(int ebnum)
>> >>       int err = 0;
>> >>       loff_t addr = ebnum * mtd->erasesize;
>> >>       size_t len = mtd->ecclayout->oobavail * pgcnt;
>> >> +     int i;
>> >> +
>> >> +     for (i = 0; i < pgcnt; i++)
>> >> +             prandom_bytes_state(&rnd_state, &writebuf[i * use_len],
>> >> +                             use_len);
>> >> +     if (len % use_len)
>> >> +             prandom_bytes_state(&rnd_state, &writebuf[i * use_len],
>> >> +                             len % use_len);
>> >>
>> >> -     prandom_bytes_state(&rnd_state, writebuf, len);
>> >>       ops.mode      = MTD_OPS_AUTO_OOB;
>> >>       ops.len       = 0;
>> >>       ops.retlen    = 0;
>>
>> I would rather fix the use of prandom_bytes_state() in write_eraseblock()
>> than fix in verify_eraseblock_in_one_go().
>>
> Why and how?

I thought that it could reduce calls of prandom_bytes_state() and
it makes code simpler than increasing calls.

> write_whole_device() (which calls write_eraseblock()) is used multiple
> times with different verification methods (all blocks in one go or each
> block individually).
> If prandom_state_bytes() in write_eraseblock() would be changed, that
> function would have to know, how the block are going to be checked
> lateron to know how to set up the writebuffer.

Instead of calling prandom_bytes_state() in the for loop in
write_eraseblock(), call prandom_bytes_state() at once before going
into the loop and use correct offset in writebuf in the loop.
Although, we also need to fix verify_eraseblock() in the same way.

Doesn't that fix this problem?
