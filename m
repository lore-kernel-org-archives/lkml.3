Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbaACWau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 17:30:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51314 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbaACWat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 17:30:49 -0500
Date: Fri, 3 Jan 2014 14:30:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] Make for_each_child_of_node() reference its args
 when CONFIG_OF=n
Message-Id: <20140103143048.ee945c557167755871f23c5f@linux-foundation.org>
In-Reply-To: <20140103160723.8153.14334.stgit@warthog.procyon.org.uk>
References: <20140103160723.8153.14334.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: [PATCH 1/7] Make for_each_child_of_node() reference its args when CONFIG_OF=n

Nit: Documentation/SubmittingPatches, section 15.  "subsystem: " is
missing from all patche titles.

On Fri, 03 Jan 2014 16:07:23 +0000 David Howells <dhowells@redhat.com> wrote:

> Make for_each_child_of_node() reference its args when CONFIG_OF=n to avoid
> warnings like:
> 
> 	drivers/leds/leds-pwm.c:88:22: warning: unused variable 'node' [-Wunused-variable]
> 	  struct device_node *node = pdev->dev.of_node;
> 			      ^
> ...
>
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -377,8 +377,13 @@ static inline bool of_have_populated_dt(void)
>  	return false;
>  }
>  
> +/* Kill an unused variable warning on a device_node pointer */
> +static inline void __of_use_dn(const struct device_node *np)
> +{
> +}
> +
>  #define for_each_child_of_node(parent, child) \
> -	while (0)
> +	while (__of_use_dn(parent), __of_use_dn(child), 0)
>  
>  #define for_each_available_child_of_node(parent, child) \
>  	while (0)

That's a bit ugly.  __maybe_unused fixes it appropriately but can't be
placed into the macro.


I wonder if we should instead generalise it to

static inline void reference_var_to_squish_gcc_warning(const void *p)
{
}

I guess not, until/unless we find other macros which need the same
treatment.


Yes, passing a var to an empty function suppresses the warning.  But is
this intentional or a happy accident?  Future gcc's could quite
legitimately be enhanced to detect that the arg is still unused and
then we'd need to find a new way of suppressing the warning, if such
exists.

