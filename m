Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001Ab3G3Tic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 15:38:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756059Ab3G3Tib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 15:38:31 -0400
Date: Tue, 30 Jul 2013 15:38:06 -0400
From: Dave Jones <davej@redhat.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, daniel.vetter@ffwll.ch,
        airlied@redhat.com, Ben Widawsky <ben@bwidawsk.net>
Subject: Re: i915 debug spew during boot.
Message-ID: <20130730193805.GA11633@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>, daniel.vetter@ffwll.ch,
	airlied@redhat.com, Ben Widawsky <ben@bwidawsk.net>
References: <20130729195431.GA3540@redhat.com>
 <20130729210429.GB27041@cantiga.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130729210429.GB27041@cantiga.alporthouse.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 10:04:29PM +0100, Chris Wilson wrote:

 > Whoops, we spotted that error and fixed it in the next tree, but forgot
 > to send a fix for stable as well.
 > ... 
 >
 > +}
 > +
 > +void intel_pm_init(struct drm_device *dev)
 > +{
 >  	INIT_DELAYED_WORK(&dev_priv->rps.delayed_resume_work,
 >  			  intel_gen6_powersave_work);
 >  }

This doesn't compile.

  LD      drivers/gpu/drm/drm_kms_helper.o
  LD      drivers/gpu/drm/drm.o
  CC      drivers/gpu/drm/i915/intel_pm.o
drivers/gpu/drm/i915/intel_pm.c: In function ‘intel_pm_init’:
drivers/gpu/drm/i915/intel_pm.c:5543:70: error: ‘dev_priv’ undeclared (first use in this function)
  INIT_DELAYED_WORK(&dev_priv->rps.delayed_resume_work,
                                                                      ^
drivers/gpu/drm/i915/intel_pm.c:5543:70: note: each undeclared identifier is reported only once for each function it appears in
make[4]: *** [drivers/gpu/drm/i915/intel_pm.o] Error 1

Needs this on top:


diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index 1235d71..f895d15 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -5540,6 +5540,8 @@ void intel_gt_init(struct drm_device *dev)
 
 void intel_pm_init(struct drm_device *dev)
 {
+	struct drm_i915_private *dev_priv = dev->dev_private;
+
 	INIT_DELAYED_WORK(&dev_priv->rps.delayed_resume_work,
 			  intel_gen6_powersave_work);
 }
