Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab3KEPPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 10:15:47 -0500
Received: from mga03.intel.com ([143.182.124.21]:42231 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab3KEPPp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 10:15:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="384930770"
From: "Cohen, David A" <david.a.cohen@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3/4] usb: ffs: check quirk to pad epout buf size when
 not aligned to maxpacketsize
Thread-Topic: [PATCH v4 3/4] usb: ffs: check quirk to pad epout buf size
 when not aligned to maxpacketsize
Thread-Index: AQHO2jnjXiO3HvkZPkSLoIdur8UPnA==
Date: Tue, 5 Nov 2013 15:15:39 +0000
Message-ID: <52790B35.1080305@intel.com>
References: <Pine.LNX.4.44L0.1311050950260.1360-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1311050950260.1360-100000@iolanthe.rowland.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005
 Icedove/17.0.9
x-originating-ip: [172.28.128.180]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <B5DE50E09768034C9655D755B9661492@intel.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
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