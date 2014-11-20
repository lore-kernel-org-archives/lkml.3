Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836AbaKTR6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 12:58:25 -0500
Received: from mail-by2on0133.outbound.protection.outlook.com ([207.46.100.133]:47072
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756023AbaKTR6Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 12:58:24 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Dexuan Cui <decui@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
CC: Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH] hv: hv_fcopy: drop the obsolete message on transfer
 failure
Thread-Topic: [PATCH] hv: hv_fcopy: drop the obsolete message on transfer
 failure
Thread-Index: AQHP/ixzoWqBLlree0aJYfe1XGjx8ZxonIcQgACGI1CAALBG0A==
Date: Thu, 20 Nov 2014 17:58:22 +0000
Message-ID: <6b6a1089b0104b3fb9c2e785d058cd1d@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1415768606-28538-1-git-send-email-decui@microsoft.com>
 <BN1PR0301MB0707ED3958628389255649FCA0890@BN1PR0301MB0707.namprd03.prod.outlook.com>
 <F792CF86EFE20D4AB8064279AFBA51C613E577E6@HKNPRD3002MB017.064d.mgd.msft.net>
In-Reply-To: <F792CF86EFE20D4AB8064279AFBA51C613E577E6@HKNPRD3002MB017.064d.mgd.msft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2601:8:9b00:fd:3cf0:919c:163c:e95a]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0712;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0712;
x-forefront-prvs: 0401647B7F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(377454003)(13464003)(52314003)(199003)(164054003)(51704005)(31966008)(19580395003)(87936001)(217423001)(19580405001)(2656002)(76176999)(54356999)(50986999)(33646002)(2421001)(551934003)(101416001)(106116001)(106356001)(105586002)(99286002)(95666004)(107046002)(99396003)(122556002)(120916001)(40100003)(77096003)(77156002)(62966003)(76576001)(46102003)(2501002)(92566001)(2201001)(108616004)(74316001)(4396001)(2561002)(97736003)(86362001)(86612001)(20776003)(1511001)(21056001)(64706001)(24736002)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0712;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dexuan Cui
> Sent: Wednesday, November 19, 2014 11:48 PM
> To: KY Srinivasan; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; driverdev-devel@linuxdriverproject.org;
> olaf@aepfle.de; apw@canonical.com; jasowang@redhat.com
> Cc: Haiyang Zhang
> Subject: RE: [PATCH] hv: hv_fcopy: drop the obsolete message on transfer
> failure
> 
> > -----Original Message-----
> > From: KY Srinivasan
> > Sent: Thursday, November 20, 2014 6:59 AM
> > > diff --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c index
> > > 23b2ce2..177122a 100644
> > > --- a/drivers/hv/hv_fcopy.c
> > > +++ b/drivers/hv/hv_fcopy.c
> > > @@ -86,6 +86,15 @@ static void fcopy_work_func(struct work_struct
> > > *dummy)
> > >   * process the pending transaction.
> > >   */
> > >  fcopy_respond_to_host(HV_E_FAIL);
> > > +
> > > +/* In the case the user-space daemon crashes, hangs or is killed,
> > > +we
> > > + * need to down the semaphore, otherwise, after the daemon starts
> > > next
> > > + * time, the obsolete data in fcopy_transaction.message or
> > > + * fcopy_transaction.fcopy_msg will be used immediately.
> > > + */
> > > +if (down_trylock(&fcopy_transaction.read_sema))
> > > +pr_debug("FCP: failed to acquire the semaphore\n");
> > > +
> > >  }
> >
> > When the daemon is killed, we currently reset the state in the release
> > function. Why can't we cleanup the semaphore state (initialize) here as
> well.
> >
> > K. Y
> 
> Hi KY,
> 1) The down_trylock() here is necessary: the daemon can fail to respond in 5
> seconds due to many reasons, e.g., the VM's CPU and I/O are too busy. In
> this case, the daemon may become running later(NOTE: in this example, the
> daemon is not killed), but from the host user's point of view, the PowerShell
> copy-vmfile command has failed, so here we have to 'down' the semaphore
> anyway, otherwise, the daemon can get obsolete data.
> 
> 2) If we add a line
> sema_init(&fcopy_transaction.read_sema, 0); in fcopy_release(), it seems
> OK at a glance, but we have to handle the race
> condition: the above down_trylock() and the sema_init() can, in theory, run
> simultaneously on different virtual CPUs.  It's tricky to address this.
> 
> 3) So I think we can reuse the same semaphore without an actually
> unnecessary re-initialization. :-)

Agreed; you may want to get rid of the pr_debug() call though.

Thanks,

K. Y
> 
> Thanks,
> -- Dexuan

