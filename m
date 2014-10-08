Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbaJHXNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 19:13:37 -0400
Received: from p3plex2out04.prod.phx3.secureserver.net ([184.168.131.18]:50227
	"EHLO p3plex2out04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754352AbaJHXNf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 19:13:35 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bernd Porr <mail@berndporr.me.uk>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] staging: comedi: (regression) channel list must be set
 for COMEDI_CMD ioctl
Thread-Topic: [PATCH] staging: comedi: (regression) channel list must be set
 for COMEDI_CMD ioctl
Thread-Index: AQHP4wnpNYH9+4ZdNEyejQppx5vVCpwmzf7g
Date: Wed, 8 Oct 2014 23:13:33 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825FDD84E@P3PWEX4MB008.ex4.secureserver.net>
References: <1412780954-11299-1-git-send-email-abbotti@mev.co.uk>
In-Reply-To: <1412780954-11299-1-git-send-email-abbotti@mev.co.uk>
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

On Wednesday, October 08, 2014 8:09 AM, Ian Abbott wrote:
> `do_cmd_ioctl()`, the handler for the `COMEDI_CMD` ioctl can incorrectly
> call the Comedi subdevice's `do_cmd()` handler with a NULL channel list
> pointer.  This is a regression as the `do_cmd()` handler has never been
> expected to deal with that, leading to a kernel OOPS when it tries to
> dereference it.
>
> A NULL channel list pointer is allowed for the `COMEDI_CMDTEST` ioctl,
> handled by `do_cmdtest_ioctl()` and the subdevice's `do_cmdtest()`
> handler, but not for the `COMEDI_CMD` ioctl and its handlers.
>
> Both `do_cmd_ioctl()` and `do_cmdtest_ioctl()` call
> `__comedi_get_user_chanlist()` to copy the channel list from user memory
> into dynamically allocated kernel memory and check it for consistency.
> That function currently returns 0 if the `user_chanlist` parameter
> (pointing to the channel list in user memory) is NULL.  That's fine for
> `do_cmdtest_ioctl()`, but `do_cmd_ioctl()` incorrectly assumes the
> kernel copy of the channel list has been set-up correctly.
>
> Fix it by not allowing the `user_chanlist` parameter to be NULL in
> `__comedi_get_user_chanlist()`, and only calling it from
> `do_cmdtest_ioctl()` if the parameter is non-NULL.
>
> Thanks to Bernd Porr for reporting the bug via an initial patch sent
> privately.
>
> Fixes: c6cd0eefb27b ("staging: comedi: comedi_fops: introduce __comedi_get_user_chanlist()")
> Reported-by: Bernd Porr <mail@berndporr.me.uk>
> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
> Cc: Bernd Porr <mail@berndporr.me.uk>
> Cc: <stable@vger.kernel.org> # 3.15.y 3.16.y 3.17.y
> ---
>  drivers/staging/comedi/comedi_fops.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
> index 495969f..a9b7fe5 100644
> --- a/drivers/staging/comedi/comedi_fops.c
> +++ b/drivers/staging/comedi/comedi_fops.c
> @@ -1462,10 +1462,6 @@ static int __comedi_get_user_chanlist(struct comedi_device *dev,
>  	unsigned int *chanlist;
>  	int ret;
>  
> -	/* user_chanlist could be NULL for do_cmdtest ioctls */
> -	if (!user_chanlist)
> -		return 0;
> -

I think you need a check here to avoid a NULL pointer getting
passed to the  memdup_user().

	If (!user_chanlist || cmd->chanlist_len == 0)
		return -EINVAL;

>  	chanlist = memdup_user(user_chanlist,
>  			       cmd->chanlist_len * sizeof(unsigned int));
>  	if (IS_ERR(chanlist))
> @@ -1609,10 +1605,13 @@ static int do_cmdtest_ioctl(struct comedi_device *dev,
>  
>  	s = &dev->subdevices[cmd.subdev];
>  
> -	/* load channel/gain list */
> -	ret = __comedi_get_user_chanlist(dev, s, user_chanlist, &cmd);
> -	if (ret)
> -		return ret;
> +	/* user_chanlist can be NULL for COMEDI_CMDTEST ioctl */
> +	if (user_chanlist) {
> +		/* load channel/gain list */
> +		ret = __comedi_get_user_chanlist(dev, s, user_chanlist, &cmd);
> +		if (ret)
> +			return ret;
> +	}
>
>  	ret = s->do_cmdtest(dev, s, &cmd);
 
The reset looks ok.


Side-note on mem_dupuser(). That function does a kmalloc to copy the
user data to the kernel. Shouldn't we be freeing it when we are done with
it?

do_become_nonbusy() does a kfree(async->cmd.chanlist) which will free
the memory for do_cmd_ioctl().

But, do_cmdtest_ioctl() actually copies the user data into a local variable.
I think we are missing a kfree() there.

Regards,
Hartley

