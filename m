Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475AbaCQH1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 03:27:09 -0400
Received: from smtprelay0107.hostedemail.com ([216.40.44.107]:50998 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756256AbaCQH1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 03:27:08 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3866:3867:3868:3870:3871:3872:4321:5007:7652:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crow23_1f66186189919
X-Filterd-Recvd-Size: 3031
Message-ID: <1395041214.2556.17.camel@joe-AO722>
Subject: Re: [PATCH] virtio-blk: make the queue depth configurable
From: Joe Perches <joe@perches.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, fes@google.com
Date: Mon, 17 Mar 2014 00:26:54 -0700
In-Reply-To: <1395032434.2556.10.camel@joe-AO722>
References: <1394818263-29947-1-git-send-email-tytso@mit.edu>
	 <1394818720.3253.1.camel@joe-AO722> <20140314180258.GA29201@thunk.org>
	 <87y509scl3.fsf@rustcorp.com.au> <1395032434.2556.10.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-03-16 at 22:00 -0700, Joe Perches wrote:
> On Mon, 2014-03-17 at 14:25 +1030, Rusty Russell wrote:
> 
> > Erk, our tests are insufficient.  Testbuilding an allmodconfig with this
> > now:
> 
> Good idea.
> 
> > diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
> []
> > @@ -188,6 +188,9 @@ struct kparam_array
> >  	/* Default value instead of permissions? */			\
> >  	static int __param_perm_check_##name __attribute__((unused)) =	\
> >  	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2))	\
> > +	/* User perms >= group perms >= other perms. */			\
> > +	+ BUILD_BUG_ON_ZERO(((perm) >> 6) < (((perm) >> 3) & 7))	\
> > +	+ BUILD_BUG_ON_ZERO((((perm) >> 3) & 7) < ((perm) & 7))		\
> >  	+ BUILD_BUG_ON_ZERO(sizeof(""prefix) > MAX_PARAM_PREFIX_LEN);	\
> >  	static const char __param_str_##name[] = prefix #name;		\
> >  	static struct kernel_param __moduleparam_const __param_##name	\
> 
> It might make sense to separate this octal permissions
> test into a new macro for other checks in macros like
> CLASS_ATTR, DEVICE_ATTR, SENSOR_ATTR and SENSOR_ATTR_2.
> 
> Maybe something like:
> 
> #define VERIFY_OCTAL_PERMISSIONS(perm)					\
> 	static int __param_perm_check_##name __attribute__((unused)) =	\
> 	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2))	\
> 	/* User perms >= group perms >= other perms. */			\
> 	+ BUILD_BUG_ON_ZERO(((perm) >> 6) < (((perm) >> 3) & 7))	\
> 	+ BUILD_BUG_ON_ZERO((((perm) >> 3) & 7) < ((perm) & 7));	\

Maybe this is better:

#define VERIFY_OCTAL_PERMISSIONS(perms)					\
({									\
	if (__builtin_constant_p(perms)) {				\
		BUILD_BUG_ON((perms) < 0);				\
		BUILD_BUG_ON((perms) > 0777);				\
		/* User perms >= group perms >= other perms */		\
		BUILD_BUG_ON(((perms) >> 6) < (((perms) >> 3) & 7));	\
		BUILD_BUG_ON((((perms) >> 3) & 7) < ((perms) & 7));	\
	}								\
	;								\
})


