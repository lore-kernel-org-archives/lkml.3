Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbaBDMmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 07:42:53 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:59202 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753738AbaBDMmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 07:42:51 -0500
Message-ID: <52F0E043.3090205@hurleysoftware.com>
Date: Tue, 04 Feb 2014 07:42:43 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: Pavel Roskin <proski@gnu.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: serial8250: bogus low_latency destabilizes kernel, need sanity
 check
References: <20140113193547.47b7a646@IRBT4585>	<20140114120811.648571ea@alan.etchedpixels.co.uk>	<20140114112457.q54ujbz9c444s040-cebfxv@webmail.spamcop.net>	<52ED0E0F.5050300@hurleysoftware.com> <20140203111040.4cafe560@alan.etchedpixels.co.uk>
In-Reply-To: <20140203111040.4cafe560@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2014 06:10 AM, One Thousand Gnomes wrote:
> On Sat, 01 Feb 2014 10:09:03 -0500
> Peter Hurley <peter@hurleysoftware.com> wrote:
>
>> On 01/14/2014 11:24 AM, Pavel Roskin wrote:
>>> Hi Alan,
>>>
>>> Quoting One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>:
>>>
>>>>> Maybe we should unset the low_latency flag as soon as DMA fails?  There
>>>>> are two flags, one is state->uart_port->flags and the other is
>>>>> port->low_latency.  I guess we need to unset both.
>>>>
>>>> Well low latency and DMA are pretty much exclusive in the real world so
>>>> probably DMA ports shouldn't allow low_latency to be set at all in DMA
>>>> mode.
>>>
>>> That's a useful insight.  I assumed exactly the opposite.
>>
>> The meaning of low_latency has migrated since 2.6.28
>
> Not really. The meaning of low latency was always "get the turn around
> time for command/response protocols down as low as possible". DMA driven
> serial usually reports a transfer completion on a watermark or a timeout,
> so tends to work very badly within the Linux definition of 'low latency'
> for tty.
>
> What it does has certainly changed but thats implementation detail.

I meant the meaning as interpreted by the kernel, not the ideal meaning nor
its original intent.

>> Perhaps we should unconditionally unset low_latency (or remove it entirely).
>> Real low latency can be addressed by using the -RT kernel.
>
> Just saying "use -RT" would be a regression and actually hurt quite a few
> annoying "simple protocol" using tools for all sorts of control systems.
> We are talking about milliseconds not microseconds here.

Ok, fair enough.

[Although my gut feeling is that nominal overhead is more like sub 10 usecs,
  and only when the scheduler is I/O-bound does worst case get near 1 msec.]

> The expected behaviour in low_latency is probably best described as
>
> data arrives
> processed
> wakeup

low_latency cannot guarantee that data will be processed, only that
it will not wait.

Examples:
  1) SLIP is changing the mtu size. In this case, data will be dropped
     because, since the net queue is stopped, no data is taken up but any
     data passed to the receive_buf() is assumed to have been consumed.
  2) tty buffers are being flushed. There may or may not be any data to
     process but there's no way to know without waiting.
  3) termios is changing/has been changed. Depending on the line
     discipline, data may or may not be processed until termios changes
     complete.

etc.

> and to avoid the case of
>
> data arrives
> queued for back end
> [up to 10mS delay, but typically 1-2mS]
> processed
> wakeup
>
>
> which multipled over a 50,000 S record download is a lot of time
>
> Everything else is not user visible so can be changed freely to get that
> assumption to work (including ending up not needing it in the first
> place).
>
> Getting tty to the point everything but N_TTY canonical mode is a fast
> path would probably eliminate the need nicely - I don't know of any use
> cases that expect ICANON, ECHO or I*/O* processing for low latency.

Easier said than done.

For example, what happens if termios is changing?
Presumably, data cannot be processed at that time. So the line discipline
returns early without having processed the data. [For example, the
receive_buf() path could use trylocks and abort, rather than waiting.]

But then, what restarts the attempt to process the data and can that wait?

Similarly for throttling. Unthrottling may be in progress; and even though
in progress, the condition that prompted the unthrottle may no longer be
true and throttling must be done. Ok, it can't happen right
now, but then when?

Regards,
Peter Hurley


