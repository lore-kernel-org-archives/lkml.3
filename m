Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396AbaGaKMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 06:12:24 -0400
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:43543
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750969AbaGaKMW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 06:12:22 -0400
From: Dexuan Cui <decui@microsoft.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH v3] video: hyperv: hyperv_fb: refresh the VM screen by
 force on VM panic
Thread-Topic: [PATCH v3] video: hyperv: hyperv_fb: refresh the VM screen by
 force on VM panic
Thread-Index: AQHPrAHsLR3FR7YCb0qbISFqmZOZ7pu58uTA
Date: Thu, 31 Jul 2014 10:11:41 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C98F6F78@SINEX14MBXC417.southpacific.corp.microsoft.com>
References: <1404875063-27424-1-git-send-email-decui@microsoft.com>
 <53D90008.4060908@ti.com>
In-Reply-To: <53D90008.4060908@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.92]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(51704005)(199002)(13464003)(377454003)(164054003)(189002)(77982001)(4396001)(81156004)(46102001)(106466001)(47776003)(87936001)(20776003)(77096002)(6806004)(80022001)(76482001)(46406003)(83322001)(81542001)(19580405001)(31966008)(23726002)(68736004)(81342001)(85806002)(97736001)(55846006)(19580395003)(106116001)(95666004)(21056001)(16796002)(2656002)(97756001)(86612001)(74662001)(33656002)(54356999)(84676001)(92566001)(99396002)(50466002)(64706001)(74502001)(79102001)(85306003)(69596002)(110136001)(26826002)(76176999)(86362001)(50986999)(83072002)(107046002)(44976005)(92726001)(85852003);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB248;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0289B6431E
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Tomi Valkeinen [mailto:tomi.valkeinen@ti.com]
> Sent: Wednesday, July 30, 2014 22:24 PM
> > +static struct fb_info *hvfb_info;
> 
> Static variables like these are usually a no-no. This prevents you from
> having multiple device instances.
I agree.

> >  static uint screen_width = HVFB_WIDTH;
> >  static uint screen_height = HVFB_HEIGHT;
> >  static uint screen_depth;
> >  static uint screen_fb_size;
> >
> > +/* If true, the VSC notifies the VSP on every framebuffer change */
> > +static bool synchronous_fb;
> > +
> 
> Same comment here.
> 
> However, if (and only if) the driver is already designed to work only
> with single device instance, then this patch is probably ok. But even
IMO the host should only provide at most 1 synthetic video device to a VM. :-)

> then, I'd prefer this to be handled without static variables so that the
> driver could eventually be changed to support multiple device instances.

Hi Tomi,
Maybe we can remove these static stuff:
+static struct fb_info *hvfb_info;
+static struct notifier_block hvfb_panic_nb = {
+	.notifier_call = hvfb_on_panic,
+};
by kmalloc()-ing  a new struct:
struct hv_fb_panic_nb {
        struct fb_info *hvfb_info;
        struct notifier_block nb;
}
?
I think in hvfb_on_panic() we should be able to get the
hvfb_info pointer by
hvfb_info = container_of(nb, struct hv_fb_panic_nb, nb).

If you like that or have a better idea, please let me know so
I can make a new patch.

Thanks,
-- Dexuan
