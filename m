Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbaGBWSl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 18:18:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbaGBWSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 18:18:40 -0400
Date: Wed, 2 Jul 2014 18:18:22 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jingoo Han <jg1.han@samsung.com>, Alexandru Juncu <alexj@rosedu.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Joe Perches <joe@perches.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video: fbdev: matrox: matroxfb_base.c:  Fix for possible
 null pointer dereference
In-Reply-To: <1404337551-6499-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Message-ID: <alpine.LRH.2.02.1407021815130.17688@file01.intranet.prod.int.rdu2.redhat.com>
References: <1404337551-6499-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 Jul 2014, Rickard Strandqvist wrote:

> Fix a possible null pointer dereference, there is otherwise a risk of a 
> possible null pointer dereference
> 
> This was found using a static code analysis program called cppcheck
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/video/fbdev/matrox/matroxfb_base.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/video/fbdev/matrox/matroxfb_base.c b/drivers/video/fbdev/matrox/matroxfb_base.c
> index 7116c53..85ef84b 100644
> --- a/drivers/video/fbdev/matrox/matroxfb_base.c
> +++ b/drivers/video/fbdev/matrox/matroxfb_base.c
> @@ -1971,9 +1971,9 @@ static void matroxfb_register_device(struct matrox_fb_info* minfo) {
>  	int i = 0;
>  	list_add(&minfo->next_fb, &matroxfb_list);
>  	for (drv = matroxfb_driver_l(matroxfb_driver_list.next);
> -	     drv != matroxfb_driver_l(&matroxfb_driver_list);
> +	     drv && drv != matroxfb_driver_l(&matroxfb_driver_list);

The "drv" check is pointless because drv can't be NULL - use the patch 
below.

>  	     drv = matroxfb_driver_l(drv->node.next)) {
> -		if (drv && drv->probe) {
> +		if (drv->probe) {
>  			void *p = drv->probe(minfo);
>  			if (p) {
>  				minfo->drivers_data[i] = p;
> -- 
> 1.7.10.4

matroxfb: delete pointless NULL-pointer check

The for loop walks a double-linked list, so drv cannot be NULL.

This patch deletes the pointless NULL-pointer check. cppcheck warned about
it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/video/fbdev/matrox/matroxfb_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/video/fbdev/matrox/matroxfb_base.c
===================================================================
--- linux-2.6.orig/drivers/video/fbdev/matrox/matroxfb_base.c	2014-06-19 16:41:45.048259897 +0200
+++ linux-2.6/drivers/video/fbdev/matrox/matroxfb_base.c	2014-07-03 00:13:04.299380130 +0200
@@ -1973,7 +1973,7 @@ static void matroxfb_register_device(str
 	for (drv = matroxfb_driver_l(matroxfb_driver_list.next);
 	     drv != matroxfb_driver_l(&matroxfb_driver_list);
 	     drv = matroxfb_driver_l(drv->node.next)) {
-		if (drv && drv->probe) {
+		if (drv->probe) {
 			void *p = drv->probe(minfo);
 			if (p) {
 				minfo->drivers_data[i] = p;
