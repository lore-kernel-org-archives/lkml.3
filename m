Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbaHAR3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 13:29:43 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:18925
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750851AbaHAR3l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 13:29:41 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Dexuan Cui <decui@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jkosina@suse.cz" <jkosina@suse.cz>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
CC: Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH] HID: hyperv: register as a wakeup source
Thread-Topic: [PATCH] HID: hyperv: register as a wakeup source
Thread-Index: AQHPrYv64sO6oVKNGEuPE0s1MI+FW5u8AS2Q
Date: Fri, 1 Aug 2014 17:29:38 +0000
Message-ID: <2e66fa7690584834b26b0069063e85e0@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1406903201-7210-1-git-send-email-decui@microsoft.com>
In-Reply-To: <1406903201-7210-1-git-send-email-decui@microsoft.com>
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
> Sent: Friday, August 1, 2014 7:27 AM
> To: gregkh@linuxfoundation.org; jkosina@suse.cz; linux-
> input@vger.kernel.org; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com
> Cc: KY Srinivasan; Haiyang Zhang
> Subject: [PATCH] HID: hyperv: register as a wakeup source
> 
> With this patch, we can move the mouse to wake up the VM after the VM
> executes "echo freeze > /sys/power/state".
> 
> This addresses part of https://bugzilla.redhat.com/show_bug.cgi?id=1086100
> 
> Cc: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

> ---
>  drivers/hid/hid-hyperv.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/hid/hid-hyperv.c b/drivers/hid/hid-hyperv.c index
> f52dbcb..31fad64 100644
> --- a/drivers/hid/hid-hyperv.c
> +++ b/drivers/hid/hid-hyperv.c
> @@ -308,6 +308,9 @@ static void mousevsc_on_receive(struct hv_device
> *device,
>  		memcpy(input_dev->input_buf, input_report->buffer, len);
>  		hid_input_report(input_dev->hid_device,
> HID_INPUT_REPORT,
>  				 input_dev->input_buf, len, 1);
> +
> +		pm_wakeup_event(&input_dev->device->device, 0);
> +
>  		break;
>  	default:
>  		pr_err("unsupported hid msg type - type %d len %d", @@ -
> 549,6 +552,8 @@ static int mousevsc_probe(struct hv_device *device,
>  		goto probe_err2;
>  	}
> 
> +	device_init_wakeup(&device->device, true);
> +
>  	input_dev->connected = true;
>  	input_dev->init_complete = true;
> 
> @@ -571,6 +576,7 @@ static int mousevsc_remove(struct hv_device *dev)  {
>  	struct mousevsc_dev *input_dev = hv_get_drvdata(dev);
> 
> +	device_init_wakeup(&dev->device, false);
>  	vmbus_close(dev->channel);
>  	hid_hw_stop(input_dev->hid_device);
>  	hid_destroy_device(input_dev->hid_device);
> --
> 1.9.1

