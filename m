Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494AbaJNOEs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 10:04:48 -0400
Received: from mail-by2on0141.outbound.protection.outlook.com ([207.46.100.141]:53564
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932478AbaJNOEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 10:04:46 -0400
From: Thomas Shao <huishao@microsoft.com>
To: Mike Surcouf <mps.surcouf.lkml@gmail.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
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
Thread-Index: AQHP55ZRTp/VO8CmfEuTJogFjyVUzJwvcjOAgAAW4JCAAAnnAIAABQMw
Date: Tue, 14 Oct 2014 14:00:38 +0000
Message-ID: <CD2CABCB2C0A0D4682C5F8AD840141540BFE97@HKXPRD3002MB006.064d.mgd.msft.net>
References: <1413285078-7027-1-git-send-email-huishao@microsoft.com>
	<20141014111915.GV23154@mwanda>
	<CD2CABCB2C0A0D4682C5F8AD840141540BFD19@HKXPRD3002MB006.064d.mgd.msft.net>
 <CAL7Bo8ESE-=FY0KyQDc2Ne1SfX=fF0Q088jo_j-JpMmQYvArGg@mail.gmail.com>
In-Reply-To: <CAL7Bo8ESE-=FY0KyQDc2Ne1SfX=fF0Q088jo_j-JpMmQYvArGg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [61.173.50.55]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(24454002)(13464003)(189002)(51704005)(199003)(377454003)(33656002)(110136001)(87936001)(2656002)(15975445006)(97736003)(46102003)(66066001)(80022003)(86146001)(21056001)(50466002)(77096002)(81156004)(4396001)(86362001)(23676002)(64706001)(84676001)(47776003)(50986999)(76176999)(26826002)(15202345003)(68736004)(69596002)(85306004)(93886004)(19580405001)(107046002)(55846006)(54356999)(20776003)(19580395003)(44976005)(86612001)(106116001)(106466001)(99396003)(95666004)(92566001)(31966008)(16796002)(85852003)(76482002)(120916001)(6806004)(92726001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0693;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0693;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 03648EFF89
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=huishao@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9EE4sbo025290


> -----Original Message-----
> From: Mike Surcouf [mailto:mps.surcouf.lkml@gmail.com]
> Sent: Tuesday, October 14, 2014 9:17 PM
> To: Thomas Shao
> Cc: Dan Carpenter; tglx@linutronix.de; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com; KY Srinivasan
> Subject: Re: [PATCH 2/2] hyperv: Implement Time Synchronization using host
> time sample
> 
> What is your expected value for TICK_USEC?  I cant make the arithmetic work.

The value for TICK_USEC is defined as ((1000000UL + USER_HZ/2) / USER_HZ). 
 In my box, it's 10000.

> You double the check time if you are close but you never reduce the check
> time if you are not.
> Adjusting the tick count is a coarse adjustment of the clock.  You will end up
> chasing the host time but never stabilizing it.
> 

The double polling schedule is just for the initial state. For example the VM just 
get booted. So I didn't set the polling schedule back, once it is in stable state. 

> Regarding the comment we have NTP for this I agree that would be better
> than this implementation and I think Thomas agrees (as he said NTP is the
> preferred option) In order for this to be a good source of time for RTP and
> other time sensitive stuff . you will have to have to re-implement parts of
> NTP such as adjusting the clock frequency decreasing the check period when
> error becomes too great etc. etc..
> 

I don't think decreasing the check period will help a lot. And sometimes, if the check
period is too short, it might cause the time sync component to adjust time too frequently.

> I still think there is a requirement for this if it is done more comprehensively.
> For example depending on CPU loading some Hyperv guests can give a drift
> of greater than 500ppm which NTP cant cope with.
> 
> 
> On Tue, Oct 14, 2014 at 1:50 PM, Thomas Shao <huishao@microsoft.com>
> wrote:
> >
> >> -----Original Message-----
> >> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> >> Sent: Tuesday, October 14, 2014 7:19 PM
> >> To: Thomas Shao
> >> Cc: tglx@linutronix.de; gregkh@linuxfoundation.org; linux-
> >> kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> >> apw@canonical.com; jasowang@redhat.com; KY Srinivasan
> >> Subject: Re: [PATCH 2/2] hyperv: Implement Time Synchronization using
> >> host time sample
> >>
> >> I had a couple small style nits.
> >>
> >> On Tue, Oct 14, 2014 at 04:11:18AM -0700, Thomas Shao wrote:
> >> > diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c index
> >> > 3b9c9ef..1d8390c 100644
> >> > --- a/drivers/hv/hv_util.c
> >> > +++ b/drivers/hv/hv_util.c
> >> > @@ -51,11 +51,30 @@
> >> >  #define HB_WS2008_MAJOR    1
> >> >  #define HB_WS2008_VERSION  (HB_WS2008_MAJOR << 16 |
> >> HB_MINOR)
> >> >
> >> > +#define  TIMESAMPLE_INTERVAL 5000000000L  /* 5s in nanosecond */
> >>
> >> If you wanted you could say:
> >>
> >> #define  TIMESAMPLE_INTERVAL  (5 * NSEC_PER_SEC)
> >>
> >> > +
> >> > +/*host sends time sample for every 5s.So the max polling interval
> >> > +*is 128*5 = 640s.
> >> > +*/
> >>
> >> The comment still has problems throughout.  Read
> >> Documentation/CodingStyle.
> >>
> >
> > I will correct the style of the comment.
> >
> >> > +#define  TIME_ADJ_MAX_INTERVAL 128 /*Max polling interval */
> >> > +
> >> >  static int sd_srv_version;
> >> >  static int ts_srv_version;
> >> >  static int hb_srv_version;
> >> >  static int util_fw_version;
> >> >
> >> > +/*host sends time sample for every 5s.So the initial polling
> >> > +interval *is 5s.
> >> > +*/
> >> > +static s32 adj_interval = 1;
> >>
> >> Prefer mundane types instead there is a reason.  This should be int
> >> because it's not specified in a hardware spec.  I know you are being
> >> consistent with the surrounding code, but the surrounding code is bad so
> don't emulate it.
> >>
> > I agree with you. Maybe it's a good idea to correct the surrounding
> > code in another patch.
> >
> >> > +
> >> > +/*The host_time_sync module parameter is used to control the time
> >> > +  sync between host and guest.
> >> > +*/
> >> > +static bool host_time_sync;
> >> > +module_param(host_time_sync, bool, (S_IRUGO | S_IWUSR));
> >> > +MODULE_PARM_DESC(host_time_sync, "If the guest sync time with
> >> host");
> >>
> >> Maybe say: "Synchronize time with the host"?
> >
> > Sounds good.
> >
> >>
> >> > +
> >> >  static void shutdown_onchannelcallback(void *context);  static
> >> > struct hv_util_service util_shutdown = {
> >> >     .util_cb = shutdown_onchannelcallback, @@ -163,15 +182,61 @@
> >> static
> >> > void shutdown_onchannelcallback(void *context)
> >> >  /*
> >> >   * Set guest time to host UTC time.
> >> >   */
> >> > -static inline void do_adj_guesttime(u64 hosttime)
> >> > +static inline void do_adj_guesttime(u64 hosttime, bool forceSync)
> >>
> >> I'm surprise checkpatch.pl does't complain about this CamelCase.
> >
> > I've run the scripts/checkpatch.pl, it didn't complain anything. I'll change to
> forcesync.
> >
> >>
> >> regards,
> >> dan carpenter
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-kernel" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
