Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbaBYPv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 10:51:28 -0500
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.89]:35098 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752734AbaBYPv1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 10:51:27 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Gerd Hoffmann <kraxel@redhat.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        KY Srinivasan <kys@microsoft.com>,
        "Abhishek Gupta (LIS)" <abgupta@microsoft.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tomi.valkeinen@ti.com" <tomi.valkeinen@ti.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Subject: RE: [PATCH v4 2/2] hyperv-fb: kick off efifb early
Thread-Topic: [PATCH v4 2/2] hyperv-fb: kick off efifb early
Thread-Index: AQHPMiWzK5WeHZdVVkWghxu6/BfrCJrGGZtw
Date: Tue, 25 Feb 2014 15:51:15 +0000
Message-ID: <5414def7813d4bccbcf1b128b6a5ee46@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1393331320-18147-1-git-send-email-kraxel@redhat.com>
 <1393331320-18147-3-git-send-email-kraxel@redhat.com>
In-Reply-To: <1393331320-18147-3-git-send-email-kraxel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(199002)(189002)(377454003)(13464003)(164054003)(51914003)(51704005)(81686001)(93516002)(47736001)(80022001)(50466002)(66066001)(65816001)(47976001)(85306002)(69226001)(76482001)(94316002)(74876001)(31966008)(74662001)(79102001)(20776003)(80976001)(4396001)(47776003)(63696002)(84676001)(74502001)(53806001)(83322001)(19580395003)(19580405001)(54356001)(47446002)(44976005)(6806004)(77982001)(59766001)(2656002)(46102001)(87266001)(74706001)(93136001)(83072002)(85852003)(95666003)(81542001)(81342001)(56816005)(95416001)(94946001)(74366001)(50986001)(23726002)(87936001)(56776001)(76796001)(46406003)(81816001)(86612001)(76786001)(49866001)(92566001)(54316002)(33646001)(90146001)(51856001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUSR01MB591;H:hybrid.exchange.microsoft.com;FPR:B42E6D1E.23D154C2.EFE6DB42.84A69A11.202CE;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 01334458E5
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Gerd Hoffmann [mailto:kraxel@redhat.com]
> Sent: Tuesday, February 25, 2014 7:29 AM
> To: linux-fbdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; gregkh@linuxfoundation.org; KY Srinivasan;
> Abhishek Gupta (LIS); Haiyang Zhang; jasowang@redhat.com;
> tomi.valkeinen@ti.com; devel@linuxdriverproject.org; Gerd Hoffmann; Jean-
> Christophe Plagniol-Villard
> Subject: [PATCH v4 2/2] hyperv-fb: kick off efifb early
> 
> Remove firmware framebuffer before initializing hyperv-fb.  Needed
> on gen2 virtual machines.   Letting register_framebuffer handle the
> switchover results in efifb still being active while hyperv graphics are
> initialized, which in turn can make the linux kernel hang.
> 
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>  drivers/video/hyperv_fb.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/video/hyperv_fb.c b/drivers/video/hyperv_fb.c index
> b7b3dd0..1b11886 100644
> --- a/drivers/video/hyperv_fb.c
> +++ b/drivers/video/hyperv_fb.c
> @@ -683,6 +683,7 @@ static int hvfb_getmem(struct fb_info *info)
>  		info->apertures->ranges[0].base = pci_resource_start(pdev, 0);
>  		info->apertures->ranges[0].size = pci_resource_len(pdev, 0);
>  	}
> +	remove_conflicting_framebuffers(info->apertures,
> KBUILD_MODNAME,
> +false);

Thanks for the updates. I'm concerned about, after removing efifb, 
if synthvid_send_config(hdev) fails, then there will be no video driver
available. Is there a way to bring the generic driver back if 
synthvid_send_config(hdev) fails?

If no way to recover the generic driver, please limit the early
remove_conflicting_framebuffers() to Gen2 VM only.

Thanks,
- Haiyang

