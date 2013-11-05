Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab3KEPG4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 10:06:56 -0500
Received: from mga03.intel.com ([143.182.124.21]:24906 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396Ab3KEPGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 10:06:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="384927253"
Message-ID: <52790925.7040306@linux.intel.com>
Date: Tue, 05 Nov 2013 07:05:09 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/4] usb: ffs: check quirk to pad epout buf size when
 not aligned to maxpacketsize
References: <Pine.LNX.4.44L0.1311050950260.1360-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1311050950260.1360-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2013 06:52 AM, Alan Stern wrote:
> On Mon, 4 Nov 2013, David Cohen wrote:
> 
>> Check gadget.quirk_ep_out_aligned_size to decide if buffer size requires
>> to be aligned to maxpacketsize of an out endpoint. ffs_epfile_io() needs
>> to pad epout buffer to match above condition if quirk is found.
>>
>> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
>> ---
>>  drivers/usb/gadget/f_fs.c | 22 ++++++++++++++++++++++
>>  1 file changed, 22 insertions(+)
>>
>> diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
>> index 75e4b7846a8d..e7c3c3119552 100644
>> --- a/drivers/usb/gadget/f_fs.c
>> +++ b/drivers/usb/gadget/f_fs.c
>> @@ -755,10 +755,13 @@ static ssize_t ffs_epfile_io(struct file *file,
>>  			     char __user *buf, size_t len, int read)
>>  {
>>  	struct ffs_epfile *epfile = file->private_data;
>> +	struct usb_gadget *gadget = epfile->ffs->gadget;
>>  	struct ffs_ep *ep;
>>  	char *data = NULL;
>> +	size_t data_len = 0;
>>  	ssize_t ret;
>>  	int halt;
>> +	size_t orig_len = len;
>>  
>>  	goto first_try;
>>  	do {
>> @@ -794,11 +797,30 @@ first_try:
>>  			goto error;
>>  		}
>>  
>> +		/*
>> +		 * Controller requires buffer size to be aligned to
>> +		 * maxpacketsize of an out endpoint.
>> +		 */
>> +		if (gadget->quirk_ep_out_aligned_size && read) {
>> +			/*
>> +			 * We pass 'orig_len' to usp_ep_align_maxpacketsize()
>> +			 * due to we're in a loop and 'len' may have been
>> +			 * changed.
>> +			 */
>> +			len = usb_ep_align_maxpacketsize(ep->ep, orig_len);
>> +			if (data && len > data_len) {
>> +				kfree(data);
>> +				data = NULL;
>> +				data_len = 0;
>> +			}
>> +		}
> 
> Since the value of orig_len never changes, there's no point calling 
> usb_ep_align_maxpacketsize() inside the loop.  You should call it only 
> once, before the loop starts.  Once you do that, you won't need 
> orig_len at all.

orig_len doesn't change but ep->ep does. If USB specs say max packet
size won't change even if ep does, than we can call it from outside the
loop.

Br, David
