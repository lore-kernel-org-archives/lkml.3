Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267AbaJNMvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 08:51:08 -0400
Received: from mail-bn1bbn0108.outbound.protection.outlook.com ([157.56.111.108]:23872
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932190AbaJNMvG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 08:51:06 -0400
From: Thomas Shao <huishao@microsoft.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 2/2] hyperv: Implement Time Synchronization using host
 time sample
Thread-Topic: [PATCH 2/2] hyperv: Implement Time Synchronization using host
 time sample
Thread-Index: AQHP55ZRTp/VO8CmfEuTJogFjyVUzJwvcjOAgAAW4JA=
Date: Tue, 14 Oct 2014 12:50:23 +0000
Message-ID: <CD2CABCB2C0A0D4682C5F8AD840141540BFD19@HKXPRD3002MB006.064d.mgd.msft.net>
References: <1413285078-7027-1-git-send-email-huishao@microsoft.com>
 <20141014111915.GV23154@mwanda>
In-Reply-To: <20141014111915.GV23154@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [61.173.50.55]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(24454002)(189002)(13464003)(51704005)(199003)(377454003)(77096002)(19580405001)(19580395003)(6806004)(44976005)(21056001)(16796002)(120916001)(76176999)(80022003)(46102003)(46406003)(50986999)(110136001)(2656002)(85306004)(87936001)(33656002)(55846006)(86146001)(31966008)(85852003)(4396001)(26826002)(76482002)(84676001)(68736004)(69596002)(47776003)(20776003)(64706001)(66066001)(50466002)(97736003)(86612001)(92726001)(92566001)(86362001)(23726002)(106466001)(54356999)(97756001)(99396003)(95666004)(106116001)(107046002)(81156004);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0301MB1204;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1204;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 03648EFF89
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=huishao@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Tuesday, October 14, 2014 7:19 PM
> To: Thomas Shao
> Cc: tglx@linutronix.de; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com; KY Srinivasan
> Subject: Re: [PATCH 2/2] hyperv: Implement Time Synchronization using host
> time sample
> 
> I had a couple small style nits.
> 
> On Tue, Oct 14, 2014 at 04:11:18AM -0700, Thomas Shao wrote:
> > diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c index
> > 3b9c9ef..1d8390c 100644
> > --- a/drivers/hv/hv_util.c
> > +++ b/drivers/hv/hv_util.c
> > @@ -51,11 +51,30 @@
> >  #define HB_WS2008_MAJOR	1
> >  #define HB_WS2008_VERSION	(HB_WS2008_MAJOR << 16 |
> HB_MINOR)
> >
> > +#define  TIMESAMPLE_INTERVAL 5000000000L  /* 5s in nanosecond */
> 
> If you wanted you could say:
> 
> #define  TIMESAMPLE_INTERVAL  (5 * NSEC_PER_SEC)
> 
> > +
> > +/*host sends time sample for every 5s.So the max polling interval
> > +*is 128*5 = 640s.
> > +*/
> 
> The comment still has problems throughout.  Read
> Documentation/CodingStyle.
> 

I will correct the style of the comment.

> > +#define  TIME_ADJ_MAX_INTERVAL 128 /*Max polling interval */
> > +
> >  static int sd_srv_version;
> >  static int ts_srv_version;
> >  static int hb_srv_version;
> >  static int util_fw_version;
> >
> > +/*host sends time sample for every 5s.So the initial polling interval
> > +*is 5s.
> > +*/
> > +static s32 adj_interval = 1;
> 
> Prefer mundane types instead there is a reason.  This should be int because
> it's not specified in a hardware spec.  I know you are being consistent with
> the surrounding code, but the surrounding code is bad so don't emulate it.
> 
I agree with you. Maybe it's a good idea to correct the surrounding code in 
another patch.

> > +
> > +/*The host_time_sync module parameter is used to control the time
> > +  sync between host and guest.
> > +*/
> > +static bool host_time_sync;
> > +module_param(host_time_sync, bool, (S_IRUGO | S_IWUSR));
> > +MODULE_PARM_DESC(host_time_sync, "If the guest sync time with
> host");
> 
> Maybe say: "Synchronize time with the host"?

Sounds good.

> 
> > +
> >  static void shutdown_onchannelcallback(void *context);  static struct
> > hv_util_service util_shutdown = {
> >  	.util_cb = shutdown_onchannelcallback, @@ -163,15 +182,61 @@
> static
> > void shutdown_onchannelcallback(void *context)
> >  /*
> >   * Set guest time to host UTC time.
> >   */
> > -static inline void do_adj_guesttime(u64 hosttime)
> > +static inline void do_adj_guesttime(u64 hosttime, bool forceSync)
> 
> I'm surprise checkpatch.pl does't complain about this CamelCase.

I've run the scripts/checkpatch.pl, it didn't complain anything. I'll change to forcesync.

> 
> regards,
> dan carpenter

