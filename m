Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333AbaDZUrQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 16:47:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbaDZUrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 16:47:14 -0400
Date: Sat, 26 Apr 2014 22:47:05 +0200
From: Mateusz Guzik <mguzik@redhat.com>
To: Laurent Navet <laurent.navet@gmail.com>
Cc: gregkh@linuxfoundation.org, tiwai@suse.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: line6: fix possible overrun
Message-ID: <20140426204704.GB17562@mguzik.redhat.com>
References: <1398532162-23006-1-git-send-email-laurent.navet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1398532162-23006-1-git-send-email-laurent.navet@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2014 at 07:09:22PM +0200, Laurent Navet wrote:
> The strcpy operation may write past the end of the fixed-size destination
> buffer if the source buffer is too large.
> 
> Found by coverity scan : CID 144979
> 
> Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
> ---
> build tested only
> 
>  drivers/staging/line6/audio.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/line6/audio.c b/drivers/staging/line6/audio.c
> index 171d80c..65f5cd4 100644
> --- a/drivers/staging/line6/audio.c
> +++ b/drivers/staging/line6/audio.c
> @@ -32,9 +32,10 @@ int line6_init_audio(struct usb_line6 *line6)
>  
>  	line6->card = card;
>  
> -	strcpy(card->id, line6->properties->id);
> +	strncpy(card->id, line6->properties->id, (sizeof(card->id)-1));
>  	strcpy(card->driver, DRIVER_NAME);
> -	strcpy(card->shortname, line6->properties->name);
> +	strncpy(card->shortname, line6->properties->name,
> +			(sizeof(card->shortname)-1));
>  	/* longname is 80 chars - see asound.h */
>  	sprintf(card->longname, "Line6 %s at USB %s", line6->properties->name,
>  		dev_name(line6->ifcdev));

Would not it be better to return -EINVAL (or some other error) instead?

Now you will possibly truncate the name.

-- 
Mateusz Guzik
