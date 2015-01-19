Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642AbbASCB3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 21:01:29 -0500
Received: from mail-bl2on0125.outbound.protection.outlook.com ([65.55.169.125]:52224
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751179AbbASCB1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 21:01:27 -0500
From: Dudley Du <dudl@cypress.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "jmmahler@gmail.com" <jmmahler@gmail.com>,
        "rydberg@euromail.se" <rydberg@euromail.se>,
        "bleung@google.com" <bleung@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v18 01/12] input: cyapa: re-design driver to support
 multi-trackpad in one driver
Thread-Topic: [PATCH v18 01/12] input: cyapa: re-design driver to support
 multi-trackpad in one driver
Thread-Index: AQHQMVaQgakEruBMtkWj3GZ4z0PFxJzFjm0AgAEhrxA=
Date: Mon, 19 Jan 2015 01:45:48 +0000
Message-ID: <BN1PR06MB070D0832A48930BFA25C040D14A0@BN1PR06MB070.namprd06.prod.outlook.com>
References: <1421390055-32760-1-git-send-email-dudl@cypress.com>
 <1421390055-32760-2-git-send-email-dudl@cypress.com>
 <20150118082710.GC15720@dtor-ws>
In-Reply-To: <20150118082710.GC15720@dtor-ws>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [140.207.206.26]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=dudl@cypress.com; 
x-dmarcaction-test: None
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BN1PR06MB071;UriScan:;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR06MB071;
x-forefront-prvs: 046164D5C4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(13464003)(51704005)(189002)(199003)(24454002)(51164003)(2900100001)(76576001)(54206007)(87936001)(110136001)(77156002)(62966003)(33656002)(64706001)(2656002)(2950100001)(46102003)(122556002)(40100003)(68736005)(66066001)(102836002)(99286002)(101416001)(86362001)(97736003)(74316001)(106116001)(54356999)(105586002)(76176999)(54606007)(92566002)(19580395003)(106356001)(19580405001)(50986999);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR06MB071;H:BN1PR06MB070.namprd06.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2015 01:45:48.1318
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR06MB071
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR06MB856;
X-OriginatorOrg: cypress.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: 2015?1?18? 16:27
> To: Dudley Du
> Cc: jmmahler@gmail.com; rydberg@euromail.se; bleung@google.com;
> linux-input@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v18 01/12] input: cyapa: re-design driver to support
> multi-trackpad in one driver
>
> Hi Dudley,
>
> On Fri, Jan 16, 2015 at 02:34:04PM +0800, Dudley Du wrote:
> > In order to support multiple different chipsets and communication protocols
> > trackpad devices in one cyapa driver, the new cyapa driver is re-designed
> > with one cyapa driver core and multiple device specific functions component.
> > The cyapa driver core is contained in this patch, it supplies basic functions
> > that working with kernel and input subsystem, and also supplies the interfaces
> > that the specific devices' component can connect and work together with as
> > one driver.
> > TEST=test on Chromebooks.
> >
> > Signed-off-by: Dudley Du <dudl@cypress.com>
> > ---
> >  drivers/input/mouse/Kconfig      |   10 -
> >  drivers/input/mouse/Makefile     |    3 +-
> >  drivers/input/mouse/cyapa.c      | 1076 +++++++++++++++-----------------------
> >  drivers/input/mouse/cyapa.h      |  296 +++++++++++
> >  drivers/input/mouse/cyapa_gen3.c |  807 ++++++++++++++++++++++++++++
> >  5 files changed, 1516 insertions(+), 676 deletions(-)
> >  create mode 100644 drivers/input/mouse/cyapa.h
> >  create mode 100644 drivers/input/mouse/cyapa_gen3.c
> >
> > diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
> > index 2541bfa..d8b46b0 100644
> > --- a/drivers/input/mouse/Kconfig
> > +++ b/drivers/input/mouse/Kconfig
> > @@ -146,16 +146,6 @@ config MOUSE_PS2_OLPC
> >
> >    If unsure, say N.
> >
> > -config MOUSE_PS2_FOCALTECH
> > -bool "FocalTech PS/2 mouse protocol extension" if EXPERT
> > -default y
> > -depends on MOUSE_PS2
> > -help
> > -  Say Y here if you have a FocalTech PS/2 TouchPad connected to
> > -  your system.
> > -
> > -  If unsure, say Y.
> > -
>
> Hmm, I wonder why you do not like Focaltech ;) I fixed it up locally, no
> need to resubmit.

Sorry, it should be my mistook to do the merge.
I don't want to remove the Focaltech.
I will correct it locally.

>
> Thanks.
>
> --
> Dmitry

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
