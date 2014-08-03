Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbaHCMFK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 08:05:10 -0400
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48650 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752320AbaHCMFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 08:05:08 -0400
Date: Sun, 3 Aug 2014 15:04:33 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] media: davinci: vpif: fix array out of bound warnings
Message-ID: <20140803120432.GZ16460@valkosipuli.retiisi.org.uk>
References: <1405701111-26983-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405701111-26983-1-git-send-email-prabhakar.csengg@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

On Fri, Jul 18, 2014 at 05:31:51PM +0100, Lad, Prabhakar wrote:
> This patch fixes following array out of bound warnings,
> 
> drivers/media/platform/davinci/vpif_display.c: In function 'vpif_remove':
> drivers/media/platform/davinci/vpif_display.c:1389:36: warning: iteration
> 1u invokes undefined behavior [-Waggressive-loop-optimizations]
>    vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
>                                     ^
> drivers/media/platform/davinci/vpif_display.c:1385:2: note: containing loop
>   for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++) {
>   ^
> drivers/media/platform/davinci/vpif_capture.c: In function 'vpif_remove':
> drivers/media/platform/davinci/vpif_capture.c:1581:36: warning: iteration
> 1u invokes undefined behavior [-Waggressive-loop-optimizations]
>    vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
>                                     ^
> drivers/media/platform/davinci/vpif_capture.c:1577:2: note: containing loop
>   for (i = 0; i < VPIF_CAPTURE_MAX_DEVICES; i++) {
>   ^
> drivers/media/platform/davinci/vpif_capture.c:1580:23: warning: array subscript
> is above array bounds [-Warray-bounds]
>    common = &ch->common[i];
> 
> Reported-by: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  drivers/media/platform/davinci/vpif_capture.c | 2 +-
>  drivers/media/platform/davinci/vpif_display.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
> index 2f90f0d..3a85238 100644
> --- a/drivers/media/platform/davinci/vpif_capture.c
> +++ b/drivers/media/platform/davinci/vpif_capture.c
> @@ -1577,7 +1577,7 @@ static int vpif_remove(struct platform_device *device)
>  	for (i = 0; i < VPIF_CAPTURE_MAX_DEVICES; i++) {
>  		/* Get the pointer to the channel object */
>  		ch = vpif_obj.dev[i];
> -		common = &ch->common[i];
> +		common = &ch->common[VPIF_VIDEO_INDEX];

You could refer to the alloc_ctz directly w/o extra local variables. Also
local variables that are only used inside the loop could be declared there
as well.

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

>  		vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
>  		/* Unregister video device */
>  		video_unregister_device(ch->video_dev);
> diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
> index 0bd6dcb..6c6bd6b 100644
> --- a/drivers/media/platform/davinci/vpif_display.c
> +++ b/drivers/media/platform/davinci/vpif_display.c
> @@ -1385,7 +1385,7 @@ static int vpif_remove(struct platform_device *device)
>  	for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++) {
>  		/* Get the pointer to the channel object */
>  		ch = vpif_obj.dev[i];
> -		common = &ch->common[i];
> +		common = &ch->common[VPIF_VIDEO_INDEX];
>  		vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
>  		/* Unregister video device */
>  		video_unregister_device(ch->video_dev);

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
