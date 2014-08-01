Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbaHAR3P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 13:29:15 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:27169
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751694AbaHAR3N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 13:29:13 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Dexuan Cui <decui@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
CC: Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH] Input: hyperv-keyboard: register as a wakeup source
Thread-Topic: [PATCH] Input: hyperv-keyboard: register as a wakeup source
Thread-Index: AQHPrYw4YZKzhZE33kO/L7f+c6WZR5u8AKwA
Date: Fri, 1 Aug 2014 17:29:09 +0000
Message-ID: <0c4b13461c5c44c5a7ebaa3d215e1875@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1406903304-7256-1-git-send-email-decui@microsoft.com>
In-Reply-To: <1406903304-7256-1-git-send-email-decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e8:ee31::2]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 029097202E
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(377454003)(51704005)(13464003)(189002)(199002)(85852003)(87936001)(83072002)(2656002)(80022001)(4396001)(1511001)(92566001)(105586002)(106356001)(106116001)(95666004)(99286002)(2201001)(33646002)(107046002)(50986999)(54356999)(99396002)(81542001)(46102001)(83322001)(85306004)(19580395003)(21056001)(76176999)(81342001)(19580405001)(86362001)(101416001)(74662001)(74502001)(31966008)(76482001)(74316001)(79102001)(76576001)(77982001)(15975445006)(64706001)(77096002)(20776003)(24736002)(3826002)(108616003);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0710;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dexuan Cui [mailto:decui@microsoft.com]
> Sent: Friday, August 1, 2014 7:28 AM
> To: gregkh@linuxfoundation.org; dmitry.torokhov@gmail.com; linux-
> input@vger.kernel.org; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com
> Cc: KY Srinivasan; Haiyang Zhang
> Subject: [PATCH] Input: hyperv-keyboard: register as a wakeup source
> 
> With this patch, we can press a key to wake up the VM after the VM
> executes "echo freeze > /sys/power/state".
> 
> This addresses part of https://bugzilla.redhat.com/show_bug.cgi?id=1086100
> 
> Cc: K. Y. Srinivasan <kys@microsoft.com>
Thanks Dexuan.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>  drivers/input/serio/hyperv-keyboard.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/input/serio/hyperv-keyboard.c
> b/drivers/input/serio/hyperv-keyboard.c
> index 6132619..e74e5d6 100644
> --- a/drivers/input/serio/hyperv-keyboard.c
> +++ b/drivers/input/serio/hyperv-keyboard.c
> @@ -170,6 +170,15 @@ static void hv_kbd_on_receive(struct hv_device
> *hv_dev,
>  			serio_interrupt(kbd_dev->hv_serio, scan_code, 0);
>  		}
>  		spin_unlock_irqrestore(&kbd_dev->lock, flags);
> +
> +		/*
> +		 * Only trigger a wakeup on key down, otherwise
> +		 * "echo freeze > /sys/power/state" can't really enter the
> +		 * state because the Enter-UP can trigger a wakeup at once.
> +		 */
> +		if (!(info & IS_BREAK))
> +			pm_wakeup_event(&hv_dev->device, 0);
> +
>  		break;
> 
>  	default:
> @@ -376,6 +385,9 @@ static int hv_kbd_probe(struct hv_device *hv_dev,
>  		goto err_close_vmbus;
> 
>  	serio_register_port(kbd_dev->hv_serio);
> +
> +	device_init_wakeup(&hv_dev->device, true);
> +
>  	return 0;
> 
>  err_close_vmbus:
> @@ -390,6 +402,7 @@ static int hv_kbd_remove(struct hv_device *hv_dev)
> {
>  	struct hv_kbd_dev *kbd_dev = hv_get_drvdata(hv_dev);
> 
> +	device_init_wakeup(&hv_dev->device, false);
>  	serio_unregister_port(kbd_dev->hv_serio);
>  	vmbus_close(hv_dev->channel);
>  	kfree(kbd_dev);
> --
> 1.9.1

