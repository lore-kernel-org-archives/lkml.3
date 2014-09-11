Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbaIKLIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 07:08:22 -0400
Received: from sauhun.de ([89.238.76.85]:51618 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbaIKLIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 07:08:20 -0400
Date: Thu, 11 Sep 2014 13:08:29 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Lee Jones <lee.jones@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        "Bowens, Alan" <Alan.Bowens@atmel.com>
Subject: Re: [PATCH] Input: atmel_mxt_ts: Add of node type to the i2c table
Message-ID: <20140911110829.GA5149@katana>
References: <1410249158-18192-1-git-send-email-sjoerd.simons@collabora.co.uk>
 <540ED495.20609@collabora.co.uk>
 <20140910092832.GM30307@lee--X1>
 <1410422429.2857.16.camel@collabora.co.uk>
 <54115F6E.3010007@collabora.co.uk>
 <5411693A.3050300@itdev.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
In-Reply-To: <5411693A.3050300@itdev.co.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Funny timing. I am just reviewing the series from Lee and also stumbled
over modaliases, too...

On Thu, Sep 11, 2014 at 10:19:54AM +0100, Nick Dyer wrote:
> On 11/09/14 09:38, Javier Martinez Canillas wrote:
> > To expand on what Sjoerd already said and just to be sure everyone is o=
n the
> > same page.
> >=20
> > The problem is that right now the driver reports the following modalias:
> >=20
> > # cat /sys/class/i2c-adapter/i2c-8/8-004b/modalias
> > i2c:maxtouch
> >=20
> > but if you look at the module information, that is not a valid alias:
> >=20
> > # modinfo atmel_mxt_ts | grep alias
> > alias:          i2c:mXT224
> > alias:          i2c:atmel_mxt_tp
> > alias:          i2c:atmel_mxt_ts
> > alias:          i2c:qt602240_ts
> > alias:          of:N*T*Catmel,maxtouch*
> >=20
> > which means that udev/kmod can't load the module automatically based on=
 the
> > alias information.
> >=20
> > The aliases are filled by both MODULE_DEVICE_TABLE(i2c, mxt_id) and
> > MODULE_DEVICE_TABLE(of, mxt_of_match) so after Sjoerd's patch:
> >=20
> > # cat /sys/class/i2c-adapter/i2c-8/8-004b/modalias
> > i2c:maxtouch
> >=20
> > # modinfo atmel_mxt_ts | grep alias
> > alias:          i2c:mXT224
> > alias:          i2c:maxtouch
> > alias:          i2c:atmel_mxt_tp
> > alias:          i2c:atmel_mxt_ts
> > alias:          i2c:qt602240_ts
> >=20
> > which matches the reported uevent so the module will be auto-loaded.
> >=20
> > This is because the I2C subsystem hardcodes i2c:<client->name>, if you =
look at
> > drivers/i2c/i2c-core.c:
> >=20
> > /* uevent helps with hotplug: modprobe -q $(MODALIAS) */
> > static int i2c_device_uevent(struct device *dev, struct kobj_uevent_env=
 *env)
> > {
> > ...
> >         if (add_uevent_var(env, "MODALIAS=3D%s%s",
> >                            I2C_MODULE_PREFIX, client->name))
> > ...
> > }
> >=20
> > I've looked at Lee's series and AFAICT that remains the same so I second
> > Sjoerd that module auto-loading will continue to be broken.

I think the above code in the i2c core needs a fix. Will have a closer
look after lunch.

> The i2c aliases are a bit confusing. The original device the driver was
> written for was called qt602240, which was renamed by Atmel to mXT224 when
> the chip series was called "maXTouch". The driver now actually supports
> many other chips which aren't listed (more than 20 devices that I've
> personally tested). I could add them all, but it would be an extremely lo=
ng
> list. It may be preferable to use the generic name maXTouch.

This is probably true for some more I2C devices. Like RTCs being
compatible or, most prominent, EEPROMS. I don't want to have a list of
all vendors producing 24c02s if they are all compatible. If generic
entries are frowned upon, I'd agree on a "first come, first served" policy:
Somebody provides one compatible-property with the vendor which happens
to be on that board, and the others have to reuse that
compatible-property since they are, well, compatible.

> So I think the sensible thing to do here would be to add "maxtouch" to the
> i2c list to fix the module autoload issue.

This is a workaround. It would make sense, however, to add it because we
want to support i2c_board_info structures.

Regards,

   Wolfram


--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUEYKsAAoJEBQN5MwUoCm2MisP/j6KMB98jM2SPQCfaOhxV5GD
8e0Q8w3h5eqj6yZHP+Rb4YdKxcy8mvqDskifLBbnpVVOQEo7n9ANdX8iNKhmU16m
e0BIakqL6BogcCb2A8R6796nHp3+f82tvLIIUQlnPdDT8JfAImu4eBbapLAXyN9L
PjGPdohFDIY6zB+F1AyfRa27VDtMQEZ/xnV7G3NOgiFTiYAKyLXsFjvQl6iPfx06
1LNlEUo6D+0DYMU7mj3r2OeWQQ1viymTdjPX1n08NZ2bZj7BtjM03pwkBxhub7q1
hTCTuF7g08fDnsQi3o9oRJIK0lSrg75Sde681y+l14bfSuoIOUrsYWzhIMgCF+Am
psOM1dS2juNwC1NZ0tGdq/TcHF/+KAR/DyL2xHndCHgc6dg+eJAH0B+soAvOJCnA
dM1AeAyCH+6wY/KbRNuXQz+/kic4x/yc7oWFtqYX2rpFqEz37LQsa5360gsiP4Bz
sUnWuWhFRyqs14qFFvO1jpGGmL95EkGSYJVrlnGMdm07YIDYsLSsOBT2tEFP4JZ+
1ST+419kVg5lICuekEZuu0966wsY1vFBiIAwPid8f9HgUO/loUdrzPTVgfjcqFeQ
ght74/8aku2zplK7C+FXDVHZEOWG5cNnGnGSVqxKKBXbO3vJuxvOvzJaA4G8fvNU
LtHWsAp3mgguUbOCkMnK
=ovMj
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
