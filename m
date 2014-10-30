Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759930AbaJ3SFn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 14:05:43 -0400
Received: from p3plex2out02.prod.phx3.secureserver.net ([184.168.131.14]:41712
	"EHLO p3plex2out02.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758831AbaJ3SFm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 14:05:42 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 4/7] staging: comedi: don't allow read() on async
 command set up for "write"
Thread-Topic: [PATCH 4/7] staging: comedi: don't allow read() on async
 command set up for "write"
Thread-Index: AQHP9D8MkQ4h3yYEcUmBaoU/Io570pxI7omA
Date: Thu, 30 Oct 2014 18:05:40 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D882600D340@P3PWEX4MB008.ex4.secureserver.net>
References: <1414672952-1587-1-git-send-email-abbotti@mev.co.uk>
 <1414672952-1587-5-git-send-email-abbotti@mev.co.uk>
In-Reply-To: <1414672952-1587-5-git-send-email-abbotti@mev.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 30, 2014 5:42 AM, Ian Abbott wrote:
> If a Comedi asynchronous command has been set up for data transfer in
> the "write" direction on the current "read" subdevice (for those
> subdevices that support both directions), don't allow the "read" file
> operation as that would mess with the data in the comedi data buffer
> that is read by the low-level comedi hardware driver.
>
> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
> ---
>  drivers/staging/comedi/comedi_fops.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
> index fef68da..6805ec9 100644
> --- a/drivers/staging/comedi/comedi_fops.c
> +++ b/drivers/staging/comedi/comedi_fops.c
> @@ -2210,6 +2210,10 @@ static ssize_t comedi_read(struct file *file, char __user *buf, size_t nbytes,
>  		retval = -EACCES;
>  		goto out;
>  	}
> +	if (async->cmd.flags & CMDF_WRITE) {
> +		retval = -EINVAL;
> +		goto out;
> +	}
>  
>  	add_wait_queue(&async->wait_head, &wait);
>  	while (nbytes > 0 && !retval) {
> @@ -2249,6 +2253,10 @@ static ssize_t comedi_read(struct file *file, char __user *buf, size_t nbytes,
>  				retval = -EACCES;
>  				break;
>  			}
> +			if (async->cmd.flags & CMDF_WRITE) {
> +				retval = -EINVAL;
> +				break;
> +			}

Is this second test really needed in the while() loop?

For that matter, are the s->busy tests needed in the while() loop?

>  			continue;
 >		}
 >		m = copy_to_user(buf, async->prealloc_buf +

Regards,
Hartley

