Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbaGKOtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:49:23 -0400
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:23138
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752048AbaGKOtW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:49:22 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 6/8] Drivers: scsi: storvsc: Implement an abort handler
Thread-Topic: [PATCH 6/8] Drivers: scsi: storvsc: Implement an abort handler
Thread-Index: AQHPmwbaMJcVE9K7bk+ZFkv2/whfmJuXbd+AgACmi9CAAQSuAIAAzDFQgADAb4CAAFJ50A==
Date: Fri, 11 Jul 2014 14:49:17 +0000
Message-ID: <24b8bacd815e4c43add14f66c85ff61b@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-6-git-send-email-kys@microsoft.com>
 <20140709084415.GF6012@infradead.org>
 <9b76360fb30745d3941b6d56bdae268f@BY2PR03MB299.namprd03.prod.outlook.com>
 <20140710101320.GB1151@infradead.org>
 <f662b500fada4fbca75c55089d3f8ee4@BY2PR03MB299.namprd03.prod.outlook.com>
 <53BFB3F7.7010304@suse.de>
In-Reply-To: <53BFB3F7.7010304@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.135.110.52]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 02698DF457
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(479174003)(377454003)(189002)(199002)(51704005)(13464003)(24454002)(33646001)(2656002)(101416001)(74316001)(80022001)(95666004)(20776003)(50986999)(81342001)(54356999)(85852003)(74662001)(106116001)(19580395003)(99286002)(76176999)(86362001)(105586002)(106356001)(92566001)(575784001)(86612001)(74502001)(107046002)(76482001)(76576001)(19580405001)(46102001)(81542001)(64706001)(77982001)(66066001)(4396001)(87936001)(83072002)(79102001)(21056001)(85306003)(93886003)(31966008)(83322001)(99396002)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB300;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Friday, July 11, 2014 2:53 AM
> To: KY Srinivasan; Christoph Hellwig
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> ohering@suse.com; jbottomley@parallels.com; jasowang@redhat.com;
> apw@canonical.com; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 6/8] Drivers: scsi: storvsc: Implement an abort handler
> 
> On 07/11/2014 12:26 AM, KY Srinivasan wrote:
> >
> >
> >> -----Original Message-----
> >> From: Christoph Hellwig [mailto:hch@infradead.org]
> >> Sent: Thursday, July 10, 2014 3:13 AM
> >> To: KY Srinivasan
> >> Cc: Christoph Hellwig; linux-kernel@vger.kernel.org;
> >> devel@linuxdriverproject.org; ohering@suse.com;
> >> jbottomley@parallels.com; jasowang@redhat.com; apw@canonical.com;
> >> linux-scsi@vger.kernel.org
> >> Subject: Re: [PATCH 6/8] Drivers: scsi: storvsc: Implement an abort
> >> handler
> >>
> >>
> >> Note that you could increase the timeout and/or implement an
> >> eh_timed_out handler that just returns BLK_EH_RESET_TIMER, but if the
> >> completion takes too long the expectation is that a command will
> >> eventually finish instead of beeing delayed by an unmound amount.
> >
> > I like this idea; I will implement a eh_timed_out_handler.
> >
> Something like this should be sufficient:
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c index
> e71a0d7..630ae81 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1468,6 +1468,12 @@ static int storvsc_get_chs(struct scsi_device
> *sdev, stru ct block_device * bdev,
>          return 0;
>   }
> 
> +static enum blk_eh_timer_return
> +storvsc_timed_out_handler(struct scsi_cmnd *scmd) {
> +       return BLK_EH_RESET_TIMER;
> +}
> +
>   static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
>   {
>          struct hv_host_device *host_dev = shost_priv(scmnd->device->host);
> @@ -1687,6 +1693,7 @@ static struct scsi_host_template scsi_driver = {
>          .name =                 "storvsc_host_t",
>          .bios_param =           storvsc_get_chs,
>          .queuecommand =         storvsc_queuecommand,
> +       .eh_timed_out =         storvsc_timed_out_handler,
>          .eh_host_reset_handler =        storvsc_host_reset_handler,
>          .slave_alloc =          storvsc_device_alloc,
>          .slave_destroy =        storvsc_device_destroy,
> 
> Cheers,

Thanks Hannes. Based on Christoph's feedback I have implemented exactly this patch. It is under test on Azure.
I will be re-spinning and posting the patches shortly.

K. Y
> 
> Hannes
> --
> Dr. Hannes Reinecke		      zSeries & Storage
> hare@suse.de			      +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
> GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
