Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbaIYOXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 10:23:53 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:50072 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaIYOXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 10:23:49 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Aaron Lu <aaron.lu@intel.com>
Subject: Re: ACPI/i915: Cannot configure display brightness on Dell Latitude E6440
Date: Thu, 25 Sep 2014 16:23:45 +0200
User-Agent: KMail/1.13.7 (Linux/3.17.0-031700rc6-generic; KDE/4.13.2; x86_64; ; )
Cc: Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
References: <201409232206.02819@pali> <201409242021.10107@pali> <542388D7.1010008@intel.com>
In-Reply-To: <542388D7.1010008@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart282337937.isauQXBJ55";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201409251623.45636@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart282337937.isauQXBJ55
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 25 September 2014 05:15:35 Aaron Lu wrote:
> Hi Hans,
>=20
> Thanks for following up and explaining the situation to Pali.
>=20
> On 09/25/2014 02:21 AM, Pali Roh=C3=A1r wrote:
> > On Wednesday 24 September 2014 16:34:21 Hans de Goede wrote:
> >> Ok, so the dell-laptop interface is just an obsolete
> >> wrapper around the i915 opregion code, which shows that
> >> the right interface to use is the i915 one, which we do if
> >> you don't specify any kernel commandline parameters, case
> >> closed.
> >>=20
> >> Regards,
> >>=20
> >> Hans
> >=20
> > Nope, its not closed.
> >=20
> > Still i915 interface has problem with setting backlight. It
> > exports lot of levels which turning display off. Which
> > breaking exiting applications for configuring display
> > brightness. This is still big regression as black screen is
> > not want people want to see.
> >=20
> > Driver dell-laptop has exported only few - not thousands
> > level (which is insane) and only usefull levels (not lot of
> > levels which turn display off).
> >=20
> > So for this reason using i915 backlight interface is not
> > possible and also Dell (for E6440) set kernel param
> > acpi_backlight=3Dvendor to use dell_laptop module for
> > controlling brightness.
> >=20
> > On my laptop E6440 is better for using dell-laptop and not
> > acpi or i915.
>=20
> Hi Pali,
>=20
> Please test this patch:
>=20

Hi! this patch fixing this problem. With acpi_backlight=3Dvendor=20
dell-laptop will register backlight interface which is working=20
again. Also userspace application dellLcdBrightness is working=20
now without problem.

Can you going to send this patch also to stable 3.16 branch? As=20
it fixing commit 0b9f7d93ca6109048a4eb06332b666b6e29df4fe.

> diff --git a/drivers/gpu/drm/i915/intel_opregion.c
> b/drivers/gpu/drm/i915/intel_opregion.c index
> ca52ad2ae7d1..15534345bd57 100644
> --- a/drivers/gpu/drm/i915/intel_opregion.c
> +++ b/drivers/gpu/drm/i915/intel_opregion.c
> @@ -396,6 +396,24 @@ int intel_opregion_notify_adapter(struct
> drm_device *dev, pci_power_t state) return -EINVAL;
>  }
>=20
> +/*
> + * Some of the Thinkpads' firmware will issue a backlight
> change operation + * region request unconditionally on AC
> plug/unplug, this is undesirable and + * should be ignored.
> Then there is a Dell laptop whose vendor backlight + *
> interface also makes use of operation region request to
> change backlight + * level and we have to keep it work. The
> rule used here is: if the vendor + * backlight interface is
> not in use and the ACPI backlight interface is + * broken, we
> ignore the requests; oterwise, we keep processing them. + */
> +static bool should_ignore_backlight_request(void)
> +{
> +	if (acpi_video_backlight_support() &&
> +	    !acpi_video_verify_backlight_support())
> +		return true;
> +
> +	return false;
> +}
> +
>  static u32 asle_set_backlight(struct drm_device *dev, u32
> bclp) {
>  	struct drm_i915_private *dev_priv =3D dev->dev_private;
> @@ -404,11 +422,7 @@ static u32 asle_set_backlight(struct
> drm_device *dev, u32 bclp)
>=20
>  	DRM_DEBUG_DRIVER("bclp =3D 0x%08x\n", bclp);
>=20
> -	/*
> -	 * If the acpi_video interface is not supposed to be used,
> don't -	 * bother processing backlight level change requests
> from firmware. -	 */
> -	if (!acpi_video_verify_backlight_support()) {
> +	if (should_ignore_backlight_request()) {
>  		DRM_DEBUG_KMS("opregion backlight request ignored\n");
>  		return 0;
>  	}

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart282337937.isauQXBJ55
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlQkJXEACgkQi/DJPQPkQ1LiowCfSmnMdeKrRqf1YTTj0CglrAOb
oqQAn1nc2qMmAf6BYqYbL1KQFTkBSD9a
=MLL4
-----END PGP SIGNATURE-----

--nextPart282337937.isauQXBJ55--
