Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbaB0Lh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:37:56 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52868 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbaB0Lhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:37:55 -0500
Date: Thu, 27 Feb 2014 20:37:48 +0900
From: Mark Brown <broonie@kernel.org>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Message-ID: <20140227113748.GY9383@sirena.org.uk>
References: <1393473057-19919-1-git-send-email-abrestic@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2VOk7s3pVsDYAazo"
Content-Disposition: inline
In-Reply-To: <1393473057-19919-1-git-send-email-abrestic@chromium.org>
X-Cookie: Q:	Are we not men?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 175.126.181.193
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: don't use spinlocks with
 REGCACHE_{RBTREE,COMPRESSED}
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2VOk7s3pVsDYAazo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 26, 2014 at 07:50:57PM -0800, Andrew Bresticker wrote:
> Both REGCACHE_RBTREE and REGCACHE_COMPRESSED make GFP_KERNEL allocations
> with the regmap lock held.  If we're initializing a regmap which would
> normally use a spinlock (e.g. MMIO), fall back to using a mutex if one
> of these caching types is to be used.

Have all the users been audited to verify that they're actually safe
with this?  I just took a quick look at the Tegra drivers and they're
doing regmap operations in their trigger operations which is done from
atomic context so they should run into problems trying to take mutexes
anyway.

I think we need to either ensure that all users allocate their caches at
probe time (which is fine and is hopefully what the current users are
doing), provide a mechanism for them to do cache allocations outside of
the spinlock (which sounds hairy) or convert them to flat cache.

--2VOk7s3pVsDYAazo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTDyOJAAoJELSic+t+oim9fKgP/RjTj/rFc56CP7KzzkDsKI2w
uMkLsVCv/5SE+pt0503BEPR6iP1bN4EQlYmY+2s/Dr6wqRXr/Uz+ebe3Uu2cwZo5
1yjZwSFdFej5kk6JT6tmQIBsVxKOmj1FarN1g7vKUun5SmOwgOaxe+ybCB6Y5bJj
/1h3p4wNdaF/6cJ938tLNQ2YHFLfuC4bezjhyR/duTzmnttUd3aPmptyg6ndLvof
7/eJQJ0gc7X6/mGfcBYHa8CaE8TiPYYy3dvkoLnnjhMpUs1Nt5n/gDu1dY+B+C9i
7pjcK58P7hoYLYMq8UwygSiIb5TwTLOHDpU1iB3MfZ3e3AgdKeD/y3qffu/hs6AT
IEg0ThfX5e3MCm7qZ2E/BAZunEaUwnqs90wmVaHfNg/aacUtaHEt8aLVfrdgzNhx
SbbUrqRuoBkemPplm1xQMCby/cUTORj9/UE4dLGCsMU3S2/JxUU3ZEiIuRzttjRR
8lGowxqS3ySkQBULpf3deBCq2/4wYXC8bfPD32dNTJkeb2uF3atgO78/6X9KfKN8
LYyEZqG8FL10tBOhprIVue6pvY5lVVSpwNvQ+taRW76YGN9p/OcHmuXH6AKqlO/Z
BTnCmcH0mFbVDca6l82ZXv/S5bGlK5py29eTbdFuH93AH//RMsakFcRbEevFoRtu
Tck89H/5G8qpx9MsEfGq
=n0r3
-----END PGP SIGNATURE-----

--2VOk7s3pVsDYAazo--
