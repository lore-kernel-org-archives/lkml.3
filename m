Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab3IYWIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 18:08:44 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:62938 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab3IYWIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 18:08:43 -0400
Date: Wed, 25 Sep 2013 15:08:38 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, khali@linux-fr.org,
        lm-sensors@lm-sensors.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        bugzilla@colorremedies.com
Subject: Re: applesmc oops in 3.10/3.11
Message-ID: <20130925220838.GB4184@roeck-us.net>
References: <CA+5PVA5mmLPEqM2r5=fBN4sM4LLacynn8R1tewObsX35e4_TfA@mail.gmail.com>
 <20130925195628.GA1532@roeck-us.net>
 <20130925214807.GA3234@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925214807.GA3234@polaris.bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 11:48:07PM +0200, Henrik Rydberg wrote:
> On Wed, Sep 25, 2013 at 12:56:28PM -0700, Guenter Roeck wrote:
> > On Wed, Sep 25, 2013 at 03:06:25PM -0400, Josh Boyer wrote:
> > > Hi All,
> > > 
> > > Chris has reported[1] an issue with the applesmc driver in the 3.10
> > > and 3.11 kernels.  This seems to be a bit transient, but the oops is
> > > consistent across those releases.  This is with a MacBook Pro 4,1.
> > > The backtrace is below.
> > > 
> > > Any ideas on this one?
> > > 
> > Some of the bug reports suggest that there are related messages in at least some
> > of the kernel logs.
> > 
> > Jul 02 22:23:22 f19s.local kernel: applesmc: send_byte(0x04, 0x0300) fail: 0x01
> > Jul 02 22:23:22 f19s.local kernel: applesmc: : read len fail
> > 
> > This suggests that initialization may be attempted more than once. The key cache
> > is allocated only once, but the number of keys is read for each attempt.
> > 
> > No idea if that can happen, but if the number of keys can increase after
> > the first initialization attempt you would have an explanation for the crash.
> 
> Good idea, and easy enough to test with the patch below.
> 
Should we apply this patch even though it may not solve the specific problem ?

Again, not sure if the key count can change, but the current code is at the very
least inconsistent, as it keeps reading the key count without updating or
verifying the cache size.

Thanks,
Guenter

> diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
> index 62c2e32..d962c4d 100644
> --- a/drivers/hwmon/applesmc.c
> +++ b/drivers/hwmon/applesmc.c
> @@ -525,16 +525,24 @@ static int applesmc_init_smcreg_try(void)
>  {
>         struct applesmc_registers *s = &smcreg;
>         bool left_light_sensor, right_light_sensor;
> +       unsigned int count;
>         u8 tmp[1];
>         int ret;
>  
>         if (s->init_complete)
>                 return 0;
>  
> -       ret = read_register_count(&s->key_count);
> +       ret = read_register_count(&count);
>         if (ret)
>                 return ret;
>  
> +       if (s->cache && s->key_count != count) {
> +               pr_warn("key count changed from %d to %d\n", s->key_count, count);
> +               kfree(s->cache);
> +               s->cache = NULL;
> +       }
> +       s->key_count = count;
> +
>         if (!s->cache)
>                 s->cache = kcalloc(s->key_count, sizeof(*s->cache), GFP_KERNEL);
>         if (!s->cache)
>  
> Thanks,
> Henrik
> 
