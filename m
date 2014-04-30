Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946045AbaD3VzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 17:55:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49578 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1945930AbaD3VzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 17:55:07 -0400
Date: Wed, 30 Apr 2014 14:53:22 -0700
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, andriy.shevchenko@intel.com,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v7] DMA: sun6i: Add driver for the Allwinner A31 DMA
 controller
Message-ID: <20140430215322.GH3000@lukather>
References: <20140430070408.GR32284@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3U8TY7m7wOx7RL1F"
Content-Disposition: inline
In-Reply-To: <20140430070408.GR32284@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3U8TY7m7wOx7RL1F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Vinod,

On Wed, Apr 30, 2014 at 12:34:08PM +0530, Vinod Koul wrote:
> On Thu, Apr 24, 2014 at 04:22:44PM +0200, Maxime Ripard wrote:
> > The Allwinner A31 has a 16 channels DMA controller that it shares with =
the
> > newer A23. Although sharing some similarities with the DMA controller o=
f the
> > older Allwinner SoCs, it's significantly different, I don't expect it t=
o be
> > possible to share the driver for these two.
> >=20
> > The A31 Controller is able to memory-to-memory or memory-to-device tran=
sfers on
> > the 16 channels in parallel.
>=20
> Overall driver looks in good shape, few comments though...
>=20
> > +This driver follows the generic DMA bindings defined in dma.txt.
> > +
> > +Required properties:
> > +
> > +- compatible:	Must be "allwinner,sun6i-a31-dma"
> > +- reg:		Should contain the registers base address and length
> > +- interrupts:	Should contain a reference to the interrupt used by this=
 device
> > +- clocks:	Should contain a reference to the parent AHB clock
> > +- resets:	Should contain a reference to the reset controller asserting
> > +	  	this device in reset
> > +- #dma-cells :	Should be 1, a single cell holding a line request number
> > +
> > +Example:
> > +	dma: dma-controller@01c02000 {
> > +		compatible =3D "allwinner,sun6i-a31-dma";
> > +		reg =3D <0x01c02000 0x1000>;
> > +		interrupts =3D <0 50 4>;
> > +		clocks =3D <&ahb1_gates 6>;
> > +		resets =3D <&ahb1_rst 6>;
> > +		#dma-cells =3D <1>;
> > +	};
> > +
> > +Clients:
> > +
> > +DMA clients connected to the A31 DMA controller must use the format
> > +described in the dma.txt file, using a two-cell specifier for each
> > +channel: a phandle plus one integer cells.
> > +The two cells in order are:
> > +
> > +1. A phandle pointing to the DMA controller.
> > +2. The port ID as specified in the datasheet
> > +
> > +Example:
> > +spi2: spi@01c6a000 {
> > +	compatible =3D "allwinner,sun6i-a31-spi";
> > +	reg =3D <0x01c6a000 0x1000>;
> > +	interrupts =3D <0 67 4>;
> > +	clocks =3D <&ahb1_gates 22>, <&spi2_clk>;
> > +	clock-names =3D "ahb", "mod";
> > +	dmas =3D <&dma 25>, <&dma 25>;
> > +	dma-names =3D "rx", "tx";
> > +	resets =3D <&ahb1_rst 22>;
> > +};
> Ideally binding should be a separate patch

Ok

