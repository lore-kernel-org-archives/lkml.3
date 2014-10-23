Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbaJWQpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 12:45:19 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:59029 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbaJWQpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 12:45:16 -0400
Date: Thu, 23 Oct 2014 09:45:07 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Steven Honeyman <stevenhoneyman@gmail.com>
Subject: Re: [PATCH] i8k: Ignore temperature sensors which report invalid
 values
Message-ID: <20141023164507.GC21343@roeck-us.net>
References: <1413730014-30945-1-git-send-email-pali.rohar@gmail.com>
 <201410221835.53526@pali>
 <20141022171005.GA30530@roeck-us.net>
 <201410231237.35053@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201410231237.35053@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Suspect
X-CTCH-VOD: Unknown
X-CTCH-Flags: 512
X-CTCH-RefID: str=0001.0A020206.5449309C.01DC,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=512,sb=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 10
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 4
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 12:37:34PM +0200, Pali Rohár wrote:
> On Wednesday 22 October 2014 19:10:05 Guenter Roeck wrote:
> > On Wed, Oct 22, 2014 at 06:35:53PM +0200, Pali Rohár wrote:
> > > On Wednesday 22 October 2014 18:19:47 Guenter Roeck wrote:
> > > > On Wed, Oct 22, 2014 at 02:29:06PM +0200, Pali Rohár wrote:
> > > > > On Tuesday 21 October 2014 06:27:23 Guenter Roeck wrote:
> > > > > > On 10/20/2014 09:46 AM, Pali Rohár wrote:
> > > > > > > Ok, I will describe my problem. Guenter, maybe you
> > > > > > > can find another solution/fix for it.
> > > > > > > 
> > > > > > > Calling i8k_get_temp(3) on my laptop without
> > > > > > > I8K_TEMPERATURE_BUG always returns value 193 (which
> > > > > > > is above I8K_MAX_TEMP).
> > > > > > > 
> > > > > > > When I8K_TEMPERATURE_BUG is enabled (by default)
> > > > > > > then i8k_get_temp(3) returns value from prev[3] and
> > > > > > > store new value I8K_TEMPERATURE_BUG to prev[3].
> > > > > > > Value in prev[3] is initialized to 0.
> > > > > > > 
> > > > > > > What I want to achieve is: when i8k_get_temp() for
> > > > > > > particular sensor id always returns invalid value (>
> > > > > > > I8K_MAX_TEMP) then we should totally ignore sensor
> > > > > > > with that id and do not export it via hwmon.
> > > > > > > 
> > > > > > > My solution is: initialize prev[id] to I8K_MAX_TEMP,
> > > > > > > so on invalid data first call to i8k_get_temp(id)
> > > > > > > returns I8K_MAX_TEMP. Then in i8k_init_hwmon check
> > > > > > > if value is < I8K_MAX_TEMP and if not ignore sensor
> > > > > > > id.
> > > > > > > 
> > > > > > > Guenter, it is clear now? Are you ok that we should
> > > > > > > ignore sensor if always report value above
> > > > > > > I8K_MAX_TEMP? If you do not like my solution/patch
> > > > > > > for it, can you specify how other can it be fixed?
> > > > > > 
> > > > > > I still don't see the point in initializing prev[].
> > > > > 
> > > > > Now prev[] is initialized to 0. It means that first call
> > > > > i8k_get_temp() (with sensor id which return value >
> > > > > I8K_MAX_TEMP) returns 0. Second and other calls returns
> > > > > I8K_MAX_TEMP.
> > > > > 
> > > > > So point is to return same value for first and other
> > > > > calls.
> > > > 
> > > > Yes, I realized that after I sent my previous mail.
> > > > 
> > > > > > Yes, I am ok with ignoring sensor values if the
> > > > > > reported temperature is above I8K_MAX_TEMP. I am just
> > > > > > not sure if we should check against I8K_MAX_TEMP or
> > > > > > against, say, 192. Reason is that we do know that the
> > > > > > sensor can erroneously return 0x99 on some systems
> > > > > > once in a while. We would not want to ignore those
> > > > > > sensors just because they happen to report 0x99
> > > > > > during initialization.
> > > > > > 
> > > > > > So maybe make it
> > > > > > 
> > > > > > 	if (err >= 0 && err < 192)
> > > > > > 
> > > > > > and add a note before the first if(), explaining that
> > > > > > higher values suggest that there is no sensor
> > > > > > attached.
> > > > > > 
> > > > > > Thanks,
> > > > > > Guenter
> > > > > 
> > > > > Right, now we need to decide which magic constant to
> > > > > use...
> > > > > 
> > > > > And now I found another problem :-)
> > > > > 
> > > > > On my laptop i8k_get_temp(3) not always return value
> > > > > 193. It is only when AMD graphics card is turned off.
> > > > > When card is on i8k_get_temp(3) returns same value as
> > > > > temperature hwmon part from radeon DRM driver.
> > > > 
> > > > Can you turn the GPU on or off during runtime ?
> > > > That would make it really tricky to handle the situation.
> > > 
> > > Yes. New laptops with Nvidia Optimus or AMD PowerXpress or
> > > Enduro technology are designed to automatically turn off
> > > secondary GPU when is not in use. And nouveau/radeon
> > > drivers together with vga_switcheroo implements this
> > > dynamic power on/off.
> > > 
> > > > > So it looks like that on my laptop i8k sensor with id 3
> > > > > reports GPU temperature.
> > > > > 
> > > > > When card is turned off radeon driver reports -EINVAL
> > > > > for temperature hwmon sysnode.
> > > > > 
> > > > > So now I think i8k could not ignore sensor totally as it
> > > > > can be mapped to some HW which can be dynamically
> > > > > turned on/off (like my graphics card).
> > > > > 
> > > > > So what do you think about reporting -EINVAL instead
> > > > > I8K_MAX_TEMP when dell SMM returns value above
> > > > > I8K_MAX_TEMP?
> > > > 
> > > > -EINVAL is supposed to mean "Invalid Argument", so it
> > > > really has ia different semantics. We could use -ENXIO,
> > > > "No such device or address", which seems more
> > > > appropriate.
> > > 
> > > I prefer to use -EINVAL because other driver (radeon) is
> > > using it and userspace "sensors" programs handle EINVAL and
> > > show "N/A" in output instead reporting some error about
> > > reading value. If nothing else consistency (with other
> > > drivers) is my argument.
> > 
> > Ok, if sensors implements it that way then let's do it.
> > 
> > > > Overall, I think the entire error handling is broken and
> > > > should be replaced. One option would be to explicitly
> > > > check for 0x99 and, if detected, go to sleep for, say,
> > > > 100ms and try again. If it still fails, and for all other
> > > > bad values, return -ENXIO. Then the calling code can
> > > > either return the error to user space in the show
> > > > function, or not install the sensor in the probe
> > > > function.
> > > > 
> > > > Does that make sense ?
> > > 
> > > Yes, replacing error handling with retry call (after some
> > > sleep) is better then current code (which returns previous
> > > value or returns I8K_MAX_TEMP).
> > > 
> > > But your solution not install the sensor if probe fails on
> > > bad value does not solve problem that i8k.ko is loading at
> > > time when GPU card is turned off.
> > 
> > Yes, the dynamics in that situation makes it a bit difficult
> > to handle the situation.
> > 
> > > I think current check for installing sensor (err < 0) is
> > > enough and when invalid value (> I8K_MAX_TEMP) is returned
> > > just do not show this value for userspace in hwmon sysnode.
> > 
> > Ok with me, and agreed.
> > 
> > Thanks,
> > Guenter
> 
> Ok, are you going to fix i8k_get_temp() function (with sleeping)?
> 
I had hoped you would find the time to do it ;-).

Sure, I can do it, but I am kind of busy right now, so it will take
a while.

Thanks,
Guenter
