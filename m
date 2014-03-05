Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844AbaCEUcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 15:32:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54030 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbaCEUcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 15:32:52 -0500
Date: Wed, 5 Mar 2014 12:32:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jean Delvare <khali@linux-fr.org>, Li Zhong <zhong@linux.vnet.ibm.com>,
        Jon Mason <jon.mason@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] Taint the kernel for unsafe module options
Message-Id: <20140305123250.8caa9c6abc2b40d812bbb1b2@linux-foundation.org>
In-Reply-To: <1394011994-30604-1-git-send-email-daniel.vetter@ffwll.ch>
References: <1394011994-30604-1-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  5 Mar 2014 10:33:14 +0100 Daniel Vetter <daniel.vetter@ffwll.ch> wrote:

> Users just love to set random piles of options since surely enabling
> all the experimental stuff helps. Later on we get bug reports because
> it all fell apart.
> 
> Even more fun when it's labelled a regression when some change only
> just made the feature possible (e.g. stolen memory fixes suddenly
> making fbc possible).
> 
> Make it clear that users are playing with fire here. In drm/i915 all
> these options follow the same pattern of using -1 as the per-machine
> default, and any other value being used for force the parameter.
> 
> Adding a pile of cc's to solicit input and figure out whether this
> would be generally useful - this quick rfc is just for drm/i915.

Seems harmless and potentially useful to others so yes, I'd vote for
putting it in core kernel.

However this only handles integers.  Will we end up needed great gobs
of new code to detect unsafe setting of u8's, strings, etc?


> --- a/drivers/gpu/drm/i915/i915_params.c
> +++ b/drivers/gpu/drm/i915/i915_params.c

The patch adds lots of trailing whitespace.  checkpatch is ->thattaway.

> @@ -50,7 +50,46 @@ struct i915_params i915 __read_mostly = {
>  	.disable_display = 0,
>  };
>  
> -module_param_named(modeset, i915.modeset, int, 0400);
> +int param_set_unsafe_int(const char *val, const struct kernel_param *kp)
> +{
> +	long l;
> +	int ret;
> +
> +	ret = kstrtol(val, 0, &l);
> +	if (ret < 0 || ((int)l != l))
> +		return ret < 0 ? ret : -EINVAL;

That's a bit screwy.  Simpler:

	if (ret < 0)
		return ret;
	if ((int)l != l)
		return -EINVAL;


> +	/* Taint if userspace overrides the kernel defaults. */
> +	if (l != -1) {
> +		printk(KERN_WARNING "Setting dangerous option %s to non-default value!\n",
> +		       kp->name);

pr_warn() is nicer.

> +		add_taint(TAINT_USER, LOCKDEP_STILL_OK);
> +	}
> +
> +	*((int *)kp->arg) = l;
> +	return 0;
> +}
>
> ...
>
