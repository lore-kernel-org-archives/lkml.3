Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145AbaCDMVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 07:21:37 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:36420 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703AbaCDMVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 07:21:35 -0500
Message-ID: <5315C535.2070303@ti.com>
Date: Tue, 4 Mar 2014 14:21:09 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: Grant Likely <grant.likely@linaro.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH v5 5/7] [media] of: move common endpoint parsing to drivers/of
References: <1393522540-22887-1-git-send-email-p.zabel@pengutronix.de>	 <1393522540-22887-6-git-send-email-p.zabel@pengutronix.de>	 <531595AB.4000001@ti.com> <1393932989.3917.62.camel@paszta.hi.pengutronix.de>
In-Reply-To: <1393932989.3917.62.camel@paszta.hi.pengutronix.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="IXxvtPJjNkm96PREqxo5baSKBmbogb4sQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--IXxvtPJjNkm96PREqxo5baSKBmbogb4sQ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 04/03/14 13:36, Philipp Zabel wrote:
> Hi Tomi,
>=20
> Am Dienstag, den 04.03.2014, 10:58 +0200 schrieb Tomi Valkeinen:
> [...]
>>> +int of_graph_parse_endpoint(const struct device_node *node,
>>> +			    struct of_endpoint *endpoint)
>>> +{
>>> +	struct device_node *port_node =3D of_get_parent(node);
>>
>> Can port_node be NULL? Probably only if something is quite wrong, but
>> maybe it's safer to return error in that case.
>=20
> both of_property_read_u32 and of_node_put can handle port_node =3D=3D N=
ULL.
> I'll add a WARN_ONCE here as for of_graph_get_next_endpoint and continu=
e
> on.

Isn't it better to return an error?

>> And generally speaking, if struct of_endpoint is needed, maybe it woul=
d
>> be better to return the struct of_endpoint when iterating the ports an=
d
>> endpoints. That way there's no need to do parsing "afterwards", trying=

>> to figure out if there's a parent port node, but the information is
>> already at hand.
>=20
> I'd like to keep the iteration separate from parsing so we can
> eventually introduce a for_each_endpoint_of_node helper macro around
> of_graph_get_next_endpoint.
>=20
> [...]
>> A few thoughts about the iteration, and the API in general.
>>
>> In the omapdss version I separated iterating ports and endpoints, for
>> the two reasons:
>>
>> 1) I think there are cases where you may want to have properties in th=
e
>> port node, for things that are common for all the port's endpoints.
>>
>> 2) if there are multiple ports, I think the driver code is cleaner if
>> you first take the port, decide what port that is and maybe call a
>> sub-function, and then iterate the endpoints for that port only.
>=20
> It depends a bit on whether you are actually iterating over individual
> ports, or if you are just walking the whole endpoint graph to find
> remote devices that have to be added to the component master's waiting
> list, for example.

True, but the latter is easily implemented using the separate
port/endpoint iteration. So I see it as a more powerful API.

>> Both of those are possible with the API in the series, but not very cl=
eanly.
>>
>> Also, if you just want to iterate the endpoints, it's easy to implemen=
t
>> a helper using the separate port and endpoint iterations.
>=20
> I started out to move an existing (albeit lightly used) API to a common=

> place so others can use it and improve upon it, too. I'm happy to pile
> on fixes directly in this series, but could we separate the improvement=

> step from the move, for the bigger modifications?

Yes, I understand that. What I wonder is that which is easier: make it a
public API now, more or less as it was in v4l2, or make it a public API
only when all the improvements we can think of have been made.

So my fear is that the API is now made public, and you and others start
to use it. But I can't use it, as I need things like separate
port/endpoint iteration. I need to add those, which also means that I
need to change all the users of the API, making the task more difficult
than I'd like.

However, this is more of "thinking out loud" than "I don't like the
series". It's a good series =3D).

> I had no immediate use for the port iteration, so I have taken no steps=

> to add a function for this. I see no problem to add this later when
> somebody needs it, or even rewrite of_graph_get_next_endpoint to use it=

> if it is feasible. Iterating over endpoints on a given port needs no
> helper, as you can just use for_each_child_of_node.

