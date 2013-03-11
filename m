Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab3CKOtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 10:49:19 -0400
Received: from smtp.infotech.no ([82.134.31.41]:45860 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239Ab3CKOtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 10:49:15 -0400
Message-ID: <513DEED6.3090709@interlog.com>
Date: Mon, 11 Mar 2013 10:48:54 -0400
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] [SCSI] scsi_transport_sas: check for allocation failure
References: <20130308120215.GB18712@longonot.mountain> <513A2678.5000803@interlog.com> <1362783019.2370.45.camel@dabdike.int.hansenpartnership.com> <20130311131032.GO9189@mwanda>
In-Reply-To: <20130311131032.GO9189@mwanda>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-03-11 09:10 AM, Dan Carpenter wrote:
> On Fri, Mar 08, 2013 at 10:50:19PM +0000, James Bottomley wrote:
>> On Fri, 2013-03-08 at 12:57 -0500, Douglas Gilbert wrote:
>>> On 13-03-08 07:02 AM, Dan Carpenter wrote:
>>>> Static checkers complain that this allocation isn't checked.  We
>>>> should return zero if the allocation fails.
>>>>
>>>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>>>>
>>>> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
>>>> index 1b68142..a022997 100644
>>>> --- a/drivers/scsi/scsi_transport_sas.c
>>>> +++ b/drivers/scsi/scsi_transport_sas.c
>>>> @@ -379,9 +379,12 @@ sas_tlr_supported(struct scsi_device *sdev)
>>>>    {
>>>>    	const int vpd_len = 32;
>>>>    	struct sas_end_device *rdev = sas_sdev_to_rdev(sdev);
>>>> -	char *buffer = kzalloc(vpd_len, GFP_KERNEL);
>>>> +	char *buffer;
>>>>    	int ret = 0;
>>>>
>>>> +	buffer = kzalloc(vpd_len, GFP_KERNEL);
>>>> +	if (!buffer)
>>>> +		goto out;
>>>>    	if (scsi_get_vpd_page(sdev, 0x90, buffer, vpd_len))
>>>>    		goto out;
>>>>
>>>
>>> For 32 bytes, why not use the stack?
>>
>> Because the buffer is a DMA target.  You can't DMA to stack because of
>> padding and cacheline issues.
>>
>
> I think stack data works here.  scsi_execute() calls
> blk_rq_map_kern() which handles stack memory and alignment issues.

That being the case, several other callers of
scsi_get_vpd_page() 9and friends) could be
simplified and sped up.

Also since VPD pages don't change and they can carry
a lot of disparate information (e.g. the Extended
Inquiry and Block Limits pages) perhaps they could
be cached by the appropriate level (e.g. Extended
Inquiry cached by mid-level; Block Limits cached
by sd driver).

Doug Gilbert


