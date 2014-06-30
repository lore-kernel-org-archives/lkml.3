Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbaF3HAQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 03:00:16 -0400
Received: from mail.fireflyinternet.com ([87.106.93.118]:54984 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754554AbaF3HAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 03:00:14 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Date: Mon, 30 Jun 2014 07:59:55 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Ed Tomlinson <edt@aei.ca>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Herrmann <dh.herrmann@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Dave Airlie <airlied@linux.ie>
Subject: Re: [PATCH 5/5] drm/i915: Kick out vga console
Message-ID: <20140630065955.GD7687@nuc-i3427.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Ed Tomlinson <edt@aei.ca>, Daniel Vetter <daniel.vetter@ffwll.ch>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>,
	David Herrmann <dh.herrmann@gmail.com>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Dave Airlie <airlied@linux.ie>
References: <1401980308-5116-1-git-send-email-daniel.vetter@ffwll.ch>
 <1401980308-5116-5-git-send-email-daniel.vetter@ffwll.ch>
 <1602327.OGkKxHtt2b@grover>
 <3945293.Jtp4nyZMfX@grover>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3945293.Jtp4nyZMfX@grover>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 28, 2014 at 11:55:19PM -0400, Ed Tomlinson wrote:
> On Saturday 28 June 2014 15:28:22 Ed Tomlinson wrote:
> 
> Resend without html krud which causes list to bounce the message.
> 
> > Hi
> > 
> > This commit ( a4de05268e674e8ed31df6348269e22d6c6a1803 ) hangs my boot with 3.16-git.  Reverting it lets the boot proceed. 
> > 
> > I have an i7 with a built-in i915 and an pcie r7 260x.  The R7 is the primary console.  The i915 is initialized
> > but does not have a physical display attached.
> > 
> > With the patch applied the boot stops at the messages:
> > 
> > [drm] Memory usable by graphics device = 2048M
> > [drm] Replacing VGA console driver

The issue looks like that we are ripping out the radeon fb_con whilst it
is active and that upsets everyone. In which case, I think the
compromise is:


diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 5f44581..4915f1d 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1439,18 +1439,20 @@ static int i915_kick_out_vgacon(struct drm_i915_private *dev_priv)
 #else
 static int i915_kick_out_vgacon(struct drm_i915_private *dev_priv)
 {
-       int ret;
+       int ret = 0;
 
        DRM_INFO("Replacing VGA console driver\n");
 
        console_lock();
-       ret = do_take_over_console(&dummy_con, 0, MAX_NR_CONSOLES - 1, 1);
-       if (ret == 0) {
-               ret = do_unregister_con_driver(&vga_con);
-
-               /* Ignore "already unregistered". */
-               if (ret == -ENODEV)
-                       ret = 0;
+       if (con_is_bound(&vga_con)) {
+               ret = do_take_over_console(&dummy_con, 0, MAX_NR_CONSOLES - 1, 1);
+               if (ret == 0) {
+                       ret = do_unregister_con_driver(&vga_con);
+
+                       /* Ignore "already unregistered". */
+                       if (ret == -ENODEV)
+                               ret = 0;
+               }
        }
        console_unlock();

-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
