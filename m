Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab3JCVgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 17:36:38 -0400
Received: from smtp.outflux.net ([198.145.64.163]:39166 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755227Ab3JCVgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 17:36:36 -0400
Date: Thu, 3 Oct 2013 14:36:25 -0700
From: Kees Cook <kees@outflux.net>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: keescook@chromium.org, jmorris@namei.org, linux-kernel@vger.kernel.org,
        james.l.morris@oracle.com, casey@schaufler-ca.com,
        linux-security-module@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: [PATCH] LSM: ModPin LSM for module loading restrictions
Message-ID: <20131003213625.GH5729@outflux.net>
References: <20130920203556.GA8726@www.outflux.net>
 <alpine.LRH.2.02.1309241124420.3782@tundra.namei.org>
 <alpine.LRH.2.02.1309241128430.3782@tundra.namei.org>
 <CAGXu5jJ9t7tet4Bx=VUaVmjp1C18iK-nLpQBgmXqgukoAmmd4A@mail.gmail.com>
 <20131003205515.GF5729@outflux.net>
 <201310040631.IIF39022.OVFOFQOtJSFHLM@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201310040631.IIF39022.OVFOFQOtJSFHLM@I-love.SAKURA.ne.jp>
Organization: Outflux
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 06:31:42AM +0900, Tetsuo Handa wrote:
> Kees Cook wrote:
> > +static int modpin_load_module(struct file *file)
> > +{
> > +   struct dentry *module_root;
> > +
> > +   if (!file) {
> > +           if (!modpin_enforced) {
> > +                   report_load_module(NULL, "old-api-pinning-ignored");
> > +                   return 0;
> > +           }
> > +
> > +           report_load_module(NULL, "old-api-denied");
> > +           return -EPERM;
> > +   }
> > +
> > +   module_root = file->f_path.mnt->mnt_root;
> > +
> > +   /* First loaded module defines the root for all others. */
> > +   spin_lock(&pinned_root_spinlock);
> > +   if (!pinned_root) {
> > +           pinned_root = dget(module_root);
> > +           /*
> > +            * Unlock now since it's only pinned_root we care about.
> > +            * In the worst case, we will (correctly) report pinning
> > +            * failures before we have announced that pinning is
> > +            * enabled. This would be purely cosmetic.
> > +            */
> > +           spin_unlock(&pinned_root_spinlock);
> > +           check_pinning_enforcement();
> > +           report_load_module(&file->f_path, "pinned");
> > +           return 0;
> > +   }
> > +   spin_unlock(&pinned_root_spinlock);
> 
> Firstly loaded module is usually in initramfs whereas subsequently loaded
> modules are usually on a hard disk partition.
> 
> This module is not meant for PC servers, is it?

This LSM is what Chrome OS uses for the module pinning logic. We do not use
an initramfs. This LSM could also be used for devices booting entirely from
CDROM or other R/O media.

I'm open to improvements, obviously. I imagine things like delayed
activation, where the initramfs triggers pinning in some way once it is
done loading modules from its filesystem, etc. But since I don't have any
real life examples of this, I'm writing the LSM as it currently is, used
without an initramfs. :)

-Kees

-- 
Kees Cook                                            @outflux.net
