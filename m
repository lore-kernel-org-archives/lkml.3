Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711Ab3AXFVF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 00:21:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54005 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab3AXFU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 00:20:58 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <1359001345-3446-1-git-send-email-airlied@gmail.com>
References: <1359001345-3446-1-git-send-email-airlied@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] vgacon/vt: clear buffer attributes when we load a 512 character font
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 23 Jan 2013 23:20:45 -0600
To: Dave Airlie <airlied@gmail.com>, dri-devel@lists.freedesktop.org
CC: linux-kernel@vger.kernel.org
Message-ID: <b2122295-0a35-4aba-90f3-8306b92af78b@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should clear this bit presumably on switching either from or to 512-char mode, since the bit doesn't really make sense either way.

Dave Airlie <airlied@gmail.com> wrote:

>From: Dave Airlie <airlied@redhat.com>
>
>When we switch from 256->512 byte font rendering mode, it means the
>current contents of the screen is being reinterpreted. The bit that
>holds
>the high bit of the 9-bit font, may have been previously set, and thus
>the new font misrenders.
>
>The problem case we see is grub2 writes spaces with the bit set, so it
>ends up with data like 0x820, which gets reinterpreted into 0x120 char
>which the font translates into G with a circumflex. This flashes up on
>screen at boot and is quite ugly.
>
>A current side effect of this patch though is that any rendering on the
>screen changes color to a slightly darker color, but at least the
>screen
>no longer corrupts.
>
>Signed-off-by: Dave Airlie <airlied@redhat.com>
>---
> drivers/tty/vt/vt.c            |  2 +-
> drivers/video/console/vgacon.c | 19 ++++++++++++-------
> include/linux/vt_kern.h        |  1 +
> 3 files changed, 14 insertions(+), 8 deletions(-)
>
>diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
>index 8fd8968..c8067ae 100644
>--- a/drivers/tty/vt/vt.c
>+++ b/drivers/tty/vt/vt.c
>@@ -638,7 +638,7 @@ static inline void save_screen(struct vc_data *vc)
>  *	Redrawing of screen
>  */
> 
>-static void clear_buffer_attributes(struct vc_data *vc)
>+void clear_buffer_attributes(struct vc_data *vc)
> {
> 	unsigned short *p = (unsigned short *)vc->vc_origin;
> 	int count = vc->vc_screenbuf_size / 2;
>diff --git a/drivers/video/console/vgacon.c
>b/drivers/video/console/vgacon.c
>index d449a74..271b5d0 100644
>--- a/drivers/video/console/vgacon.c
>+++ b/drivers/video/console/vgacon.c
>@@ -1064,7 +1064,7 @@ static int vgacon_do_font_op(struct vgastate
>*state,char *arg,int set,int ch512)
> 	unsigned short video_port_status = vga_video_port_reg + 6;
> 	int font_select = 0x00, beg, i;
> 	char *charmap;
>-	
>+	bool clear_attribs = false;
> 	if (vga_video_type != VIDEO_TYPE_EGAM) {
> 		charmap = (char *) VGA_MAP_MEM(colourmap, 0);
> 		beg = 0x0e;
>@@ -1169,12 +1169,6 @@ static int vgacon_do_font_op(struct vgastate
>*state,char *arg,int set,int ch512)
> 
> 	/* if 512 char mode is already enabled don't re-enable it. */
> 	if ((set) && (ch512 != vga_512_chars)) {
>-		/* attribute controller */
>-		for (i = 0; i < MAX_NR_CONSOLES; i++) {
>-			struct vc_data *c = vc_cons[i].d;
>-			if (c && c->vc_sw == &vga_con)
>-				c->vc_hi_font_mask = ch512 ? 0x0800 : 0;
>-		}
> 		vga_512_chars = ch512;
> 		/* 256-char: enable intensity bit
> 		   512-char: disable intensity bit */
>@@ -1185,8 +1179,19 @@ static int vgacon_do_font_op(struct vgastate
>*state,char *arg,int set,int ch512)
> 		   it means, but it works, and it appears necessary */
> 		inb_p(video_port_status);
> 		vga_wattr(state->vgabase, VGA_AR_ENABLE_DISPLAY, 0);	
>+		clear_attribs = true;
> 	}
> 	raw_spin_unlock_irq(&vga_lock);
>+
>+	if (clear_attribs) {
>+		for (i = 0; i < MAX_NR_CONSOLES; i++) {
>+			struct vc_data *c = vc_cons[i].d;
>+			if (c && c->vc_sw == &vga_con) {
>+				clear_buffer_attributes(c);
>+				c->vc_hi_font_mask = ch512 ? 0x0800 : 0;
>+			}
>+		}
>+	}
> 	return 0;
> }
> 
>diff --git a/include/linux/vt_kern.h b/include/linux/vt_kern.h
>index 50ae7d0..1f55665 100644
>--- a/include/linux/vt_kern.h
>+++ b/include/linux/vt_kern.h
>@@ -47,6 +47,7 @@ int con_set_cmap(unsigned char __user *cmap);
> int con_get_cmap(unsigned char __user *cmap);
> void scrollback(struct vc_data *vc, int lines);
> void scrollfront(struct vc_data *vc, int lines);
>+void clear_buffer_attributes(struct vc_data *vc);
>void update_region(struct vc_data *vc, unsigned long start, int count);
> void redraw_screen(struct vc_data *vc, int is_switch);
> #define update_screen(x) redraw_screen(x, 0)

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
