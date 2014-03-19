Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965631AbaCSQFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 12:05:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42802 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965600AbaCSQFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 12:05:04 -0400
Date: Wed, 19 Mar 2014 09:07:07 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Joe Perches <joe@perches.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, fes@google.com,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH] virtio-blk: make the queue depth configurable
Message-ID: <20140319160707.GA19820@kroah.com>
References: <1394818263-29947-1-git-send-email-tytso@mit.edu>
 <1394818720.3253.1.camel@joe-AO722>
 <20140314180258.GA29201@thunk.org>
 <87y509scl3.fsf@rustcorp.com.au>
 <1395032434.2556.10.camel@joe-AO722>
 <1395041214.2556.17.camel@joe-AO722>
 <87zjkmr8w1.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zjkmr8w1.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 05:07:50PM +1030, Rusty Russell wrote:
> Joe Perches <joe@perches.com> writes:
> > On Sun, 2014-03-16 at 22:00 -0700, Joe Perches wrote:
> >> On Mon, 2014-03-17 at 14:25 +1030, Rusty Russell wrote:
> >> 
> >> > Erk, our tests are insufficient.  Testbuilding an allmodconfig with this
> >> > now:
> >> 
> >> Good idea.
> >> 
> >> > diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
> >> []
> >> > @@ -188,6 +188,9 @@ struct kparam_array
> >> >  	/* Default value instead of permissions? */			\
> >> >  	static int __param_perm_check_##name __attribute__((unused)) =	\
> >> >  	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2))	\
> >> > +	/* User perms >= group perms >= other perms. */			\
> >> > +	+ BUILD_BUG_ON_ZERO(((perm) >> 6) < (((perm) >> 3) & 7))	\
> >> > +	+ BUILD_BUG_ON_ZERO((((perm) >> 3) & 7) < ((perm) & 7))		\
> >> >  	+ BUILD_BUG_ON_ZERO(sizeof(""prefix) > MAX_PARAM_PREFIX_LEN);	\
> >> >  	static const char __param_str_##name[] = prefix #name;		\
> >> >  	static struct kernel_param __moduleparam_const __param_##name	\
> >> 
> >> It might make sense to separate this octal permissions
> >> test into a new macro for other checks in macros like
> >> CLASS_ATTR, DEVICE_ATTR, SENSOR_ATTR and SENSOR_ATTR_2.
> 
> OK, I took your bikeshed and re-painted it below.
> 
> > #define VERIFY_OCTAL_PERMISSIONS(perms)					\
> > ({									\
> > 	if (__builtin_constant_p(perms)) {				\
> > 		BUILD_BUG_ON((perms) < 0);				\
> > 		BUILD_BUG_ON((perms) > 0777);				\
> > 		/* User perms >= group perms >= other perms */		\
> > 		BUILD_BUG_ON(((perms) >> 6) < (((perms) >> 3) & 7));	\
> > 		BUILD_BUG_ON((((perms) >> 3) & 7) < ((perms) & 7));	\
> > 	}								\
> > 	;								\
> > })
> 
> Subject: VERIFY_OCTAL_PERMISSIONS: stricter checking for sysfs perms.
> 
> Summary of http://lkml.org/lkml/2014/3/14/363 :
> 
>   Ted: module_param(queue_depth, int, 444)
>   Joe: 0444!
>   Rusty: User perms >= group perms >= other perms?
>   Joe: CLASS_ATTR, DEVICE_ATTR, SENSOR_ATTR and SENSOR_ATTR_2?
> 
> Side effect of stricter permissions means removing the unnecessary
> S_IFREG from drivers/pci/slot.c.
> 
> Suggested-by: Joe Perches <joe@perches.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

