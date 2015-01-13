Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbbAMLfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 06:35:44 -0500
Received: from sauhun.de ([89.238.76.85]:35122 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbbAMLfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 06:35:42 -0500
Date: Tue, 13 Jan 2015 12:35:38 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Harini Katakam <harinik@xilinx.com>
Cc: mark.rutland@arm.com, michal.simek@xilinx.com, soren.brinkmann@xilinx.com,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, harinikatakamlinux@gmail.com,
        Vishnu Motghare <vishnum@xilinx.com>
Subject: Re: [PATCH v5 2/2] i2c: cadence: Check for errata condition
 involving master receive
Message-ID: <20150113113538.GB7660@katana>
References: <1418357907-4215-1-git-send-email-harinik@xilinx.com>
 <1418357907-4215-3-git-send-email-harinik@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CUfgB8w4ZwR/yMy5"
Content-Disposition: inline
In-Reply-To: <1418357907-4215-3-git-send-email-harinik@xilinx.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CUfgB8w4ZwR/yMy5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> @@ -541,6 +541,18 @@ static int cdns_i2c_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
>  	 * processed with a repeated start.
>  	 */
>  	if (num > 1) {
> +		/*
> +		 * This controller does not give completion interrupt after a
> +		 * master receive transfer if HOLD bit is set (repeated start),
> +		 * resulting in SW timeout. Hence, if a receive transfer is
> +		 * followed by any other transfer, an error is returned
> +		 * indicating that this sequence is not supported.
> +		 */
> +		for (count = 0; count < num-1; count++) {
> +			if (msgs[count].flags & I2C_M_RD)
> +				dev_warn(adap->dev.parent, "No support for repeated start when receive is followed by a transfer\n");
> +				return -EOPNOTSUPP;
> +		}
>  		id->bus_hold_flag = 1;
>  		reg = cdns_i2c_readreg(CDNS_I2C_CR_OFFSET);
>  		reg |= CDNS_I2C_CR_HOLD;

Have you ever tested this code? There is a huge bug in it :(

Also, in the comment, use "message" instead of "transfer". One transfer
consists of multiple messages.

Maybe the warning can be simplified, too: "can't do repeated start after
read messages".


--CUfgB8w4ZwR/yMy5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtQMJAAoJEBQN5MwUoCm2GbkQAJ1ou19WCsD54vaH/GhCL3Pq
+ICDCBX413n3hW7+0rBH+iglu8gOitCjzig0rITukINHpKjuUmGQwqtyuUQCpiQM
3ba5WCF9i4EyS5STwuL9vrWuBug9o5ZK2nHFpDT2z/g3RzeY+8Fd0D7FCObIFA84
rud55GY/GUsn7g/MqAOe59C65/ZAGvBxzgwotSrMrUwP2q8AVRcExXHn5jZqKbrr
zXNxu3XZmx7zuc61o1jldQRHXP62bbdEy/+tH3UuLAsvOQc5pxXEClb5TTDsrqWl
YGfnKZ43Nr4DMzUhtnhMQJoh9mdsRUtry6xRUwK5dkdDWSbaiDyd3rYuWHUcK6rn
EgG8DrESnVTThPAOUgov5LMv3GUWtGqJTJciWrwudaX4lgOcDGlVWS/07ndEPRhX
UCP+WvNNhThQjZHdtil0G07Hbobu+OFNnYy5euL6fNgVUZbYtKh+irZMR0G9wSAe
ZDWuuq4ekT7JMXD6gTS9QxXa2whjxQ7D0l5brqvt2WYt4Y8l+fqIg5G6c+7EiSll
fFnEQWKVVyz4m6vlwC2KUo0qNO33nYRXR6PclbuD9eVMmNDQPBJPfh3TD/mxraMW
lXo3BPRfFIGgbQ8uHESqmxPs+f9AseIJeT+lHbyQWi20vs3jycyrP5/YQakW/w5t
Pl0GYHcj6MMCOdOGATxe
=7H8d
-----END PGP SIGNATURE-----

--CUfgB8w4ZwR/yMy5--
