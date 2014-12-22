Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbaLVCJm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 21:09:42 -0500
Received: from mail-by2on0113.outbound.protection.outlook.com ([207.46.100.113]:52352
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751127AbaLVCJk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 21:09:40 -0500
From: Dudley Du <dudl@cypress.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jeremiah Mahler <jmmahler@gmail.com>,
        "rydberg@euromail.se" <rydberg@euromail.se>,
        "bleung@google.com" <bleung@google.com>, David Solda <dso@cypress.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v16 00/12] input: cyapa: instruction of cyapa patches
Thread-Topic: [PATCH v16 00/12] input: cyapa: instruction of cyapa patches
Thread-Index: AQHQGqmcizaS/V/Z90+9ZdsIRkHnfZyYFCmAgAAEkQCAAsHi8A==
Date: Mon, 22 Dec 2014 02:09:36 +0000
Message-ID: <BN1PR06MB0701C428956C2E7F7A1DD76D1560@BN1PR06MB070.namprd06.prod.outlook.com>
References: <1418896856-15766-1-git-send-email-dudl@cypress.com>
 <20141220071533.GA1139@newt.localdomain> <20141220073154.GB4637@dtor-ws>
In-Reply-To: <20141220073154.GB4637@dtor-ws>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.95.211.187]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=dudl@cypress.com; 
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0601MB1081;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0601MB1081;
x-forefront-prvs: 0433DB2766
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(164054003)(189002)(24454002)(51164003)(51704005)(76176999)(76576001)(106356001)(46102003)(105586002)(99286002)(107046002)(107886001)(19580395003)(19580405001)(54206007)(74316001)(66066001)(64706001)(20776003)(62966003)(54356999)(86362001)(50986999)(77156002)(92566001)(68736005)(33656002)(2950100001)(2656002)(54606007)(87936001)(2900100001)(31966008)(120916001)(4396001)(97736003)(99396003)(2501002)(106116001)(101416001)(21056001)(102836002)(40100003)(2201001)(122556002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0601MB1081;H:BN1PR06MB070.namprd06.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Dec 2014 02:09:36.7851
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR0601MB1081
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Dmitry and Jeremiah,

I reproduced this issue in my side when putting fingers on trackpad when system booting up.
It only happened on gen3 trackpad device.
The root cause is, for gen3 TP, the cyapa->ops->sort_empty_output_data is not set, so when cyapa->input is not set,
the interrupt process should be passed, but since the logica error, it's not, so this issue happen.

The fix code should be as below.
I will correct it and resubmited the patches.

Code to fix this issue.
@@ -585,9 +585,10 @@ static irqreturn_t cyapa_irq(int irq, void *dev_id)
        /* Interrupt event maybe from trackpad device input reporting. */
        if (cont && cyapa->ops->irq_handler) {
                /* Still in probling or in firware image udpating or reading. */
-               if (!cyapa->input && cyapa->ops->sort_empty_output_data) {
-                       cyapa->ops->sort_empty_output_data(cyapa,
-                               NULL, NULL, NULL);
+               if (!cyapa->input) {
+                       if (cyapa->ops->sort_empty_output_data)
+                               cyapa->ops->sort_empty_output_data(cyapa,
+                                       NULL, NULL, NULL);
                        goto out;
                }

Thanks,
Dudley


> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: 2014?12?20? 15:32
> To: Jeremiah Mahler; Dudley Du; rydberg@euromail.se; bleung@google.com;
> David Solda; linux-input@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v16 00/12] input: cyapa: instruction of cyapa patches
>
> On Fri, Dec 19, 2014 at 11:15:33PM -0800, Jeremiah Mahler wrote:
> > Dudley,
> >
> > On Thu, Dec 18, 2014 at 06:00:44PM +0800, Dudley Du wrote:
> > > V16 patches have below updates, details of other updates see history list:
> > [...]
> >
> > This version has problems.  I am getting an oops (below) and then things
> > quit working and usually my machine hangs.
> >
> > [    2.388284] input: HDA Intel PCH Headphone as
> /devices/pci0000:00/0000:00:1b.0/sound/card1/input10
> > [    2.412938] FS-Cache: Netfs 'nfs' registered for caching
> > [    2.427645] [drm] Initialized i915 1.6.0 20141121 for 0000:00:02.0 on minor 0
> > [    2.428320] __add_probed_i2c_device failed to register device 1-4a
> > [    2.428331] platform chromeos_laptop: Driver chromeos_laptop requests
> probe deferral
> > [    2.429126] fbcon: inteldrmfb (fb0) is primary device
> > [    2.449066] BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000160
> > [    2.449073] IP: [<ffffffff813f7b2b>] input_mt_sync_frame+0xb/0x60
>
> Sounds like we got an interrupts before we had a chance to initialize
> input device...
>
> Thanks.
>
> --
> Dmitry

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
