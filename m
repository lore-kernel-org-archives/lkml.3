Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680AbbAVNFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 08:05:37 -0500
Received: from mail-oi0-f48.google.com ([209.85.218.48]:60630 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbbAVNFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 08:05:34 -0500
Message-ID: <54C0F59B.8090709@acm.org>
Date: Thu, 22 Jan 2015 07:05:31 -0600
From: Corey Minyard <minyard@acm.org>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Nicholas Krause <xerofoify@gmail.com>
CC: openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] char:ipmi: Free ipmi_recv_msg messages from the
 linked list,recv_msgs for the function,ipmi_release in the file,ipmi_devintf.c
References: <1421723653-19633-1-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1421723653-19633-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch is queued for 3.20.  Thanks.

-corey

On 01/19/2015 09:14 PM, Nicholas Krause wrote:
> This adds a loop through the elements in the linked list, recv_msgs using
> list_for_entry_safe in order to free messages in this list.  In addition
> we are using the safe version of this marco in order to prevent use after
> bugs related to deleting the element we are on currently by holding a
> pointer to the next element after the current one we are on and freeing
> with the function, ipmi_free_recv_msg internally in this loop.
>
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/char/ipmi/ipmi_devintf.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/char/ipmi/ipmi_devintf.c b/drivers/char/ipmi/ipmi_devintf.c
> index ec318bf..d2af38a 100644
> --- a/drivers/char/ipmi/ipmi_devintf.c
> +++ b/drivers/char/ipmi/ipmi_devintf.c
> @@ -157,14 +157,15 @@ static int ipmi_release(struct inode *inode, struct file *file)
>  {
>  	struct ipmi_file_private *priv = file->private_data;
>  	int                      rv;
> +	struct  ipmi_recv_msg *msg, *next;
>  
>  	rv = ipmi_destroy_user(priv->user);
>  	if (rv)
>  		return rv;
>  
> -	/* FIXME - free the messages in the list. */
> -	kfree(priv);
> -
> +	list_for_each_entry_safe(msg, next, &priv->recv_msgs, link) {
> +		ipmi_free_recv_msg(msg);
> +	}
>  	return 0;
>  }
>  

