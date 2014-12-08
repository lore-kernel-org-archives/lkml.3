Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbaLHQre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 11:47:34 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:12168 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755101AbaLHQrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 11:47:31 -0500
X-PGP-Universal: processed;
	by imgpgp01.kl.imgtec.org on Mon, 08 Dec 2014 16:47:29 +0000
Message-ID: <5485D620.7010900@imgtec.com>
Date: Mon, 8 Dec 2014 16:47:28 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.0
MIME-Version: 1.0
To: Sifan Naeem <sifan.naeem@imgtec.com>, <mchehab@osg.samsung.com>
CC: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <james.hartley@imgtec.com>, <ezequiel.garcia@imgtec.com>
Subject: Re: [PATCH 1/5] rc: img-ir: add scancode requests to a struct
References: <1417707523-7730-1-git-send-email-sifan.naeem@imgtec.com> <1417707523-7730-2-git-send-email-sifan.naeem@imgtec.com>
In-Reply-To: <1417707523-7730-2-git-send-email-sifan.naeem@imgtec.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="7M3PHuQfHS3VsshHw3Gehd5tFVlEsmsAt"
X-Originating-IP: [192.168.154.101]
X-ESG-ENCRYPT-TAG: b93fcccb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7M3PHuQfHS3VsshHw3Gehd5tFVlEsmsAt
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/12/14 15:38, Sifan Naeem wrote:
> The information being requested of hardware decode callbacks through
> the img-ir-hw scancode API is mounting up, so combine it into a struct
> which can be passed in with a single pointer rather than multiple
> pointer arguments. This allows it to be extended more easily without
> touching all the hardware decode callbacks.
>=20
> Signed-off-by: Sifan Naeem <sifan.naeem@imgtec.com>

Acked-by: James Hogan <james.hogan@imgtec.com>

Cheers
James

> ---
>  drivers/media/rc/img-ir/img-ir-hw.c    |   16 +++++++++-------
>  drivers/media/rc/img-ir/img-ir-hw.h    |   16 ++++++++++++++--
>  drivers/media/rc/img-ir/img-ir-jvc.c   |    8 ++++----
>  drivers/media/rc/img-ir/img-ir-nec.c   |   24 ++++++++++++------------=

>  drivers/media/rc/img-ir/img-ir-sanyo.c |    8 ++++----
>  drivers/media/rc/img-ir/img-ir-sharp.c |    8 ++++----
>  drivers/media/rc/img-ir/img-ir-sony.c  |   12 ++++++------
>  7 files changed, 53 insertions(+), 39 deletions(-)
>=20
> diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img=
-ir/img-ir-hw.c
> index ec49f94..61850a6 100644
> --- a/drivers/media/rc/img-ir/img-ir-hw.c
> +++ b/drivers/media/rc/img-ir/img-ir-hw.c
> @@ -789,20 +789,22 @@ static void img_ir_handle_data(struct img_ir_priv=
 *priv, u32 len, u64 raw)