I would have a helper, which should do some sanity checks, like that the
node names are "endpoint".

>> Then, about the get_remote functions: I think there should be only one=

>> function for that purpose, one that returns the device node that
>> contains the remote endpoint.
>>
>> My reasoning is that the ports and endpoints, and their contents, shou=
ld
>> be private to the device. So the only use to get the remote is to get
>> the actual device, to see if it's been probed, or maybe get some video=

>> API for that device.
>=20
> of_graph_get_remote_port currently is used in the exynos4-is/fimc-is.c
> v4l2 driver to get the mipi-csi channel id from the remote port, and
> I've started using it in imx-drm-core.c for two cases:
> - given an endpoint on the encoder, find the remote port connected to
>   it, get the associated drm_crtc, to obtain its the drm_crtc_mask
>   for encoder->possible_crtcs.
> - given an encoder and a connected drm_crtc, walk all endpoints to find=

>   the remote port associated with the drm_crtc, and then use the local
>   endpoint parent port to determine multiplexer settings.

Ok.

In omapdss each driver handles only the ports and endpoints defined for
its device, and they can be considered private to that device. The only
reason to look for the remote endpoint is to find the remote device. To
me the omapdss model makes sense, and feels logical and sane =3D). So I
have to say I'm not really familiar with the model you're using.

Of course, the different get_remove_* funcs do no harm, even if we have
a bunch of them. My point was only about enforcing the correct use of
the model, where "correct" is of course subjective =3D).

>> If the driver model used has some kind of master-driver, which goes
>> through all the display entities, I think the above is still valid. Wh=
en
>> the master-driver follows the remote-link, it still needs to first get=

>> the main device node, as the ports and endpoints make no sense without=

>> the context of the main device node.
>=20
> I'm not sure about this. I might just need the remote port node
> associated with a remote drm_crtc or drm_encoder structure to find out
> which local endpoint I should look at to retrieve configuration.

Ok. I guess if you have a fixed model for the video pipeline elements it
works out. For omapdss we don't know what's there on the remote side, as
we can have arbitrary amount of video pipeline elements.

 Tomi



--IXxvtPJjNkm96PREqxo5baSKBmbogb4sQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTFcU1AAoJEPo9qoy8lh71R5AQAIUM/WUCv72o2BJb5tLUhrmz
GmE+lHeqbBth/+sxcXR4sT/c5Rm6kZA5xROMLDbJErKU8dDFImTAUve0a1e7cl4f
T7REBPw2bckd/KdJ3T9jmCsfKqN0TxmmGXQ9FQ/XqBXLhmU5ejDzzpBJ5pRnz+kx
wzXcVOFvHGgOlPMy9As6a2mr86fYPhJmkU+HRD4uGA+AptP69PGGniLV5pr53Kq1
K5UjXQbEHk64aRX0giRvL7o6QATFEF5EmI5on1hW//JQn9jZj1KDnFmwkuIgpi9r
OWW/pLipfKs0VdfpnYWx/ZzqEz5Tn+mGK0h7bL2BxXcNlurmZ9JuEdCdVe/HxWV3
xJcYIOMah5wJk9qFx6iIQJ8tq9f01UsgRzLfXzZa7mkFsXMjOXhVRTFd7cLVkgc2
pluhPRed6FBPV8F8lPU17V0kC2+fpJiI60H+radPv9iwocR6wmeRIQlexriHLozd
hvOgFj3Yhq2lUmS9tB6jwWKMAENlUJ43R8ahWIKVj9BkZrJnxszQ2gBvUkGEczQr
A+zlOPVE9P+UoxFiEOCrt83W07WI/6PMtQrmWHetb3C2BjPRHczEeLDFHP5La9Ik
1sa3J5/fUG9h7zojUiPNd5C1yLJFJ9wh1wYqgvxLxC6vvhn1muyHmd5Fj4NIDAEX
24l/x4gwYR6E7emc3MLQ
=YW3P
-----END PGP SIGNATURE-----

--IXxvtPJjNkm96PREqxo5baSKBmbogb4sQ--
