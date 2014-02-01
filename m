Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933201AbaBAPJN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 10:09:13 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:57374 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751321AbaBAPJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 10:09:12 -0500
Message-ID: <52ED0E0F.5050300@hurleysoftware.com>
Date: Sat, 01 Feb 2014 10:09:03 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: serial8250: bogus low_latency destabilizes kernel, need sanity
 check
References: <20140113193547.47b7a646@IRBT4585>	<20140114120811.648571ea@alan.etchedpixels.co.uk> <20140114112457.q54ujbz9c444s040-cebfxv@webmail.spamcop.net>
In-Reply-To: <20140114112457.q54ujbz9c444s040-cebfxv@webmail.spamcop.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 11:24 AM, Pavel Roskin wrote:
> Hi Alan,
>
> Quoting One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>:
>
>>> Maybe we should unset the low_latency flag as soon as DMA fails?  There
>>> are two flags, one is state->uart_port->flags and the other is
>>> port->low_latency.  I guess we need to unset both.
>>
>> Well low latency and DMA are pretty much exclusive in the real world so
>> probably DMA ports shouldn't allow low_latency to be set at all in DMA
>> mode.
>
> That's a useful insight.  I assumed exactly the opposite.

The meaning of low_latency has migrated since 2.6.28

Although it used to mean 'process the input immediately even in
interrupt context', it has become 'the device doesn't receive data
in interrupt context so process the data now'.

> But how should a real low_latency device work?

A low_latency device does not receive data in interrupt context;
ie., tty_flip_buffers() cannot be called from an irq handler
or with interrupts disabled.

> Are they supported by 8250_core?

yes

> Do they have hard IRQs?

possibly but not for rx

> Are those IRQs handled by serial8250_handle_irq()?

possibly, but again not for rx

> If DMA is not used, then serial8250_rx_chars() is the only way to receive data.
> But serial8250_rx_chars() calls tty_flip_buffer_push() unconditionally,
> and the later should not be called from the IRQ context for low_latency devices,
> if the comment about it is to be trusted.

Exactly.

Perhaps we should unconditionally unset low_latency (or remove it entirely).
Real low latency can be addressed by using the -RT kernel.

Regards,
Peter Hurley


