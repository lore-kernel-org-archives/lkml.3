Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248AbaJaPOp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 11:14:45 -0400
Received: from mail-by2on0065.outbound.protection.outlook.com ([207.46.100.65]:62736
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932508AbaJaPOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 11:14:43 -0400
Message-ID: <5453A2EB.5040607@opensource.altera.com>
Date: Fri, 31 Oct 2014 09:55:39 -0500
From: Dinh Nguyen <dinguyen@opensource.altera.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <paulz@synopsys.com>, <dinh.linux@gmail.com>, <swarren@wwwdotorg.org>,
        <b.zolnierkie@samsung.com>, <matthijs@stdin.nl>,
        <r.baldyga@samsung.com>, <jg1.han@samsung.com>,
        <sachin.kamat@linaro.org>, <ben-linux@fluff.org>,
        <dianders@chromium.org>, <kever.yang@rock-chips.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv6 1/8] usb: dwc2: Update the gadget driver to use common
 dwc2_hsotg structure
References: <1414538749-14735-1-git-send-email-dinguyen@opensource.altera.com> <1414538749-14735-2-git-send-email-dinguyen@opensource.altera.com> <20141030135406.GB6482@saruman>
In-Reply-To: <20141030135406.GB6482@saruman>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: DM2PR10CA0048.namprd10.prod.outlook.com (10.141.241.16) To
 BY1PR0301MB1192.namprd03.prod.outlook.com (25.160.195.150)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1192;
