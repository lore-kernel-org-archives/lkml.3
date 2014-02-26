Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbaBZFL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 00:11:29 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:64407 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbaBZFLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 00:11:23 -0500
MIME-Version: 1.0
In-Reply-To: <1393072281-5814-1-git-send-email-peter@hurleysoftware.com>
References: <1393072281-5814-1-git-send-email-peter@hurleysoftware.com>
Date: Wed, 26 Feb 2014 13:11:21 +0800
Message-ID: <CA++bM2uq=vRo20FTMWvkDau+-X7h0+KU3n4Av7ef895mQKr5fA@mail.gmail.com>
Subject: Re: [PATCH] tty: Fix low_latency BUG
From: Feng Tang <feng.79.tang@gmail.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        Beat Bolli <bbolli@ewanet.ch>, Pavel Roskin <proski@gnu.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, David Sterba <dsterba@suse.cz>,
        Felipe Balbi <balbi@ti.com>, Grant Edwards <grant.b.edwards@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Hal Murray <murray+fedora@ip-64-139-1-69.sjc.megapath.net>,
        Alan Cox <gnomes@lxorguk.ukuu.org.uk>, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

2014-02-22 20:31 GMT+08:00 Peter Hurley <peter@hurleysoftware.com>:
> The user-settable knob, low_latency, has been the source of
> several BUG reports which stem from flush_to_ldisc() running
> in interrupt context. Since 3.12, which added several sleeping
> locks (termios_rwsem and buf->lock) to the input processing path,
> the frequency of these BUG reports has increased.
>
> Note that changes in 3.12 did not introduce this regression;
> sleeping locks were first added to the input processing path
> with the removal of the BKL from N_TTY in commit
> a88a69c91256418c5907c2f1f8a0ec0a36f9e6cc,
> 'n_tty: Fix loss of echoed characters and remove bkl from n_tty'
> and later in commit 38db89799bdf11625a831c5af33938dcb11908b6,
> 'tty: throttling race fix'. Since those changes, executing
> flush_to_ldisc() in interrupt_context (ie, low_latency set), is unsafe.
>
> However, since most devices do not validate if the low_latency
> setting is appropriate for the context (process or interrupt) in
> which they receive data, some reports are due to misconfiguration.
> Further, serial dma devices for which dma fails, resort to
> interrupt receiving as a backup without resetting low_latency.
>
> Historically, low_latency was used to force wake-up the reading
> process rather than wait for the next scheduler tick. The
> effect was to trim multiple milliseconds of latency from
> when the process would receive new data.
>
> Recent tests [1] have shown that the reading process now receives
> data with only 10's of microseconds latency without low_latency set.

The 10's of miscroseconds is ok for 115200 bps like device, but it may
hurt the high speed device like Bluetooth which runs at 3M/4M bps or
higher.

More and more smartphones are using uart as the Bluetooth data
interface due to its low-pin, low-power feature, and many of them
are using HZ=100 kernel, I'm afraid this added delay may cause
some problem.

Thanks,
Feng
