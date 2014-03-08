Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbaCHK2E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 05:28:04 -0500
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:30264
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750961AbaCHK16 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 05:27:58 -0500
From: KY Srinivasan <kys@microsoft.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH V2 1/6] Drivers: net: hyperv: Enable scatter gather I/O
Thread-Topic: [PATCH V2 1/6] Drivers: net: hyperv: Enable scatter gather I/O
Thread-Index: AQHPOb9ZPe/NC2ri2EabJEzpTsS2OprWKk0AgABnMWCAACyeAIAAPXEw
Date: Sat, 8 Mar 2014 10:27:54 +0000
Message-ID: <c72c0d17b4bd405cb218ab09b1c2e77e@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1394170361-1043-1-git-send-email-kys@microsoft.com>
	<20140307.164756.1488071770631289333.davem@davemloft.net>
	<fd6bb08bd9a447aa9c0da3b584ea9bb8@BY2PR03MB299.namprd03.prod.outlook.com>
 <20140308.013658.918013334851017662.davem@davemloft.net>
In-Reply-To: <20140308.013658.918013334851017662.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [117.192.118.125]
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(13464003)(51704005)(199002)(189002)(377454003)(59766001)(65816001)(87266001)(79102001)(86362001)(74876001)(74502001)(74662001)(47446002)(95416001)(47976001)(85306002)(97186001)(97336001)(80022001)(94946001)(76786001)(46102001)(33646001)(93516002)(50986001)(19580405001)(66066001)(81816001)(76576001)(86612001)(85852003)(63696002)(19580395003)(74316001)(69226001)(80976001)(47736001)(49866001)(81686001)(87936001)(51856001)(2656002)(76796001)(94316002)(93136001)(81342001)(95666003)(83322001)(56776001)(81542001)(54356001)(54316002)(83072002)(76482001)(90146001)(4396001)(53806001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB595;H:BY2PR03MB299.namprd03.prod.outlook.com;CLIP:117.192.118.125;FPR:BCDDF206.80F6B9EA.94F3735F.1EAD9A03.20356;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Saturday, March 8, 2014 12:07 PM
> To: KY Srinivasan
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com
> Subject: Re: [PATCH V2 1/6] Drivers: net: hyperv: Enable scatter gather I/O
> 
> From: KY Srinivasan <kys@microsoft.com>
> Date: Sat, 8 Mar 2014 04:12:01 +0000
> 
> >
> >
> >> -----Original Message-----
> >> From: David Miller [mailto:davem@davemloft.net]
> >> Sent: Saturday, March 8, 2014 3:18 AM
> >> To: KY Srinivasan
> >> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> >> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> >> jasowang@redhat.com
> >> Subject: Re: [PATCH V2 1/6] Drivers: net: hyperv: Enable scatter
> >> gather I/O
> >>
> >> From: "K. Y. Srinivasan" <kys@microsoft.com>
> >> Date: Thu,  6 Mar 2014 21:32:36 -0800
> >>
> >> > +static u32 fill_pg_buf(struct page *page, u32 offset, u32 len,
> >> > +			struct hv_page_buffer *pb)
> >> > +{
> >> > +	int j = 0;
> >> > +
> >> > +	/* Deal with compund pages by ignoring unused part
> >> > +	 * of the page.
> >> > +	 */
> >> > +	page += offset  >> PAGE_SHIFT;
> >>
> >> Please only one space between "offset" and ">>"
> >>
> >> > +	offset &= ~PAGE_MASK;
> >> > +
> >> > +	while (len > 0) {
> >> > +		unsigned long bytes;
> >> > +
> >> > +		bytes = PAGE_SIZE - offset;
> >> > +		if (bytes > len)
> >> > +			bytes = len;
> >> > +		pb[j].pfn = page_to_pfn(page);
> >> > +		pb[j].offset = offset;
> >> > +		pb[j].len = bytes;
> >> > +
> >> > +		offset += bytes;
> >> > +		len -= bytes;
> >> > +
> >> > +		if (offset == PAGE_SIZE && len) {
> >> > +			page++;
> >> > +			offset = 0;
> >> > +			j++;
> >> > +		}
> >> > +	}
> >> > +
> >> > +	return j + 1;
> >> > +}
> >>
> >> I think this function has some edge case errors.
> >>
> >> As I understand it, this function returns how many page buffer
> >> entries were filled in.
> >>
> >> But if we fill exactly the end of a page, we will report one too many
> >> in the return value.
> >
> > I may be missing something here; but in the case you are describing we
> > would return a value of one as we should. When offset + len is exactly
> > equal to the page size, we would not increment the value of j, since
> > at that point len == 0. Since the initial value of j was 0 and we return (j + 1),
> we will return 1.
> 
> That's not what happens, you execute the loop code at least once, and
> hit:
> 
> >> > +		offset += bytes;
> >> > +		len -= bytes;
> >> > +		if (offset == PAGE_SIZE && len) {
> >> > +			page++;
> >> > +			offset = 0;
> >> > +			j++;
> >> > +		}

> 
> thus incrementing j before the return statement.

I don't mean to be argumentative, but I still don't see the issue here. You are right, I
will execute the loop code at least once, but j gets incremented only if len is non-zero as well as
offset being == PAGE_SIZE. "len" would have gotten decremented prior to the check and in the case
we are talking about, "len" would be zero and so j would not get incremented.

Regards,

K. Y

