Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab3KKUD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 15:03:26 -0500
Received: from mga01.intel.com ([192.55.52.88]:5215 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754386Ab3KKUDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:03:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,679,1378882800"; 
   d="scan'208";a="431553425"
Message-ID: <5281390F.9080104@linux.intel.com>
Date: Mon, 11 Nov 2013 12:07:43 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Michal Nazarewicz <mpn@google.com>
CC: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>
Subject: Re: [PATCH 1/2] usb: gadget: f_fs: remove loop from I/O function
References: <1383603177-4624-4-git-send-email-david.a.cohen@linux.intel.com> <1384102237-19784-1-git-send-email-mpn@google.com>
In-Reply-To: <1384102237-19784-1-git-send-email-mpn@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On 11/10/2013 08:50 AM, Michal Nazarewicz wrote:
> From: Michal Nazarewicz <mina86@mina86.com>
>
> When endpoint changes (due to it being disabled or alt setting changed),
> mimic the action as if the change happened after the request has been
> queued, instead of retrying with the new endpoint.
>
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> ---
>   drivers/usb/gadget/f_fs.c | 94 +++++++++++++++++++++--------------------------
>   1 file changed, 41 insertions(+), 53 deletions(-)
>
> diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
> index 44cf775..f875f26 100644
> --- a/drivers/usb/gadget/f_fs.c
> +++ b/drivers/usb/gadget/f_fs.c
> @@ -754,74 +754,61 @@ static ssize_t ffs_epfile_io(struct file *file,
>   {
>   	struct ffs_epfile *epfile = file->private_data;
>   	struct ffs_ep *ep;
> -	char *data = NULL;
>   	ssize_t ret;
> +	char *data;
>   	int halt;
>
> -	goto first_try;
> -	do {
> -		spin_unlock_irq(&epfile->ffs->eps_lock);
> -		mutex_unlock(&epfile->mutex);
> +	/* Are we still active? */
> +	if (WARN_ON(epfile->ffs->state != FFS_ACTIVE)) {
> +		ret = -ENODEV;
> +		goto error;
> +	}
>
> -first_try:
> -		/* Are we still active? */
> -		if (WARN_ON(epfile->ffs->state != FFS_ACTIVE)) {
> -			ret = -ENODEV;
> +	/* Wait for endpoint to be enabled */
> +	ep = epfile->ep;
> +	if (!ep) {
> +		if (file->f_flags & O_NONBLOCK) {
> +			ret = -EAGAIN;
>   			goto error;
>   		}
>
> -		/* Wait for endpoint to be enabled */
> -		ep = epfile->ep;
> -		if (!ep) {
> -			if (file->f_flags & O_NONBLOCK) {
> -				ret = -EAGAIN;
> -				goto error;
> -			}
> -
> -			if (wait_event_interruptible(epfile->wait,
> -						     (ep = epfile->ep))) {
> -				ret = -EINTR;
> -				goto error;
> -			}
> -		}
> -
> -		/* Do we halt? */
> -		halt = !read == !epfile->in;
> -		if (halt && epfile->isoc) {
> -			ret = -EINVAL;
> +		if (wait_event_interruptible(epfile->wait, (ep = epfile->ep))) {

FYI this line fails checkpatch:
ERROR: do not use assignment in if condition
#70: FILE: drivers/usb/gadget/f_fs.c:777:
+		if (wait_event_interruptible(epfile->wait, (ep = epfile->ep))) {

total: 1 errors, 0 warnings, 121 lines checked

Since you're just moving that line here, you may want (or not) to clean
this up in a new patch for 3.13.

Br, David Cohen
