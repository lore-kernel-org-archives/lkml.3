Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbaIGVlq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 17:41:46 -0400
Received: from mail-bl2on0138.outbound.protection.outlook.com ([65.55.169.138]:16384
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751911AbaIGVlp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 17:41:45 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Amos Kong <kongjianjun@gmail.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        Jason Wang <jasowang@redhat.com>
Subject: RE: [PATCH V2 1/1] Drivers: hv: vmbus: Enable interrupt driven flow
 control
Thread-Topic: [PATCH V2 1/1] Drivers: hv: vmbus: Enable interrupt driven flow
 control
Thread-Index: AQHPyWCi3C5uiwWov0udKsmfZTDDLZv1jzSAgACifQA=
Date: Sun, 7 Sep 2014 21:41:41 +0000
Message-ID: <5432c0b0e64d4aa88e1c690e8b78954b@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1409963352-2193-1-git-send-email-kys@microsoft.com>
 <CAFeW=paZ23VF6QTapGb6jR2-A_bkUYRTaOL9y_TULtASpj+2fw@mail.gmail.com>
In-Reply-To: <CAFeW=paZ23VF6QTapGb6jR2-A_bkUYRTaOL9y_TULtASpj+2fw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [50.135.110.52]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0327618309
x-forefront-antispam-report: SFV:NSPM;SFS:(10019017)(6009001)(57704003)(51704005)(377454003)(24454002)(189002)(199003)(13464003)(76482001)(79102001)(107046002)(110136001)(85306004)(81542001)(19580395003)(106356001)(54356999)(101416001)(15202345003)(83072002)(4396001)(33646002)(106116001)(15975445006)(86612001)(86362001)(99286002)(95666004)(87936001)(46102001)(21056001)(92566001)(97736003)(76576001)(105586002)(81342001)(99396002)(83322001)(1411001)(76176999)(20776003)(19580405001)(77982001)(85852003)(80022001)(66066001)(50986999)(90102001)(74502001)(74662001)(108616004)(31966008)(74316001)(2656002)(77096002)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0710;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Amos Kong [mailto:kongjianjun@gmail.com]
> Sent: Sunday, September 7, 2014 4:44 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; open list; devel@linuxdriverproject.org;
> olaf@aepfle.de; apw@canonical.com; Jason Wang
> Subject: Re: [PATCH V2 1/1] Drivers: hv: vmbus: Enable interrupt driven flow
> control
> 
> On Sat, Sep 6, 2014 at 8:29 AM, K. Y. Srinivasan <kys@microsoft.com> wrote:
> >
> > In win8 we have a feature that allows for interrupt driven flow
> > management for host/guest communication. For instance, if the host
> > were blocked because there was no space available in the ringbuffer,
> > the host could request that the guest send an interrupt when space
> > becomes available in the ringbuffer (when the guest drains the ringbuffer).
> >
> > While this feature was implemented in the guest a while ago, we had
> > not advertised that the guest supported this feature. This patch
> > advertises the support to the host.
> >
> > For pre-win8 hosts, this has no effect since the size of the
> > ringbuffer control structure has not changed and all changes have been
> > backward compatible - unused/reserved space has been used to
> implement
> > this feature.
> >
> > In this version of the patch I have cleaned up the commit log based on
> > feedback from Greg KH.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > ---
> >  drivers/hv/ring_buffer.c |    5 +++++
> >  1 files changed, 5 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c index
> > 15db66b..6361d12 100644
> > --- a/drivers/hv/ring_buffer.c
> > +++ b/drivers/hv/ring_buffer.c
> > @@ -361,6 +361,11 @@ int hv_ringbuffer_init(struct hv_ring_buffer_info
> *ring_info,
> >         ring_info->ring_buffer->read_index =
> >                 ring_info->ring_buffer->write_index = 0;
> >
> > +       /*
> > +        * Set the feature bit for enabling flow control.
> > +        */
> > +       ring_info->ring_buffer->feature_bits.value = 1;
> > +
> 
> This feature is enabled, do we need to reset  pending_send_sz and
> reserved1[12], reserved1[4028] here?
> 
> >         ring_info->ring_size = buflen;
> >         ring_info->ring_datasize = buflen - sizeof(struct
> > hv_ring_buffer);
> >

All the pages for the ring buffer have already been zeroed out including the shared control structure.
Look at vmbus_open() (drivers/hv/channel.c) where we allocate the ring buffer - we pass in the flag to
Zero out the pages.

Regards,

K. Y
> > --
> > 1.7.4.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-kernel" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
