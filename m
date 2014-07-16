Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965808AbaGPSul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 14:50:41 -0400
Received: from mx2.parallels.com ([199.115.105.18]:46368 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965526AbaGPSuf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 14:50:35 -0400
From: James Bottomley <jbottomley@parallels.com>
To: "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: Re: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
Thread-Topic: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
Thread-Index: AQHPoSYn2vh72TcerE+9u7O+On3hT5ujgK+A
Date: Wed, 16 Jul 2014 18:50:31 +0000
Message-ID: <1405536631.3165.23.camel@dabdike.int.hansenpartnership.com>
References: <20140709084300.GD6012@infradead.org>
	 <a31a45eddb544024a7538458b98c3611@BY2PR03MB299.namprd03.prod.outlook.com>
	 <1404935792.2184.5.camel@dabdike.int.hansenpartnership.com>
	 <2f3ae589e6f149acbe4c5dd79f905971@BY2PR03MB299.namprd03.prod.outlook.com>
	 <1404944843.2184.8.camel@dabdike.int.hansenpartnership.com>
	 <20140711063216.GA20660@infradead.org>
	 <328b7a6174ef4dd8a54a7db5ac959834@BY2PR03MB299.namprd03.prod.outlook.com>
	 <yq1a98d2z5x.fsf@sermon.lab.mkp.net> <20140716110111.GA7382@infradead.org>
	 <yq14myhtijx.fsf@sermon.lab.mkp.net> <20140716173827.GB20528@infradead.org>
	 <yq1fvi1rya0.fsf@sermon.lab.mkp.net>
	 <1405533734.3165.12.camel@dabdike.int.hansenpartnership.com>
	 <yq1bnsprvl1.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1bnsprvl1.fsf@sermon.lab.mkp.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.46.103.107]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <81F91A0C3A4F654E84482637DCDD08D7@sw.swsoft.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-16 at 14:45 -0400, Martin K. Petersen wrote:
> >>>>> "James" == James Bottomley <jbottomley@parallels.com> writes:
> 
> >> I don't have a problem with a BLIST_PREFER_UNMAP flag or something
> >> like that. But BLIST_TRY_VPD_PAGES seems more generally useful and it
> >> does fix the problem at hand. That's why I went that route.
> 
> James> Hang on ... unless we apply Christoph or my fix, we'll get the
> James> same issue with every raid driver (that's about 10 I think) that
> James> set no_write_same when they hit a >2TB RAID volume,
> 
> no_write_same is set for all the RAID controller drivers (54b2b50c20a6).
> 
> If a WRITE SAME(10/16) command fails and the UNMAP bit is not set we'll
> set no_write_same=1 and disable REQ_WRITE_SAME support.
> 
> If a WRITE SAME(10/16) command fails and the UNMAP bit is set we'll
> disable REQ_DISCARD support.
> 
> Not sure where the 10 vs. 16 byte 2TB limitation comes into play here?

It's the code we identified in sd.c:read_capacity_16():

	if (buffer[14] & 0x80) { /* LBPME */
		sdkp->lbpme = 1;

		if (buffer[14] & 0x40) /* LBPRZ */
			sdkp->lbprz = 1;

		sd_config_discard(sdkp, SD_LBP_WS16);
	}

If the inquiry shows LBPME set, we'll do write same regardless of the
no_write_same bit.  That's why for SPC-2 devices it only shows up on
>2TB devices because they force RC16.

James

