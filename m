Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760791AbaJ3SHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 14:07:47 -0400
Received: from p3plex2out04.prod.phx3.secureserver.net ([184.168.131.18]:36139
	"EHLO p3plex2out04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759765AbaJ3SHq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 14:07:46 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 5/7] staging: comedi: don't allow write() on async
 command set up for "read"
Thread-Topic: [PATCH 5/7] staging: comedi: don't allow write() on async
 command set up for "read"
Thread-Index: AQHP9D8NeNklhsIE8UCM1SSPyB51qJxI750A
Date: Thu, 30 Oct 2014 18:07:43 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D882600D3B7@P3PWEX4MB008.ex4.secureserver.net>
References: <1414672952-1587-1-git-send-email-abbotti@mev.co.uk>
 <1414672952-1587-6-git-send-email-abbotti@mev.co.uk>
In-Reply-To: <1414672952-1587-6-git-send-email-abbotti@mev.co.uk>
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

On Thursday, October 30, 2014 5:43 AM, Ian Abbott wrote:
> If a Comedi asynchronous command has been set up for data transfer in
> the "read" direction on the current "write" subdevice (for those
> subdevices that support both directions), don't allow the "write" file
> operation as that would mess with the data in the comedi data buffer
> that is written by the low-level comedi hardware driver.
>
> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
> ---
>  drivers/staging/comedi/comedi_fops.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
> index 6805ec9..6328965 100644
> --- a/drivers/staging/comedi/comedi_fops.c
> +++ b/drivers/staging/comedi/comedi_fops.c
> @@ -2075,6 +2075,10 @@ static ssize_t comedi_write(struct file *file, const char __user *buf,
>  		retval = -EACCES;
>  		goto out;
>  	}
> +	if (!(async->cmd.flags & CMDF_WRITE)) {
> +		retval = -EINVAL;
> +		goto out;
> +	}
>  
>  	add_wait_queue(&async->wait_head, &wait);
>  	on_wait_queue = true;
> @@ -2146,6 +2150,10 @@ static ssize_t comedi_write(struct file *file, const char __user *buf,
>  				retval = -EACCES;
>  				break;
>  			}
> +			if (!(async->cmd.flags & CMDF_WRITE)) {
> +				retval = -EINVAL;
> +				break;
> +			}

Same question as with PATCH 4/7.

Is this test needed in the while () loop. Also, are the s->busy tests needed here?

>  			continue;
>  		}

Regards,
Hartley

