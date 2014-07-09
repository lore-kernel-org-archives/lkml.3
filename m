Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610AbaGISfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 14:35:52 -0400
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:43120
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756016AbaGISfu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 14:35:50 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 8/8] drivers: scsi: storvsc: Correctly handle
 TEST_UNIT_READY failure
Thread-Topic: [PATCH 8/8] drivers: scsi: storvsc: Correctly handle
 TEST_UNIT_READY failure
Thread-Index: AQHPmwbbLP1k3YziP06O7vS4mu3TlZuXbpEAgACjy7A=
Date: Wed, 9 Jul 2014 18:35:47 +0000
Message-ID: <67b90e6c79674f27979f42277dbb62e5@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-8-git-send-email-kys@microsoft.com>
 <20140709084644.GH6012@infradead.org>
In-Reply-To: <20140709084644.GH6012@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.135.110.52]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 0267E514F9
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(199002)(189002)(51704005)(13464003)(24454002)(377454003)(19580405001)(64706001)(106356001)(2656002)(74316001)(54356999)(81342001)(19580395003)(74662001)(105586002)(83322001)(76576001)(31966008)(76482001)(99396002)(92566001)(95666004)(50986999)(86612001)(79102001)(99286002)(80022001)(106116001)(83072002)(66066001)(46102001)(21056001)(74502001)(77982001)(101416001)(33646001)(20776003)(81542001)(76176999)(4396001)(85852003)(107046002)(110136001)(93886003)(87936001)(86362001)(85306003)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB298;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Wednesday, July 9, 2014 1:47 AM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> ohering@suse.com; jbottomley@parallels.com; jasowang@redhat.com;
> apw@canonical.com; linux-scsi@vger.kernel.org; stable@vger.kernel.org
> Subject: Re: [PATCH 8/8] drivers: scsi: storvsc: Correctly handle
> TEST_UNIT_READY failure
> 
> On Tue, Jul 08, 2014 at 05:46:52PM -0700, K. Y. Srinivasan wrote:
> > --- a/drivers/scsi/storvsc_drv.c
> > +++ b/drivers/scsi/storvsc_drv.c
> > @@ -1023,6 +1023,13 @@ static void storvsc_handle_error(struct
> vmscsi_request *vm_srb,
> >  		case ATA_12:
> >  			set_host_byte(scmnd, DID_PASSTHROUGH);
> >  			break;
> > +		/*
> > +		 * On Some Windows hosts TEST_UNIT_READY command can
> return
> > +		 * SRB_STATUS_ERROR, let the upper level code deal with it
> > +		 * based on the sense information.
> > +		 */
> > +		case TEST_UNIT_READY:
> > +			break;
> 
> Don't we need to set an error in the command for the error handler to take
> action?  Or is this propagated elsewhere?

The host sets the appropriate scsi response and sense information that allows the upper-level scsi stack to appropriately recover. We are just making sure that we won't mark the target as failed which is what would happen in the absence of this patch since the host has set a very generic SRB error code that indicates failure.

Regards,

K. Y

