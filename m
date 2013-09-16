Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab3IPSmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 14:42:32 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:47650
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751353Ab3IPSm3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 14:42:29 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vojtech@suse.cz" <vojtech@suse.cz>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH 1/1] Drivers: input: serio: New driver to support
 Hyper-V synthetic keyboard
Thread-Topic: [PATCH 1/1] Drivers: input: serio: New driver to support
 Hyper-V synthetic keyboard
Thread-Index: AQHOspfSNoWHhKt7u0WqPY6XUwHbdJnIBjYAgABmTaCAAArAAIAAC6BwgAAXC4CAABPrMIAAA2WAgAABSXA=
Date: Mon, 16 Sep 2013 18:42:25 +0000
Message-ID: <117fbf407a554684b4d72ab06b033eeb@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1379309334-25042-1-git-send-email-kys@microsoft.com>
 <20130916082110.GN25896@mwanda>
 <3b5096d0190b4440a8e25afbd22ab72d@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130916150548.GO25896@mwanda>
 <baabf219b12b40de8e17b029e621e079@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130916170951.GB20734@core.coreip.homeip.net>
 <3e45f054c6e243eabf2896ab1dcf38d4@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130916183319.GM19256@mwanda>
In-Reply-To: <20130916183319.GM19256@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e8:ed31::3]
x-forefront-prvs: 0971922F40
x-forefront-antispam-report: SFV:NSPM;SFS:(13464003)(377454003)(51704005)(199002)(189002)(80976001)(54356001)(77096001)(76576001)(77982001)(59766001)(56816003)(81816001)(81686001)(79102001)(65816001)(74366001)(76482001)(74316001)(76786001)(76796001)(50986001)(63696002)(46102001)(83072001)(74502001)(51856001)(19580405001)(83322001)(19580395003)(47446002)(74662001)(31966008)(69226001)(74706001)(81342001)(81542001)(80022001)(53806001)(54316002)(4396001)(74876001)(47736001)(47976001)(33646001)(49866001)(56776001)(24736002)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB063;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:2001:4898:80e8:ed31::3;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a84fc36a-4ed7-4e57-ab1c-3e967bcbad48.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Monday, September 16, 2013 11:33 AM
> To: KY Srinivasan
> Cc: Dmitry Torokhov; olaf@aepfle.de; gregkh@linuxfoundation.org;
> jasowang@redhat.com; linux-kernel@vger.kernel.org; vojtech@suse.cz; linux-
> input@vger.kernel.org; apw@canonical.com; devel@linuxdriverproject.org
> Subject: Re: [PATCH 1/1] Drivers: input: serio: New driver to support Hyper-V
> synthetic keyboard
> 
> Just roll something like the following into your patch.
> 
> regards,
> dan carpenter
> 
> diff --git a/drivers/input/serio/hyperv-keyboard.c b/drivers/input/serio/hyperv-
> keyboard.c
> index 0d4625f..262721b 100644
> --- a/drivers/input/serio/hyperv-keyboard.c
> +++ b/drivers/input/serio/hyperv-keyboard.c
> @@ -151,15 +151,18 @@ static void hv_kbd_free_device(struct hv_kbd_dev
> *device)
>  }
> 
>  static void hv_kbd_on_receive(struct hv_device *device,
> -				struct vmpacket_descriptor *packet)
> +			      struct vmpacket_descriptor *packet, size_t size)
>  {
>  	struct synth_kbd_msg *msg;
>  	struct hv_kbd_dev *kbd_dev = hv_get_drvdata(device);
>  	struct synth_kbd_keystroke *ks_msg;
> +	int offset;
>  	u16 scan_code;
> 
> -	msg = (struct synth_kbd_msg *)((unsigned long)packet +
> -					(packet->offset8 << 3));
> +	offset = packet->offset8 << 3;
> +	if (offset + sizeof(struct synth_kbd_protocol_response) > size)
> +		return;
> +	msg = (void *)packet + offset;
> 
>  	switch (msg->header.type) {
>  	case SYNTH_KBD_PROTOCOL_RESPONSE:
> @@ -220,7 +223,7 @@ static void hv_kbd_on_channel_callback(void *context)
>  				break;
> 
>  			case VM_PKT_DATA_INBAND:
> -				hv_kbd_on_receive(device, desc);
> +				hv_kbd_on_receive(device, desc, bytes_recvd);
>  				break;
> 
>  			default:

Dan,

Rolling the changes you have indicated is not the issue; this can trivially be done.
My contention is that it is not needed given that the underlying function is already
doing that. Look at the function  vmbus_recvpacket_raw() in drivers/hv/channel.c.

Regards,

K. Y


