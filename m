Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498AbaLOHA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 02:00:57 -0500
Received: from mail-bn1on0139.outbound.protection.outlook.com ([157.56.110.139]:60496
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750943AbaLOHAy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 02:00:54 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Jeremiah Mahler <jmmahler@gmail.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "mcb30@ipxe.org" <mcb30@ipxe.org>
Subject: RE: [PATCH V3 1/1] Drivers: hv: vmbus: Fix a bug in
 vmbus_establish_gpadl()
Thread-Topic: [PATCH V3 1/1] Drivers: hv: vmbus: Fix a bug in
 vmbus_establish_gpadl()
Thread-Index: AQHQFNXP7cQ2Cgh5A0G3eqF7RTGUppyJpY2AgAaYN8A=
Date: Mon, 15 Dec 2014 07:00:45 +0000
Message-ID: <BY2PR0301MB0711EC29782DB872564AB81AA06F0@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1418260380-8774-1-git-send-email-kys@microsoft.com>
 <20141211021019.GA5648@hudson.localdomain>
In-Reply-To: <20141211021019.GA5648@hudson.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2601:8:9b00:fd:68f6:1cd1:daba:8313]
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dkim=none (message not signed) header.d=none;
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0711;UriScan:;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0711;
x-forefront-prvs: 04267075BD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(377454003)(13464003)(199003)(189002)(24454002)(51704005)(77156002)(106116001)(105586002)(54606007)(102836002)(15975445007)(31966008)(120916001)(2656002)(74316001)(87936001)(86612001)(122556002)(33656002)(62966003)(101416001)(110136001)(54206007)(19580405001)(1411001)(21056001)(76576001)(99396003)(40100003)(86362001)(106356001)(92566001)(97736003)(107046002)(76176999)(54356999)(68736005)(4396001)(50986999)(64706001)(46102003)(99286002)(19580395003)(20776003)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0711;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0712;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jeremiah Mahler [mailto:jmmahler@gmail.com]
> Sent: Wednesday, December 10, 2014 6:10 PM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; mcb30@ipxe.org
> Subject: Re: [PATCH V3 1/1] Drivers: hv: vmbus: Fix a bug in
> vmbus_establish_gpadl()
> 
> K. Y. Srinivasan,
> 
> On Wed, Dec 10, 2014 at 05:13:00PM -0800, K. Y. Srinivasan wrote:
> > Correctly compute the local (gpadl) handle.
> 
> This description is still too sparse for me.  How was it computed before and
> why was this incorrect?  Pretend like you are trying to explain your patch to
> someone who has no idea what you did.
> 
> > I would like to thank Michael Brown <mcb30@ipxe.org> for seeing this bug.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Reported-by: Michael Brown <mcb30@ipxe.org>
> > ---
> > Changes in V2: Added the Reported-by tag.
> > Changes in V3: Cleaned up the commit log.
> >
> >  drivers/hv/channel.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c index
> > 433f72a..c76ffbe 100644
> > --- a/drivers/hv/channel.c
> > +++ b/drivers/hv/channel.c
> > @@ -366,8 +366,8 @@ int vmbus_establish_gpadl(struct vmbus_channel
> *channel, void *kbuffer,
> >  	unsigned long flags;
> >  	int ret = 0;
> >
> > -	next_gpadl_handle =
> atomic_read(&vmbus_connection.next_gpadl_handle);
> > -	atomic_inc(&vmbus_connection.next_gpadl_handle);
> > +	next_gpadl_handle =
> > +
> 	(atomic_inc_return(&vmbus_connection.next_gpadl_handle) - 1);
> >
> Tell me if I understand this correctly.
> 
> Before it read the handle and incremented it.
> 
>   y = x + 1
> 
> Now it reads the handle, increments it, then decrements it.
> 
>   y = (x + 1) - 1 = x

This code can be executed concurrently on multiple CPUs. We want to ensure that each call to
establish gpadl gets a unique local handle. The earlier code was buggy in that we would read the
handle and then atomically increment it. Thus, multiple CPUs could read the identical current
value which would be their local handle. What we want is the ability to atomically read and increment
the value - this would ensure that each caller got a unique value even if they executed the code
concurrently on multiple CPUs. The API atomic_inc_return(), atomically increments and returns the
incremented value. We locally decrement this value to emulate the logic of "read the current value and
atomically increment the value.

Hope this helps,

K. Y
> 
> >  	ret = create_gpadl_header(kbuffer, size, &msginfo, &msgcount);
> >  	if (ret)
> > --
> > 1.7.4.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-kernel" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> --
> - Jeremiah Mahler
