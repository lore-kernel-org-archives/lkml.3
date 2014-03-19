Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbaCSGuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 02:50:39 -0400
Received: from smtprelay0092.hostedemail.com ([216.40.44.92]:45705 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752021AbaCSGuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 02:50:37 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:901:960:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3622:3657:3865:3866:3868:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4605:5007:7652:9025:9388:10004:10049:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:12679:12740,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:no
X-HE-Tag: bead92_7994324b8052e
X-Filterd-Recvd-Size: 3568
Message-ID: <1395211832.8649.40.camel@joe-AO722>
Subject: Re: [PATCH] virtio-blk: make the queue depth configurable
From: Joe Perches <joe@perches.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, fes@google.com,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Tue, 18 Mar 2014 23:50:32 -0700
In-Reply-To: <87zjkmr8w1.fsf@rustcorp.com.au>
References: <1394818263-29947-1-git-send-email-tytso@mit.edu>
	 <1394818720.3253.1.camel@joe-AO722> <20140314180258.GA29201@thunk.org>
	 <87y509scl3.fsf@rustcorp.com.au> <1395032434.2556.10.camel@joe-AO722>
	 <1395041214.2556.17.camel@joe-AO722> <87zjkmr8w1.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-19 at 17:07 +1030, Rusty Russell wrote:

> Summary of http://lkml.org/lkml/2014/3/14/363 :
> 
>   Ted: module_param(queue_depth, int, 444)
>   Joe: 0444!
>   Rusty: User perms >= group perms >= other perms?
>   Joe: CLASS_ATTR, DEVICE_ATTR, SENSOR_ATTR and SENSOR_ATTR_2?

<smile>

Adding:

Rusty: Bikeshedding
Joe: Missing ((perm) & 2) ?

[]

> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 471090093c67..945afeb3058a 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -842,4 +842,13 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
>  # define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
>  #endif
>  
> +/* Permissions on a sysfs file: you didn't miss the 0 prefix did you? */
> +#define VERIFY_OCTAL_PERMISSIONS(perms)					\
> +	((__builtin_constant_p(perms) ?					\
> +	  BUILD_BUG_ON_ZERO((perms) < 0) +				\
> +	  BUILD_BUG_ON_ZERO((perms) > 0777) +				\
> +	  /* User perms >= group perms >= other perms */		\
> +	  BUILD_BUG_ON_ZERO(((perms) >> 6) < (((perms) >> 3) & 7)) +	\
> +	  BUILD_BUG_ON_ZERO((((perms) >> 3) & 7) < ((perms) & 7)): 0) +	\
> +	 (perms))
>  #endif
> diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
> index 175f6995d1af..204a67743804 100644
> --- a/include/linux/moduleparam.h
> +++ b/include/linux/moduleparam.h
> @@ -186,14 +186,12 @@ struct kparam_array
>     parameters. */
>  #define __module_param_call(prefix, name, ops, arg, perm, level)	\
>  	/* Default value instead of permissions? */			\
> -	static int __param_perm_check_##name __attribute__((unused)) =	\
> -	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2))	\

Now missing test for ((perm) & 2)

Dunno if that was ever necessary.

> -	+ BUILD_BUG_ON_ZERO(sizeof(""prefix) > MAX_PARAM_PREFIX_LEN);	\
> -	static const char __param_str_##name[] = prefix #name;		\
> +	static const char __param_str_##name[] = prefix #name; \
>  	static struct kernel_param __moduleparam_const __param_##name	\
>  	__used								\
>      __attribute__ ((unused,__section__ ("__param"),aligned(sizeof(void *)))) \
> -	= { __param_str_##name, ops, perm, level, { arg } }
> +	= { __param_str_##name, ops, VERIFY_OCTAL_PERMISSIONS(perm),	\
> +	    level, { arg } }


