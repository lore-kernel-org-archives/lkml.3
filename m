Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443AbaLOTwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:52:41 -0500
Received: from mail-bn1bbn0104.outbound.protection.outlook.com ([157.56.111.104]:64798
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751156AbaLOTwj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:52:39 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 1/1] Drivers: hv: vmbus: Support a vmbus API for
 efficiently sending page arrays
Thread-Topic: [PATCH 1/1] Drivers: hv: vmbus: Support a vmbus API for
 efficiently sending page arrays
Thread-Index: AQHQGJyW6lv/ko7zRkCZwFtBiFhboZyRCuKAgAAEyEA=
Date: Mon, 15 Dec 2014 19:52:36 +0000
Message-ID: <BY2PR0301MB0711EE39793F0016994F6230A06F0@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1418675627-15213-1-git-send-email-kys@microsoft.com>
 <20141215193351.GC9842@kroah.com>
In-Reply-To: <20141215193351.GC9842@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.192.71]
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0710;
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0710;
x-forefront-prvs: 04267075BD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(13464003)(51704005)(377454003)(24454002)(97736003)(40100003)(77156002)(62966003)(31966008)(54606007)(74316001)(50986999)(2656002)(110136001)(21056001)(76576001)(87936001)(76176999)(107046002)(54356999)(4396001)(122556002)(46102003)(54206007)(120916001)(19580395003)(105586002)(19580405001)(106116001)(92566001)(86362001)(66066001)(106356001)(101416001)(68736005)(64706001)(102836002)(99396003)(86612001)(20776003)(99286002)(575784001)(33656002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0710;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Monday, December 15, 2014 11:34 AM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> olaf@aepfle.de; apw@canonical.com; jasowang@redhat.com
> Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Support a vmbus API for
> efficiently sending page arrays
> 
> On Mon, Dec 15, 2014 at 12:33:47PM -0800, K. Y. Srinivasan wrote:
> > Currently, the API for sending a multi-page buffer over VMBUS is
> > limited to a maximum pfn array of MAX_MULTIPAGE_BUFFER_COUNT.
> This
> > limitation is not imposed by the host and unnecessarily limits the
> > maximum payload that can be sent. Implement an API that does not have
> this restriction.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > ---
> >  drivers/hv/channel.c   |   44
> ++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/hyperv.h |   31 +++++++++++++++++++++++++++++++
> >  2 files changed, 75 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c index
> > c76ffbe..18c4f23 100644
> > --- a/drivers/hv/channel.c
> > +++ b/drivers/hv/channel.c
> > @@ -686,6 +686,50 @@
> EXPORT_SYMBOL_GPL(vmbus_sendpacket_pagebuffer);
> >  /*
> >   * vmbus_sendpacket_multipagebuffer - Send a multi-page buffer packet
> >   * using a GPADL Direct packet type.
> > + * The buffer includes the vmbus descriptor.
> > + */
> > +int vmbus_sendpacket_mpb_desc(struct vmbus_channel *channel,
> > +			      struct vmbus_packet_mpb_array *desc,
> > +			      u32 desc_size,
> > +			      void *buffer, u32 bufferlen, u64 requestid) {
> > +	int ret;
> > +	u32 packetlen;
> > +	u32 packetlen_aligned;
> > +	struct kvec bufferlist[3];
> > +	u64 aligned_data = 0;
> > +	bool signal = false;
> > +
> > +	packetlen = desc_size + bufferlen;
> > +	packetlen_aligned = ALIGN(packetlen, sizeof(u64));
> > +
> > +	/* Setup the descriptor */
> > +	desc->type = VM_PKT_DATA_USING_GPA_DIRECT;
> > +	desc->flags =
> VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED;
> > +	desc->dataoffset8 = desc_size >> 3; /* in 8-bytes grandularity */
> > +	desc->length8 = (u16)(packetlen_aligned >> 3);
> > +	desc->transactionid = requestid;
> > +	desc->rangecount = 1;
> > +
> > +	bufferlist[0].iov_base = desc;
> > +	bufferlist[0].iov_len = desc_size;
> > +	bufferlist[1].iov_base = buffer;
> > +	bufferlist[1].iov_len = bufferlen;
> > +	bufferlist[2].iov_base = &aligned_data;
> > +	bufferlist[2].iov_len = (packetlen_aligned - packetlen);
> > +
> > +	ret = hv_ringbuffer_write(&channel->outbound, bufferlist, 3,
> > +&signal);
> > +
> > +	if (ret == 0 && signal)
> > +		vmbus_setevent(channel);
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(vmbus_sendpacket_mpb_desc);
> > +
> > +/*
> > + * vmbus_sendpacket_multipagebuffer - Send a multi-page buffer packet
> > + * using a GPADL Direct packet type.
> >   */
> >  int vmbus_sendpacket_multipagebuffer(struct vmbus_channel *channel,
> >  				struct hv_multipage_buffer
> *multi_pagebuffer, diff --git
> > a/include/linux/hyperv.h b/include/linux/hyperv.h index
> > 08cfaff..8615b0d 100644
> > --- a/include/linux/hyperv.h
> > +++ b/include/linux/hyperv.h
> > @@ -57,6 +57,18 @@ struct hv_multipage_buffer {
> >  	u64 pfn_array[MAX_MULTIPAGE_BUFFER_COUNT];
> >  };
> >
> > +/*
> > + * Multiple-page buffer array; the pfn array is variable size:
> > + * The number of entries in the PFN array is determined by
> > + * "len" and "offset".
> > + */
> > +struct hv_mpb_array {
> > +	/* Length and Offset determines the # of pfns in the array */
> > +	u32 len;
> > +	u32 offset;
> > +	u64 pfn_array[];
> > +};
> 
> Does this cross the user/kernel boundry?  If so, they need to be __u32 and
> __u64 variables.

This does not cross user/kernel boundry. 
> 
> > +
> >  /* 0x18 includes the proprietary packet header */
> >  #define MAX_PAGE_BUFFER_PACKET		(0x18 +
> 	\
> >  					(sizeof(struct hv_page_buffer) * \
> @@ -812,6 +824,18 @@ struct
> > vmbus_channel_packet_multipage_buffer {
> >  	struct hv_multipage_buffer range;
> >  } __packed;
> >
> > +/* The format must be the same as struct vmdata_gpa_direct */ struct
> > +vmbus_packet_mpb_array {
> > +	u16 type;
> > +	u16 dataoffset8;
> > +	u16 length8;
> > +	u16 flags;
> > +	u64 transactionid;
> > +	u32 reserved;
> > +	u32 rangecount;         /* Always 1 in this case */
> > +	struct hv_mpb_array range;
> > +} __packed;
> 
> Same here.
This is completely internal to the kernel.

Regards,

K. Y
> 
> thanks,
> 
> greg k-h
