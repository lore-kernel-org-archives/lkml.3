Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab3KDS6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 13:58:00 -0500
Received: from mga03.intel.com ([143.182.124.21]:15012 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079Ab3KDS57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 13:57:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="316869760"
Message-ID: <5277EF3E.1000109@linux.intel.com>
Date: Mon, 04 Nov 2013 11:02:22 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul.Zimmerman@synopsys.com
Subject: Re: [PATCH v3 2/3] usb: ffs: check quirk to pad epout buf size when
 not aligned to maxpacketsize
References: <Pine.LNX.4.44L0.1310301331580.1312-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1310301331580.1312-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Appreciate your comments. Please, see my reply.

On 10/30/2013 10:35 AM, Alan Stern wrote:
> On Wed, 30 Oct 2013, David Cohen wrote:
>
>> Check gadget.quirk_ep_out_aligned_size to decide if buffer size requires
>> to be aligned to maxpacketsize of an out endpoint. ffs_epfile_io() needs
>> to pad epout buffer to match above condition if quirk is found.
>>
>> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
>> ---
>>   drivers/usb/gadget/f_fs.c | 17 +++++++++++++++++
>>   1 file changed, 17 insertions(+)
>>
>> diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
>> index 75e4b78..b49dd55 100644
>> --- a/drivers/usb/gadget/f_fs.c
>> +++ b/drivers/usb/gadget/f_fs.c
>> @@ -755,10 +755,12 @@ static ssize_t ffs_epfile_io(struct file *file,
>>   			     char __user *buf, size_t len, int read)
>>   {
>>   	struct ffs_epfile *epfile = file->private_data;
>> +	struct usb_gadget *gadget = epfile->ffs->gadget;
>>   	struct ffs_ep *ep;
>>   	char *data = NULL;
>>   	ssize_t ret;
>>   	int halt;
>> +	size_t orig_len = len;
>>
>>   	goto first_try;
>>   	do {
>> @@ -794,6 +796,21 @@ first_try:
>>   			goto error;
>>   		}
>>
>> +		/*
>> +		 * Controller requires buffer size to be aligned to
>> +		 * maxpacketsize of an out endpoint.
>> +		 */
>> +		if (gadget->quirk_ep_out_aligned_size && read &&
>> +		    !IS_ALIGNED(len, ep->ep->desc->wMaxPacketSize)) {
>
> IS_ALIGNED works only when the second argument is a power of 2.
>
> Interrupt endpoints are not required to have maxpacket sizes that are
> powers of 2.  Does this code ever get used for an interrupt endpoint?

That's a good point. It won't use interrupt ep on the case I am working
on, but f_fs allows it. I'll cover both cases in next patchset.

>
>> +			size_t old_len = len;
>
> Why add old_len here when you added orig_len above?

See below.

>
>> +			len = roundup(orig_len,
>> +				      (size_t)ep->ep->desc->wMaxPacketSize);
>> +			if (unlikely(data) && len > old_len) {
>
> If the original value wasn't aligned, how can len fail to be > old_len?

This code is inside a loop. There is an unlikely case explained in the
end to loop again if ep got disabled or changed while acquiring mutex.
If that happens, I want to avoid to re-allocate buffer if previous size
was already enough. Since 'len' gets updated when aligning buf size, we
need to keep track of 'orig_len' to do only minimum necessary pad on
new alignment. 'old_len' is used to save previous value to decide for
new allocation or not. But maybe I should change it to something more
accurate like 'buf_size' or 'alloc_size'.

Br, David Cohen
