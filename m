Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab3AQR13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 12:27:29 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:45969 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752446Ab3AQR1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 12:27:25 -0500
Subject: Re: [PATCH] platform: Fix platform device resource linking
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: multipart/mixed; boundary=Apple-Mail-4-31836285
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20130117170719.GB9163@kroah.com>
Date: Thu, 17 Jan 2013 19:27:21 +0200
Cc: linux-kernel@vger.kernel.org, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Koen Kooi <koen@dominion.thruhere.net>
Message-Id: <87DCB3B7-0A5A-42F0-BF9C-0E91B56960C6@antoniou-consulting.com>
References: <1357252270-5955-1-git-send-email-panto@antoniou-consulting.com> <20130103224020.GB4571@kroah.com> <CD23CDD8-5740-4649-8876-ADDFCFF30C35@antoniou-consulting.com> <20130117163159.GD1396@kroah.com> <95056678-DF1A-4C49-BEAE-C5EBD7E56405@antoniou-consulting.com> <20130117170719.GB9163@kroah.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail-4-31836285
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Hi Greg,

On Jan 17, 2013, at 7:07 PM, Greg Kroah-Hartman wrote:

> On Thu, Jan 17, 2013 at 06:50:19PM +0200, Pantelis Antoniou wrote:
>>=20
>> On Jan 17, 2013, at 6:31 PM, Greg Kroah-Hartman wrote:
>>=20
>>> On Fri, Jan 04, 2013 at 12:43:46AM +0200, Pantelis Antoniou wrote:
>>>> Hi Greg,
>>>>=20
>>>> On Jan 4, 2013, at 12:40 AM, Greg Kroah-Hartman wrote:
>>>>=20
>>>>> On Fri, Jan 04, 2013 at 12:31:10AM +0200, Pantelis Antoniou wrote:
>>>>>> Platform device removal uncovered a number of problems with
>>>>>> the way resources are handled in the core platform code.
>>>>>>=20
>>>>>> Resources now form child/parent linkages and this requires
>>>>>> proper linking of the resources. On top of that the OF core
>>>>>> directly creates it's own platform devices. Simplify things
>>>>>> by providing helper functions that manage the linking properly.
>>>>>>=20
>>>>>> Two functions are provided:
>>>>>>=20
>>>>>> platform_device_link_resources(), which links all the
>>>>>> linkable resources (if not already linked).
>>>>>>=20
>>>>>> and platform_device_unlink_resources(), which unlinks all the
>>>>>> resources.
>>>>>=20
>>>>> Who would call these functions, and why?
>>>>>=20
>>>>> And why have we never seen problems with removing platform devices
>>>>> previously?
>>>>>=20
>>>>=20
>>>> Have you tried removing devices that were created via DT and=20
>>>> not using platform data?
>>>=20
>>> Don't you think that answering two questions with another question =
as
>>> something that isn't very helpful?  :)
>>>=20
>>> Dropped from my queue, please resend when you can provide the needed
>>> information.
>>>=20
>>> thanks,
>>>=20
>>=20
>> That's not very nice, but anyway...
>=20
> What would you have me do if you were in my shoes?
>=20

Point.

>> In a nutshell, we have to exercise the platform device subsystem, in =
ways
>> that never happened before, so all sorts of weird bugs that no-one =
has seen
>> before.
>=20
> Why do you have to do this?  What are you doing that is so different
> from everyone else?  What drivers are you using that trigger this type
> of thing?
>=20

This is all part of a larger patchset; I guess you weren't directly =
CCed.
The name of the patchset is 'Introducing Device Tree Overlays' and is a
method of changing the live device tree and have the changes reflected =
to
the kernel's state.

As I mentioned earlier, device tree platform devices were never removed
up until now; the DT statically described the hardware of a board and =
there
wasn't any way to remove a device.

As part of the Device Tree Overlay functionality, an overlay should be =
possible
to be removed. The crash happens when a platform device created by DT
is removed.=20

