Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbaKROHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:07:35 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48642 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbaKROHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:07:33 -0500
Date: Tue, 18 Nov 2014 14:06:58 +0000
From: Mark Brown <broonie@kernel.org>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: linux-spi@vger.kernel.org, Carlo Caione <carlo@caione.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>
Message-ID: <20141118140658.GI22111@sirena.org.uk>
References: <1416264471-774-1-git-send-email-b.galvani@gmail.com>
 <1416264471-774-2-git-send-email-b.galvani@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SdaPbLtAangIkrMZ"
Content-Disposition: inline
In-Reply-To: <1416264471-774-2-git-send-email-b.galvani@gmail.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 81.128.185.34
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/4] spi: Add 'last' flag to spi_transfer structure
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SdaPbLtAangIkrMZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 17, 2014 at 11:47:48PM +0100, Beniamino Galvani wrote:

> +	list_for_each_entry(xfer, &master->cur_msg->transfers, transfer_list) {
> +		xfer->last = list_is_last(&xfer->transfer_list,
> +					  &master->cur_msg->transfers);
> +	}

It's incredibly sad to iterate through the entire list in order to find
the last entry, especially given that it's a doubly linked list and this
is a bit of a hot path.  We should look at the previous entry for the
list head instead, or perhaps better yet by doing this as part of
spi_validate() which already itereates over the entire list and is where
we do other similar fixups.

Though looking at this I'm not sure that a flag is the best approach at
all - why not just have the driver call list_is_last() in the transfer
function or ideally provide an inline function that does that so that we
can change the implementation later?

--SdaPbLtAangIkrMZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUa1J9AAoJECTWi3JdVIfQ6SkH/3cdLDQfSJnP1yztcWiTP2H0
tKqdrVTCqE9+0oB7imoc8AKgh8DNsGVFPcFEwbYyKZIjsKDfyvGRwDVqDVMY91tz
KVECDQUYF/37VwMLGs8OSdd9SMF0CwRZbQMNivtAP5OabtpamZXFm9ubBMvrDmFZ
5FWNJ4TNKqHngUSwy9VIR7UvXdgl1N0KiwFCbbLvENk1ozmou3T5DCXZfe8RnvKR
MceKTZvLgirOAwJIDSN4zsYjJa9By91xieerdKO0l/pgg+N5XpuZ3rDGN0GeQDSo
ofOAgD2MNuAOSD7oyQELmDsHHuZwe42cKfGFG3Ux+MlATw+S87uao17PV2ry5oo=
=ehmG
-----END PGP SIGNATURE-----

--SdaPbLtAangIkrMZ--