>  	struct img_ir_priv_hw *hw =3D &priv->hw;
>  	const struct img_ir_decoder *dec =3D hw->decoder;
>  	int ret =3D IMG_IR_SCANCODE;
> -	u32 scancode;
> -	enum rc_type protocol =3D RC_TYPE_UNKNOWN;
> +	struct img_ir_scancode_req request;
> +
> +	request.protocol =3D RC_TYPE_UNKNOWN;
> =20
>  	if (dec->scancode)
> -		ret =3D dec->scancode(len, raw, &protocol, &scancode, hw->enabled_pr=
otocols);
> +		ret =3D dec->scancode(len, raw, hw->enabled_protocols, &request);
>  	else if (len >=3D 32)
> -		scancode =3D (u32)raw;
> +		request.scancode =3D (u32)raw;
>  	else if (len < 32)
> -		scancode =3D (u32)raw & ((1 << len)-1);
> +		request.scancode =3D (u32)raw & ((1 << len)-1);
>  	dev_dbg(priv->dev, "data (%u bits) =3D %#llx\n",
>  		len, (unsigned long long)raw);
>  	if (ret =3D=3D IMG_IR_SCANCODE) {
> -		dev_dbg(priv->dev, "decoded scan code %#x\n", scancode);
> -		rc_keydown(hw->rdev, protocol, scancode, 0);
> +		dev_dbg(priv->dev, "decoded scan code %#x\n",
> +			request.scancode);
> +		rc_keydown(hw->rdev, request.protocol, request.scancode, 0);
>  		img_ir_end_repeat(priv);
>  	} else if (ret =3D=3D IMG_IR_REPEATCODE) {
>  		if (hw->mode =3D=3D IMG_IR_M_REPEATING) {
> diff --git a/drivers/media/rc/img-ir/img-ir-hw.h b/drivers/media/rc/img=
-ir/img-ir-hw.h
> index 8fcc16c..1fc9583 100644
> --- a/drivers/media/rc/img-ir/img-ir-hw.h
> +++ b/drivers/media/rc/img-ir/img-ir-hw.h
> @@ -133,6 +133,18 @@ struct img_ir_timing_regvals {
>  #define IMG_IR_REPEATCODE	1	/* repeat the previous code */
> =20
>  /**
> + * struct img_ir_scancode_req - Scancode request data.
> + * @protocol:	Protocol code of received message (defaults to
> + *		RC_TYPE_UNKNOWN).
> + * @scancode:	Scan code of received message (must be written by
> + *		handler if IMG_IR_SCANCODE is returned).
> + */
> +struct img_ir_scancode_req {
> +	enum rc_type protocol;
> +	u32 scancode;
> +};
> +
> +/**
>   * struct img_ir_decoder - Decoder settings for an IR protocol.
>   * @type:	Protocol types bitmap.
>   * @tolerance:	Timing tolerance as a percentage (default 10%).
> @@ -162,8 +174,8 @@ struct img_ir_decoder {
>  	struct img_ir_control		control;
> =20
>  	/* scancode logic */
> -	int (*scancode)(int len, u64 raw, enum rc_type *protocol,
> -			u32 *scancode, u64 enabled_protocols);
> +	int (*scancode)(int len, u64 raw, u64 enabled_protocols,
> +			struct img_ir_scancode_req *request);
>  	int (*filter)(const struct rc_scancode_filter *in,
>  		      struct img_ir_filter *out, u64 protocols);
>  };
> diff --git a/drivers/media/rc/img-ir/img-ir-jvc.c b/drivers/media/rc/im=
g-ir/img-ir-jvc.c
> index a60dda8..d3e2fc0 100644
> --- a/drivers/media/rc/img-ir/img-ir-jvc.c
> +++ b/drivers/media/rc/img-ir/img-ir-jvc.c
> @@ -12,8 +12,8 @@
>  #include "img-ir-hw.h"
> =20
>  /* Convert JVC data to a scancode */
> -static int img_ir_jvc_scancode(int len, u64 raw, enum rc_type *protoco=
l,
> -			       u32 *scancode, u64 enabled_protocols)
> +static int img_ir_jvc_scancode(int len, u64 raw, u64 enabled_protocols=
,
> +			       struct img_ir_scancode_req *request)
>  {
>  	unsigned int cust, data;
> =20
> @@ -23,8 +23,8 @@ static int img_ir_jvc_scancode(int len, u64 raw, enum=
 rc_type *protocol,
>  	cust =3D (raw >> 0) & 0xff;
>  	data =3D (raw >> 8) & 0xff;
> =20
> -	*protocol =3D RC_TYPE_JVC;
> -	*scancode =3D cust << 8 | data;
> +	request->protocol =3D RC_TYPE_JVC;
> +	request->scancode =3D cust << 8 | data;
>  	return IMG_IR_SCANCODE;
>  }
> =20
> diff --git a/drivers/media/rc/img-ir/img-ir-nec.c b/drivers/media/rc/im=
g-ir/img-ir-nec.c
> index 7398975..27a7ea8 100644
> --- a/drivers/media/rc/img-ir/img-ir-nec.c
> +++ b/drivers/media/rc/img-ir/img-ir-nec.c
> @@ -13,8 +13,8 @@
>  #include <linux/bitrev.h>
> =20
>  /* Convert NEC data to a scancode */
> -static int img_ir_nec_scancode(int len, u64 raw, enum rc_type *protoco=
l,
> -			       u32 *scancode, u64 enabled_protocols)
> +static int img_ir_nec_scancode(int len, u64 raw, u64 enabled_protocols=
,
> +			       struct img_ir_scancode_req *request)
>  {
>  	unsigned int addr, addr_inv, data, data_inv;
>  	/* a repeat code has no data */
> @@ -30,23 +30,23 @@ static int img_ir_nec_scancode(int len, u64 raw, en=
um rc_type *protocol,
>  	if ((data_inv ^ data) !=3D 0xff) {
>  		/* 32-bit NEC (used by Apple and TiVo remotes) */
>  		/* scan encoding: as transmitted, MSBit =3D first received bit */
> -		*scancode =3D bitrev8(addr)     << 24 |
> -			    bitrev8(addr_inv) << 16 |
> -			    bitrev8(data)     <<  8 |
> -			    bitrev8(data_inv);
> +		request->scancode =3D bitrev8(addr)     << 24 |
> +				bitrev8(addr_inv) << 16 |
> +				bitrev8(data)     <<  8 |
> +				bitrev8(data_inv);
>  	} else if ((addr_inv ^ addr) !=3D 0xff) {
>  		/* Extended NEC */
>  		/* scan encoding: AAaaDD */
> -		*scancode =3D addr     << 16 |
> -			    addr_inv <<  8 |
> -			    data;
> +		request->scancode =3D addr     << 16 |
> +				addr_inv <<  8 |
> +				data;
>  	} else {
>  		/* Normal NEC */
>  		/* scan encoding: AADD */
> -		*scancode =3D addr << 8 |
> -			    data;
> +		request->scancode =3D addr << 8 |
> +				data;
>  	}
> -	*protocol =3D RC_TYPE_NEC;
> +	request->protocol =3D RC_TYPE_NEC;
>  	return IMG_IR_SCANCODE;
>  }
> =20
> diff --git a/drivers/media/rc/img-ir/img-ir-sanyo.c b/drivers/media/rc/=
img-ir/img-ir-sanyo.c
> index 6b0653e..f394994 100644
> --- a/drivers/media/rc/img-ir/img-ir-sanyo.c
> +++ b/drivers/media/rc/img-ir/img-ir-sanyo.c
> @@ -23,8 +23,8 @@
>  #include "img-ir-hw.h"
> =20
>  /* Convert Sanyo data to a scancode */
> -static int img_ir_sanyo_scancode(int len, u64 raw, enum rc_type *proto=
col,
> -				 u32 *scancode, u64 enabled_protocols)
> +static int img_ir_sanyo_scancode(int len, u64 raw, u64 enabled_protoco=
ls,
> +				 struct img_ir_scancode_req *request)
>  {
>  	unsigned int addr, addr_inv, data, data_inv;
>  	/* a repeat code has no data */
> @@ -44,8 +44,8 @@ static int img_ir_sanyo_scancode(int len, u64 raw, en=
um rc_type *protocol,
>  		return -EINVAL;
> =20
>  	/* Normal Sanyo */
> -	*protocol =3D RC_TYPE_SANYO;
> -	*scancode =3D addr << 8 | data;
> +	request->protocol =3D RC_TYPE_SANYO;
> +	request->scancode =3D addr << 8 | data;
>  	return IMG_IR_SCANCODE;
>  }
> =20
> diff --git a/drivers/media/rc/img-ir/img-ir-sharp.c b/drivers/media/rc/=
img-ir/img-ir-sharp.c
> index 3300a38..fe5acc4 100644
> --- a/drivers/media/rc/img-ir/img-ir-sharp.c
> +++ b/drivers/media/rc/img-ir/img-ir-sharp.c
> @@ -12,8 +12,8 @@
>  #include "img-ir-hw.h"
> =20
>  /* Convert Sharp data to a scancode */
> -static int img_ir_sharp_scancode(int len, u64 raw, enum rc_type *proto=
col,
> -				 u32 *scancode, u64 enabled_protocols)
> +static int img_ir_sharp_scancode(int len, u64 raw, u64 enabled_protoco=
ls,
> +				 struct img_ir_scancode_req *request)
>  {
>  	unsigned int addr, cmd, exp, chk;
> =20
> @@ -32,8 +32,8 @@ static int img_ir_sharp_scancode(int len, u64 raw, en=
um rc_type *protocol,
>  		/* probably the second half of the message */
>  		return -EINVAL;
> =20
> -	*protocol =3D RC_TYPE_SHARP;
> -	*scancode =3D addr << 8 | cmd;
> +	request->protocol =3D RC_TYPE_SHARP;
> +	request->scancode =3D addr << 8 | cmd;
>  	return IMG_IR_SCANCODE;
>  }
> =20
> diff --git a/drivers/media/rc/img-ir/img-ir-sony.c b/drivers/media/rc/i=
mg-ir/img-ir-sony.c
> index 3a0f17b..7f7375f 100644
> --- a/drivers/media/rc/img-ir/img-ir-sony.c
> +++ b/drivers/media/rc/img-ir/img-ir-sony.c
> @@ -12,8 +12,8 @@
>  #include "img-ir-hw.h"
> =20
>  /* Convert Sony data to a scancode */
> -static int img_ir_sony_scancode(int len, u64 raw, enum rc_type *protoc=
ol,
> -				u32 *scancode, u64 enabled_protocols)
> +static int img_ir_sony_scancode(int len, u64 raw, u64 enabled_protocol=
s,
> +				struct img_ir_scancode_req *request)
>  {
>  	unsigned int dev, subdev, func;
> =20
> @@ -25,7 +25,7 @@ static int img_ir_sony_scancode(int len, u64 raw, enu=
m rc_type *protocol,
>  		raw    >>=3D 7;
>  		dev    =3D raw & 0x1f;	/* next 5 bits */
>  		subdev =3D 0;
> -		*protocol =3D RC_TYPE_SONY12;
> +		request->protocol =3D RC_TYPE_SONY12;
>  		break;
>  	case 15:
>  		if (!(enabled_protocols & RC_BIT_SONY15))
> @@ -34,7 +34,7 @@ static int img_ir_sony_scancode(int len, u64 raw, enu=
m rc_type *protocol,
>  		raw    >>=3D 7;
>  		dev    =3D raw & 0xff;	/* next 8 bits */
>  		subdev =3D 0;
> -		*protocol =3D RC_TYPE_SONY15;
> +		request->protocol =3D RC_TYPE_SONY15;
>  		break;
>  	case 20:
>  		if (!(enabled_protocols & RC_BIT_SONY20))
> @@ -44,12 +44,12 @@ static int img_ir_sony_scancode(int len, u64 raw, e=
num rc_type *protocol,
>  		dev    =3D raw & 0x1f;	/* next 5 bits */
>  		raw    >>=3D 5;
>  		subdev =3D raw & 0xff;	/* next 8 bits */
> -		*protocol =3D RC_TYPE_SONY20;
> +		request->protocol =3D RC_TYPE_SONY20;
>  		break;
>  	default:
>  		return -EINVAL;
>  	}
> -	*scancode =3D dev << 16 | subdev << 8 | func;
> +	request->scancode =3D dev << 16 | subdev << 8 | func;
>  	return IMG_IR_SCANCODE;
>  }
> =20
>=20


--7M3PHuQfHS3VsshHw3Gehd5tFVlEsmsAt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUhdYgAAoJEGwLaZPeOHZ6eAQQAKgcrhhVcE+bKpN0eFaSR2DQ
tsO+SJiBccoavo64jg0V7OHrE+5x4FGyqEcqRz9AlhToXgCkk7AuydTVusIVSrnl
vtl7aQt3EcYmiUkTMl2t0FEpu3m1iE3UhiU5S/DphUc5aYQ/dox8w6tyFvKEw6Si
leN1RRZI4Uncp+Gm8oMDGtnh3pZEBzKzYhB+G2/MlK06K/DwD5j7jZOs9e/2x5T7
64lFdMPm8boYejpN4XoR1uXiZgRQjBJPCh37k394vADw8LBAN4hxp0ABErcBxxpb
TJ7R2tryixSRJI7z7HrqW279f5CDC3msYA1ya8w01kLF40zVxaK/CRufzFh5mLmu
4pzYRcsDXDmu0U/ZLVJ6+jxV60AfmpXDyMjTtTpZvxRthvQhcP2gsxP/yxfXq+O6
6PJgu7CG2Fd4Ru/jH1r74K0aGisVqrzbswwMycMSTIniK1s1YeHJKxM7g7jFk8/T
sumMWF+XnRTEHCPeqwVEhidcCaev1lkz4ua+RjpEojFQbjD6slWGDjGNQI7cUuPp
lF76JL0/TCipgpyiJyUsgH84cnb4CriioWUvWknAvr4AACKjvL/duLyJQNYqdrNl
ewfwwMYTPkuh3v933UHqhxDAURd1G/LNp3iev2SYWGfiFl9Zlq8Vye6vRLBc0BIz
RRKGXqoGX0JL9GXvxnBG
=Posb
-----END PGP SIGNATURE-----

--7M3PHuQfHS3VsshHw3Gehd5tFVlEsmsAt--
