Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751051AbaKYPEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 10:04:24 -0500
Received: from lists.s-osg.org ([54.187.51.154]:60558 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbaKYPEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 10:04:23 -0500
Date: Tue, 25 Nov 2014 13:04:16 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, LMML <linux-media@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH] media: exynos-gsc: fix build warning
Message-ID: <20141125130416.457e48b0@recife.lan>
In-Reply-To: <1416308268-22957-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1416308268-22957-1-git-send-email-prabhakar.csengg@gmail.com>
Organization: Samsung
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 18 Nov 2014 10:57:48 +0000
"Lad, Prabhakar" <prabhakar.csengg@gmail.com> escreveu:

> this patch fixes following build warning:
> 
> gsc-core.c:350:17: warning: 'low_plane' may be used uninitialized
> gsc-core.c:371:31: warning: 'high_plane' may be used uninitialized
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  drivers/media/platform/exynos-gsc/gsc-core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
> index 91d226b..6c71b17 100644
> --- a/drivers/media/platform/exynos-gsc/gsc-core.c
> +++ b/drivers/media/platform/exynos-gsc/gsc-core.c
> @@ -347,8 +347,8 @@ void gsc_set_prefbuf(struct gsc_dev *gsc, struct gsc_frame *frm)
>  		s_chk_addr = frm->addr.cb;
>  		s_chk_len = frm->payload[1];
>  	} else if (frm->fmt->num_planes == 3) {
> -		u32 low_addr, low_plane, mid_addr, mid_plane;
> -		u32 high_addr, high_plane;
> +		u32 low_addr, low_plane = 0, mid_addr, mid_plane;
> +		u32 high_addr, high_plane = 0;
>  		u32 t_min, t_max;
>  
>  		t_min = min3(frm->addr.y, frm->addr.cb, frm->addr.cr);

Actually, this just hides the error, without fixing.

If the address is not found, a real error occurs, and the address
is also invalid.

So, I think that the enclosed patch will be doing a better job fixing it.

Still, the entire code seems mostly useless on my eyes, as this function
seems to be used only for debugging purposes, and errors there aren't
actually handled properly.


[PATCH] [media] exynos-gsc: fix build warning

Fixes following build warnings:

gsc-core.c:350:17: warning: 'low_plane' may be used uninitialized
gsc-core.c:371:31: warning: 'high_plane' may be used uninitialized

Reported-by: Prabhakar Lad <prabhakar.csengg@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 91d226b8fe5c..3062e9fac6da 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -319,21 +319,22 @@ int gsc_enum_fmt_mplane(struct v4l2_fmtdesc *f)
 	return 0;
 }
 
-static u32 get_plane_info(struct gsc_frame *frm, u32 addr, u32 *index)
+static int get_plane_info(struct gsc_frame *frm, u32 addr, u32 *index, u32 *ret_addr)
 {
 	if (frm->addr.y == addr) {
 		*index = 0;
-		return frm->addr.y;
+		*ret_addr = frm->addr.y;
 	} else if (frm->addr.cb == addr) {
 		*index = 1;
-		return frm->addr.cb;
+		*ret_addr = frm->addr.cb;
 	} else if (frm->addr.cr == addr) {
 		*index = 2;
-		return frm->addr.cr;
+		*ret_addr = frm->addr.cr;
 	} else {
 		pr_err("Plane address is wrong");
 		return -EINVAL;
 	}
+	return 0;
 }
 
 void gsc_set_prefbuf(struct gsc_dev *gsc, struct gsc_frame *frm)
@@ -352,9 +353,11 @@ void gsc_set_prefbuf(struct gsc_dev *gsc, struct gsc_frame *frm)
 		u32 t_min, t_max;
 
 		t_min = min3(frm->addr.y, frm->addr.cb, frm->addr.cr);
-		low_addr = get_plane_info(frm, t_min, &low_plane);
+		if (get_plane_info(frm, t_min, &low_plane, &low_addr))
+			return;
 		t_max = max3(frm->addr.y, frm->addr.cb, frm->addr.cr);
-		high_addr = get_plane_info(frm, t_max, &high_plane);
+		if (get_plane_info(frm, t_max, &high_plane, &high_addr))
+			return;
 
 		mid_plane = 3 - (low_plane + high_plane);
 		if (mid_plane == 0)
