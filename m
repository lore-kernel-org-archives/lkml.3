Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbaB0D3E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 22:29:04 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:33997 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbaB0D3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 22:29:00 -0500
MIME-Version: 1.0
In-Reply-To: <530E0AD3.7040909@hurleysoftware.com>
References: <1393072281-5814-1-git-send-email-peter@hurleysoftware.com>
	<CA++bM2uq=vRo20FTMWvkDau+-X7h0+KU3n4Av7ef895mQKr5fA@mail.gmail.com>
	<530E0AD3.7040909@hurleysoftware.com>
Date: Thu, 27 Feb 2014 11:28:59 +0800
Message-ID: <CA++bM2vjzFOt5wmc=TQ1XMvRCwgnpq6=PKpex=GGZBK_-M6=mw@mail.gmail.com>
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
        Alan Cox <gnomes@lxorguk.ukuu.org.uk>, stable@vger.kernel.org,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>, feng.tang@intel.com,
        bin.yang@intel.com, alek.du@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

2014-02-26 23:40 GMT+08:00 Peter Hurley <peter@hurleysoftware.com>:
> [ +cc linux-bluetooth ]

>>>
>>> Historically, low_latency was used to force wake-up the reading
>>> process rather than wait for the next scheduler tick. The
>>> effect was to trim multiple milliseconds of latency from
>>> when the process would receive new data.
>>>
>>> Recent tests [1] have shown that the reading process now receives
>>> data with only 10's of microseconds latency without low_latency set.
>>
>>
>> The 10's of miscroseconds is ok for 115200 bps like device, but it may
>> hurt the high speed device like Bluetooth which runs at 3M/4M bps or
>> higher.
>
>
> The tests were run at 400Mbps, so 3Mbps or 4Mbps is not a problem
> (but I think you may be confusing throughput with latency).

I wrote the serial driver for intel mid platforms which are widely used
in current smart phones, so I guess I know what I'm talking :)

Our test and customer test cover both the performance and latency.
say like transferring  2 GB file while using BT A2DP to playing music.

Also I heard there is some app which will do real time void/data
exchange with paired bluetooth, here microseconds really means
something.

>
> FWIW, two things affected the latency times of those particular tests;
> 1) the kernel firewire subsystem handles rx data in a tasklet (so not
>    directly from IRQ) which negatively affected the latency reported, and
> 2) the ftrace instrumentation is not free and there are several traces per
> rx.
>
> If you look carefully at the test trace data, you'll see that the timestamps
> from tty_flip_buffer_push() of the rx data to n_tty_write() of the
> response averages _~11us_; this is the measured latency from tty driver
> receiving the rx data to reading of that data *and* the process
> response (which comes back up through several tty locks).
>
> Naturally, in mainline kernel, the scheduler load will affect the
> measured latency *but that's true regardless of low_latency rx steering
> because the user-space process must still be woken to complete the read*.
>
>
>> More and more smartphones are using uart as the Bluetooth data
>> interface due to its low-pin, low-power feature, and many of them
>> are using HZ=100 kernel, I'm afraid this added delay may cause
>> some problem.
>
>
> Some hard data showing a real problem would help further this
> discussion; my belief is that 3.12+ w/o low_latency rx steering
> will outperform 3.11- w/ low_latency rx steering in every test.

As for measurements, I guess it should cover 2 parts:
1. the performance, like the BT file transfer data rate
2. the latency, like the real time BT communication

I'll try to get some test data soon. Also I'm wondering what devices
have you tested? regarding these 2 points.

>
> I'm glad to hear that the Bluetooth uart interface is getting
> some use; that means someone will soon be fixing the hard lockup
> in hci_uart_tx_wakeup() reported here:

I'm not very familiar with the BT devices on our platforms, but most
of them are not using the in-kernel BT driver, some just use the
n_tty ldisc and the raw data, some use their own ldisc driver.

Thanks,
Feng
