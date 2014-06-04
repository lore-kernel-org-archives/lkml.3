Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbaFDRPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 13:15:21 -0400
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:16883
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750717AbaFDRPS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 13:15:18 -0400
From: KY Srinivasan <kys@microsoft.com>
To: James Bottomley <jbottomley@parallels.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 1/1] [SCSI] Fix a bug in deriving the FLUSH_TIMEOUT from
 the basic I/O timeout
Thread-Topic: [PATCH 1/1] [SCSI] Fix a bug in deriving the FLUSH_TIMEOUT from
 the basic I/O timeout
Thread-Index: AQHPgAqq5L1zp+ngQ0O2dQQp+rFvKZthLVSAgAABPoA=
Date: Wed, 4 Jun 2014 17:15:15 +0000
Message-ID: <d61f4b87a72544e4b0c1e1872a76f97b@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1401899623-24194-1-git-send-email-kys@microsoft.com>
 <1401901323.17510.23.camel@dabdike>
In-Reply-To: <1401901323.17510.23.camel@dabdike>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e0:ee43::3]
x-microsoft-antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
x-forefront-prvs: 0232B30BBC
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(377454003)(13464003)(51704005)(24454002)(377424004)(199002)(189002)(86362001)(87936001)(101416001)(86612001)(76482001)(76176999)(50986999)(77982001)(54356999)(33646001)(77096999)(64706001)(80022001)(2656002)(20776003)(85852003)(81342001)(19580405001)(83322001)(19580395003)(92566001)(76576001)(83072002)(46102001)(21056001)(99396002)(74662001)(74502001)(79102001)(81542001)(74316001)(4396001)(99286001)(31966008)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB299;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kys@microsoft.com; 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: James Bottomley [mailto:jbottomley@parallels.com]
> Sent: Wednesday, June 4, 2014 10:02 AM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; apw@canonical.com;
> devel@linuxdriverproject.org; hch@infradead.org; linux-
> scsi@vger.kernel.org; ohering@suse.com; gregkh@linuxfoundation.org;
> jasowang@redhat.com
> Subject: Re: [PATCH 1/1] [SCSI] Fix a bug in deriving the FLUSH_TIMEOUT
> from the basic I/O timeout
> 
> On Wed, 2014-06-04 at 09:33 -0700, K. Y. Srinivasan wrote:
> > Commit ID: 7e660100d85af860e7ad763202fff717adcdaacd added code to
> > derive the FLUSH_TIMEOUT from the basic I/O timeout. However, this
> > patch did not use the basic I/O timeout of the device. Fix this bug.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > ---
> >  drivers/scsi/sd.c |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c index
> > e9689d5..54150b1 100644
> > --- a/drivers/scsi/sd.c
> > +++ b/drivers/scsi/sd.c
> > @@ -832,7 +832,9 @@ static int sd_setup_write_same_cmnd(struct
> > scsi_device *sdp, struct request *rq)
> >
> >  static int scsi_setup_flush_cmnd(struct scsi_device *sdp, struct
> > request *rq)  {
> > -	rq->timeout *= SD_FLUSH_TIMEOUT_MULTIPLIER;
> > +	int timeout = sdp->request_queue->rq_timeout;
> > +
> > +	rq->timeout = (timeout * SD_FLUSH_TIMEOUT_MULTIPLIER);
> 
> Could you share where you found this to be a problem?  It looks like a bug in
> block because all inbound requests being prepared should have a timeout
> set, so block would be the place to fix it.

Perhaps; what I found was that the value in rq->timeout was 0 coming into
this function and thus multiplying obviously has no effect.

> 
> I can't see how this can happen because we definitely add the timer after the
> request is prepared in my reading of the block code, unless I'm missing some
> path in block that violates this.
> 
> James

K. Y

