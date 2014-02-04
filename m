Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935902AbaBDWxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:53:55 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:47381 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933252AbaBDWxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 17:53:54 -0500
Date: Tue, 4 Feb 2014 23:53:40 +0100
From: Sabrina Dubroca <sd@queasysnail.net>
To: Dave Airlie <airlied@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [3.14-rc1] cirrus driver problem (qemu)
Message-ID: <20140204225340.GB12991@kria>
References: <20140203153413.GA12991@kria>
 <CAPM=9twWniCmKNb1vxjS_PbsTqimX6EWVusA_+GZ7H9fdhQj3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPM=9twWniCmKNb1vxjS_PbsTqimX6EWVusA_+GZ7H9fdhQj3A@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-04, 13:20:54 +1000, Dave Airlie wrote:
> On Tue, Feb 4, 2014 at 1:34 AM, Sabrina Dubroca <sd@queasysnail.net> wrote:
> > When I boot 3.14-rc1 in qemu, I get the trace below. The console stops
> > updating and I don't get a login prompt. I can login, but I can't see
> > what I'm doing. I can login normally via SSH.
> >
> > If I revert the last commit in drivers/gpu/drm/cirrus:
> >
> > f4b4718b61d1d5a7442a4fd6863ea80c3a10e508 drm: ast,cirrus,mgag200: use drm_can_sleep
> >
> > the problem is solved.
> >
> 
> Hi does the attach patch fix it?
> 
> Dave.


Same problem. Didn't you reverse the logic on in_interrupt, compared
to the old "if (!in_interrupt())" ? It looks like drm_can_sleep() is
false when in_interrupt() is true.

I modified your patch as below. Display doesn't freeze, but I still
get the warning.

Thanks,
Sabrina

---
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index 04086c5..6ab14455f 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -1696,7 +1696,7 @@ extern int drm_platform_init(struct drm_driver *driver, struct platform_device *
 /* returns true if currently okay to sleep */
 static __inline__ bool drm_can_sleep(void)
 {
-	if (in_atomic() || in_dbg_master() || irqs_disabled())
+	if (in_atomic() || in_dbg_master() || !in_interrupt() || irqs_disabled())
 		return false;
 	return true;
 }

