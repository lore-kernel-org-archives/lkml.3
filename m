Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbbAQIts (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 03:49:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbbAQItp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 03:49:45 -0500
Message-ID: <54BA21F9.5050408@redhat.com>
Date: Sat, 17 Jan 2015 09:48:57 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?windows-1252?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 4/4] ARM: mvebu: Armada 385 GP: Add regulators to the
 SATA port
References: <1421330978-9694-1-git-send-email-gregory.clement@free-electrons.com> <1421330978-9694-5-git-send-email-gregory.clement@free-electrons.com> <54B8C933.7020502@redhat.com> <54B8D97B.3090908@free-electrons.com> <54B8E38A.6020709@redhat.com> <20150116123705.GM3043@sirena.org.uk> <54B9629C.9090800@redhat.com> <20150116202516.GL3856@sirena.org.uk>
In-Reply-To: <20150116202516.GL3856@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 16-01-15 21:25, Mark Brown wrote:
> On Fri, Jan 16, 2015 at 08:12:28PM +0100, Hans de Goede wrote:
>> On 16-01-15 13:37, Mark Brown wrote:
>
>>>> It is probably a good idea to use regulator-boot-on and
>>>> then test things this way, and if that works use
>>>> regulator-boot-on.
>
>>> No, it's unlikely that boot-on makes sense here - it's there for cases
>>> where we can't read back the hardware state at power on.
>
>> Which we cannot here since we've a gpio driven regulator, with the pin
>> in output mode, so we cannot read it back. Or at least the current kernel
>> implementation relies on regulator-boot-on rather then reading the
>> state back from the hardware.
>
> Right, this always seems like a problem with the GPIO API - not being
> able to read the state back is a total pain for boot handover, we should
> really have a way of reading back the current output state.  This is one
> of the few cases where boot-on can be useful, though ideally it'd be set
> by the bootloader rather than as a static thing since otherwise you have
> the opposite problem in the case where the disk isn't being used at the
> current time.
>
>> While we're discussing this I would also like to advocate to change the
>> behavior for regulator-boot-on to be the same as always-on when it comes
>> to regulator_init_complete(), iow regulator-boot-on regulators should
>> not be touched by regulator_init_complete(). It makes no sense to have
>> different behavior for build in versus module drivers here.
>
> Like I say boot-on is *only* intended to support bootstrapping, if you
> want the regulator to be always on then mark it as always on.  If you
> want some way of marking the end of userspace init so we can defer
> cleanup of unused resources then go do that - it's a change I've
> advocated before, it'd help with modular drivers in general.

The problem is there is no clear end of userspace init in modern event
driven systems, I think it would be much clearer to simply be consistent
and leave these regulators on, rather then turn them of $random time,
because as I've advocated before (see the simplefb thread) there is
no simple magic moment when it is right to turn things off, so doing
it when userspace starts is more or less as good as any moment, and if
it turns out that that is not a good moment, then maybe we need to
re-think the turning off in general.

With that said, since this is a re-occuring theme I've send a mail to
the systemd-devel list with you (Mark) in the CC, as well as the ide,
arm and devicetree lists. In this mail I'm asking the udev developers
if they would be willing to implement some sort of call into the kernel
to tell the kernel that udev is done with loading modules. This will
only cover devices which are already enumerated at late_init_call time,
if we've some slow scanning bus still enumerating stuff in a thread
(e.g. usb, scsi) then all bets are of, which is why I'm not enthusiastic
about this solution TBH.

A simpler solution for the use-case at hand may be to simply disallow
building of the ahci_platform driver as a module.

Regards,

Hans
