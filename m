Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbaEOBPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 21:15:55 -0400
Received: from ns.horizon.com ([71.41.210.147]:19239 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752143AbaEOBPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 21:15:53 -0400
Date: 14 May 2014 21:15:51 -0400
Message-ID: <20140515011551.26781.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: hpa@zytor.com, linux@horizon.com, pavel@ucw.cz
Subject: Re: [PATCH v2 1/3] lib/crc7: Shift crc7() output left 1 bit
Cc: arik@wizery.com, david.gnedt@davizone.at, eliad@wizery.com,
        jan.nikitenko@gmail.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-wireless@vger.kernel.org,
        linville@tuxdriver.com, luca@coelho.fi, tony@atomide.com
In-Reply-To: <53740C42.3000906@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> If the whole point of this is to use it for MMC/SD cards, why not just
> also subsume the OR 1 and call it crc7_mmc() or something like that.
>
> (Which I'm all for doing... I don't know of any other crc7 users.)

You'll find all users in my patch series.  2/3 updates the MMC
card, while 3/3 hits drivers/net/wireless/ti/wl1251/spi.c and
drivers/net/wireless/ti/wlcore/spi.c (which I'm pretty sure aren't
MMC/SPI cards).

Now, it turns out that they *also* set the lsbit (calling it
WSPI_INIT_CMD_END).  However, it's not possible to put that into the CRC
table (it would mess up all bytes but the last), so an explicitly coded
"| 1" is required at the end.  Thic ends up being no saving at all to
execution path length, and only moves one instruction from three drivers
to shared code.  While making it harder to read the drivers.

A microscopic space saving (if and only if you have more than one of these
drivers loaded) and no performance improvement didn't seem worth it to me.