> > +static inline u8 convert_burst(u8 maxburst)
> > +{
> > +	if (maxburst =3D=3D 1 || maxburst > 16)
> > +		return 0;
> are these valid configurations?

The only valid burst values are 1 (0) and 8 (2).

> > +
> > +	return fls(maxburst) - 1;
> > +}
> > +
> > +static inline u8 convert_buswidth(enum dma_slave_buswidth addr_width)
> > +{
> > +	switch (addr_width) {
> > +	case DMA_SLAVE_BUSWIDTH_2_BYTES:
> > +		return 1;
> > +	case DMA_SLAVE_BUSWIDTH_4_BYTES:
> > +		return 2;
> return (addr_width >> 1); ..??
> since DMA_SLAVE_BUSWIDTH_2_BYTES is numeric 2 and DMA_SLAVE_BUSWIDTH_4_BY=
TES
> numeric 4.=20

Yes, it would work.

> > +	default:
> > +		return 0;
> error?

Ok.

> > +static inline void sun6i_dma_cfg_lli(struct sun6i_dma_lli *lli,
> > +				     dma_addr_t src,
> > +				     dma_addr_t dst, u32 len,
> > +				     struct dma_slave_config *config)
> > +{
> > +	u32 src_width, dst_width, src_burst, dst_burst;
> > +
> > +	if (!config)
> > +		return;
> > +
> > +	src_burst =3D convert_burst(config->src_maxburst);
> > +	dst_burst =3D convert_burst(config->dst_maxburst);
> > +
> > +	src_width =3D convert_buswidth(config->src_addr_width);
> > +	dst_width =3D convert_buswidth(config->dst_addr_width);
> is 0 a valid case then?

Yes, it is. 0 is a burst of 1, and a width of a byte.

> > +
> > +static int sun6i_dma_terminate_all(struct sun6i_vchan *vchan)
> > +{
> > +	struct sun6i_dma_dev *sdev =3D to_sun6i_dma_dev(vchan->vc.chan.device=
);
> > +	struct sun6i_pchan *pchan =3D vchan->phy;
> > +	unsigned long flags;
> > +	LIST_HEAD(head);
> > +
> > +	spin_lock(&sdev->lock);
> > +	list_del_init(&vchan->node);
> > +	spin_unlock(&sdev->lock);
> > +
> > +	spin_lock_irqsave(&vchan->vc.lock, flags);
> > +
> > +	vchan_get_all_descriptors(&vchan->vc, &head);
> > +
> > +	if (pchan) {
> > +		writel(DMA_CHAN_ENABLE_STOP, pchan->base + DMA_CHAN_ENABLE);
> > +		writel(DMA_CHAN_PAUSE_RESUME, pchan->base + DMA_CHAN_PAUSE);
> > +
> > +		vchan->phy =3D NULL;
> > +		pchan->vchan =3D NULL;
> > +		pchan->desc =3D NULL;
> > +		pchan->done =3D NULL;
> > +	}
> > +
> > +	spin_unlock_irqrestore(&vchan->vc.lock, flags);
> > +
> > +	vchan_dma_desc_free_list(&vchan->vc, &head);
>=20
> shouldn't you kill the tasklet as well here?

Hmm, yes.

> > +static inline void sun6i_dma_free(struct sun6i_dma_dev *sdc)
> > +{
> > +	int i;
> > +
> > +	for (i =3D 0; i < NR_MAX_VCHANS; i++) {
> > +		struct sun6i_vchan *vchan =3D &sdc->vchans[i];
> > +
> > +		list_del(&vchan->vc.chan.device_node);
> > +		tasklet_kill(&vchan->vc.task);
> > +	}
> > +
> > +	tasklet_kill(&sdc->task);
> This is again not good. see http://lwn.net/Articles/588457/
> At this point HW can still generate interrupts or you can have irq runnin=
g!

I'm not sure to fully understand the issue here, but what is not good?
the first or the second tasklet_kill calls, or both?

=46rom what I understood, the issue is only there whenever you are
calling tasklet_disable without making sure that no one will schedule
your tasklet before disabling it.

But the point is I don't actually use either _enable/_disable. I might
be wrong in not using those functions, but I don't really see how I
can be impacted.

> > +static int sun6i_dma_probe(struct platform_device *pdev)
> > +{
> > +	struct sun6i_dma_dev *sdc;
> > +	struct resource *res;
> > +	struct clk *mux, *pll6;
> > +	int irq;
> > +	int ret, i;
> > +
> > +	sdc =3D devm_kzalloc(&pdev->dev, sizeof(*sdc), GFP_KERNEL);
> > +	if (!sdc)
> > +		return -ENOMEM;
> > +
> > +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	sdc->base =3D devm_ioremap_resource(&pdev->dev, res);
> > +	if (IS_ERR(sdc->base))
> > +		return PTR_ERR(sdc->base);
> > +
> > +	irq =3D platform_get_irq(pdev, 0);
> > +	ret =3D devm_request_irq(&pdev->dev, irq, sun6i_dma_interrupt, 0,
> > +			       dev_name(&pdev->dev), sdc);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Cannot request IRQ\n");
> > +		return ret;
> > +	}
> this is not good. You have registered for irq, so your irq handlers can be
> invoked but you initialization is not complete yet.

Not really, the device is maintained in reset, we deassert it only
later, and we're only deasserting it from reset later on in the
probe. And since it was kept in reset, you will only get interrupts
whenever you actually enable them, in the tasklet, that is only
scheduled from _issue_pending (and the interrupt handler, which would
not happen)

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--3U8TY7m7wOx7RL1F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTYXDSAAoJEBx+YmzsjxAggCEP/RkF1Y0aaOVJKajIi0CC8tlq
yZ/6mH8dKbTlMwlKCh9naLp880caJFYTUDd8jACJEAOeif2syBaOYlJ/InIBmiip
GCkFP7RLJtrZJZOlaD26oePVuabZYbrWF9wP1cGVwBMChM0wTrbxXfESMuoYheIa
kv7D+z0Lykyk1YGZO29hR+QAXOCEzpsdo+EbEWsmqxUcf34D3D8MjJJDmeOiPQNg
zHarha90vWrZ7r0GCga8W6YWr6bvloQdoStLjCSLf/2qOiJKtwH4B+EaME4cDk6M
B2/M8khiBczvreYAjJPsh4vspTBsKxLwUuAZCp+oj+zOhPcPvl7GsbXnCK0GnnlA
T057EIkJjGdchlvs67uSYHRQu7rBJviGCDEbY90B+R74GnQRa1rPHBR5spaqtOjq
cFGygXRtMsTVGPoSs7KIo7tmA+2teMfLZb4RCcdXyogUQhSUduBcrTPdgzd3yLX+
iPzu9TmHwSHjV/4wOXQtEhlXoK6pXdTIysty6U45KFGZzO4iPE0wCTNtfD31sCHs
klAmB1oc48e2bGtEopQef5eNGU639OkzxQ8aP3DN7tWA5n3DgLz4GL5skCl6QVOl
YNHt9amqhkmdU1D9r/bjvsMpK/iUULuU9dsOE6EMBIJuef6zXXOJW1ZRqvxyz0aG
7eBMpB0OJg5xZKGj5Bak
=LxQL
-----END PGP SIGNATURE-----

--3U8TY7m7wOx7RL1F--
