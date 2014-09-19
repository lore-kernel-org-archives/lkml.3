Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292AbaISXK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 19:10:27 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:39774 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756044AbaISXK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 19:10:26 -0400
X-Sasl-enc: JhgK3jAZRmEXebWFGq6//aZC4eA4TGxqX/epvc3NQ9NZ 1411168224
Date: Fri, 19 Sep 2014 16:10:23 -0700
From: Greg KH <greg@kroah.com>
To: "John L. Hammond" <john.hammond@intel.com>
Cc: andreas.dilger@intel.com, oleg.drokin@intel.com, uja.ornl@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: lustre: fix undefined references to obd_memory
Message-ID: <20140919231023.GA25259@kroah.com>
References: <1410791693-3729-1-git-send-email-john.hammond@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410791693-3729-1-git-send-email-john.hammond@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 09:34:53AM -0500, John L. Hammond wrote:
> From: "John L. Hammond" <john.hammond@intel.com>
> 
> If CONFIG_PROC_FS=n then obd_memory is not defined. So put the setup
> and cleanup of this variable within #ifdef CONFIG_PROC_FS guards.
> 
> Signed-off-by: John L. Hammond <john.hammond@intel.com>
> ---
>  .../staging/lustre/lustre/include/obd_support.h    |    2 ++
>  drivers/staging/lustre/lustre/obdclass/class_obd.c |    5 +++++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/drivers/staging/lustre/lustre/include/obd_support.h b/drivers/staging/lustre/lustre/include/obd_support.h
> index 2991d2e..408ce7f 100644
> --- a/drivers/staging/lustre/lustre/include/obd_support.h
> +++ b/drivers/staging/lustre/lustre/include/obd_support.h
> @@ -43,12 +43,14 @@
>  #include "lprocfs_status.h"
>  
>  /* global variables */
> +#ifdef CONFIG_PROC_FS
>  extern struct lprocfs_stats *obd_memory;
>  enum {
>  	OBD_MEMORY_STAT = 0,
>  	OBD_MEMORY_PAGES_STAT = 1,
>  	OBD_STATS_NUM,
>  };
> +#endif /* CONFIG_PROC_FS */
>  
>  extern unsigned int obd_debug_peer_on_timeout;
>  extern unsigned int obd_dump_on_timeout;
> diff --git a/drivers/staging/lustre/lustre/obdclass/class_obd.c b/drivers/staging/lustre/lustre/obdclass/class_obd.c
> index 8b8d338..2939f0c 100644
> --- a/drivers/staging/lustre/lustre/obdclass/class_obd.c
> +++ b/drivers/staging/lustre/lustre/obdclass/class_obd.c
> @@ -534,6 +534,7 @@ static int __init init_obdclass(void)
>  	spin_lock_init(&obd_types_lock);
>  	obd_zombie_impexp_init();
>  
> +#ifdef CONFIG_PROC_FS
>  	obd_memory = lprocfs_alloc_stats(OBD_STATS_NUM,
>  					 LPROCFS_STATS_FLAG_NONE |
>  					 LPROCFS_STATS_FLAG_IRQ_SAFE);
> @@ -548,6 +549,7 @@ static int __init init_obdclass(void)
>  	lprocfs_counter_init(obd_memory, OBD_MEMORY_PAGES_STAT,
>  			     LPROCFS_CNTR_AVGMINMAX,
>  			     "pagesused", "pages");
> +#endif /* CONFIG_PROC_FS */
>  
>  	err = obd_init_checks();
>  	if (err == -EOVERFLOW)
> @@ -688,7 +690,10 @@ static void cleanup_obdclass(void)
>  	memory_max = obd_memory_max();
>  	pages_max = obd_pages_max();
>  
> +#ifdef CONFIG_PROC_FS
>  	lprocfs_free_stats(&obd_memory);
> +#endif /* CONFIG_PROC_FS */

That's horrid.

Don't put #ifdef lines in .c files, put the proper stuff in the .h
files, that way there is always a lprocfs_free_stats call.

thanks,

greg k-h