X-Forefront-PRVS: 03818C953D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6049001)(6009001)(51234002)(24454002)(377454003)(189002)(479174003)(51704005)(199003)(110136001)(46102003)(101416001)(2351001)(87976001)(59896002)(21056001)(47776003)(107046002)(64706001)(31966008)(4396001)(80316001)(66066001)(19580405001)(62966003)(99396003)(33656002)(65806001)(106356001)(65956001)(20776003)(87266999)(92726001)(50986999)(92566001)(83506001)(575784001)(76176999)(122386002)(95666004)(19580395003)(23746002)(54356999)(86362001)(97736003)(105586002)(64126003)(40100003)(65816999)(102836001)(42186005)(120916001)(50466002)(77156002)(77096003)(19627235001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0301MB1192;H:[137.57.160.210];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 10/30/2014 08:54 AM, Felipe Balbi wrote:
> On Tue, Oct 28, 2014 at 06:25:42PM -0500,
> dinguyen@opensource.altera.com wrote:
>> From: Dinh Nguyen <dinguyen@opensource.altera.com>
>> 
>> Adds the gadget data structure and appropriate data structure
>> pointers to the common dwc2_hsotg data structure. To keep the
>> driver data dereference code looking clean, the gadget variable
>> declares are only available for peripheral and dual-role mode.
>> This is needed so that the dwc2_hsotg data structure can be used
>> by the hcd and gadget drivers.
>> 
>> Updates gadget.c to use the dwc2_hsotg data structure and gadget
>> pointers that have been moved into the common dwc2_hsotg
>> structure.
>> 
>> Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com> 
>> Signed-off-by: Paul Zimmerman <paulz@synopsys.com> --- v5: Keep
>> the changes to mininum and maintain hcd and gadget driver to
>> build and work separately. Use IS_ENABLED() instead of #if
>> defined v3: Updated with paulz's suggestion to avoid double
>> pointers. v2: Left the function parameter name as 'hsotg' and
>> just changed its type. --- drivers/usb/dwc2/core.h   | 156
>> ++++++++++++++++++++++++---------------------- 
>> drivers/usb/dwc2/gadget.c | 145
>> +++++++++++++++++++++--------------------- 2 files changed, 154
>> insertions(+), 147 deletions(-)
>> 
>> diff --git a/drivers/usb/dwc2/core.h b/drivers/usb/dwc2/core.h 
>> index 55c90c5..96c283d 100644 --- a/drivers/usb/dwc2/core.h +++
>> b/drivers/usb/dwc2/core.h @@ -84,7 +84,7 @@ static const char *
>> const s3c_hsotg_supply_names[] = { */ #define EP0_MPS_LIMIT   64
>> 
>> -struct s3c_hsotg; +struct dwc2_hsotg; struct s3c_hsotg_req;
>> 
>> /** @@ -130,7 +130,7 @@ struct s3c_hsotg_req; struct s3c_hsotg_ep
>> { struct usb_ep           ep; struct list_head        queue; -
>> struct s3c_hsotg        *parent; +	struct dwc2_hsotg
>> *parent; struct s3c_hsotg_req    *req; struct dentry
>> *debugfs;
>> 
>> @@ -155,67 +155,6 @@ struct s3c_hsotg_ep { };
>> 
>> /** - * struct s3c_hsotg - driver state. - * @dev: The parent
>> device supplied to the probe function - * @driver: USB gadget
>> driver - * @phy: The otg phy transceiver structure for phy
>> control. - * @uphy: The otg phy transceiver structure for old USB
>> phy control. - * @plat: The platform specific configuration data.
>> This can be removed once - * all SoCs support usb transceiver. -
>> * @regs: The memory area mapped for accessing registers. - *
>> @irq: The IRQ number we are using - * @supplies: Definition of
>> USB power supplies - * @phyif: PHY interface width - *
>> @dedicated_fifos: Set if the hardware has dedicated IN-EP fifos. 
>> - * @num_of_eps: Number of available EPs (excluding EP0) - *
>> @debug_root: root directrory for debugfs. - * @debug_file: main
>> status file for debugfs. - * @debug_fifo: FIFO status file for
>> debugfs. - * @ep0_reply: Request used for ep0 reply. - *
>> @ep0_buff: Buffer for EP0 reply data, if needed. - * @ctrl_buff:
>> Buffer for EP0 control requests. - * @ctrl_req: Request for EP0
>> control packets. - * @setup: NAK management for EP0 SETUP - *
>> @last_rst: Time of last reset - * @eps: The endpoints being
>> supplied to the gadget framework - */ -struct s3c_hsotg { -
>> struct device            *dev; -	struct usb_gadget_driver
>> *driver; -	struct phy               *phy; -	struct usb_phy
>> *uphy; -	struct s3c_hsotg_plat    *plat; - -	spinlock_t
>> lock; - -	void __iomem            *regs; -	int
>> irq; -	struct clk              *clk; - -	struct
>> regulator_bulk_data
>> supplies[ARRAY_SIZE(s3c_hsotg_supply_names)]; - -	u32
>> phyif; -	int			fifo_mem; -	unsigned int
>> dedicated_fifos:1; -	unsigned char           num_of_eps; -	u32
>> fifo_map; - -	struct dentry           *debug_root; -	struct
>> dentry           *debug_file; -	struct dentry
>> *debug_fifo; - -	struct usb_request      *ep0_reply; -	struct
>> usb_request      *ctrl_req; -	u8
>> ep0_buff[8]; -	u8                      ctrl_buff[8]; - -	struct
>> usb_gadget       gadget; -	unsigned int            setup; -
>> unsigned long           last_rst; -	struct s3c_hsotg_ep
>> *eps; -}; - -/** * struct s3c_hsotg_req - data transfer request *
>> @req: The USB gadget request * @queue: The list of requests for
>> the endpoint this is queued for. @@ -229,6 +168,7 @@ struct
>> s3c_hsotg_req { unsigned char           mapped; };
>> 
>> +#if IS_ENABLED(CONFIG_USB_DWC2_PERIPHERAL) ||
>> IS_ENABLED(CONFIG_USB_DWC2_DUAL_ROLE) #define call_gadget(_hs,
>> _entry) \ do { \ if ((_hs)->gadget.speed != USB_SPEED_UNKNOWN &&
>> \ @@ -238,6 +178,9 @@ do { \ spin_lock(&_hs->lock); \ } \ } while
>> (0) +#else +#define call_gadget(_hs, _entry)	do {} while (0) 
>> +#endif
>> 
>> struct dwc2_hsotg; struct dwc2_host_chan; @@ -495,11 +438,13 @@
>> struct dwc2_hw_params { * struct dwc2_hsotg - Holds the state of
>> the driver, including the non-periodic * and periodic schedules 
>> * + * These are common for both host and peripheral modes: + * *
>> @dev:                The struct device pointer * @regs:		Pointer
>> to controller regs - * @core_params:        Parameters that
>> define how the core should be configured * @hw_params:
>> Parameters that were autodetected from the *
>> hardware registers + * @core_params:	Parameters that define how
>> the core should be configured * @op_state:           The
>> operational State, during transitions (a_host=> *
>> a_peripheral and b_device=>b_host) this may not match *
>> the core, but allows the software to determine @@ -508,6 +453,8
>> @@ struct dwc2_hw_params { *                      -
>> USB_DR_MODE_PERIPHERAL *                      - USB_DR_MODE_HOST 
>> *                      - USB_DR_MODE_OTG + * @lock:		Spinlock
>> that protects all the driver data structures + * @priv:		Stores a
>> pointer to the struct usb_hcd * @queuing_high_bandwidth: True if
>> multiple packets of a high-bandwidth *
>> transfer are in process of being queued * @srp_success:
>> Stores status of SRP request in the case of a FS PHY @@ -517,6
>> +464,9 @@ struct dwc2_hw_params { *
>> interrupt * @wkp_timer:          Timer object for handling Wakeup
>> Detected interrupt * @lx_state:           Lx state of connected
>> device + * + * These are for host mode: + * * @flags:
>> Flags for handling root port state changes *
>> @non_periodic_sched_inactive: Inactive QHs in the non-periodic
>> schedule. *                      Transfers associated with these
>> QHs are not currently @@ -585,11 +535,31 @@ struct dwc2_hw_params
>> { * @status_buf_dma:     DMA address for status_buf *
>> @start_work:         Delayed work for handling host A-cable
>> connection * @reset_work:         Delayed work for handling a
>> port reset - * @lock:               Spinlock that protects all
>> the driver data structures - * @priv:               Stores a
>> pointer to the struct usb_hcd * @otg_port:           OTG port
>> number * @frame_list:         Frame list * @frame_list_dma:
>> Frame list DMA address + * + * These are for peripheral mode: +
>> * + * @driver:             USB gadget driver + * @phy:
>> The otg phy transceiver structure for phy control. + * @uphy:
>> The otg phy transceiver structure for old USB phy control. + *
>> @plat:               The platform specific configuration data.
>> This can be removed once + *                      all SoCs
>> support usb transceiver. + * @supplies:           Definition of
>> USB power supplies + * @phyif:              PHY interface width +
>> * @dedicated_fifos:    Set if the hardware has dedicated IN-EP
>> fifos. + * @num_of_eps:         Number of available EPs
>> (excluding EP0) + * @debug_root:         Root directrory for
>> debugfs. + * @debug_file:         Main status file for debugfs. +
>> * @debug_fifo:         FIFO status file for debugfs. + *
>> @ep0_reply:          Request used for ep0 reply. + * @ep0_buff:
>> Buffer for EP0 reply data, if needed. + * @ctrl_buff:
>> Buffer for EP0 control requests. + * @ctrl_req:           Request
>> for EP0 control packets. + * @setup:              NAK management
>> for EP0 SETUP + * @last_rst:           Time of last reset + *
>> @eps:                The endpoints being supplied to the gadget
>> framework */ struct dwc2_hsotg { struct device *dev; @@ -601,6
>> +571,9 @@ struct dwc2_hsotg { enum usb_otg_state op_state; enum
>> usb_dr_mode dr_mode;
>> 
>> +	spinlock_t lock; +	void *priv; + unsigned int
>> queuing_high_bandwidth:1; unsigned int srp_success:1;
>> 
>> @@ -609,6 +582,14 @@ struct dwc2_hsotg { struct timer_list
>> wkp_timer; enum dwc2_lx_state lx_state;
>> 
>> +	/* DWC OTG HW Release versions */ +#define DWC2_CORE_REV_2_71a
>> 0x4f54271a +#define DWC2_CORE_REV_2_90a	0x4f54290a +#define
>> DWC2_CORE_REV_2_92a	0x4f54292a +#define DWC2_CORE_REV_2_94a
>> 0x4f54294a +#define DWC2_CORE_REV_3_00a	0x4f54300a + +#if
>> IS_ENABLED(CONFIG_USB_DWC2_HOST) ||
>> IS_ENABLED(CONFIG_USB_DWC2_DUAL_ROLE) union
>> dwc2_hcd_internal_flags { u32 d32; struct { @@ -655,19 +636,10 @@
>> struct dwc2_hsotg {
>> 
>> struct delayed_work start_work; struct delayed_work reset_work; -
>> spinlock_t lock; -	void *priv; u8 otg_port; u32 *frame_list; 
>> dma_addr_t frame_list_dma;
>> 
>> -	/* DWC OTG HW Release versions */ -#define DWC2_CORE_REV_2_71a
>> 0x4f54271a -#define DWC2_CORE_REV_2_90a	0x4f54290a -#define
>> DWC2_CORE_REV_2_92a	0x4f54292a -#define DWC2_CORE_REV_2_94a
>> 0x4f54294a -#define DWC2_CORE_REV_3_00a	0x4f54300a - #ifdef
>> DEBUG u32 frrem_samples; u64 frrem_accum; @@ -686,6 +658,40 @@
>> struct dwc2_hsotg { u32 hfnum_other_samples_b; u64
>> hfnum_other_frrem_accum_b; #endif +#endif /* CONFIG_USB_DWC2_HOST
>> || CONFIG_USB_DWC2_DUAL_ROLE */ + +#if
>> IS_ENABLED(CONFIG_USB_DWC2_PERIPHERAL) ||
>> IS_ENABLED(CONFIG_USB_DWC2_DUAL_ROLE) +	/* Gadget structures */ +
>> struct usb_gadget_driver *driver; +	struct phy *phy;
> 
> this shouldn't be limited to gadget.
> 
>> +	struct usb_phy *uphy;
> 
> this shouldn't be limited to gadget.
> 
>> +	struct s3c_hsotg_plat *plat; + +	int	irq;
> 
> this shouldn't be limited to gadget.
> 
>> +	struct clk *clk;
> 
> this shouldn't be limited to gadget.
> 
>> + +	struct regulator_bulk_data
>> supplies[ARRAY_SIZE(s3c_hsotg_supply_names)];
> 
> this shouldn't be limited to gadget.
> 
>> +	u32 phyif; +	int fifo_mem; +	unsigned int dedicated_fifos:1; +
>> unsigned char num_of_eps; +	u32 fifo_map; + +	struct dentry
>> *debug_root;
> 
> this shouldn't be limited to gadget.
> 
>> +	struct dentry *debug_file;
> 
> this shouldn't be limited to gadget.
> 
>> +	struct dentry *debug_fifo;
> 
> this shouldn't be limited to gadget.
> 

All fixed..

thanks,
Dinh
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJUU6LrAAoJEBmUBAuBoyj024wP/j7x+PW8rV8Aqzhkg4d1zSKE
BE7/Axir8uPVTZfIOFBouHz6h0APztgW+by7DZdXCE8K6gUDAfzruxLRHNjctT6E
KRj6A+i7qYnF/0+kc9b2InWYfS8NcOxths7r70RhJz7jlCphpaqlfhlicMSc0Ury
Z/EeOYRpbwltDHGSBSkcPaw0yL4h/BQIRm1rRaUj+10cliSYwW5Re6mfiWVV+0pl
WA56MM5xf7N9PO1Q+TPyStLyUTLyb3jiNwCOWfUCIkpHwJC9AIgbuBZXPMrSGOoL
cMNoLHkgfY4HPFgzGlGxIgbHdkMec6A78FzSgz04P5+Uzh/MGKyrecordMbpQAPS
DCGGWOsPrujAbWhgrus+cfxznIV3+4vhP+uC387RgLsYaJLRpAEpYN5aTABRU8u2
uEsbfYIhRGaGDQqTR0mzcKMXy9xoUMLNLkpiaqlGTs2Et0f1ZkElIn/dpefx417u
Ocmfq7ab0cXgHnYNjdk9yE9JchgjUG5sn+INKbm/lLmXNyN3VHNZnBO42v1d78Gw
sylySISc1aUJGXkuRJDPM4oC4jyPrerLB4BQbF0bQqaakz+U83+I+wZ7e9IOldO9
bPk5I7VZO8F8Ve0oP1WvuVZGeCnhrTd2isfx/orQ4J3uQFBD9hddGyaroDPtRIkA
zoNVOSXVySi9EiPYT12u
=382E
-----END PGP SIGNATURE-----
