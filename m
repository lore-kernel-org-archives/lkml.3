Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760131AbaJ3N5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:57:05 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45375 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759871AbaJ3N5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:57:02 -0400
Date: Thu, 30 Oct 2014 08:54:06 -0500
From: Felipe Balbi <balbi@ti.com>
To: <dinguyen@opensource.altera.com>
CC: <paulz@synopsys.com>, <balbi@ti.com>, <dinh.linux@gmail.com>,
        <swarren@wwwdotorg.org>, <b.zolnierkie@samsung.com>,
        <matthijs@stdin.nl>, <r.baldyga@samsung.com>, <jg1.han@samsung.com>,
        <sachin.kamat@linaro.org>, <ben-linux@fluff.org>,
        <dianders@chromium.org>, <kever.yang@rock-chips.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv6 1/8] usb: dwc2: Update the gadget driver to use common
 dwc2_hsotg structure
Message-ID: <20141030135406.GB6482@saruman>
Reply-To: <balbi@ti.com>
References: <1414538749-14735-1-git-send-email-dinguyen@opensource.altera.com>
 <1414538749-14735-2-git-send-email-dinguyen@opensource.altera.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LpQ9ahxlCli8rRTG"
Content-Disposition: inline
In-Reply-To: <1414538749-14735-2-git-send-email-dinguyen@opensource.altera.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--LpQ9ahxlCli8rRTG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 28, 2014 at 06:25:42PM -0500, dinguyen@opensource.altera.com wr=
ote:
> From: Dinh Nguyen <dinguyen@opensource.altera.com>
>=20
> Adds the gadget data structure and appropriate data structure pointers
> to the common dwc2_hsotg data structure. To keep the driver data
> dereference code looking clean, the gadget variable declares are only ava=
ilable
> for peripheral and dual-role mode. This is needed so that the dwc2_hsotg =
data
> structure can be used by the hcd and gadget drivers.
>=20
> Updates gadget.c to use the dwc2_hsotg data structure and gadget pointers
> that have been moved into the common dwc2_hsotg structure.
>=20
> Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
> Signed-off-by: Paul Zimmerman <paulz@synopsys.com>
> ---
> v5: Keep the changes to mininum and maintain hcd and gadget driver to bui=
ld
>     and work separately. Use IS_ENABLED() instead of #if defined
> v3: Updated with paulz's suggestion to avoid double pointers.
> v2: Left the function parameter name as 'hsotg' and just changed its type.
> ---
>  drivers/usb/dwc2/core.h   | 156 ++++++++++++++++++++++++----------------=
------
>  drivers/usb/dwc2/gadget.c | 145 +++++++++++++++++++++-------------------=
--
>  2 files changed, 154 insertions(+), 147 deletions(-)
>=20
> diff --git a/drivers/usb/dwc2/core.h b/drivers/usb/dwc2/core.h
> index 55c90c5..96c283d 100644
> --- a/drivers/usb/dwc2/core.h
> +++ b/drivers/usb/dwc2/core.h
> @@ -84,7 +84,7 @@ static const char * const s3c_hsotg_supply_names[] =3D {
>   */
>  #define EP0_MPS_LIMIT   64
> =20
> -struct s3c_hsotg;
> +struct dwc2_hsotg;
>  struct s3c_hsotg_req;
> =20
>  /**
> @@ -130,7 +130,7 @@ struct s3c_hsotg_req;
>  struct s3c_hsotg_ep {
>  	struct usb_ep           ep;
>  	struct list_head        queue;
> -	struct s3c_hsotg        *parent;
> +	struct dwc2_hsotg       *parent;
>  	struct s3c_hsotg_req    *req;
>  	struct dentry           *debugfs;
> =20
> @@ -155,67 +155,6 @@ struct s3c_hsotg_ep {
>  };
> =20
>  /**
> - * struct s3c_hsotg - driver state.
> - * @dev: The parent device supplied to the probe function
> - * @driver: USB gadget driver
> - * @phy: The otg phy transceiver structure for phy control.
> - * @uphy: The otg phy transceiver structure for old USB phy control.
> - * @plat: The platform specific configuration data. This can be removed =
once
> - * all SoCs support usb transceiver.
> - * @regs: The memory area mapped for accessing registers.
> - * @irq: The IRQ number we are using
> - * @supplies: Definition of USB power supplies
> - * @phyif: PHY interface width
> - * @dedicated_fifos: Set if the hardware has dedicated IN-EP fifos.
> - * @num_of_eps: Number of available EPs (excluding EP0)
> - * @debug_root: root directrory for debugfs.
> - * @debug_file: main status file for debugfs.
> - * @debug_fifo: FIFO status file for debugfs.
> - * @ep0_reply: Request used for ep0 reply.
> - * @ep0_buff: Buffer for EP0 reply data, if needed.
> - * @ctrl_buff: Buffer for EP0 control requests.
> - * @ctrl_req: Request for EP0 control packets.
> - * @setup: NAK management for EP0 SETUP
> - * @last_rst: Time of last reset
> - * @eps: The endpoints being supplied to the gadget framework
> - */
> -struct s3c_hsotg {
> -	struct device            *dev;
> -	struct usb_gadget_driver *driver;
> -	struct phy               *phy;
> -	struct usb_phy           *uphy;
> -	struct s3c_hsotg_plat    *plat;
> -
> -	spinlock_t              lock;
> -
> -	void __iomem            *regs;
> -	int                     irq;
> -	struct clk              *clk;
> -
> -	struct regulator_bulk_data supplies[ARRAY_SIZE(s3c_hsotg_supply_names)];
> -
> -	u32                     phyif;
> -	int			fifo_mem;
> -	unsigned int            dedicated_fifos:1;
> -	unsigned char           num_of_eps;
> -	u32			fifo_map;
> -
> -	struct dentry           *debug_root;
> -	struct dentry           *debug_file;
> -	struct dentry           *debug_fifo;
> -
> -	struct usb_request      *ep0_reply;
> -	struct usb_request      *ctrl_req;
> -	u8                      ep0_buff[8];
> -	u8                      ctrl_buff[8];
> -
> -	struct usb_gadget       gadget;
> -	unsigned int            setup;
> -	unsigned long           last_rst;
> -	struct s3c_hsotg_ep     *eps;
> -};
> -
> -/**
>   * struct s3c_hsotg_req - data transfer request
>   * @req: The USB gadget request
>   * @queue: The list of requests for the endpoint this is queued for.
> @@ -229,6 +168,7 @@ struct s3c_hsotg_req {
>  	unsigned char           mapped;
>  };
> =20
> +#if IS_ENABLED(CONFIG_USB_DWC2_PERIPHERAL) || IS_ENABLED(CONFIG_USB_DWC2=
_DUAL_ROLE)
>  #define call_gadget(_hs, _entry) \
>  do { \
>  	if ((_hs)->gadget.speed !=3D USB_SPEED_UNKNOWN && \
> @@ -238,6 +178,9 @@ do { \
>  		spin_lock(&_hs->lock); \
>  	} \
>  } while (0)
> +#else
> +#define call_gadget(_hs, _entry)	do {} while (0)
> +#endif
> =20
>  struct dwc2_hsotg;
>  struct dwc2_host_chan;
> @@ -495,11 +438,13 @@ struct dwc2_hw_params {
>   * struct dwc2_hsotg - Holds the state of the driver, including the non-=
periodic
>   * and periodic schedules
>   *
> + * These are common for both host and peripheral modes:
> + *
>   * @dev:                The struct device pointer
>   * @regs:		Pointer to controller regs
> - * @core_params:        Parameters that define how the core should be co=
nfigured
>   * @hw_params:          Parameters that were autodetected from the
>   *                      hardware registers
> + * @core_params:	Parameters that define how the core should be configured
>   * @op_state:           The operational State, during transitions (a_hos=
t=3D>
>   *                      a_peripheral and b_device=3D>b_host) this may no=
t match
>   *                      the core, but allows the software to determine
> @@ -508,6 +453,8 @@ struct dwc2_hw_params {
>   *                      - USB_DR_MODE_PERIPHERAL
>   *                      - USB_DR_MODE_HOST
>   *                      - USB_DR_MODE_OTG
> + * @lock:		Spinlock that protects all the driver data structures
> + * @priv:		Stores a pointer to the struct usb_hcd
>   * @queuing_high_bandwidth: True if multiple packets of a high-bandwidth
>   *                      transfer are in process of being queued
>   * @srp_success:        Stores status of SRP request in the case of a FS=
 PHY
> @@ -517,6 +464,9 @@ struct dwc2_hw_params {
>   *                      interrupt
>   * @wkp_timer:          Timer object for handling Wakeup Detected interr=
upt
>   * @lx_state:           Lx state of connected device
> + *
> + * These are for host mode:
> + *
>   * @flags:              Flags for handling root port state changes
>   * @non_periodic_sched_inactive: Inactive QHs in the non-periodic schedu=
le.
>   *                      Transfers associated with these QHs are not curr=
ently
> @@ -585,11 +535,31 @@ struct dwc2_hw_params {
>   * @status_buf_dma:     DMA address for status_buf
>   * @start_work:         Delayed work for handling host A-cable connection
>   * @reset_work:         Delayed work for handling a port reset
> - * @lock:               Spinlock that protects all the driver data struc=
tures
> - * @priv:               Stores a pointer to the struct usb_hcd
>   * @otg_port:           OTG port number
>   * @frame_list:         Frame list
>   * @frame_list_dma:     Frame list DMA address
> + *
> + * These are for peripheral mode:
> + *
> + * @driver:             USB gadget driver
> + * @phy:                The otg phy transceiver structure for phy contro=
l.
> + * @uphy:               The otg phy transceiver structure for old USB ph=
y control.
> + * @plat:               The platform specific configuration data. This c=
an be removed once
> + *                      all SoCs support usb transceiver.
> + * @supplies:           Definition of USB power supplies
> + * @phyif:              PHY interface width
> + * @dedicated_fifos:    Set if the hardware has dedicated IN-EP fifos.
> + * @num_of_eps:         Number of available EPs (excluding EP0)
> + * @debug_root:         Root directrory for debugfs.
> + * @debug_file:         Main status file for debugfs.
> + * @debug_fifo:         FIFO status file for debugfs.
> + * @ep0_reply:          Request used for ep0 reply.
> + * @ep0_buff:           Buffer for EP0 reply data, if needed.
> + * @ctrl_buff:          Buffer for EP0 control requests.
> + * @ctrl_req:           Request for EP0 control packets.
> + * @setup:              NAK management for EP0 SETUP
> + * @last_rst:           Time of last reset
> + * @eps:                The endpoints being supplied to the gadget frame=
work
>   */
>  struct dwc2_hsotg {
>  	struct device *dev;
> @@ -601,6 +571,9 @@ struct dwc2_hsotg {
>  	enum usb_otg_state op_state;
>  	enum usb_dr_mode dr_mode;
> =20
> +	spinlock_t lock;
> +	void *priv;
> +
>  	unsigned int queuing_high_bandwidth:1;
>  	unsigned int srp_success:1;
> =20
> @@ -609,6 +582,14 @@ struct dwc2_hsotg {
>  	struct timer_list wkp_timer;
>  	enum dwc2_lx_state lx_state;
> =20
> +	/* DWC OTG HW Release versions */
> +#define DWC2_CORE_REV_2_71a	0x4f54271a
> +#define DWC2_CORE_REV_2_90a	0x4f54290a
> +#define DWC2_CORE_REV_2_92a	0x4f54292a
> +#define DWC2_CORE_REV_2_94a	0x4f54294a
> +#define DWC2_CORE_REV_3_00a	0x4f54300a
> +
> +#if IS_ENABLED(CONFIG_USB_DWC2_HOST) || IS_ENABLED(CONFIG_USB_DWC2_DUAL_=
ROLE)
>  	union dwc2_hcd_internal_flags {
>  		u32 d32;
>  		struct {
> @@ -655,19 +636,10 @@ struct dwc2_hsotg {
> =20
>  	struct delayed_work start_work;
>  	struct delayed_work reset_work;
> -	spinlock_t lock;
> -	void *priv;
>  	u8 otg_port;
>  	u32 *frame_list;
>  	dma_addr_t frame_list_dma;
> =20
> -	/* DWC OTG HW Release versions */
> -#define DWC2_CORE_REV_2_71a	0x4f54271a
> -#define DWC2_CORE_REV_2_90a	0x4f54290a
> -#define DWC2_CORE_REV_2_92a	0x4f54292a
> -#define DWC2_CORE_REV_2_94a	0x4f54294a
> -#define DWC2_CORE_REV_3_00a	0x4f54300a
> -
>  #ifdef DEBUG
>  	u32 frrem_samples;
>  	u64 frrem_accum;
> @@ -686,6 +658,40 @@ struct dwc2_hsotg {
>  	u32 hfnum_other_samples_b;
>  	u64 hfnum_other_frrem_accum_b;
>  #endif
> +#endif /* CONFIG_USB_DWC2_HOST || CONFIG_USB_DWC2_DUAL_ROLE */
> +
> +#if IS_ENABLED(CONFIG_USB_DWC2_PERIPHERAL) || IS_ENABLED(CONFIG_USB_DWC2=
_DUAL_ROLE)
> +	/* Gadget structures */
> +	struct usb_gadget_driver *driver;
> +	struct phy *phy;

this shouldn't be limited to gadget.

> +	struct usb_phy *uphy;

this shouldn't be limited to gadget.

> +	struct s3c_hsotg_plat *plat;
> +
> +	int	irq;

this shouldn't be limited to gadget.

> +	struct clk *clk;

this shouldn't be limited to gadget.

> +
> +	struct regulator_bulk_data supplies[ARRAY_SIZE(s3c_hsotg_supply_names)];

this shouldn't be limited to gadget.

> +	u32 phyif;
> +	int fifo_mem;
> +	unsigned int dedicated_fifos:1;
> +	unsigned char num_of_eps;
> +	u32 fifo_map;
> +
> +	struct dentry *debug_root;

this shouldn't be limited to gadget.

> +	struct dentry *debug_file;

this shouldn't be limited to gadget.

> +	struct dentry *debug_fifo;

this shouldn't be limited to gadget.

--=20
balbi

--LpQ9ahxlCli8rRTG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUUkL+AAoJEIaOsuA1yqREt78QAJW1l1d0Qbd49oqpI9XDdetJ
NfOWAhLjUFisptlK9ja3elK982spRBSaAS3Myi1Tm8NQ9++c0f0/cnzKytsM3OLa
djst0XZwbGfD0DCMd4fe1e44ny/EnuqNPwaSQZ3rjpsQJpdhqDhDzA+zttCc2Xjl
cizK2+htv14pSulnseXD/bVkf3IIfMlQBOtOSiPjEkyXUNIBSQlUd0g+lNcb1Ul1
4Yp6f7fZZc/OqR16V/mYb9xZOK+WlqDnDDWqkv7rhIqbceu0TcfuBWXy4FpgucLF
5XTn5YoIqFEcWuxsWJnxcVmu4AY/aAfxPagRIB8LInS4MWp9klFjv/ozleAakJYJ
1NTeFTfmiunc55m7XpKr51XtKcsBbIKVSwqV3fct7AmfYrRmcHg47e0Yq03lvNy1
RQKrhNt+87Xc26X9uDJ8mZxCSUBTOtYnYmgqLirUMMp7HGOqWwgJhPgLEr1AWCJK
BvEyRIQhdJAcsD6qD3ufVWu3NT1qynP7kMUkkoAHCnzQUv4lKbKjUQNpmIDusL5G
0tDZXq7hIFE7Mmvt6OpaJ1hA0VrFfKgLrpMx8Ckk720i2+XwHpG9M7+u60MF+Cqv
iue0t406Ssd5n2QR1JqPDqJH9mwxeCn8sexk6Sw1DiFFPPGy/w8O6TkTRazZ5EIp
kh6YpO1NlNg+miXB2XSg
=llrU
-----END PGP SIGNATURE-----

--LpQ9ahxlCli8rRTG--
