Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab3FKPLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 11:11:54 -0400
Received: from mx1.riseup.net ([198.252.153.129]:39966 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336Ab3FKPLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 11:11:53 -0400
From: Francisco Jerez <currojerez@riseup.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>, linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm: encoder_slave: respect of_node on i2c encoder init
References: <1370899422-1281-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<20130611072433.GP22870@phenom.ffwll.local>
	<51B6D91D.3000906@gmail.com>
Date: Tue, 11 Jun 2013 17:10:12 +0200
In-Reply-To: <51B6D91D.3000906@gmail.com> (Sebastian Hesselbarth's message of
	"Tue, 11 Jun 2013 10:00:29 +0200")
Message-ID: <8738soptt7.fsf@riseup.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==-=-=
Content-Type: multipart/mixed; boundary="=-=-="

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi,

Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> writes:

>> - I think we could also drop the call to ->set_config since presumably an
>>    of-enabled driver grabbed any required info already from the dt.
>[...]
>> I think this way we could still share encoder slaves across tons of
>> platforms, only the init sequence (and specifically how they get at their

The "set_config" hook is just the way a DRM driver communicates those
board-specific differences in the init sequence to the slave encoder
driver.  I don't think it would make sense to remove it unless we make
sure it's being called elsewhere.

>
> IMHO, the whole i2c encoder stuff is just wrong. Not any i2c slave
> driver is even really using its probe(). Everything is packed somewhere
> because it just worked.. this is at least a start.
>
Why is that?  What do you mean by the probe hooks not being used?
ch7006 and sil164 rely on it being called on initialization.

> I suggest this to get merged to at least allow to have DT slaves,
> then start with improving tda998x as an example, then maybe rethink
> drm_slave_encoder completely, e.g.
>
> - generalize the concept to SPI attached encoders, "internal" encoders..

drm_encoder_slave is bus-agnostic.  drm_i2c_encoder_init() is just a
helper function taking care of bus-specific details like the creation of
the underlying I2C device object, which cannot be made bus-agnostic for
obvious reasons.  You're welcome to implement SPI and internal
counterparts of drm_i2c_encoder_init().

> - find a way to setup .encoder_type and .connector_type correctly

I guess encoder_type could be initialized correctly from the slave
encoder_init() hook -- that hasn't been necessary until now because the
DRM driver making use of the slave encoder has been expected to have
some other means to find out encoder types [e.g. device-specific BIOS
tables].  OTOH, I don't think that setting connector types is the slave
encoder's business.

> - have more common of_drm_blabla helpers
>
>> config data) would be different. That would also be extensible quite
>> easily (*cough* intel platforms could setup encoder slaves from
>> information out of the vbt *cough*).
>>
>[...]

--=-=-=--

--==-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iF4EAREIAAYFAlG3PdkACgkQg5k4nX1Sv1tFVgD8DqF9bLaO6Thgyi9UV3MjsEiX
mY8WqAiN6rnRSSk59XEA/0XiT59b62ItdzN+SMKitI6rPkwmzSMRkiLEZpHl/Kxg
=gUYH
-----END PGP SIGNATURE-----
--==-=-=--
