Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbaKTHsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 02:48:38 -0500
Received: from mail-bn1on0119.outbound.protection.outlook.com ([157.56.110.119]:31648
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755212AbaKTHsg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 02:48:36 -0500
From: Dexuan Cui <decui@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>,
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
Thread-Index: AQHP/ixzoWqBLlree0aJYfe1XGjx8ZxonIcQgACGI1A=
Date: Thu, 20 Nov 2014 07:47:41 +0000
Message-ID: <F792CF86EFE20D4AB8064279AFBA51C613E577E6@HKNPRD3002MB017.064d.mgd.msft.net>
References: <1415768606-28538-1-git-send-email-decui@microsoft.com>
 <BN1PR0301MB0707ED3958628389255649FCA0890@BN1PR0301MB0707.namprd03.prod.outlook.com>
In-Reply-To: <BN1PR0301MB0707ED3958628389255649FCA0890@BN1PR0301MB0707.namprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(199003)(51704005)(189002)(377454003)(13464003)(52314003)(164054003)(551934003)(26826002)(92566001)(2201001)(2656002)(69596002)(86146001)(92726001)(1511001)(64706001)(47776003)(20776003)(86362001)(66066001)(87936001)(46406003)(44976005)(217423001)(6806004)(2421001)(50466002)(33656002)(97756001)(31966008)(50986999)(54356999)(76176999)(23726002)(97736003)(68736004)(2501002)(2561002)(21056001)(16796002)(86612001)(84676001)(120916001)(55846006)(99396003)(81156004)(106466001)(106116001)(4396001)(107046002)(77096003)(62966003)(77156002)(46102003)(95666004);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB1215;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1215;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1215;
X-Forefront-PRVS: 0401647B7F
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1215;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: KY Srinivasan
> Sent: Thursday, November 20, 2014 6:59 AM
> > diff --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c index
> > 23b2ce2..177122a 100644
> > --- a/drivers/hv/hv_fcopy.c
> > +++ b/drivers/hv/hv_fcopy.c
> > @@ -86,6 +86,15 @@ static void fcopy_work_func(struct work_struct
> > *dummy)
> >   * process the pending transaction.
> >   */
> >  fcopy_respond_to_host(HV_E_FAIL);
> > +
> > +/* In the case the user-space daemon crashes, hangs or is killed, we
> > + * need to down the semaphore, otherwise, after the daemon starts
> > next
> > + * time, the obsolete data in fcopy_transaction.message or
> > + * fcopy_transaction.fcopy_msg will be used immediately.
> > + */
> > +if (down_trylock(&fcopy_transaction.read_sema))
> > +pr_debug("FCP: failed to acquire the semaphore\n");
> > +
> >  }
> 
> When the daemon is killed, we currently reset the state in the release
> function. Why can't we cleanup the semaphore state (initialize) here as well.
> 
> K. Y

Hi KY,
1) The down_trylock() here is necessary: the daemon can fail to respond in 5
seconds due to many reasons, e.g., the VM's CPU and I/O are too busy. In this
case, the daemon may become running later(NOTE: in this example, the daemon
is not killed), but from the host user's point of view, the PowerShell
copy-vmfile command has failed, so here we have to 'down' the semaphore
anyway, otherwise, the daemon can get obsolete data.

2) If we add a line
sema_init(&fcopy_transaction.read_sema, 0);
in fcopy_release(), it seems OK at a glance, but we have to handle the race
condition: the above down_trylock() and the sema_init() can, in theory, run
simultaneously on different virtual CPUs.  It's tricky to address this.

3) So I think we can reuse the same semaphore without an actually unnecessary
re-initialization. :-)

Thanks,
-- Dexuan
