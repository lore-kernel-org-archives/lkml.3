Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbaL3WwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 17:52:15 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:63242 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbaL3WwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 17:52:14 -0500
Date: Tue, 30 Dec 2014 14:52:11 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Jonas Lundqvist <jonas@gannon.se>
Cc: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm: Move two seq_printf's outside of locked mutex
Message-ID: <20141230225211.GB31616@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Jonas Lundqvist <jonas@gannon.se>, airlied@linux.ie,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <1419976466-2113-1-git-send-email-jonas@gannon.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419976466-2113-1-git-send-email-jonas@gannon.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonas,

On Tue, Dec 30, 2014 at 10:54:26PM +0100, Jonas Lundqvist wrote:
> In drm_info.c: drm_bufs_info() and drm_vm_info() two seq_printf() was
> done unnecessarily while locking a mutex. This patch flips the order of
> the print and lock/unlock where applicable.
> 
> Signed-off-by: Jonas Lundqvist <jonas@gannon.se>
> ---
>  drivers/gpu/drm/drm_info.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_info.c b/drivers/gpu/drm/drm_info.c
> index 51efebd..981afe7 100644
> --- a/drivers/gpu/drm/drm_info.c
> +++ b/drivers/gpu/drm/drm_info.c
> @@ -81,11 +81,10 @@ int drm_vm_info(struct seq_file *m, void *data)
>  	   _DRM_SCATTER_GATHER and _DRM_CONSISTENT */
>  	const char *types[] = { "FB", "REG", "SHM", "AGP", "SG", "PCI" };
>  	const char *type;
> -	int i;
> +	int i = 0;
>  
> -	mutex_lock(&dev->struct_mutex);
>  	seq_printf(m, "slot	 offset	      size type flags	 address mtrr\n\n");
> -	i = 0;
> +	mutex_lock(&dev->struct_mutex);
>  	list_for_each_entry(r_list, &dev->maplist, head) {
>  		map = r_list->map;
>  		if (!map)
> @@ -147,8 +146,8 @@ int drm_bufs_info(struct seq_file *m, void *data)
>  			seq_printf(m, "\n");
>  		seq_printf(m, " %d", dma->buflist[i]->list);
>  	}
> -	seq_printf(m, "\n");
>  	mutex_unlock(&dev->struct_mutex);
> +	seq_printf(m, "\n");
>  	return 0;
>  }
>  

You changed 'i' but you didn't explain in your log message why you did this.

Does this change really improve anything?  It may work the same with the
locks moved around.  But if you look at the function as a whole, the
locks encapsulate the body of this function nicely.  I like the original
design better.

> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
- Jeremiah Mahler
