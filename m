Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab3KFHvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 02:51:55 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:36569 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803Ab3KFHvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 02:51:54 -0500
Message-ID: <5279F50E.6040304@ti.com>
Date: Wed, 6 Nov 2013 09:51:42 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Kevin Hilman <khilman@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Archit Taneja <archit@ti.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: Async runtime put in __device_release_driver()
References: <5267A0DF.7080604@ti.com> <CAPDyKFp0UGjEbn+pWDLKOQvKsxeXSh5hY3++TA1rpErfihOtPA@mail.gmail.com>
In-Reply-To: <CAPDyKFp0UGjEbn+pWDLKOQvKsxeXSh5hY3++TA1rpErfihOtPA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="aNj3CiBxWU9rNxe6a5uIGpIL74JqPV6h7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--aNj3CiBxWU9rNxe6a5uIGpIL74JqPV6h7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2013-11-05 23:29, Ulf Hansson wrote:
> On 23 October 2013 12:11, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:=

>> Hi,
>>
>> I was debugging why clocks were left enabled after removing omapdss
>> driver, and I found this commit:
>>
>> fa180eb448fa263cf18dd930143b515d27d70d7b (PM / Runtime: Idle devices
>> asynchronously after probe|release)
>>
>> I don't understand how that is supposed to work.
>>
>> When a driver is removed, instead of using pm_runtime_put_sync() the
>> commit uses pm_runtime_put(), so the runtime_suspend call is queued. B=
ut
>> who is going to handle the queued suspend call, as the driver is alrea=
dy
>> removed? At least in my case, obviously nobody, as I only get
>> runtime_resume call in my driver, never the runtime_suspend.
>>
>> Is there something I need to add to my driver to make this work, or
>> should that part of the patch be reverted?
>=20
> I believe it is quite common that a device driver calls
> pm_runtime_get_sync as a part of it's remove callback, then it
> explicitly returns it's resources that has been fetched during probe.
> Like a clk_disable_unprepare for example.

I guess you mean the driver calls pm_runtime_get_sync _and_
pm_runtime_put_sync as part of its remove callback?

Probably bus drivers need to do that, but for memory mapped devices in a
SoC, I don't think there's normally any need to do
pm_runtime_get/put_sync during the remove callback.

> The idea behind the change in __device_release_driver, was to try to
> prevent  devices from going active->idle->active and instead just
> remain active (if possible).
>
> In your case, which seems like a more modern way of implementing
> "remove", you shall call "pm_runtime_suspend" to make sure the
> runtime_suspend callbacks gets called.

And as far as I understand, the change creates an explicit requirement
to do either pm_runtime_get/put_sync or pm_runtime_suspend inside
driver's remove callback. If so, that should be mentioned in big red
letters in the pm-runtime documentation.

The runtime_pm.txt doc does mention something related to this (and btw,
the doc says pm_runtime_put_sync is being called, which is no longer
true), but nothing clear about how the driver remove callback must be
implemented.

I tried grepping the kernel sources to find out if pm_runtime_suspend is
widely used to get SoC platform devices to suspend, but it doesn't seem
like it is. I didn't see pm_runtime_get/put_sync being used in remove
callbacks widely either, but that was more difficult one to grep.

 Tomi



--aNj3CiBxWU9rNxe6a5uIGpIL74JqPV6h7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSefUSAAoJEPo9qoy8lh71lvYP/1J+EfdY3Pb4nZrIket+i6vC
DuweAc6BEHJfkbGHsfcEU7Bpy0FS6vvFRc5M7D4tFGevuucXq5wkGBQI38Smm0mg
S1zPx0/Y4UYfEElOmbYIq7zpmAEVurr8M813UHrwCZkiajeaVdW44iWXM/sAJDH5
DscCovC8RKZAk8RCAqR/BUEL2sC1WXGqtLZf93wzQfIBVEFuzzW+AZHMYXpfcg0x
OrLAb9AbLVbC2G9XWShMq1aaTGW17wHCtEGvElqaj6CiKi0ttRqFoFPfrn67/POP
AjyGBNd6YbhEyK+rs3i/BigRY8agTudRCStWgB/FMgfL72Dy9Jxfn+p9DqPjoDX5
2WK0hwdkiBh2ue1HUym3KLdX3tdogRwe9UsIgzi2LVNYz9IbNPeLT+zKsHFq86a2
whT2bR/LRlsdrlOUzpp3FKmIGKpjFKL7hWUW9YfhIiQ0Ztch9N7iqqDH2V2OYrva
VMFb+uJLITTwmtetxmB3n6NiLTns8a4rmf/q+98ifY0x6ayN6+ipEgBku8u81rYf
9JcDdE8WdNZTGPrAXYvqN1okH5RL2CKuKxeVtKkegOZt//Be7z1KwFFXKcsfvLBQ
oatw20lBtpE8VyPgBWwyjg8qLGSmN3TzeHArGrKyFSEqMOfvGX5hfa+iyEWXnE8l
umvoctJ+r7vcG2mL7QwA
=Q4u2
-----END PGP SIGNATURE-----

--aNj3CiBxWU9rNxe6a5uIGpIL74JqPV6h7--
