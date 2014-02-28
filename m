Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbaB1VJF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 16:09:05 -0500
Received: from ring0.de ([5.45.105.125]:41751 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbaB1VJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 16:09:03 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Fri, 28 Feb 2014 22:08:57 +0100
From: Sebastian Reichel <sre@debian.org>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv1 1/2] rx51_battery: convert to iio consumer
Message-ID: <20140228210857.GA17467@earth.universe>
References: <1393375569-21751-1-git-send-email-sre@debian.org>
 <1393375569-21751-2-git-send-email-sre@debian.org>
 <CAAfyv37B=xn3AktnUxPDpuey+5S73vW0PJnuUZtorP4rajPKiw@mail.gmail.com>
 <20140226215452.GA11468@earth.universe>
 <CAAfyv340pA2ihUAoFytBgevLtedvtj5Z0aw_=G9Rbx5occtyqw@mail.gmail.com>
 <20140228020536.GB5427@earth.universe>
 <CAAfyv36jJoMxZQ5e43pEC2rzNBHHW9Jt_4dg5O-fS8e+Aim7jA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
In-Reply-To: <CAAfyv36jJoMxZQ5e43pEC2rzNBHHW9Jt_4dg5O-fS8e+Aim7jA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 28, 2014 at 09:32:12PM +0100, Belisko Marek wrote:
> On Fri, Feb 28, 2014 at 3:05 AM, Sebastian Reichel <sre@debian.org> wrote:
> > On Thu, Feb 27, 2014 at 10:34:35PM +0100, Belisko Marek wrote:
> >> Well I've tried and it's worse :). I got during booting:
> >> [    2.218383] ERROR: could not get IIO channel /battery:temp(0)
> >> [    2.224639] platform battery.4: Driver twl4030_madc_battery
> >> requests probe deferral
> >> Not sure if it's just error or warning but temp is always reported as
> >> 0 (and also other values in sysfs).
> >
> > This is an error, which basically means, that twl4030-madc has not
> > yet been loaded. Do you get proper values when you use the old madc
> > API with the patchset applied?
>
> It works without converting to iio consumer (at least I get some
> reasonable values).  With conversion it fails with above error. I
> recheck (add printk to iio twl4030-madc) that madc driver is
> loaded. Could this be that twl4030_madc_battery is loaded earlier
> then twl4030_madc and than it fails to get iio channels?

The error above implies, that twl4030-madc has not been loaded when
twl4030-madc-battery was loaded. This iio_channel_get() fails and
returns -EPROBE_DEFER. This results in twl4030-madc-battery probe
function returning -EPROBE_DEFER. Thus you can simply ignore the
error if the twl4030-madc-battery driver is loaded later.

I guess the easiest way to debug the problem is adding some
dev_dbg() at the start of twl4030_madc_conversion(), which
prints out the entries of twl4030_madc_request. Currently
the IIO API simply calls twl4030_madc_request(), so you
should be able to find out the difference.

Also: Can you post you DTS? I use the following for Nokia N900:

/ {
	battery: n900-battery {
		compatible = "nokia,n900-battery";
		io-channels = <&twl_madc 0>, <&twl_madc 4>, <&twl_madc 12>;
		io-channel-names = "temp", "bsi", "vbat";
	};
};

&twl {
	twl_madc: madc {
		compatible = "ti,twl4030-madc";
		interrupts = <3>;
		#io-channel-cells = <1>;
	};
};

-- Sebastian

--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTEProAAoJENju1/PIO/qaPZUP/jS1e9kxUurwvO9mi7nIMcRc
kGCvikB4FvXrd1NdLj8cshI9Qpwjg0aYfDXIxB5x6hpR9vlgqmEZAx/9jXgfVUyR
mbO2dukkuqv0Jw+33zQzp8DxQcbAFlUhsgqSZxOTfIqcXMLlJTbQaNviMZwQs+4g
PDmxjQFmFAoNO6XAQ84/pfY/P0PdooyM4wr7l3mb9MuDqYn9N9bP+i5Go8b02YPM
rh5Cr5xvstpgVJnh+0jA3cpkCTX3IEeJVw6gBZaCbKgAbnn35nrJqMYL+D0mtxi5
i3oO+ZnNI4jxmnGqdxn/vGjb1bJVfxX9SEWXqrD+QhwJCyRI2inoIWjRfYLvcv2Y
8QOE9/KxY0OhTOdsjb5xWMRyd7K8XmaOikSrx3XHk2Xv8gRb08jrlomWJocuM14a
bZioEvySaqV86XOds0paSgVfh/urn4luq6wiBAzuHS5xh8iwXnb62XhNxfHZOc4v
0PD6o76RTkpEFCC9uUqRqwt6qUuFaDHD1QjhDbtXEGX+oFapyd5Gbq4Ra3eyONeN
51lNL3XnWwiTReFHdZhlvuphK8g3B9TRne8/ELznF+1qiLyvOkMCsoQL3oUCInqd
14Afo6BinK6101gSQPQys55mqCduucka7jAdjAdyuht512oHpQXevbnByuYAV68U
INu75/pphIKxmcsH+H+M
=T076
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
