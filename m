Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaCQEk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 00:40:27 -0400
Received: from ozlabs.org ([203.10.76.45]:60082 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbaCQEjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 00:39:32 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Theodore Ts'o" <tytso@mit.edu>, Joe Perches <joe@perches.com>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, fes@google.com
Subject: Re: [PATCH] virtio-blk: make the queue depth configurable
In-Reply-To: <20140314180258.GA29201@thunk.org>
References: <1394818263-29947-1-git-send-email-tytso@mit.edu> <1394818720.3253.1.camel@joe-AO722> <20140314180258.GA29201@thunk.org>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Mon, 17 Mar 2014 14:25:52 +1030
Message-ID: <87y509scl3.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Ts'o <tytso@mit.edu> writes:
> On Fri, Mar 14, 2014 at 10:38:40AM -0700, Joe Perches wrote:
>> > +static int queue_depth = 64;
>> > +module_param(queue_depth, int, 444);
>> 
>> 444?  Really Ted?
>
> Oops, *blush*.   Thanks for catching that.

Erk, our tests are insufficient.  Testbuilding an allmodconfig with this
now:

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 175f6995d1af..626b85888a6b 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -188,6 +188,9 @@ struct kparam_array
 	/* Default value instead of permissions? */			\
 	static int __param_perm_check_##name __attribute__((unused)) =	\
 	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2))	\
+	/* User perms >= group perms >= other perms. */			\
+	+ BUILD_BUG_ON_ZERO(((perm) >> 6) < (((perm) >> 3) & 7))	\
+	+ BUILD_BUG_ON_ZERO((((perm) >> 3) & 7) < ((perm) & 7))		\
 	+ BUILD_BUG_ON_ZERO(sizeof(""prefix) > MAX_PARAM_PREFIX_LEN);	\
 	static const char __param_str_##name[] = prefix #name;		\
 	static struct kernel_param __moduleparam_const __param_##name	\


