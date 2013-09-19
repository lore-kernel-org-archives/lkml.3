Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab3ISKzX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 06:55:23 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:60437 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab3ISKzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 06:55:22 -0400
Message-ID: <523AD814.1060406@monstr.eu>
Date: Thu, 19 Sep 2013 12:55:16 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Alan Tull <atull@altera.com>
CC: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        David Brown <davidb@codeaurora.org>, Dom Cobley <popcornmix@gmail.com>
Subject: Re: [RFC PATCH] fpga: Introduce new fpga subsystem
References: <cover.1379519753.git.michal.simek@xilinx.com>  <cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com>  <20130918191517.GQ19937@titan.lakedaemon.net>  <20130918203247.GA11181@obsidianresearch.com> <1379539063.31417.23.camel@atx-linux-37>
In-Reply-To: <1379539063.31417.23.camel@atx-linux-37>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="BRRwltpCpwbaMkfKu4lnHlgp3mpIHCRbL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BRRwltpCpwbaMkfKu4lnHlgp3mpIHCRbL
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Alan,

On 09/18/2013 11:17 PM, Alan Tull wrote:
> On Wed, 2013-09-18 at 14:32 -0600, Jason Gunthorpe wrote:
>> On Wed, Sep 18, 2013 at 03:15:17PM -0400, Jason Cooper wrote:
>>
>>> + Jason Gunthorpe
>>
>> Thanks, looks interesting, we could possibly use this interface if it =

>> met our needs..
>> =20
>>> On Wed, Sep 18, 2013 at 05:56:39PM +0200, Michal Simek wrote:
>>>> This new subsystem should unify all fpga drivers which
>>>> do the same things. Load configuration data to fpga
>>>> or another programmable logic through common interface.
>>>> It doesn't matter if it is MMIO device, gpio bitbanging,
>>>> etc. connection. The point is to have the same
>>>> inteface for these drivers.
>>
>> So, we have many years of in-field experience with this and this API
>> doesn't really match what we do.
>>
>> Here are the steps we perform, from userspace:
>>  - Ask kernel to place FPGA into reset and prepare for programming
>>    * Kernel can return an error (eg FPGA failed to erase, etc)
>>    * this is the PROG_N low -> DONE high, PROG_N high -> INIT_N high
>>      sequencing on Xilinx chips
>>  - Ask kernel to load a bitstream.
>>    * Userspace locats the bitstream file to load, and the mmaps it.
>>    * Userspace passes the entire file in a single write() call to the
>>      kernel which streams it over the configuration bus
>>    * The kernel can report an erro rhere (eg Xilinx can report CRC
>>    error)
>>  - Ask the kernel to verify that configuration is complete.=20
>>    * On Xilinx this wait for done to go high
>>  - Ask the kernel to release the configuration bus (tristate
>>    all drivers) (or sometimes we have to drive the bus low,
>>    it depends on the bitfile, user space knows what to do)
>>
>> It is very important that userspace know exactly which step fails
>> because the resolution is different. We use this in a manufacturing
>> setting, so failures are expected and need quick root cause
>> determination.
>>
>> You could probably address that need by very clearly defining a
>> variety of errno values for the various cases. However, it would be a
>> disaster if every driver did something a little different :|
>>
>> Using request_firmware exclusively is not useful for us. We
>> format the bitfile with a header that contains our internal tracking
>> information. Sometimes we need to bitswap the bitfile. Our userspace
>> handles all of this and can pass a bitfile in memory to write().
>>
>> request_firmware would be horrible to use :)
>>
>> Our API uses a binary sysfs attribute to stream the FPGA data, you
>> might want to consider that.
>>
>> Regards,
>> Jason
>=20
> The firmware approach is interesting.  It might be less flexible
> compared with my original code (see link to git below) that this is
> based on.  The original code created a devnode like /dev/fpga0 and a ra=
w
> bitstream could be loaded by doing 'cat bitstream > /dev/fpga0'.  Or
> some other userspace app could write the /dev/fpga0 to handle any
> headers that needed to be added to the bitstream.

We are using char device driver for our devcfg device and hwicap too
but this firmware interface is not far from that.
As Jason mentioned we can use binary sysfs attributes and you should
get the same functionality for userspace.


> This code also creates a set of files under /sys for each separate fpga=
=2E
> I.e. checking status by looking at /sys/class/fpga/fpag0/status.  It
> would be pretty small changes to control reseting the fpga by adding a
> 'reset' file there also (added first to the framework, and an interface=

> into the low level fpga manager driver).

Status is just there and for my zynq devcfg driver I do export some statu=
s
bits.

root@petalinux:~# cat /sys/class/fpga/fpga0/status
partial_bitstream_status: 0
prog_done_status: 1
dbg_lock_status: 0
seu_lock_status: 0
aes_en_lock_status: 0
aes_status: 0
seu_status: 0
spniden_status: 1
spiden_status: 1
niden_status: 1
dbgen_status: 1
dap_en_status: 7

Originally these values are single device attribute but I need to confirm=

exact usage for them. It means in this RFC I probably miss any standard
channel how to change end driver behaviour and probably there should be o=
ne more
hook for that.

> I am trying this out with my low level fpga manager driver.  I'm very
> curious about your approach and I am wondering whether the firmware
> approach will work for us or not.

I believe so.

> Will this framework handle more than one fpga at a time?

I didn't tried that because I don't have any suitable hw for this on my d=
esk
but I there shouldn't be any problem in that.

> Is there some way a per-device userspace helper can be added that can
> handle adding the headers?  Such that different fpga types get differen=
t
> helpers?

What do you exactly mean by that? Any example what do you want to achieve=
?

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--BRRwltpCpwbaMkfKu4lnHlgp3mpIHCRbL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEUEARECAAYFAlI62BQACgkQykllyylKDCEWxACVEiP71txW/zr9/EGGxjMcd48B
swCcDeTTWcFpefcTvE50WJ9ATLXWimE=
=7JAr
-----END PGP SIGNATURE-----

--BRRwltpCpwbaMkfKu4lnHlgp3mpIHCRbL--
