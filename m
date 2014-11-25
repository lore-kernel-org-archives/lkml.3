Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbaKYHGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 02:06:25 -0500
Received: from mail-bn1bbn0101.outbound.protection.outlook.com ([157.56.111.101]:29952
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752466AbaKYHGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 02:06:22 -0500
From: Peter Chen <Peter.Chen@freescale.com>
To: Kiran Raparthy <kiran.kumar@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?utf-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Benoit Goby <benoit@android.com>, Todd Poynor <toddpoynor@google.com>
Subject: RE: [PATCH v3 3/3] usb: phy: hold wakeupsource when USB is enumerated
 in peripheral mode
Thread-Topic: [PATCH v3 3/3] usb: phy: hold wakeupsource when USB is
 enumerated in peripheral mode
Thread-Index: AQHQCAv+GnQF09jqJEOVTmAISz+anpxw6mlQ
Date: Tue, 25 Nov 2014 07:06:18 +0000
Message-ID: <15cad5ef7627483cbba96e05fe180813@BN1PR0301MB0772.namprd03.prod.outlook.com>
References: <1416849900-29959-1-git-send-email-kiran.kumar@linaro.org>
 <1416849900-29959-3-git-send-email-kiran.kumar@linaro.org>
In-Reply-To: <1416849900-29959-3-git-send-email-kiran.kumar@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.158.211]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0771;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0771;
x-forefront-prvs: 040655413E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(189002)(199003)(107046002)(21056001)(95666004)(99286002)(120916001)(99396003)(2656002)(87936001)(76576001)(31966008)(105586002)(66066001)(46102003)(106356001)(20776003)(64706001)(106116001)(33646002)(74316001)(4396001)(101416001)(97736003)(62966003)(77096003)(15202345003)(77156002)(19580405001)(40100003)(19580395003)(122556002)(108616004)(15975445006)(50986999)(92566001)(54356999)(76176999)(86362001)(24736002)(422495003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0771;H:BN1PR0301MB0772.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAP76UqM003817

 
> 
> usb: phy: hold wakeupsource when USB is enumerated in peripheral mode
> 
> Some systems require a mechanism to prevent system to enter into suspend
> state when USB is connected and enumerated in peripheral mode.
> 
> This patch provides an interface to hold a wakeupsource to prevent suspend.
> PHY drivers can use this interface when USB is connected and enumerated in
> peripheral mode.
> 
> A timed wakeupsource is temporarily held on USB disconnect events, to allow
> the rest of the system to react to the USB disconnection (dropping host
> sessions, updating charger status, etc.) prior to re-allowing suspend.
> 

Hi Kiran & Felipe,

Just two questions for this series

- Will it be the default behavior for all peripheral drivers?
- If the peripheral driver's PHY driver does not vbus event, how to support it?
For example, chipidea udc driver has its vbus interface at its controller register.

Peter

> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-usb@vger.kernel.org
> Cc: Android Kernel Team <kernel-team@android.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Cc: Arve HjÃ¸nnevÃ¥g <arve@android.com>
> Cc: Benoit Goby <benoit@android.com>
> [Original patch in Android from Todd]
> Cc: Todd Poynor <toddpoynor@google.com>
> Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
> ---
>  drivers/usb/phy/phy.c   | 29 +++++++++++++++++++++++++++--
>  include/linux/usb/phy.h |  5 +++++
>  2 files changed, 32 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/phy/phy.c b/drivers/usb/phy/phy.c index
> b4066a0..8c87bc3 100644
> --- a/drivers/usb/phy/phy.c
> +++ b/drivers/usb/phy/phy.c
> @@ -331,6 +331,7 @@ int usb_add_phy(struct usb_phy *x, enum
> usb_phy_type type)
>  	int		ret = 0;
>  	unsigned long	flags;
>  	struct usb_phy	*phy;
> +	char wsource_name[40];
> 
>  	if (x->type != USB_PHY_TYPE_UNDEFINED) {
>  		dev_err(x->dev, "not accepting initialized PHY %s\n", x->label);
> @@ -353,6 +354,10 @@ int usb_add_phy(struct usb_phy *x, enum
> usb_phy_type type)
>  	x->type = type;
>  	list_add_tail(&x->head, &phy_list);
> 
> +	snprintf(wsource_name, sizeof(wsource_name), "vbus-%s",
> +		dev_name(x->dev));
> +	wakeup_source_init(&x->wsource, wsource_name);
> +
>  out:
>  	spin_unlock_irqrestore(&phy_lock, flags);
>  	return ret;
> @@ -404,6 +409,7 @@ void usb_remove_phy(struct usb_phy *x)
> 
>  	spin_lock_irqsave(&phy_lock, flags);
>  	if (x) {
> +		wakeup_source_trash(&x->wsource);
>  		list_for_each_entry(phy_bind, &phy_bind_list, list)
>  			if (phy_bind->phy == x)
>  				phy_bind->phy = NULL;
> @@ -448,13 +454,32 @@ int usb_bind_phy(const char *dev_name, u8 index,
> EXPORT_SYMBOL_GPL(usb_bind_phy);
> 
>  /**
> - * usb_phy_set_event - set event to phy event
> + * usb_phy_set_event - set event to phy event and
> + * hold/temporarily hold wakeupsource
>   * @x: the phy returned by usb_get_phy();
>   *
> - * This sets event to phy event
> + * This holds per-PHY wakeupsource/timed wakeupsource
>   */
>  void usb_phy_set_event(struct usb_phy *x, unsigned long event)  {
> +
>  	x->last_event = event;
> +
> +	switch (event) {
> +	case USB_EVENT_ENUMERATED:
> +		__pm_stay_awake(&x->wsource);
> +		break;
> +
> +	case USB_EVENT_NONE:
> +	case USB_EVENT_ID:
> +	case USB_EVENT_VBUS:
> +	case USB_EVENT_CHARGER:
> +		__pm_wakeup_event(&x->wsource,
> +				  USB_PHY_DEFAULT_WAKEUP_SRC_TIMEOUT);
> +		break;
> +
> +	default:
> +		break;
> +	}
>  }
>  EXPORT_SYMBOL_GPL(usb_phy_set_event);
> diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h index
> f499c23..63a56bf 100644
> --- a/include/linux/usb/phy.h
> +++ b/include/linux/usb/phy.h
> @@ -12,6 +12,8 @@
>  #include <linux/notifier.h>
>  #include <linux/usb.h>
> 
> +#define USB_PHY_DEFAULT_WAKEUP_SRC_TIMEOUT
> 	msecs_to_jiffies(2000)
> +
>  enum usb_phy_interface {
>  	USBPHY_INTERFACE_MODE_UNKNOWN,
>  	USBPHY_INTERFACE_MODE_UTMI,
> @@ -88,6 +90,9 @@ struct usb_phy {
>  	/* for notification of usb_phy_events */
>  	struct atomic_notifier_head	notifier;
> 
> +	/* wakeup source */
> +	struct wakeup_source    wsource;
> +
>  	/* to pass extra port status to the root hub */
>  	u16			port_status;
>  	u16			port_change;
> --
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in the body
> of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
