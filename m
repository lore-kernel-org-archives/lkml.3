Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab3KKXLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 18:11:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:55272 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569Ab3KKXLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 18:11:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="407121828"
Message-ID: <52816521.7030908@linux.intel.com>
Date: Mon, 11 Nov 2013 15:15:45 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>
CC: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/2] check quirk to pad epout buf size when not aligned
 to maxpacketsize
References: <1384102237-19784-1-git-send-email-mpn@google.com> <1384102237-19784-2-git-send-email-mpn@google.com> <5280567C.2060004@linux.intel.com> <xa1t8uwvyyia.fsf@mina86.com>
In-Reply-To: <xa1t8uwvyyia.fsf@mina86.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 03:21 AM, Michal Nazarewicz wrote:
> Check gadget.quirk_ep_out_aligned_size to decide if buffer size requires
> to be aligned to maxpacketsize of an out endpoint.  ffs_epfile_io() needs
> to pad epout buffer to match above condition if quirk is found.
>
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> ---
>   drivers/usb/gadget/f_fs.c | 23 +++++++++++++++++++----
>   1 file changed, 19 insertions(+), 4 deletions(-)
>
>> On 11/10/2013 08:50 AM, Michal Nazarewicz wrote:
>>> @@ -787,6 +788,13 @@ static ssize_t ffs_epfile_io(struct file *file,
>>>
>>>   	/* Allocate & copy */
>>>   	if (!halt) {
>>> +		/*
>>> +		 * Controller requires buffer size to be aligned to
>>> +		 * maxpacketsize of an out endpoint.
>>> +		 */
>>> +		data_len = read && gadget->quirk_ep_out_aligned_size ?
>>> +			usb_ep_align_maxpacketsize(ep->ep, len) : len;
>>> +
>>>   		data = kmalloc(len, GFP_KERNEL);
>
> On Mon, Nov 11 2013, David Cohen <david.a.cohen@linux.intel.com> wrote:
>> Shouldn't this kmalloc() allocate 'data_len' bytes, instead of 'len'?
>
> Yes, of coures.
>
> diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
> index e496b72..fd769a8 100644
> --- a/drivers/usb/gadget/f_fs.c
> +++ b/drivers/usb/gadget/f_fs.c

[snip]

>   			ret = ep->status;
>   			if (read && ret > 0 &&
> -			    unlikely(copy_to_user(buf, data, ret)))
> +			    unlikely(copy_to_user(buf, data, min(ret, len))))

You need to replace min(ret, len) by min_t(size_t, ret, len) to avoid
this warning:
drivers/usb/gadget/f_fs.c:858:124: warning: comparison of distinct 
pointer types lacks a cast [enabled by default]

Once again, you (or me) need to reply to my v5 patch set.

Br, David
