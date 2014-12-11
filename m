Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933558AbaLKCKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 21:10:23 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:37578 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932937AbaLKCKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 21:10:22 -0500
Date: Wed, 10 Dec 2014 18:10:19 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, mcb30@ipxe.org
Subject: Re: [PATCH V3 1/1] Drivers: hv: vmbus: Fix a bug in
 vmbus_establish_gpadl()
Message-ID: <20141211021019.GA5648@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>, gregkh@linuxfoundation.org,
	linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
	olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
	mcb30@ipxe.org
References: <1418260380-8774-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418260380-8774-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

K. Y. Srinivasan,

On Wed, Dec 10, 2014 at 05:13:00PM -0800, K. Y. Srinivasan wrote:
> Correctly compute the local (gpadl) handle. 

This description is still too sparse for me.  How was it computed before
and why was this incorrect?  Pretend like you are trying to explain your
patch to someone who has no idea what you did.

> I would like to thank Michael Brown <mcb30@ipxe.org> for seeing this bug.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reported-by: Michael Brown <mcb30@ipxe.org>
> ---
> Changes in V2: Added the Reported-by tag.
> Changes in V3: Cleaned up the commit log.
> 
>  drivers/hv/channel.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
> index 433f72a..c76ffbe 100644
> --- a/drivers/hv/channel.c
> +++ b/drivers/hv/channel.c
> @@ -366,8 +366,8 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
>  	unsigned long flags;
>  	int ret = 0;
>  
> -	next_gpadl_handle = atomic_read(&vmbus_connection.next_gpadl_handle);
> -	atomic_inc(&vmbus_connection.next_gpadl_handle);
> +	next_gpadl_handle =
> +		(atomic_inc_return(&vmbus_connection.next_gpadl_handle) - 1);
>  
Tell me if I understand this correctly.

Before it read the handle and incremented it.

  y = x + 1

Now it reads the handle, increments it, then decrements it.

  y = (x + 1) - 1 = x

>  	ret = create_gpadl_header(kbuffer, size, &msginfo, &msgcount);
>  	if (ret)
> -- 
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
- Jeremiah Mahler
