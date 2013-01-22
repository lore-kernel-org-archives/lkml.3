Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab3AVNSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 08:18:31 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:49063 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab3AVNS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 08:18:27 -0500
MIME-Version: 1.0
In-Reply-To: <CAOAMb1C=b2fXqKJKx1ZR7UD7n=c7qQoLnMgMmy2FXEubyP=dtw@mail.gmail.com>
References: <50efad8d.84fc440a.589e.ffff9546SMTPIN_ADDED_BROKEN@mx.google.com>
	<CACRpkdYSaFsastx-WWC7sBu8NteAc2hCDZMz4-yMc8+=2dyBVw@mail.gmail.com>
	<50f107aa.894e420a.596a.ffffe3f6SMTPIN_ADDED_BROKEN@mx.google.com>
	<CACRpkdaJd48WOzP_iURATb=c+V6==2-AB2Y9oFyh=E3oe1eT0Q@mail.gmail.com>
	<20130114002608.GV23505@n2100.arm.linux.org.uk>
	<CACRpkdbVPeva08nL_FP7qw0MeKLz6h40kPHAz_W95ZBGraOnpg@mail.gmail.com>
	<CAOAMb1BgcvBb6KHaZbwbh0rq8r1WfAtdCeZJexfaYoOwGfU7Sg@mail.gmail.com>
	<CAOAMb1BS6gvezeSrUTNJ--gGxCRL17AO8PHJ_eLrxzjOex7w1g@mail.gmail.com>
	<CAOAMb1C=b2fXqKJKx1ZR7UD7n=c7qQoLnMgMmy2FXEubyP=dtw@mail.gmail.com>
Date: Tue, 22 Jan 2013 14:18:27 +0100
Message-ID: <CACRpkdYt8CoF0_yrMkNE20fhKnRuG-=yxr2XsQKPgMWD=ehUNA@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: PL011: Add support for Rx DMA buffer polling
From: Linus Walleij <linus.walleij@linaro.org>
To: Chanho Min <chanho.min@lge.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>, Chanho Min <chanho0207@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 1:45 PM, Chanho Min <chanho.min@lge.com> wrote:

> In DMA support, The received data is not pushed to tty until the DMA buffer
> is filled. But some megabyte rate chips such as BT expect fast response and
> data should be pushed immediately. In order to fix this issue, We suggest
> the use of the timer for polling DMA buffer.
> In our test, no data loss occurred at high-baudrate as compared with interrupt-
> driven (We tested with 3Mbps).

So to enable this you put a poll rate > 0 into the new variable,
OK seems like it could work...

> - If poll timer is activated, We use consistent DMA mappings to avoid from
>   the frequent cache operation of the timer function. sg->coherency is used
>   to check if buffer is coherent.

Hm. We can begin like this but maybe we should later patch it to
make this the default unless it has performance impacts on our
systems.

> +++ b/include/linux/amba/serial.h
> @@ -203,6 +203,8 @@ struct amba_pl011_data {
>         bool (*dma_filter)(struct dma_chan *chan, void *filter_param);
>         void *dma_rx_param;
>         void *dma_tx_param;
> +       unsigned int dma_rx_poll_rate;
> +       unsigned int dma_rx_poll_timeout;
>          void (*init) (void);
>         void (*exit) (void);
>  };

Maybe this is a good opportunity to add some kerneldoc above
this struct so as to help platform implementers. It will invariably
be reused by Device Tree binding authors later on...

Yours,
Linus Walleij
