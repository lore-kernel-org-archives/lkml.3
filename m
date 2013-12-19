Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab3LSQ60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:58:26 -0500
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:55444
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752109Ab3LSQ6Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:58:25 -0500
From: KY Srinivasan <kys@microsoft.com>
To: David Herrmann <dh.herrmann@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
CC: Jiri Kosina <jkosina@suse.cz>, Dan Carpenter <dan.carpenter@oracle.com>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] HID: hyperv: make sure input buffer is big enough
Thread-Topic: [PATCH] HID: hyperv: make sure input buffer is big enough
Thread-Index: AQHO/K4UEm22C8szIEGRjdMt8XnJVJpbvWLQ
Date: Thu, 19 Dec 2013 16:58:21 +0000
Message-ID: <5bae77400133466d9698c925bfe58df5@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1387452744-8860-1-git-send-email-dh.herrmann@gmail.com>
In-Reply-To: <1387452744-8860-1-git-send-email-dh.herrmann@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2601:8:9b00:402:c810:5727:8fa5:f7e2]
x-forefront-prvs: 006546F32A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(13464003)(199002)(189002)(51704005)(377454003)(50986001)(33646001)(46102001)(74876001)(74706001)(47736001)(47976001)(49866001)(4396001)(74316001)(74366001)(76482001)(51856001)(53806001)(54356001)(63696002)(81542001)(19580405001)(19580395003)(81342001)(79102001)(54316002)(83322001)(65816001)(80976001)(80022001)(81816001)(81686001)(69226001)(31966008)(87266001)(85306002)(74502001)(74662001)(47446002)(85852003)(59766001)(77982001)(87936001)(76576001)(76786001)(76796001)(56776001)(90146001)(83072002)(2656002)(56816005)(3826001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB300;H:BY2PR03MB299.namprd03.prod.outlook.com;CLIP:2601:8:9b00:402:c810:5727:8fa5:f7e2;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Herrmann [mailto:dh.herrmann@gmail.com]
> Sent: Thursday, December 19, 2013 3:32 AM
> To: linux-input@vger.kernel.org
> Cc: Jiri Kosina; Dan Carpenter; Joseph Salisbury; KY Srinivasan; Haiyang Zhang;
> linux-kernel@vger.kernel.org; David Herrmann
> Subject: [PATCH] HID: hyperv: make sure input buffer is big enough
> 
> We need at least HID_MAX_BUFFER_SIZE (4096) bytes as input buffer. HID
> core depends on this as it requires every input report to be at least as
> big as advertised.
> 
> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

> ---
> Hi
> 
> Same as for the HIDP patch, if there's a way to avoid the extra copy, please
> provide a better patch.
> 
> Thanks
> David
> 
>  drivers/hid/hid-hyperv.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/hid/hid-hyperv.c b/drivers/hid/hid-hyperv.c
> index 8fae6d1..c24908f 100644
> --- a/drivers/hid/hid-hyperv.c
> +++ b/drivers/hid/hid-hyperv.c
> @@ -157,6 +157,7 @@ struct mousevsc_dev {
>  	u32			report_desc_size;
>  	struct hv_input_dev_info hid_dev_info;
>  	struct hid_device       *hid_device;
> +	u8			input_buf[HID_MAX_BUFFER_SIZE];
>  };
> 
> 
> @@ -256,6 +257,7 @@ static void mousevsc_on_receive(struct hv_device
> *device,
>  	struct synthhid_msg *hid_msg;
>  	struct mousevsc_dev *input_dev = hv_get_drvdata(device);
>  	struct synthhid_input_report *input_report;
> +	size_t len;
> 
>  	pipe_msg = (struct pipe_prt_msg *)((unsigned long)packet +
>  						(packet->offset8 << 3));
> @@ -300,9 +302,12 @@ static void mousevsc_on_receive(struct hv_device
> *device,
>  			(struct synthhid_input_report *)pipe_msg->data;
>  		if (!input_dev->init_complete)
>  			break;
> -		hid_input_report(input_dev->hid_device,
> -				HID_INPUT_REPORT, input_report->buffer,
> -				input_report->header.size, 1);
> +
> +		len = min(input_report->header.size,
> +			  (u32)sizeof(input_dev->input_buf));
> +		memcpy(input_dev->input_buf, input_report->buffer, len);
> +		hid_input_report(input_dev->hid_device, HID_INPUT_REPORT,
> +				 input_dev->input_buf, len, 1);
>  		break;
>  	default:
>  		pr_err("unsupported hid msg type - type %d len %d",
> --
> 1.8.5.1

