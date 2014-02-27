Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbaB0Dti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 22:49:38 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:48611 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbaB0Dth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 22:49:37 -0500
MIME-Version: 1.0
In-Reply-To: <530E9BEF.8080601@cn.fujitsu.com>
References: <1393429360-4344-1-git-send-email-clancy.kieran@gmail.com> <530E9BEF.8080601@cn.fujitsu.com>
From: Kieran Clancy <clancy.kieran@gmail.com>
Date: Thu, 27 Feb 2014 14:19:05 +1030
Message-ID: <CAGf84Q+Xd9EUjOEMe3+EMRhdPaFgnAjNDOoPZmf=gn8mi=FhWw@mail.gmail.com>
Subject: Re: [PATCH] ACPI / EC: Clear stale EC events on Samsung systems
To: Li Guang <lig.fnst@cn.fujitsu.com>
Cc: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lan Tianyu <tianyu.lan@intel.com>,
        Juan Manuel Cabo <juanmanuel.cabo@gmail.com>,
        Dennis Jansen <dennis.jansen@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 12:29 PM, Li Guang <lig.fnst@cn.fujitsu.com> wrote:
>> +#define ACPI_EC_CLEAR_MAX      20      /* Maximum number of events to
>> query
>> +                                        * when trying to clear the EC */
>>
>
>
> 20 is enough?
> the query index is length of a byte.

On my machine, 8 seems to be enough, so 20 seems to be a conservative
maximum. Just reading your other email, maybe we should set this to
32? or 40? 100?

If it's not enough, hopefully anyone seeing bugs will notice the
warning "maximum of X stale EC events cleared".

Here's what happens if I plug/replug the AC lots of times (more than
8) during suspend:

[ 8807.019800] ACPI : EC: ---> status = 0x29
[ 8807.019804] ACPI : EC: ---> data = 0x66
[ 8807.020790] ACPI : EC: ---> status = 0x29
[ 8807.020793] ACPI : EC: ---> data = 0x66
[ 8807.021793] ACPI : EC: ---> status = 0x29
[ 8807.021798] ACPI : EC: ---> data = 0x66
[ 8807.022831] ACPI : EC: ---> status = 0x29
[ 8807.022834] ACPI : EC: ---> data = 0x66
[ 8807.023788] ACPI : EC: ---> status = 0x29
[ 8807.023792] ACPI : EC: ---> data = 0x66
[ 8807.024787] ACPI : EC: ---> status = 0x29
[ 8807.024791] ACPI : EC: ---> data = 0x66
[ 8807.025787] ACPI : EC: ---> status = 0x29
[ 8807.025790] ACPI : EC: ---> data = 0x66
[ 8807.026787] ACPI : EC: ---> status = 0x29
[ 8807.026790] ACPI : EC: ---> data = 0x66
[ 8807.027786] ACPI : EC: ---> status = 0x09
[ 8807.027790] ACPI : EC: ---> data = 0x00
[ 8807.027792] ACPI : EC: 8 stale EC events cleared

Note that most of these have SCI_EVT set, but the OS is not notified
according to ACPI specs (seemingly because these events happened
during sleep).

The _Q66 method in my DSDT, is:

                        P8XH (Zero, 0x66)
                        If (LEqual (B1EX, One))
                        {
                            Notify (BAT1, 0x80)
                        }

So, basically, this is supposed to notify that the battery (BAT1 =
PNP0C0A) has changed state, but they are stale events so we don't run
the handlers.

>> +static int EC_FLAGS_CLEAR_ON_RESUME; /* EC should be polled on
>> boot/resume */
>
> seems name is implicit, what about EC_FLAGS_QEVENT_CLR_ON_RESUME?
> seems too long :-)

In my mind this is referring to the function name (acpi_ec_)clear.
Perhaps we could just make the connection more explicit in the
comment:

/* needs acpi_ec_clear() on boot/resume */

Not sure if this is better?

>> +       /* Some hardware may need the EC to be cleared before use */
>
> description is implicit, should specify what we clear is Q event, not EC.

Are Q events the only thing we can get from the EC data port? I've
read the relevant parts of the ACPI spec and I can't say I am 100%
sure.

Thank you for your advice,
Kieran.
