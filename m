Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaBZPkM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 10:40:12 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:42508 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752552AbaBZPkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 10:40:08 -0500
Message-ID: <530E0AD3.7040909@hurleysoftware.com>
Date: Wed, 26 Feb 2014 10:40:03 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Feng Tang <feng.79.tang@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        Beat Bolli <bbolli@ewanet.ch>, Pavel Roskin <proski@gnu.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, David Sterba <dsterba@suse.cz>,
        Felipe Balbi <balbi@ti.com>, Grant Edwards <grant.b.edwards@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Hal Murray <murray+fedora@ip-64-139-1-69.sjc.megapath.net>,
        Alan Cox <gnomes@lxorguk.ukuu.org.uk>, stable@vger.kernel.org,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>
Subject: Re: [PATCH] tty: Fix low_latency BUG
References: <1393072281-5814-1-git-send-email-peter@hurleysoftware.com> <CA++bM2uq=vRo20FTMWvkDau+-X7h0+KU3n4Av7ef895mQKr5fA@mail.gmail.com>
In-Reply-To: <CA++bM2uq=vRo20FTMWvkDau+-X7h0+KU3n4Av7ef895mQKr5fA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ +cc linux-bluetooth ]

Hi Feng,

On 02/26/2014 12:11 AM, Feng Tang wrote:
> Hi Peter,
>
> 2014-02-22 20:31 GMT+08:00 Peter Hurley <peter@hurleysoftware.com>:
>> The user-settable knob, low_latency, has been the source of
>> several BUG reports which stem from flush_to_ldisc() running
>> in interrupt context. Since 3.12, which added several sleeping
>> locks (termios_rwsem and buf->lock) to the input processing path,
>> the frequency of these BUG reports has increased.
>>
>> Note that changes in 3.12 did not introduce this regression;
>> sleeping locks were first added to the input processing path
>> with the removal of the BKL from N_TTY in commit
>> a88a69c91256418c5907c2f1f8a0ec0a36f9e6cc,
>> 'n_tty: Fix loss of echoed characters and remove bkl from n_tty'
>> and later in commit 38db89799bdf11625a831c5af33938dcb11908b6,
>> 'tty: throttling race fix'. Since those changes, executing
>> flush_to_ldisc() in interrupt_context (ie, low_latency set), is unsafe.
>>
>> However, since most devices do not validate if the low_latency
>> setting is appropriate for the context (process or interrupt) in
>> which they receive data, some reports are due to misconfiguration.
>> Further, serial dma devices for which dma fails, resort to
>> interrupt receiving as a backup without resetting low_latency.
>>
>> Historically, low_latency was used to force wake-up the reading
>> process rather than wait for the next scheduler tick. The
>> effect was to trim multiple milliseconds of latency from
>> when the process would receive new data.
>>
>> Recent tests [1] have shown that the reading process now receives
>> data with only 10's of microseconds latency without low_latency set.
>
> The 10's of miscroseconds is ok for 115200 bps like device, but it may
> hurt the high speed device like Bluetooth which runs at 3M/4M bps or
> higher.

The tests were run at 400Mbps, so 3Mbps or 4Mbps is not a problem
(but I think you may be confusing throughput with latency).

FWIW, two things affected the latency times of those particular tests;
1) the kernel firewire subsystem handles rx data in a tasklet (so not
    directly from IRQ) which negatively affected the latency reported, and
2) the ftrace instrumentation is not free and there are several traces per rx.

If you look carefully at the test trace data, you'll see that the timestamps
from tty_flip_buffer_push() of the rx data to n_tty_write() of the
response averages _~11us_; this is the measured latency from tty driver
receiving the rx data to reading of that data *and* the process
response (which comes back up through several tty locks).

Naturally, in mainline kernel, the scheduler load will affect the
measured latency *but that's true regardless of low_latency rx steering
because the user-space process must still be woken to complete the read*.

> More and more smartphones are using uart as the Bluetooth data
> interface due to its low-pin, low-power feature, and many of them
> are using HZ=100 kernel, I'm afraid this added delay may cause
> some problem.

Some hard data showing a real problem would help further this
discussion; my belief is that 3.12+ w/o low_latency rx steering
will outperform 3.11- w/ low_latency rx steering in every test.

I'm glad to hear that the Bluetooth uart interface is getting
some use; that means someone will soon be fixing the hard lockup
in hci_uart_tx_wakeup() reported here:

http://www.spinics.net/lists/linux-serial/msg11529.html

Regards,
Peter Hurley
