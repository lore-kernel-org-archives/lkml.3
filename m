Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416AbaBKSSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 13:18:22 -0500
Received: from alt-proxy90.mail.unifiedlayer.com ([74.220.215.9]:56279 "HELO
	alt-proxy90.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752378AbaBKSSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 13:18:20 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Feb 2014 13:18:19 EST
Date: Tue, 11 Feb 2014 10:11:37 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Baytrail/T (ASUS T100 etc) regression from 3.13 onwards
Message-ID: <20140211101137.23b2274b@jbarnes-desktop>
In-Reply-To: <20140211163541.GB12567@kroah.com>
References: <CA+55aFwLXnW-GWKNcUCrpS5e7fd_0ZoKk83H4qMJNUS_WCF_3A@mail.gmail.com>
	<20140114120103.436d190b@alan.etchedpixels.co.uk>
	<20140211142203.77561e0f@alan.etchedpixels.co.uk>
	<20140211163541.GB12567@kroah.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Feb 2014 08:35:41 -0800
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Tue, Feb 11, 2014 at 02:22:03PM +0000, One Thousand Gnomes wrote:
> > On Tue, 14 Jan 2014 12:01:03 +0000
> > One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk> wrote:
> > 
> > > On Sun, 12 Jan 2014 20:33:03 +0700
> > > Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > > 
> > > > Another week, another RC. And things look fine.
> > > 
> > > It seems to hate Baytrail/T
> > > 
> > > My ASUS T100TA has gone from 3.11 'needs video=VGA-1:blah' to get the mode
> > > right but otherwise running nicely and playing 3D games to 3.13-rc8
> > 
> > This has now been pinned down to (confirmed by multiple people)
> > 
> > commit 6c4a8962a4a078cacfc8eb5d4bd79f6343b8cd7a
> > Author: Jesse Barnes <jbarnes@virtuousgeek.org>
> > Date:   Tue Sep 10 14:54:42 2013 -0700
> > 
> >     drm/i915/vlv: re-enable hotplug detect based probing on VLV/BYT
> > 
> > 
> > which given this is affecting some of the top 10 Amazon selling new
> > laptops and has not been fixed for 3.14-rc should IMHO be reverted until
> > such time as any needed debugging for the MIPI panels is done for this
> > driver and the hotplug probing doesn't break the workarounds.
> > 
> > Likewise it wants pulling from any -stable backports.
> 
> I only see it in the 3.13 tree, so when this gets reverted in Linus's
> tree, can someone mark it for stable so I know to pick it up for
> 3.13-stable as well?

Ugg, so reverting a real fix to make the T100TA work by accident...
this is ugly.

According to the reg dumps, this is actually a MIPI panel we're failing
to bring up properly.  We're working on that issue, but in the
meantime, maybe something like the below would work for you?

-- 
Jesse Barnes, Intel Open Source Technology Center

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index 61fb9fc..adc16a5 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -155,6 +155,11 @@ module_param_named(prefault_disable, i915_prefault_disable, bool, 0600);
 MODULE_PARM_DESC(prefault_disable,
 		"Disable page prefaulting for pread/pwrite/reloc (default:false). For developers only.");
 
+bool i915_force_vga_hotplug __read_mostly;
+module_param_named(force_vga_hotplug, i915_force_vga_hotplug, bool, 0600);
+MODULE_PARM_DESC(force_vga_hotplug,
+		 "Force VGA hotplug detection to always return true (default: false)");
+
 static struct drm_driver driver;
 
 static const struct intel_device_info intel_i830_info = {
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 29e1e86..f7a5e98 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1918,6 +1918,7 @@ extern bool i915_fastboot __read_mostly;
 extern int i915_enable_pc8 __read_mostly;
 extern int i915_pc8_timeout __read_mostly;
 extern bool i915_prefault_disable __read_mostly;
+extern bool i915_force_vga_hotplug __read_mostly;
 
 extern int i915_suspend(struct drm_device *dev, pm_message_t state);
 extern int i915_resume(struct drm_device *dev);
diff --git a/drivers/gpu/drm/i915/intel_crt.c b/drivers/gpu/drm/i915/intel_crt.c
index e2e39e6..55531d6 100644
--- a/drivers/gpu/drm/i915/intel_crt.c
+++ b/drivers/gpu/drm/i915/intel_crt.c
@@ -434,6 +434,9 @@ static bool intel_crt_detect_hotplug(struct drm_connector *connector)
 	/* and put the bits back */
 	I915_WRITE(PORT_HOTPLUG_EN, orig);
 
+	if (i915_force_vga_hotplug)
+		ret = true;
+
 	return ret;
 }
 
