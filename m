Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419AbaKROrC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:47:02 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:60998 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383AbaKROq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:46:56 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] i8k: Ignore temperature sensors which report invalid values
Date: Tue, 18 Nov 2014 15:46:51 +0100
User-Agent: KMail/1.13.7 (Linux/3.17.0-031700rc6-generic; KDE/4.14.1; x86_64; ; )
Cc: Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Steven Honeyman <stevenhoneyman@gmail.com>
References: <1413730014-30945-1-git-send-email-pali.rohar@gmail.com> <201411170935.30987@pali> <546ADF7B.5020201@roeck-us.net>
In-Reply-To: <546ADF7B.5020201@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3483590.t1MHJRtOVM";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411181546.51284@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3483590.t1MHJRtOVM
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 18 November 2014 06:56:11 Guenter Roeck wrote:
> On 11/17/2014 12:35 AM, Pali Roh=C3=A1r wrote:
> > On Thursday 23 October 2014 18:45:07 Guenter Roeck wrote:
> >> On Thu, Oct 23, 2014 at 12:37:34PM +0200, Pali Roh=C3=A1r wrote:
> >>> On Wednesday 22 October 2014 19:10:05 Guenter Roeck wrote:
> >>>> On Wed, Oct 22, 2014 at 06:35:53PM +0200, Pali Roh=C3=A1r=20
wrote:
> >>>>> On Wednesday 22 October 2014 18:19:47 Guenter Roeck
> >=20
> > wrote:
> >>>>>> On Wed, Oct 22, 2014 at 02:29:06PM +0200, Pali Roh=C3=A1r
> >=20
> > wrote:
> >>>>>>> On Tuesday 21 October 2014 06:27:23 Guenter Roeck
> >=20
> > wrote:
> >>>>>>>> On 10/20/2014 09:46 AM, Pali Roh=C3=A1r wrote:
> >>>>>>>>> Ok, I will describe my problem. Guenter, maybe
> >>>>>>>>> you can find another solution/fix for it.
> >>>>>>>>>=20
> >>>>>>>>> Calling i8k_get_temp(3) on my laptop without
> >>>>>>>>> I8K_TEMPERATURE_BUG always returns value 193
> >>>>>>>>> (which is above I8K_MAX_TEMP).
> >>>>>>>>>=20
> >>>>>>>>> When I8K_TEMPERATURE_BUG is enabled (by default)
> >>>>>>>>> then i8k_get_temp(3) returns value from prev[3]
> >>>>>>>>> and store new value I8K_TEMPERATURE_BUG to
> >>>>>>>>> prev[3]. Value in prev[3] is initialized to 0.
> >>>>>>>>>=20
> >>>>>>>>> What I want to achieve is: when i8k_get_temp()
> >>>>>>>>> for particular sensor id always returns invalid
> >>>>>>>>> value (> I8K_MAX_TEMP) then we should totally
> >>>>>>>>> ignore sensor with that id and do not export it
> >>>>>>>>> via hwmon.
> >>>>>>>>>=20
> >>>>>>>>> My solution is: initialize prev[id] to
> >>>>>>>>> I8K_MAX_TEMP, so on invalid data first call to
> >>>>>>>>> i8k_get_temp(id) returns I8K_MAX_TEMP. Then in
> >>>>>>>>> i8k_init_hwmon check if value is < I8K_MAX_TEMP
> >>>>>>>>> and if not ignore sensor id.
> >>>>>>>>>=20
> >>>>>>>>> Guenter, it is clear now? Are you ok that we
> >>>>>>>>> should ignore sensor if always report value
> >>>>>>>>> above I8K_MAX_TEMP? If you do not like my
> >>>>>>>>> solution/patch for it, can you specify how
> >>>>>>>>> other can it be fixed?
> >>>>>>>>=20
> >>>>>>>> I still don't see the point in initializing
> >>>>>>>> prev[].
> >>>>>>>=20
> >>>>>>> Now prev[] is initialized to 0. It means that first
> >>>>>>> call i8k_get_temp() (with sensor id which return
> >>>>>>> value > I8K_MAX_TEMP) returns 0. Second and other
> >>>>>>> calls returns I8K_MAX_TEMP.
> >>>>>>>=20
> >>>>>>> So point is to return same value for first and other
> >>>>>>> calls.
> >>>>>>=20
> >>>>>> Yes, I realized that after I sent my previous mail.
> >>>>>>=20
> >>>>>>>> Yes, I am ok with ignoring sensor values if the
> >>>>>>>> reported temperature is above I8K_MAX_TEMP. I am
> >>>>>>>> just not sure if we should check against
> >>>>>>>> I8K_MAX_TEMP or against, say, 192. Reason is that
> >>>>>>>> we do know that the sensor can erroneously return
> >>>>>>>> 0x99 on some systems once in a while. We would
> >>>>>>>> not want to ignore those sensors just because
> >>>>>>>> they happen to report 0x99 during initialization.
> >>>>>>>>=20
> >>>>>>>> So maybe make it
> >>>>>>>>=20
> >>>>>>>> 	if (err >=3D 0 && err < 192)
> >>>>>>>>=20
> >>>>>>>> and add a note before the first if(), explaining
> >>>>>>>> that higher values suggest that there is no
> >>>>>>>> sensor attached.
> >>>>>>>>=20
> >>>>>>>> Thanks,
> >>>>>>>> Guenter
> >>>>>>>=20
> >>>>>>> Right, now we need to decide which magic constant to
> >>>>>>> use...
> >>>>>>>=20
> >>>>>>> And now I found another problem :-)
> >>>>>>>=20
> >>>>>>> On my laptop i8k_get_temp(3) not always return value
> >>>>>>> 193. It is only when AMD graphics card is turned
> >>>>>>> off. When card is on i8k_get_temp(3) returns same
> >>>>>>> value as temperature hwmon part from radeon DRM
> >>>>>>> driver.
> >>>>>>=20
> >>>>>> Can you turn the GPU on or off during runtime ?
> >>>>>> That would make it really tricky to handle the
> >>>>>> situation.
> >>>>>=20
> >>>>> Yes. New laptops with Nvidia Optimus or AMD PowerXpress
> >>>>> or Enduro technology are designed to automatically turn
> >>>>> off secondary GPU when is not in use. And
> >>>>> nouveau/radeon drivers together with vga_switcheroo
> >>>>> implements this dynamic power on/off.
> >>>>>=20
> >>>>>>> So it looks like that on my laptop i8k sensor with
> >>>>>>> id 3 reports GPU temperature.
> >>>>>>>=20
> >>>>>>> When card is turned off radeon driver reports
> >>>>>>> -EINVAL for temperature hwmon sysnode.
> >>>>>>>=20
> >>>>>>> So now I think i8k could not ignore sensor totally
> >>>>>>> as it can be mapped to some HW which can be
> >>>>>>> dynamically turned on/off (like my graphics card).
> >>>>>>>=20
> >>>>>>> So what do you think about reporting -EINVAL instead
> >>>>>>> I8K_MAX_TEMP when dell SMM returns value above
> >>>>>>> I8K_MAX_TEMP?
> >>>>>>=20
> >>>>>> -EINVAL is supposed to mean "Invalid Argument", so it
> >>>>>> really has ia different semantics. We could use
> >>>>>> -ENXIO, "No such device or address", which seems more
> >>>>>> appropriate.
> >>>>>=20
> >>>>> I prefer to use -EINVAL because other driver (radeon) is
> >>>>> using it and userspace "sensors" programs handle EINVAL
> >>>>> and show "N/A" in output instead reporting some error
> >>>>> about reading value. If nothing else consistency (with
> >>>>> other drivers) is my argument.
> >>>>=20
> >>>> Ok, if sensors implements it that way then let's do it.
> >>>>=20
> >>>>>> Overall, I think the entire error handling is broken
> >>>>>> and should be replaced. One option would be to
> >>>>>> explicitly check for 0x99 and, if detected, go to
> >>>>>> sleep for, say, 100ms and try again. If it still
> >>>>>> fails, and for all other bad values, return -ENXIO.
> >>>>>> Then the calling code can either return the error to
> >>>>>> user space in the show function, or not install the
> >>>>>> sensor in the probe function.
> >>>>>>=20
> >>>>>> Does that make sense ?
> >>>>>=20
> >>>>> Yes, replacing error handling with retry call (after
> >>>>> some sleep) is better then current code (which returns
> >>>>> previous value or returns I8K_MAX_TEMP).
> >>>>>=20
> >>>>> But your solution not install the sensor if probe fails
> >>>>> on bad value does not solve problem that i8k.ko is
> >>>>> loading at time when GPU card is turned off.
> >>>>=20
> >>>> Yes, the dynamics in that situation makes it a bit
> >>>> difficult to handle the situation.
> >>>>=20
> >>>>> I think current check for installing sensor (err < 0) is
> >>>>> enough and when invalid value (> I8K_MAX_TEMP) is
> >>>>> returned just do not show this value for userspace in
> >>>>> hwmon sysnode.
> >>>>=20
> >>>> Ok with me, and agreed.
> >>>>=20
> >>>> Thanks,
> >>>> Guenter
> >>>=20
> >>> Ok, are you going to fix i8k_get_temp() function (with
> >>> sleeping)?
> >>=20
> >> I had hoped you would find the time to do it ;-).
> >>=20
> >> Sure, I can do it, but I am kind of busy right now, so it
> >> will take a while.
> >>=20
> >> Thanks,
> >> Guenter
> >=20
> > Ok. Will you do that for 3.19 kernel? Meanwhile I can
> > prepare patch for temperature labels. I looked into
> > NBSVC.MDM and there is something related for type of
> > temperature sensors...
>=20
> Highly unlikely. I don't have the time right now.
>=20
> Guenter

Ok. I will try to at least fix patch from first post in this=20
thread, so i8k_get_temp() does not return totally invalid value=20
to userspace (or at first call).

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart3483590.t1MHJRtOVM
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRrW9sACgkQi/DJPQPkQ1JKHACfa/6um8k4p7roaocDTr0h0lBt
T2wAoMuTy9beWPr5r+VmUH+tf7o7kiRn
=Mz3l
-----END PGP SIGNATURE-----

--nextPart3483590.t1MHJRtOVM--