>> In that case, the code path for creating platform devices from DT is
>> not the same as the one that is used when creating platform device =
from
>> a board file.
>=20
> Why not?
>=20

Because while DT creates platform devices, it doesn't use the platform =
device
methods to do so, rather than builds the platform device itself. This is=20=

something that was overlooked.

>> Take a look at platform_device_add() in drivers/base/platform.c and
>> drivers/of/device.c
>>=20
>> platform_device_add() properly links the resources by using =
insert_resource(),
>> while of_device_add() doesn't bother with it. Now when we try to =
unregister
>> the device everything will is fine in the platform device case, since =
the resources
>> are linked properly. In the DT case we will crash spectacularly in=20
>> __release_resource at the first line (p =3D &old->parent->child), =
since no-one bothered
>> to fill in the parent pointer.
>=20
> So, isn't that a bug in the DT case?  A device always has to have a
> parent, as you have found out.  Hm, maybe not "root" devices, but you
> don't have many of those, right?
>=20

It's not about a device parent, it's about a resource parent. In general =
resource
handling in the DT world is a big WIP. One step to that direction is to =
have the
resources properly linked as the rest of the kernel code expects.

>> That's what the patches do; first the code in platform_device_add() =
that perform the
>> resource linking is factored as a separate function =
(platform_device_link_resources).
>>=20
>> The platform_device_unlink_resources() function, just makes things =
more clearer.=20
>=20
> But you added a new function that no one calls, which is what I am
> objecting to.
>=20

Looking at my mailer, it looks like the patch that uses this got dropped =
since it
is such a small patch.

That is my mistake and apologize for the severe confusion.

The patch in question is attached; I will sent it along by itself too.

> thanks,
>=20
> greg k-h

Regards

-- Pantelis


--Apple-Mail-4-31836285
Content-Disposition: attachment;
	filename=0001-Link-platform-device-resources-properly.patch
Content-Type: application/octet-stream;
	name="0001-Link-platform-device-resources-properly.patch"
Content-Transfer-Encoding: quoted-printable

=46rom=20a17f5ea9601938d492cd7d236826d9a6dba6d79d=20Mon=20Sep=2017=20=
00:00:00=202001=0AFrom:=20Pantelis=20Antoniou=20=
<panto@antoniou-consulting.com>=0ADate:=20Fri,=2028=20Dec=202012=20=
11:39:29=20+0200=0ASubject:=20[PATCH]=20Link=20platform=20device=20=
resources=20properly.=0A=0AThe=20resources=20of=20the=20platform=20=
devices=20created=20by=20the=20OF=20core=20were=0Anot=20properly=20=
linked.=20Make=20sure=20that=20they=20are,=20so=20that=20we=20don't=20=
get=0Aany=20crashes=20when=20trying=20to=20remove=20the=20device.=0A=0A=
Signed-off-by:=20Pantelis=20Antoniou=20<panto@antoniou-consulting.com>=0A=
---=0A=20drivers/of/device.c=20|=203=20+++=0A=201=20file=20changed,=203=20=
insertions(+)=0A=0Adiff=20--git=20a/drivers/of/device.c=20=
b/drivers/of/device.c=0Aindex=204c74e4f..d75fcaf=20100644=0A---=20=
a/drivers/of/device.c=0A+++=20b/drivers/of/device.c=0A@@=20-62,6=20+62,9=20=
@@=20int=20of_device_add(struct=20platform_device=20*ofdev)=0A=20=09if=20=
(!ofdev->dev.parent)=0A=20=09=09set_dev_node(&ofdev->dev,=20=
of_node_to_nid(ofdev->dev.of_node));=0A=20=0A+=09/*=20make=20sure=20we=20=
add=20the=20resources=20to=20the=20appropriate=20lists=20*/=0A+=09=
platform_device_link_resources(ofdev);=0A+=0A=20=09return=20=
device_add(&ofdev->dev);=0A=20}=0A=20=0A--=20=0A1.7.12=0A=0A=

--Apple-Mail-4-31836285--
