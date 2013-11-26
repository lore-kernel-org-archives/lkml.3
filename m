Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab3KZM2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 07:28:24 -0500
Received: from sauhun.de ([89.238.76.85]:40362 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744Ab3KZM2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 07:28:22 -0500
Date: Tue, 26 Nov 2013 13:28:18 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH] i2c-mux-pca954x: Disable mux after 200ms timeout
Message-ID: <20131126122818.GA7427@katana>
References: <1385447520-3306-1-git-send-email-mike.looijmans@topic.nl>
 <20131126090639.GA2568@katana>
 <52946BA6.3080308@topic.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <52946BA6.3080308@topic.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


CCing linux-pm, maybe they know more...

> The extra I2C traffic consumes extra power. If the bus is terminated
> using 2k resistors, approximately 1mA of current (assuming ~2V
> signals) is flowing when the bus is pulled low. On low power
> designs, this extra power consumption is noticable. There is no way
> to turn the mux "off" from either user or kernel space. The signals
> going through the mux to a place where no I2C device is actually
> listening are only wasting power.

I only have an overview of current linux pm mechanisms. I wonder if
those can't be used somehow. Like if devices on the multiplexed bus are
idle (well, only regarding transfers), then we can switch off the muxer.

> The I2C signals are used to control sensitive codecs. When looking
> at the sampled data, the I2C traffic is visible in the captured
> analog signal. To prevent this from happening, the mux can be

I wonder: Is this really a feature of sensitive codecs or an issue of
the board design?

> disabled whenever not communicating with the codec. This could be
> accomplished with the "deselect_on_exit" boolean, but because audio
> driver sends the codec parameters in dozens of small transactions,
> this will result in a lot more needless I2C traffic, constantly
> switching the mux for each codec setting.

Has this been looked at? ASoC supports grouping of tranfers IIRC. Maybe
your I2C driver is only missing I2C_M_NOSTART?.

> Would it be acceptable if I made the timeout optional, by making the
> "deselect_on_exit" boolean into a three-state value (off, on,
> timeout)? Or, alternatively, implement "deselect_on_exit" using the
> timeout scheme (probably with a very short timeout)?

I have a number of concerns designwise. First, if we do something like
shutting-down-a-bus-if-there-are-no-transfers-expected, it definately
should be in the core, not the driver. As said before, I have the
assumption it should even be connected to the runtime pm core via some
callback. And if we have that for I2C, we surely want that for other
buses as well, at least SPI. Also, the timeout thing sounds too
heuristic to me. Later, people might want to change the timeout value
depending on workloads or so, and then a governor, etc... No, thanks.

BTW is it feasible to shut down the whole I2C bus at controller level
after transfers? No needless transfers and maybe even more power
savings.

Anyway, thanks for letting me know about your requirements (they should
have been in the original commit message, though ;))


--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSlJPiAAoJEBQN5MwUoCm2WaAP/jEQxpzpkCRv30ek392aaFSH
oR+BKUv02Kt/pcbjlGfAX6e0gN1cCVgPMKXU0nf0nb2s+gNQBJWQvWxwLLvhtwu4
fGbrrfgt2hIxXbdjy+/cTN5r/KkmmJp9bYJyEnDy/bx+H2RVLGB2gyNDlWXRmWIP
+GVs4NO5GgDz5KaBVKhNxfK4K98+2NFY70xZZqCTZEbgTJhCwU+8dbFz9kMkPSrG
PyHJ13DhLkM6Rwc60PCPcLpFny2lb27kPa1vbnrEphEWvV5uzi3LI7LArD7j6mPk
iBwU0kayze/wGUgPCAsA1qTeT9SSC7siB2e7RfeglG2xeB0f/z9dT8mbeJPKBDRO
HxVC6A9nMQelX2V/WsGFcuiKb7Xd7t9+qisvRkqtvB+XF8xIgZWKrXmSXl1pMs/+
SAyNVbTQK2lLOHdGNVBeFVaZkeqwAQIfK5fqyQmbRbhF5UQHj6CNUHf3ILjmxg55
Ud0Z0R4ow2ZbOToi5bn96wuYQbFbQyPisb+V9rXnDzAFyHIxzjRFP+5C9NER4gYi
fAQrTkS1g0fr9erX+58wzDAUZcO8Ue12mmXZnwXpJlEfSwnu/8Zq26sHqsBMeqfE
sH6ua1yCNAJx/zubQaUtkd/Ot8MGs/3bZvdrGPx14Er9t1lka6fGQQaNZNxMVLFk
5z0Rv2w6q/iMK9LCvbno
=8bpp
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
