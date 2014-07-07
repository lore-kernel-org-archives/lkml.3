Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841AbaGGGka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 02:40:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbaGGGk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 02:40:26 -0400
Date: Mon, 7 Jul 2014 12:09:56 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jason Cooper <jason@lakedaemon.net>,
        "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] hwrng: fetch randomness only after device init
Message-ID: <20140707063956.GE27024@grmbl.mre>
References: <cover.1404538109.git.amit.shah@redhat.com>
 <515a12ecc5fca5452bf0bfda4d54546d8fb5829c.1404538109.git.amit.shah@redhat.com>
 <CAGXu5j+j1LUv_rRpf=03nRfu=Sek5O8TUs8R066JvfbUgT9ZQQ@mail.gmail.com>
 <20140707055352.GB27024@grmbl.mre>
 <20140707060458.GC27024@grmbl.mre>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140707060458.GC27024@grmbl.mre>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Mon) 07 Jul 2014 [11:34:58], Amit Shah wrote:
> On (Mon) 07 Jul 2014 [11:23:52], Amit Shah wrote:
> > On (Sun) 06 Jul 2014 [21:41:47], Kees Cook wrote:
> > > On Fri, Jul 4, 2014 at 10:34 PM, Amit Shah <amit.shah@redhat.com> wrote:
> > > > Commit d9e7972619334 "hwrng: add randomness to system from rng sources"
> > > > added a call to rng_get_data() from the hwrng_register() function.
> > > > However, some rng devices need initialization before data can be read
> > > > from them.
> > > >
> > > > This commit makes the call to rng_get_data() depend on no init fn
> > > > pointer being registered by the device.  If an init function is
> > > > registered, this call is made after device init.
> > > 
> > > Thanks, this seems pretty reasonable. One side-effect is that cycling
> > > between hwrngs via sysfs (when they have init functions) will cause
> > > them to add more entropy. I don't think this is a problem, but it is
> > > kind of a weird side-effect.
> > 
> > Yes, agreed.  Having a per-device bool that indicates whether the
> > initial randomness is obtained is quite a heavy solution for this
> > side-effect.  But I can put this in the commit log so it's clear..
> 
> Well actually this feels a little weird, so how about making this the
> default behaviour for all devices, whether they have ->init() or not?
> 
> This also means that if a virtio-rng device is switched, it can
> contribute as its probe would have been over.

Something like this - untested:

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 50f5b76..c4419ea 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -81,17 +81,15 @@ static void add_early_randomness(struct hwrng *rng)
 
 static inline int hwrng_init(struct hwrng *rng)
 {
-       int ret;
-
-       if (!rng->init)
-               return 0;
-
-       ret =  rng->init(rng);
-       if (ret)
-               return ret;
+       if (rng->init) {
+               int ret;
 
+               ret =  rng->init(rng);
+               if (ret)
+                       return ret;
+       }
        add_early_randomness(rng);
-       return ret;
+       return 0;
 }
 
 static inline void hwrng_cleanup(struct hwrng *rng)
@@ -372,8 +370,16 @@ int hwrng_register(struct hwrng *rng)
        INIT_LIST_HEAD(&rng->list);
        list_add_tail(&rng->list, &rng_list);
 
-       if (!rng->init)
+       if (old_rng && !rng->init) {
+               /*
+                * Use a new device's input to add some randomness to
+                * the system.  If this rng device isn't going to be
+                * used right away, its init function hasn't been
+                * called yet; so only use the randomness from devices
+                * that don't need an init callback.
+                */
                add_early_randomness(rng);
+       }
 
 out_unlock:
        mutex_unlock(&rng_mutex);


		Amit
