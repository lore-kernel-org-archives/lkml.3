Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710AbaBTTeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 14:34:18 -0500
Received: from plane.gmane.org ([80.91.229.3]:59917 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755491AbaBTTeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 14:34:17 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Grant Edwards <grant.b.edwards@gmail.com>
Subject: Re: locking changes in tty broke low latency feature
Date: Thu, 20 Feb 2014 19:33:46 +0000 (UTC)
Message-ID: <le5laq$40s$1@ger.gmane.org>
References: <20140219230623.736E8406062@ip-64-139-1-69.sjc.megapath.net>
 <53056E99.9070900@hurleysoftware.com> <53064672.3000807@hurleysoftware.com>
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: dsl.comtrol.com
User-Agent: slrn/1.0.1 (Linux)
Cc: linux-serial@vger.kernel.org, linux-rt-users@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-02-20, Peter Hurley <peter@hurleysoftware.com> wrote:
> On 02/19/2014 09:55 PM, Peter Hurley wrote:
>> On 02/19/2014 06:06 PM, Hal Murray wrote:
>>>> Can you give me an idea of your device's average and minimum required
>>>> latency (please be specific)?  Is your target arch x86 [so I can evaluate the
>>>> the impact of bus-locked instructions relative to your expected]?
>>>
>>> The code I'm familiar with is ntpd and gpsd.  They run on almost any hardware
>>> or OS and talk to a wide collection of devices.
>>>
>>> There is no hard requirement for latency.  They just work better with lower
>>> latency.  The lower the better.
>>>
>>> People gripe about the latency due to USB polling which is about a ms.
>>
>> Have you tried 3.12+ without low_latency? I ripped out a lot of locks
>> from 3.12+ so it's possible it already meets your requirements.
>
> Using Alan's idea to mock up a latency test, I threw together a test jig
> using two computers running 3.14-rc1 and my fwserial driver (modified to
> not aggregrate writes) in raw mode where the target does this:
>
>          while (1) {
>                  read 64 bytes
>                  compare to pattern
>                  write 1 byte response
>          }
>
> and the sender does this:
>
>          for (i = 0; i < 2000; i++) {
>                  write 64-byte pattern
>                  read 1 byte response
>          }
>
> Sender completes 2000 loops in 160ms total run time;
> that's 80us average per complete round-trip.

If I understand correctly, that 80us _includes_ the actual time for
the bits on the wire (which means the actual "baud rate" involved is
high enough that it's negligible).


> I think this shows that low_latency is unnecessary and should
> just be removed/ignored by the tty core.

If that's the sort of latency that you get for typical kernel
configurations for typical distros, then I agree that the low_latency
flag is not needed by the tty later.

However, it might still be useful for the lower-level tty or
serial-core driver to control CPU usage vs. latency trade-offs (for
exaple, one of my drivers uses it to decide where to set the rx FIFO
threshold).

-- 
Grant Edwards               grant.b.edwards        Yow! I wonder if I could
                                  at               ever get started in the
                              gmail.com            credit world?

