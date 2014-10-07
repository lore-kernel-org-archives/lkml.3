Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbaJGQv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 12:51:59 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40744 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbaJGQv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 12:51:57 -0400
Date: Tue, 7 Oct 2014 11:51:49 -0500
From: Felipe Balbi <balbi@ti.com>
To: Krzysztof Opasiak <k.opasiak@samsung.com>
CC: <balbi@ti.com>, "'Robert Baldyga'" <r.baldyga@samsung.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mina86@mina86.com>,
        <andrzej.p@samsung.com>
Subject: Re: [PATCH] usb: gadget: f_fs: add "zombie" mode
Message-ID: <20141007165149.GT24720@saruman>
Reply-To: <balbi@ti.com>
References: <1412594714-535-1-git-send-email-r.baldyga@samsung.com>
 <20141007022851.GA13956@saruman>
 <5433892C.80109@samsung.com>
 <20141007140656.GB24720@saruman>
 <0a2301cfe23f$8b4a40b0$a1dec210$%opasiak@samsung.com>
 <20141007152822.GO24720@saruman>
 <0a3e01cfe24c$fb865370$f292fa50$%opasiak@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2mNuWrpDTYoom6W8"
Content-Disposition: inline
In-Reply-To: <0a3e01cfe24c$fb865370$f292fa50$%opasiak@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--2mNuWrpDTYoom6W8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 07, 2014 at 06:37:26PM +0200, Krzysztof Opasiak wrote:

[snip]

> > yeah, and the way to deal with that is disconnecting from the host
> > because that USB function, can't be functional anymore. I mean,
> > imagine you try to e.g. unload pictures from your nice DSLR and
> > that DSLR runs Linux and implements MTP or PTP using FFS. Then ptpd
> > dies and you're still connected to the host so you can't know that
> > something went wrong, the camera just stoped sending you data. So
> > you figure: well, it must just be slow, I'll leave it here and go
> > have a nap. Hours later and nothing has changed, because ptpd is
> > still missing.
> >=20
> > If you disconnect from the host, however, user knows
> > instantaneously that something went wrong.
>=20
> Please believe me that I totally agree with you, but I also see Robert's
> point. Let's take ADB as example. Before ADB has been ported to
> FunctionFS it communicated with kernel using dev node provided by ADB
> function driver. With that infrastructure death of daemon didn't cause
> gadget unbind because kernel driver of that function was just stalling
> the endpoints. This allows user to use all other functions of this

I really mixed feelings about that. It's really counter-intuitive to
allow a non-working function to be exposed to the host.

> gadget. In current design ADB uses FunctionFS and for example if daemon
> will be killed by OOM whole gadget get's unbind and user cannot use any
> other function. Don't you think that's a bit of regression?

Why ? Why would you event want to keep the other functions working ?
Since you're running out of memory anyway, you'd just delay the
inevitable. Soon enough you won't be able to transfer files through
mtp/ptp, or enable usb tethering, or any of that.

> I see and understand yours and Roberts point of view. Personally I'm not
> too enthusiastic about using this solution but I see some rationales for
> this and use cases. Summing it up, this patch may be useful in some
> case. Let's allow end user to decide whether to use this mode or not. I
> think that a few people will find this useful.

It can't be only end user, we have to also consider USB certification.
If we go to certification with a non-working function (say adbd crashed
during init or whatever), then we won't pass certification.

I would rather cause the gadget to disconnect so any crashes on adbd can
be fixed and we pass certification, then exposing that non-working
function to the host.

OOM is another situation which we don't really have control over.
There's nothing we can do to prevent an application from malloc(1 << 30)
and cause OOM to go crazy, however arguably that application is wrong
for allocating 1GiB of memory, in any case, you get the point :-)

> > I don't think maintaining a "zombie" function is very nice. In
> > fact, the very reason for adding usb_function_activate/deactivate
> > was exactly to prevent us from ever connecting to a host with a
> > non-working function.
>=20
> Here also I agree. Zombie mode should "mock" the function until first
> next enumeration or unbind. It should not be possible to bind gadget
> with function in zombie mode to UDC. Zombie mode should "pretend" only
> as long as gadget is bound and enumerated.

Not really. We shouldn't even coonect to host until adbd is running.
Now, when adbd crashes we fix adbd. If it gets killed due to OOM we
can't even say "ok, we'll buffer USB requests until adbd is restarted"
because, well, we're running out of memory.

So, OOM we can't fix. Soon enough, another daemon (mtpd, ptpd, whatever)
will be killed and another function will be left unusable.

As for adbd/mtpd/ptpd crashes, those need to fixed and kernel should not
have to deal with them in any way.

--=20
balbi

--2mNuWrpDTYoom6W8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUNBolAAoJEIaOsuA1yqREvT4P/0KL08ohBKMFHLtfV6ZPp80/
tuxx/1i48PTXzrKqZ6NL5DT2/xz4CXmf+eV+phoctH0+jcnGPqI3nz0kYGvezi3I
mVUXmb931SHJLg7f5MNdFCnP03POELWLJ3gS/9VuuJKb24Am5LQrMmUSxr8wV8G3
MZSQTdNPWLkeQ2JUzHhflexj05Z5gBCdiSbPA/Oj4SaquisLklIHYltFe4rBAe51
u0xjPOl8Yk4/0ThFydPIpcBiY+KaHO+XnbgzX7em8Csqc1uKblPDwUHP3DyPFril
n5JOJPgmUZlqVUKCMi6mJ+powM3vFgvHf37F4KJExLA01IoO8AkhHtoLN/9Q8cSO
PVNbjfNz1aYh6uk3ZqmyoldcdjR90ZC3yL8tmeaGdVjtToepmEGJjNZ7NnJqgsZe
4ZVNuXbgS1s+w7EusamWDWSvhoD+ajlZuZhTR+xLTcoewAem0YZwfU+9A7bEj1WV
LXxa8YMsoDwv44C1zF0GI12Ivf5cpQVGcjklQ6OdBnkgBwhXn7FZyBgwXwnTwwAQ
JIPZnJl4lllzQZftEphmhjsizcAt7F+x8WOacYI035LH4+hyttrb4WszFt5c/83h
LUEwt/wBejclH6JrUs2KVPzhw9HNSVHo94V+SIM4eNYhWuvSSa6RTyvUy5hvrpWl
sj8JsJY03rQrTAPH6C+I
=T2dN
-----END PGP SIGNATURE-----

--2mNuWrpDTYoom6W8--
