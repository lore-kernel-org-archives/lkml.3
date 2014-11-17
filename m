Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbaKQVnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 16:43:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbaKQVnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 16:43:16 -0500
Date: Mon, 17 Nov 2014 16:43:05 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Antonio Borneo <borneo.antonio@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] HID: i2c-hid: fix race condition reading reports
Message-ID: <20141117214305.GC30324@mail.corp.redhat.com>
References: <1416149064-25655-1-git-send-email-borneo.antonio@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1416149064-25655-1-git-send-email-borneo.antonio@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Antonio,

On Nov 16 2014 or thereabouts, Antonio Borneo wrote:
> From: Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
> 
> From: Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
> 
> Current driver uses a common buffer for reading reports either
> synchronously in i2c_hid_get_raw_report() and asynchronously in
> the interrupt handler.
> There is race condition if an interrupt arrives immediately after
> the report is received in i2c_hid_get_raw_report(); the common
> buffer is modified by the interrupt handler with the new report
> and then i2c_hid_get_raw_report() proceed using wrong data.
> 
> Fix it by using a separate buffers for asynchronous reports.
> 
> Signed-off-by: Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
> [Antonio Borneo: cleanup and rebase to v3.17]
> Signed-off-by: Antonio Borneo <borneo.antonio@gmail.com>
> Cc: stable@vger.kernel.org

For your next submission, when you want a patch to go in stable, put CC
here, but please do not CC the actual mail to stable@. Stable should receive
either mails which are already in Linus' tree, or which refer a commit
in Linus' tree in case it does not applies smoothly.

[keeping stable@ here to show them that this one should not get picked
right now]

> ---
> 
> Hi Jiri, Benjamin,
> 
> I think this patch should also go through linux-stable.
> Confirmation from our side is welcome.

I think the patch is definitively valuable. However, my personal taste
would go for having a new .rawbuf buffer and use it in
i2c_hid_get_raw_report(). The rationale would be that it's actually
i2c_hid_get_raw_report() which is problematic, not the generic irq
handling. Also I prefer rawbuf to irqinbuf.

I am perfectly aware that this is just bikeshedding, so if changing the
patch is too cumbersome (looks like Jean-Baptiste is involved), and if
Jiri agree, this can go into the hid tree with my reviewed-by.

I am fine having this version or the rawbuf one in stable BTW.

Cheers,
Benjamin

> 
> Regards,
> Antonio
> 
>  drivers/hid/i2c-hid/i2c-hid.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
> index 933bf10..7c80e96 100644
> --- a/drivers/hid/i2c-hid/i2c-hid.c
> +++ b/drivers/hid/i2c-hid/i2c-hid.c
> @@ -136,6 +136,7 @@ struct i2c_hid {
>  						   * register of the HID
>  						   * descriptor. */
>  	unsigned int		bufsize;	/* i2c buffer size */
> +	char			*irqinbuf;	/* Asynchronous Input buffer */
>  	char			*inbuf;		/* Input buffer */
>  	char			*cmdbuf;	/* Command buffer */
>  	char			*argsbuf;	/* Command arguments buffer */
> @@ -371,7 +372,7 @@ static void i2c_hid_get_input(struct i2c_hid *ihid)
>  	int ret, ret_size;
>  	int size = le16_to_cpu(ihid->hdesc.wMaxInputLength);
>  
> -	ret = i2c_master_recv(ihid->client, ihid->inbuf, size);
> +	ret = i2c_master_recv(ihid->client, ihid->irqinbuf, size);
>  	if (ret != size) {
>  		if (ret < 0)
>  			return;
> @@ -381,7 +382,7 @@ static void i2c_hid_get_input(struct i2c_hid *ihid)
>  		return;
>  	}
>  
> -	ret_size = ihid->inbuf[0] | ihid->inbuf[1] << 8;
> +	ret_size = ihid->irqinbuf[0] | ihid->irqinbuf[1] << 8;
>  
>  	if (!ret_size) {
>  		/* host or device initiated RESET completed */
> @@ -396,11 +397,11 @@ static void i2c_hid_get_input(struct i2c_hid *ihid)
>  		return;
>  	}
>  
> -	i2c_hid_dbg(ihid, "input: %*ph\n", ret_size, ihid->inbuf);
> +	i2c_hid_dbg(ihid, "input: %*ph\n", ret_size, ihid->irqinbuf);
>  
>  	if (test_bit(I2C_HID_STARTED, &ihid->flags))
> -		hid_input_report(ihid->hid, HID_INPUT_REPORT, ihid->inbuf + 2,
> -				ret_size - 2, 1);
> +		hid_input_report(ihid->hid, HID_INPUT_REPORT,
> +				 ihid->irqinbuf + 2, ret_size - 2, 1);
>  
>  	return;
>  }
> @@ -503,9 +504,11 @@ static void i2c_hid_find_max_report(struct hid_device *hid, unsigned int type,
>  
>  static void i2c_hid_free_buffers(struct i2c_hid *ihid)
>  {
> +	kfree(ihid->irqinbuf);
>  	kfree(ihid->inbuf);
>  	kfree(ihid->argsbuf);
>  	kfree(ihid->cmdbuf);
> +	ihid->irqinbuf = NULL;
>  	ihid->inbuf = NULL;
>  	ihid->cmdbuf = NULL;
>  	ihid->argsbuf = NULL;
> @@ -521,11 +524,13 @@ static int i2c_hid_alloc_buffers(struct i2c_hid *ihid, size_t report_size)
>  		       sizeof(__u16) + /* size of the report */
>  		       report_size; /* report */
>  
> +	ihid->irqinbuf = kzalloc(report_size, GFP_KERNEL);
>  	ihid->inbuf = kzalloc(report_size, GFP_KERNEL);
>  	ihid->argsbuf = kzalloc(args_len, GFP_KERNEL);
>  	ihid->cmdbuf = kzalloc(sizeof(union command) + args_len, GFP_KERNEL);
>  
> -	if (!ihid->inbuf || !ihid->argsbuf || !ihid->cmdbuf) {
> +	if (!ihid->irqinbuf || !ihid->inbuf ||
> +	    !ihid->argsbuf || !ihid->cmdbuf) {
>  		i2c_hid_free_buffers(ihid);
>  		return -ENOMEM;
>  	}
> -- 
> 2.1.3
> 
