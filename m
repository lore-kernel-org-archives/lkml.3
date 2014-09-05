Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbaIECex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 22:34:53 -0400
Received: from ozlabs.org ([103.22.144.67]:41603 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755867AbaIECev convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 22:34:51 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Rustad\, Mark D" <mark.d.rustad@intel.com>
Cc: "Kirsher\, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] moduleparam: Resolve missing-field-initializer warning
In-Reply-To: <F8A4F5BF-C490-4099-9360-0C771451FF1D@intel.com>
References: <1409317709-5005-1-git-send-email-jeffrey.t.kirsher@intel.com> <87ha0skvrj.fsf@rustcorp.com.au> <F8A4F5BF-C490-4099-9360-0C771451FF1D@intel.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 05 Sep 2014 11:22:57 +0930
Message-ID: <87ppfakf46.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rustad, Mark D" <mark.d.rustad@intel.com> writes:
> On Aug 31, 2014, at 5:52 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>
>> Jeff Kirsher <jeffrey.t.kirsher@intel.com> writes:
>>> From: Mark Rustad <mark.d.rustad@intel.com>
>>> 
>>> Resolve a missing-field-initializer warning, that is produced
>>> by every reference to module_param_call, by using designated
>>> initialization for the first field. That is enough to silence
>>> the complaint.
>>> 
>>> Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
>>> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>>> ---
>>> include/linux/moduleparam.h | 2 +-
>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> Strange, I haven't seen this warning.  Compiler version?  And it's good
>> to quote the error message, so people can google it.
>
> The message is only seen when doing a W=2 build. I happened to be using gcc 4.8.3, but I think most versions would produce the warning when it is enabled. It can either be silenced by using even a single designated initializer as I did here, or providing values for all of the fields. Because of the number of references to the macro, this change silences many warnings in W=2 builds.
>
> One instance of the full warning message looks like this:
>
> /home/share/git/nn-mdr/include/linux/moduleparam.h:198:16: warning: missing initializer for field ‘free’ of ‘struct kernel_param_ops’ [-Wmissing-field-initializers]
>   static struct kernel_param_ops __param_ops_##name =  \
>                 ^
> /home/share/git/nn-mdr/fs/fuse/inode.c:35:1: note: in expansion of macro ‘module_param_call’
>  module_param_call(max_user_bgreq, set_global_limit, param_get_uint,
>  ^
> /home/share/git/nn-mdr/include/linux/moduleparam.h:56:9: note: ‘free’ declared here
>   void (*free)(void *arg);

OK, I pasted this into your commit message, and applied it.  See below.

Thanks!
Rusty.

From: Mark Rustad <mark.d.rustad@intel.com>
Subject: moduleparam: Resolve missing-field-initializer warning

Resolve a missing-field-initializer warning, that is produced
by every reference to module_param_call, by using designated
initialization for the first field. That is enough to silence
the complaint.

The message is only seen when doing a W=2 build. I happened to be using gcc
4.8.3, but I think most versions would produce the warning when it is
enabled. It can either be silenced by using even a single designated
initializer as I did here, or providing values for all of the fields. Because
of the number of references to the macro, this change silences many warnings
in W=2 builds.

One instance of the full warning message looks like this:

/home/share/git/nn-mdr/include/linux/moduleparam.h:198:16: warning: missing
initializer for field ‘free’ of ‘struct kernel_param_ops’
[-Wmissing-field-initializers]
  static struct kernel_param_ops __param_ops_##name =  \
		  ^
/home/share/git/nn-mdr/fs/fuse/inode.c:35:1: note: in expansion of macro
‘module_param_call’
 module_param_call(max_user_bgreq, set_global_limit, param_get_uint,
 ^
/home/share/git/nn-mdr/include/linux/moduleparam.h:56:9: note: ‘free’
declared here
  void (*free)(void *arg);

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/moduleparam.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 593501996574..b43f4752304e 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -224,7 +224,7 @@ struct kparam_array
 /* Obsolete - use module_param_cb() */
 #define module_param_call(name, set, get, arg, perm)			\
 	static struct kernel_param_ops __param_ops_##name =		\
-		{ 0, (void *)set, (void *)get };			\
+		{ .flags = 0, (void *)set, (void *)get };		\
 	__module_param_call(MODULE_PARAM_PREFIX,			\
 			    name, &__param_ops_##name, arg,		\
 			    (perm) + sizeof(__check_old_set_param(set))*0, -1, 0)
