Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502AbaFHUyh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 16:54:37 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:40687 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768AbaFHUy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 16:54:28 -0400
MIME-Version: 1.0
In-Reply-To: <20140608203007.GA6265@roeck-us.net>
References: <1402174021-25857-1-git-send-email-fabio.baltieri@gmail.com>
 <20140608201600.GA30953@roeck-us.net> <20140608203007.GA6265@roeck-us.net>
From: Fabio Baltieri <fabio.baltieri@gmail.com>
Date: Sun, 8 Jun 2014 21:54:07 +0100
X-Google-Sender-Auth: 3UZtL2sWGipp_-kB1cRar_gzWu4
Message-ID: <CABkP77cnLvvQH-M45xJ14ny8x_z3DWPPj_zi9xtABQpvsMr4tw@mail.gmail.com>
Subject: Re: [lm-sensors] [PATCH] hwmon: (ina2xx) Change register cache to signed
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, Lothar Felten <l-felten@ti.com>,
        lm-sensors@lm-sensors.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 8, 2014 at 9:30 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> On Sun, Jun 08, 2014 at 01:16:00PM -0700, Guenter Roeck wrote:
>> On Sat, Jun 07, 2014 at 09:47:01PM +0100, Fabio Baltieri wrote:
>> > All devices supported by the ina2xx driver are bidirectional and reports
>> > the measured value as a signed 16 bit, but the current driver
>> > implementation caches the number as an u16, leading to an incorrect sign
>> > extension when reporting to the userspace in ina2xx_get_value().
>> >
>> > This patch fixes the problem by using a s16 instead, and has been tested
>> > on an INA219.
>> >
>> > Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
>>
>> Applied.
>>
> Actually, no, this won't work. The statement above is only correct for current
> and shunt voltage measurements, but not for power measurements and not for bus
> voltage measurements. Changing the register to s16 won't help; conversion needs
> to be done in ina2xx_get_value() for shunt voltage and current measurement only.
> Otherwise we just move the bug from current/shunt voltage measurements to
> power / bus voltage measurements.
>
> Even more interesting, the power is supposed to be the product of Bus voltage
> and current, and the latter can be negative. However, the power register
> description does not suggest that the upper bit would be a sign bit. So there
> is some discrepancy in the datasheet, and we'll need some real-world data to
> understand if the upper power bit is signed or not.

Hi Guenter,

looks like you're right here, I wasn't paying too attention to the
power register and it actually always reads positive, even when the
current is flowing in the reverse direction, real data from the
ina219:

[55694.263502] shunt_voltage=fb46
[55694.263691] bus_voltage=20c2
[55694.263847] power=00fe
[55694.263954] current=fb46

I'll send a v2 to only cast the two signed register then.

Many thanks for spotting this!

Fabio

-- 
Fabio Baltieri
