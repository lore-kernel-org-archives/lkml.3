Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab3KKECz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 23:02:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:20242 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558Ab3KKECt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 23:02:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,675,1378882800"; 
   d="scan'208";a="431093612"
Message-ID: <5280567C.2060004@linux.intel.com>
Date: Sun, 10 Nov 2013 20:01:00 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Michal Nazarewicz <mpn@google.com>
CC: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>
Subject: Re: [PATCH 2/2] check quirk to pad epout buf size when not aligned
 to maxpacketsize
References: <1384102237-19784-1-git-send-email-mpn@google.com> <1384102237-19784-2-git-send-email-mpn@google.com>
In-Reply-To: <1384102237-19784-2-git-send-email-mpn@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On 11/10/2013 08:50 AM, Michal Nazarewicz wrote:
> From: Michal Nazarewicz <mina86@mina86.com>
> 
> Check gadget.quirk_ep_out_aligned_size to decide if buffer size requires
> to be aligned to maxpacketsize of an out endpoint.  ffs_epfile_io() needs
> to pad epout buffer to match above condition if quirk is found.
> 
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> ---
>  I'm wondering whether the len should be aligned down rather then up.
>  This would have it's own problems, but maybe better then
>  a possibility of silently dropping data.
> 
>  drivers/usb/gadget/f_fs.c | 21 ++++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
> index f875f26..ea0b8ba 100644
> --- a/drivers/usb/gadget/f_fs.c
> +++ b/drivers/usb/gadget/f_fs.c
> @@ -753,8 +753,9 @@ static ssize_t ffs_epfile_io(struct file *file,
>  			     char __user *buf, size_t len, int read)
>  {
>  	struct ffs_epfile *epfile = file->private_data;
> +	struct usb_gadget *gadget = epfile->ffs->gadget;
>  	struct ffs_ep *ep;
> -	ssize_t ret;
> +	ssize_t ret, data_len;
>  	char *data;
>  	int halt;
>  
> @@ -787,6 +788,13 @@ static ssize_t ffs_epfile_io(struct file *file,
>  
>  	/* Allocate & copy */
>  	if (!halt) {
> +		/*
> +		 * Controller requires buffer size to be aligned to
> +		 * maxpacketsize of an out endpoint.
> +		 */
> +		data_len = read && gadget->quirk_ep_out_aligned_size ?
> +			usb_ep_align_maxpacketsize(ep->ep, len) : len;
> +
>  		data = kmalloc(len, GFP_KERNEL);

Shouldn't this kmalloc() allocate 'data_len' bytes, instead of 'len'?

Br, David
