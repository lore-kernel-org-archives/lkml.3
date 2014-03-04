Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603AbaCDI6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 03:58:53 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:56672 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbaCDI6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 03:58:51 -0500
Message-ID: <531595AB.4000001@ti.com>
Date: Tue, 4 Mar 2014 10:58:19 +0200
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
References: <1393522540-22887-1-git-send-email-p.zabel@pengutronix.de> <1393522540-22887-6-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1393522540-22887-6-git-send-email-p.zabel@pengutronix.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="W1QClLt3nmoU3v6nhl8j8kClSe3Q5JPLF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--W1QClLt3nmoU3v6nhl8j8kClSe3Q5JPLF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Philipp,

On 27/02/14 19:35, Philipp Zabel wrote:
> This patch adds a new struct of_endpoint which is then embedded in stru=
ct
> v4l2_of_endpoint and contains the endpoint properties that are not V4L2=

> (or even media) specific: the port number, endpoint id, local device tr=
ee
> node and remote endpoint phandle. of_graph_parse_endpoint parses those
> properties and is used by v4l2_of_parse_endpoint, which just adds the
> V4L2 MBUS information to the containing v4l2_of_endpoint structure.

<snip>

> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 8ecca7a..ba3cfca 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -1985,6 +1985,37 @@ struct device_node *of_find_next_cache_node(cons=
t struct device_node *np)
>  }
> =20
>  /**
> + * of_graph_parse_endpoint() - parse common endpoint node properties
> + * @node: pointer to endpoint device_node
> + * @endpoint: pointer to the OF endpoint data structure
> + *
> + * All properties are optional. If none are found, we don't set any fl=
ags.
> + * This means the port has a static configuration and no properties ha=
ve
> + * to be specified explicitly.
> + * The caller should hold a reference to @node.
> + */
> +int of_graph_parse_endpoint(const struct device_node *node,
> +			    struct of_endpoint *endpoint)
> +{
> +	struct device_node *port_node =3D of_get_parent(node);

Can port_node be NULL? Probably only if something is quite wrong, but
maybe it's safer to return error in that case.

> +	memset(endpoint, 0, sizeof(*endpoint));
> +
> +	endpoint->local_node =3D node;
> +	/*
> +	 * It doesn't matter whether the two calls below succeed.
> +	 * If they don't then the default value 0 is used.
> +	 */
> +	of_property_read_u32(port_node, "reg", &endpoint->port);
> +	of_property_read_u32(node, "reg", &endpoint->id);

If the endpoint does not have 'port' as parent (i.e. the shortened
format), the above will return the 'reg' of the device node (with
'device node' I mean the main node, with 'compatible' property).

And generally speaking, if struct of_endpoint is needed, maybe it would
be better to return the struct of_endpoint when iterating the ports and
endpoints. That way there's no need to do parsing "afterwards", trying
to figure out if there's a parent port node, but the information is
already at hand.

> +
> +	of_node_put(port_node);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(of_graph_parse_endpoint);
> +
> +/**
>   * of_graph_get_next_endpoint() - get next endpoint node
>   * @parent: pointer to the parent device node
>   * @prev: previous endpoint node, or NULL to get first
> diff --git a/include/linux/of_graph.h b/include/linux/of_graph.h
> index 3bbeb60..2b233db 100644
> --- a/include/linux/of_graph.h
> +++ b/include/linux/of_graph.h
> @@ -14,7 +14,21 @@
>  #ifndef __LINUX_OF_GRAPH_H
>  #define __LINUX_OF_GRAPH_H
> =20
> +/**
> + * struct of_endpoint - the OF graph endpoint data structure
> + * @port: identifier (value of reg property) of a port this endpoint b=
elongs to
> + * @id: identifier (value of reg property) of this endpoint
> + * @local_node: pointer to device_node of this endpoint
> + */
> +struct of_endpoint {
> +	unsigned int port;
> +	unsigned int id;
> +	const struct device_node *local_node;
> +};

A few thoughts about the iteration, and the API in general.

In the omapdss version I separated iterating ports and endpoints, for
the two reasons:

1) I think there are cases where you may want to have properties in the
port node, for things that are common for all the port's endpoints.

2) if there are multiple ports, I think the driver code is cleaner if
you first take the port, decide what port that is and maybe call a
sub-function, and then iterate the endpoints for that port only.

Both of those are possible with the API in the series, but not very clean=
ly.

Also, if you just want to iterate the endpoints, it's easy to implement
a helper using the separate port and endpoint iterations.


Then, about the get_remote functions: I think there should be only one
function for that purpose, one that returns the device node that
contains the remote endpoint.

My reasoning is that the ports and endpoints, and their contents, should
be private to the device. So the only use to get the remote is to get
the actual device, to see if it's been probed, or maybe get some video
API for that device.

If the driver model used has some kind of master-driver, which goes
through all the display entities, I think the above is still valid. When
the master-driver follows the remote-link, it still needs to first get
the main device node, as the ports and endpoints make no sense without
the context of the main device node.

 Tomi



--W1QClLt3nmoU3v6nhl8j8kClSe3Q5JPLF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTFZWrAAoJEPo9qoy8lh71ZqkQAIWQ3Rp4oBW8B1BfNm03QPeR
1k7Z/xKVLox4L73LlV8SvcvtvMtKf7MWoHNISAbv9LJigcoea9y5KXvquOBKp7ll
8HrL7BSpka2hI08OdSbN1Vr/OGa1CDSMQi2XQdQOxKePvfnpt4nky3WJ7/+JmZBG
oguaSa6VjKVjfsZhSkDfiM0ctJAYQWsYa6vDOgEtbP67H7FXqJXsnvojYCDHUlpU
uZ6teeIbfKVeqH2OiV5sJXmxJXs9VfmBscr5FfOgadYpzSHXmdKpI6LxncY6WSCp
e/AESz3RYoRkqpiu/PA558Z15WKHREQE2MuL7eYlhm0nPp01bz+ovEr2EYbmz/wV
7BvApIsJdf3c82WtuNNuFVN1qrQha79ojgMmNNfVHtDrYwshQylTh7eaKU9FsshQ
ExRXw2/RejmUyV1+w3uIxhJpKpNL5P3UmS0eZLtmEGwvhs7ftbI8gp543GauFCdX
dCsyJe+6C5ijOeOmwWnu2qd3WmAfiMB4/SVP/jr+V27Nldd0YaiM/HcatIMSEQeI
eqReKC9c6grUhQzuuK+xq1/HT7Pp+ZwR8KTwGoqPc1A7wIvCztprUWtZjpYy7Cc/
ZL60y28W21bT0k3L4pf02APdtn8XgZwMXt0BDV95X/J+ozWW6ViJ+n8KduOhSDoc
WFQ0DKJPQ4BsZjopyKpw
=vWYR
-----END PGP SIGNATURE-----

--W1QClLt3nmoU3v6nhl8j8kClSe3Q5JPLF--
