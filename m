Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbaKDQuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:50:51 -0500
Received: from mail-bn1bon0140.outbound.protection.outlook.com ([157.56.111.140]:57528
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751649AbaKDQur convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:50:47 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Drivers: hv: vmbus: Fix a race condition when
 unregistering a device
Thread-Topic: [PATCH] Drivers: hv: vmbus: Fix a race condition when
 unregistering a device
Thread-Index: AQHP+Cx/QGK5N5xRuUCqDgcGtmoOqpxQrg1w
Date: Tue, 4 Nov 2014 16:50:42 +0000
Message-ID: <c4546b3420864d0d8be7e4b8e36d1875@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1415104811-28142-1-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1415104811-28142-1-git-send-email-vkuznets@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [50.135.110.52]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0712;UriScan:;
x-forefront-prvs: 03853D523D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(377454003)(51704005)(189002)(13464003)(199003)(97736003)(76176999)(33646002)(19580405001)(2656002)(87936001)(19580395003)(2421001)(54356999)(101416001)(120916001)(122556002)(64706001)(106116001)(76576001)(20776003)(66066001)(86362001)(46102003)(95666004)(99286002)(1511001)(86612001)(50986999)(77096003)(21056001)(77156002)(108616004)(99396003)(105586002)(40100003)(31966008)(4396001)(62966003)(106356001)(92566001)(107046002)(74316001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0712;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0614;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> Sent: Tuesday, November 4, 2014 4:40 AM
> To: KY Srinivasan; Haiyang Zhang
> Cc: Greg Kroah-Hartman; devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH] Drivers: hv: vmbus: Fix a race condition when unregistering
> a device
> 
> When build with Debug the following crash is sometimes observed:
> Call Trace:
>  [<ffffffff812b9600>] string+0x40/0x100
>  [<ffffffff812bb038>] vsnprintf+0x218/0x5e0  [<ffffffff810baf7d>] ?
> trace_hardirqs_off+0xd/0x10  [<ffffffff812bb4c1>] vscnprintf+0x11/0x30
> [<ffffffff8107a2f0>] vprintk+0xd0/0x5c0  [<ffffffffa0051ea0>] ?
> vmbus_process_rescind_offer+0x0/0x110 [hv_vmbus]  [<ffffffff8155c71c>]
> printk+0x41/0x45  [<ffffffffa004ebac>] vmbus_device_unregister+0x2c/0x40
> [hv_vmbus]  [<ffffffffa0051ecb>]
> vmbus_process_rescind_offer+0x2b/0x110 [hv_vmbus] ...
> 
> This happens due to the following race: between 'if (channel->device_obj)'
> check in vmbus_process_rescind_offer() and pr_debug() in
> vmbus_device_unregister() the device can disappear. Fix the issue by taking
> an additional reference to the device before proceeding to
> vmbus_device_unregister().
> 
Thank you.
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>
> ---
>  drivers/hv/channel_mgmt.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c index
> a2d1a96..d36ce68 100644
> --- a/drivers/hv/channel_mgmt.c
> +++ b/drivers/hv/channel_mgmt.c
> @@ -216,9 +216,16 @@ static void vmbus_process_rescind_offer(struct
> work_struct *work)
>  	unsigned long flags;
>  	struct vmbus_channel *primary_channel;
>  	struct vmbus_channel_relid_released msg;
> +	struct device *dev;
> +
> +	if (channel->device_obj) {
> +		dev = get_device(&channel->device_obj->device);
> +		if (dev) {
> +			vmbus_device_unregister(channel->device_obj);
> +			put_device(dev);
> +		}
> +	}
> 
> -	if (channel->device_obj)
> -		vmbus_device_unregister(channel->device_obj);
>  	memset(&msg, 0, sizeof(struct vmbus_channel_relid_released));
>  	msg.child_relid = channel->offermsg.child_relid;
>  	msg.header.msgtype = CHANNELMSG_RELID_RELEASED;
> --
> 1.9.3

