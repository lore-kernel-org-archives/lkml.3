Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbaCHEMI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 23:12:08 -0500
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:32335
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751978AbaCHEMG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 23:12:06 -0500
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
Thread-Index: AQHPOb9ZPe/NC2ri2EabJEzpTsS2OprWKk0AgABnMWA=
Date: Sat, 8 Mar 2014 04:12:01 +0000
Message-ID: <fd6bb08bd9a447aa9c0da3b584ea9bb8@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1394170320-1002-1-git-send-email-kys@microsoft.com>
	<1394170361-1043-1-git-send-email-kys@microsoft.com>
 <20140307.164756.1488071770631289333.davem@davemloft.net>
In-Reply-To: <20140307.164756.1488071770631289333.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [117.192.118.125]
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(979002)(6009001)(428001)(189002)(199002)(377454003)(13464003)(51704005)(56816005)(33646001)(90146001)(74706001)(95666003)(77982001)(56776001)(74316001)(97336001)(97186001)(94946001)(69226001)(4396001)(81686001)(19580405001)(19580395003)(50986001)(2656002)(49866001)(54356001)(81342001)(54316002)(86612001)(51856001)(83322001)(74876001)(59766001)(63696002)(47446002)(81542001)(66066001)(92566001)(80976001)(76786001)(94316002)(76796001)(46102001)(95416001)(76576001)(53806001)(85852003)(83072002)(76482001)(79102001)(74366001)(74502001)(65816001)(47736001)(87266001)(47976001)(87936001)(80022001)(81816001)(93136001)(86362001)(93516002)(31966008)(85306002)(74662001)(24736002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB596;H:BY2PR03MB299.namprd03.prod.outlook.com;CLIP:117.192.118.125;FPR:B4DDF206.BEF5BCCA.95F3739F.D09D9A00.2031B;MLV:ovrnspm;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Saturday, March 8, 2014 3:18 AM
> To: KY Srinivasan
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com
> Subject: Re: [PATCH V2 1/6] Drivers: net: hyperv: Enable scatter gather I/O
> 
> From: "K. Y. Srinivasan" <kys@microsoft.com>
> Date: Thu,  6 Mar 2014 21:32:36 -0800
> 
> > +static u32 fill_pg_buf(struct page *page, u32 offset, u32 len,
> > +			struct hv_page_buffer *pb)
> > +{
> > +	int j = 0;
> > +
> > +	/* Deal with compund pages by ignoring unused part
> > +	 * of the page.
> > +	 */
> > +	page += offset  >> PAGE_SHIFT;
> 
> Please only one space between "offset" and ">>"
> 
> > +	offset &= ~PAGE_MASK;
> > +
> > +	while (len > 0) {
> > +		unsigned long bytes;
> > +
> > +		bytes = PAGE_SIZE - offset;
> > +		if (bytes > len)
> > +			bytes = len;
> > +		pb[j].pfn = page_to_pfn(page);
> > +		pb[j].offset = offset;
> > +		pb[j].len = bytes;
> > +
> > +		offset += bytes;
> > +		len -= bytes;
> > +
> > +		if (offset == PAGE_SIZE && len) {
> > +			page++;
> > +			offset = 0;
> > +			j++;
> > +		}
> > +	}
> > +
> > +	return j + 1;
> > +}
> 
> I think this function has some edge case errors.
> 
> As I understand it, this function returns how many page buffer entries were
> filled in.
> 
> But if we fill exactly the end of a page, we will report one too many in the
> return value.

I may be missing something here; but in the case you are describing we would return a value
of one as we should. When offset + len is exactly equal to the page size, we would not increment
the value of j, since at that point len == 0. Since the initial value of j was 0 and we return (j + 1),
we will return 1.

Regards,

K. Y
> 
> Consider an "offset" of X, where X is smaller than PAGE_SIZE.  And a "len"
> which is exactly "PAGE_SIZE - offset".
> 
> We will fill in exactly one page buffer entry, however we will erroneously
> return 2 from this function.
> 
> I believe the fix is to first replace the test at the end of the loop
> with:
> 
> 	page++;
> 	offset = 0;
> 	j++;
> 
> And subsequently change the function to just return plain "j".
