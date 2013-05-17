Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab3EQTIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 15:08:31 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:45738 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756147Ab3EQTIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 15:08:30 -0400
Message-ID: <5196802A.604@hurleysoftware.com>
Date: Fri, 17 May 2013 15:08:26 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: Add missing lock in n_tty_write()
References: <20130515105656.GI24440@8bytes.org> <5193A3B5.7010400@suse.cz> <20130515154753.GJ24440@8bytes.org> <5193D7E0.5010803@hurleysoftware.com> <20130515194835.GK24440@8bytes.org> <519415F3.6060103@hurleysoftware.com> <20130517114845.GA2602@8bytes.org>
In-Reply-To: <20130517114845.GA2602@8bytes.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2013 07:48 AM, Joerg Roedel wrote:
> Hi Peter,
>
> thanks for you explanations. They helped me to better understand what is
> happening now.
>
> On Wed, May 15, 2013 at 07:10:43PM -0400, Peter Hurley wrote:
>> On 05/15/2013 03:48 PM, Joerg Roedel wrote:
>
>> Agreed. Those functions look written for single-producer/single-consumer
>> i/o model. (That's why I asked about CONFIG_CONSOLE_POLL=y as well because
>> that doesn't look thread-safe either).
>
> Ok, I checked that. CONFIG_CONSOLE_POLL is on in that kernel.
>
>> Just to be clear here: there's a difference between a console driver
>> and a tty driver.
>>
>> The console driver's write() method is serialized with the global
>> console_lock() so parallel console writes are not possible.
>>
>> No such guarantee exists for the tty driver write() method, although it
>> probably wouldn't be difficult to provide that guarantee (since the
>> line discipline write() is already serialized by tty->atomic_write_lock).
>
> Okay, so it is safe to say that currently the drivers write() (and
> put_chars()) functions need to expect to be called concurrently and
> therefore they have to serialize themselves when they need it, right?

If only it were that simple :)

Yes, console write() and tty write() can be concurrent. However, the
console write() can also be _recursive_ wrt. tty write(). This can happen,
for example, if something oopses in the tty write() path.

If you review serial8250_console_write() in drivers/tty/serial/8250/8250_core.c,
you'll see how some of this is worked around.

But looking at this from a wider perspective, the goal should be
to limit the overlap as much as possible.

Regards,
Peter Hurley



