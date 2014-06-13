Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbaFMPhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 11:37:31 -0400
Received: from smtp.citrix.com ([66.165.176.89]:40635 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511AbaFMPh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 11:37:29 -0400
X-IronPort-AV: E=Sophos;i="5.01,471,1400025600"; 
   d="scan'208";a="143542796"
Message-ID: <539B1A9C.1080902@citrix.com>
Date: Fri, 13 Jun 2014 17:37:00 +0200
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [Xen-devel] [PATCH] xen-blkfront: check feature-persitent on
 resume
References: <1400769607-17278-1-git-send-email-roger.pau@citrix.com>	<20140523175105.GA8995@phenom.dumpdata.com> <537F8EA4.2050506@citrix.com>
In-Reply-To: <537F8EA4.2050506@citrix.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

On 23/05/14 20:08, Roger Pau Monné wrote:
> On 23/05/14 19:51, Konrad Rzeszutek Wilk wrote:
>> On Thu, May 22, 2014 at 04:40:07PM +0200, Roger Pau Monne wrote:
>>> We are missing a check to see if the backend supports persistent
>>> grants on resume, meaning we will always run with the value fetched
>>> from the firsts host on which we run on.
>>>
>>> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
>>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>>> Cc: David Vrabel <david.vrabel@citrix.com>
>>> ---
>>>  drivers/block/xen-blkfront.c |   23 ++++++++++++++++-------
>>>  1 files changed, 16 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
>>> index efe1b47..00ae36b 100644
>>> --- a/drivers/block/xen-blkfront.c
>>> +++ b/drivers/block/xen-blkfront.c
>>> @@ -1430,6 +1430,20 @@ static void split_bio_end(struct bio *bio, int error)
>>>  	bio_put(bio);
>>>  }
>>>  
>>> +static void blkfront_setup_persistent(struct blkfront_info *info)
>>> +{
>>> +	unsigned int persistent;
>>> +	int err;
>>> +
>>> +	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
>>> +			    "feature-persistent", "%u", &persistent,
>>> +			    NULL);
>>> +	if (err)
>>> +		info->feature_persistent = 0;
>>> +	else
>>> +		info->feature_persistent = persistent;
>>> +}
>>> +
>>>  static int blkif_recover(struct blkfront_info *info)
>>>  {
>>>  	int i;
>>> @@ -1456,6 +1470,7 @@ static int blkif_recover(struct blkfront_info *info)
>>>  	info->shadow_free = info->ring.req_prod_pvt;
>>>  	info->shadow[BLK_RING_SIZE-1].req.u.rw.id = 0x0fffffff;
>>>  
>>> +	blkfront_setup_persistent(info);
>>>  	rc = blkfront_setup_indirect(info);
>>>  	if (rc) {
>>>  		kfree(copy);
>>> @@ -1851,13 +1866,7 @@ static void blkfront_connect(struct blkfront_info *info)
>>>  	if (!err && discard)
>>>  		blkfront_setup_discard(info);
>>>  
>>> -	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
>>> -			    "feature-persistent", "%u", &persistent,
>>> -			    NULL);
>>> -	if (err)
>>> -		info->feature_persistent = 0;
>>> -	else
>>> -		info->feature_persistent = persistent;
>>> +	blkfront_setup_persistent(info);
>>
>> Should we also flush the ones that are on the info->grants list if
>> we turning it off?
> 
> This path is only taken on the first connection, further calls to
> blkfront_connect from resume code don't get here, because they take the
> BLKIF_STATE_SUSPENDED path and just call blkif_recover and return. And
> on disconnection blkfront_connect doesn't even get called.
> 
> Roger.
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
> 

