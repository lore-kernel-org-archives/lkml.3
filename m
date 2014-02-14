Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbaBNIwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 03:52:33 -0500
Received: from relay.parallels.com ([195.214.232.42]:42446 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbaBNIwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 03:52:31 -0500
Message-ID: <52FDD93F.2030802@parallels.com>
Date: Fri, 14 Feb 2014 12:52:15 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <gregkh@linuxfoundation.org>, <cl@linux-foundation.org>,
        <penberg@kernel.org>, <linux-kernel@vger.kernel.org>,
        <devel@openvz.org>
Subject: Re: [PATCH 1/2] kobject: don't block for each kobject_uevent
References: <ca22d856315916d3e8c74666da7079b9ae42e646.1391942582.git.vdavydov@parallels.com> <20140213115325.0afcef6b57b63a2ce407c76b@linux-foundation.org>
In-Reply-To: <20140213115325.0afcef6b57b63a2ce407c76b@linux-foundation.org>
Content-Type: multipart/mixed;
	boundary="------------070001040200090600040604"
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------070001040200090600040604
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

On 02/13/2014 11:53 PM, Andrew Morton wrote:
> On Sun, 9 Feb 2014 14:56:15 +0400 Vladimir Davydov <vdavydov@parallels.com> wrote:
>
>> Currently kobject_uevent has somewhat unpredictable semantics. The point
>> is, since it may call a usermode helper and wait for it to execute
>> (UMH_WAIT_EXEC), it is impossible to say for sure what lock dependencies
>> it will introduce for the caller - strictly speaking it depends on what
>> fs the binary is located on and the set of locks fork may take. There
>> are quite a few kobject_uevent's users that do not take this into
>> account and call it with various mutexes taken, e.g. rtnl_mutex,
>> net_mutex, which might potentially lead to a deadlock.
>>
>> Since there is actually no reason to wait for the usermode helper to
>> execute there, let's make kobject_uevent start the helper asynchronously
>> with the aid of the UMH_NO_WAIT flag.
>>
>> Personally, I'm interested in this, because I really want kobject_uevent
>> to be called under the slab_mutex in the slub implementation as it used
>> to be some time ago, because it greatly simplifies synchronization and
>> automatically fixes a kmemcg-related race. However, there was a deadlock
>> detected on an attempt to call kobject_uevent under the slab_mutex (see
>> https://lkml.org/lkml/2012/1/14/45), which was reported to be fixed by
>> releasing the slab_mutex for kobject_uevent. Unfortunately, there was no
>> information about who exactly blocked on the slab_mutex causing the
>> usermode helper to stall, neither have I managed to find this out or
>> reproduce the issue.
>>
>> BTW, this is not the first attempt to make kobject_uevent use
>> UMH_NO_WAIT. Previous one was made by commit f520360d93c, but it was
>> wrong (it passed arguments allocated on stack to async thread) so it was
>> reverted (commit 05f54c13cd0c). It targeted on speeding up the boot
>> process though.
> Am not a huge fan of this patch.  My test box gets an early oops in
>
> initcalls
> ->...
>   ->register_pernet_operations
>     ->rtnetlink_net_init
>       ->__netlink_kernel_create
>         ->sock_create_lite
>           ->sock_alloc
>             ->new_inode_pseudo
>               ->alloc_inode+0xe
>
> I expect that sock_mnt->mnt_sb is null.  Or perhaps sb->s_op.  Perhaps
> sockfs hasn't mounted yet.
>
> The oops doesn't happen on mainline - it only happens on linux-next. 
> So there may be some interaction there, but it may only be timing
> related.
>
> config: http://ozlabs.org/~akpm/stuff/config-akpm2

Oh, that's because I missed that call_usermodehelper_exec() calls
cleanup not only on success, but also on failure resulting in a bunch of
double frees at early boot when khelper hasn't been initialized yet :-(

Please sorry for such a silly mistake. The fixed version is attached.

Thank you.

--------------070001040200090600040604
Content-Type: text/x-patch;
	name="0001-kobject-don-t-block-for-each-kobject_uevent.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0001-kobject-don-t-block-for-each-kobject_uevent.patch"

>From 6f08b7e4b59245f4f5b859991931c74e9fcf713a Mon Sep 17 00:00:00 2001
From: Vladimir Davydov <vdavydov@parallels.com>
Date: Fri, 14 Feb 2014 12:32:13 +0400
Subject: [PATCH v2] kobject: don't block for each kobject_uevent

Currently kobject_uevent has somewhat unpredictable semantics.  The point
is, since it may call a usermode helper and wait for it to execute
(UMH_WAIT_EXEC), it is impossible to say for sure what lock dependencies
it will introduce for the caller - strictly speaking it depends on what fs
the binary is located on and the set of locks fork may take.  There are
quite a few kobject_uevent's users that do not take this into account and
call it with various mutexes taken, e.g.  rtnl_mutex, net_mutex, which
might potentially lead to a deadlock.

Since there is actually no reason to wait for the usermode helper to
execute there, let's make kobject_uevent start the helper asynchronously
with the aid of the UMH_NO_WAIT flag.

Personally, I'm interested in this, because I really want kobject_uevent
to be called under the slab_mutex in the slub implementation as it used to
be some time ago, because it greatly simplifies synchronization and
automatically fixes a kmemcg-related race.  However, there was a deadlock
detected on an attempt to call kobject_uevent under the slab_mutex (see
https://lkml.org/lkml/2012/1/14/45), which was reported to be fixed by
releasing the slab_mutex for kobject_uevent.  Unfortunately, there was no
information about who exactly blocked on the slab_mutex causing the
usermode helper to stall, neither have I managed to find this out or
reproduce the issue.

BTW, this is not the first attempt to make kobject_uevent use UMH_NO_WAIT.
Previous one was made by commit f520360d93c ("kobject: don't block for
each kobject_uevent"), but it was wrong (it passed arguments allocated on
stack to async thread) so it was reverted in 05f54c13cd0c ("Revert
"kobject: don't block for each kobject_uevent".").  It targeted on
speeding up the boot process though.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Greg KH <greg@kroah.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
---
 v2: fix env double free on call_usermodehelper_exec failure

 include/linux/kobject.h |    1 +
 lib/kobject_uevent.c    |   42 ++++++++++++++++++++++++++++++++++++------
 2 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 926afb6f6b5f..f896a33e8341 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -119,6 +119,7 @@ struct kobj_type {
 };
 
 struct kobj_uevent_env {
+	char *argv[3];
 	char *envp[UEVENT_NUM_ENVP];
 	int envp_idx;
 	char buf[UEVENT_BUFFER_SIZE];
diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index 5f72767ddd9b..4e3bd71bd949 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -124,6 +124,30 @@ static int kobj_usermode_filter(struct kobject *kobj)
 	return 0;
 }
 
+static int init_uevent_argv(struct kobj_uevent_env *env, const char *subsystem)
+{
+	int len;
+
+	len = strlcpy(&env->buf[env->buflen], subsystem,
+		      sizeof(env->buf) - env->buflen);
+	if (len >= (sizeof(env->buf) - env->buflen)) {
+		WARN(1, KERN_ERR "init_uevent_argv: buffer size too small\n");
+		return -ENOMEM;
+	}
+
+	env->argv[0] = uevent_helper;
+	env->argv[1] = &env->buf[env->buflen];
+	env->argv[2] = NULL;
+
+	env->buflen += len + 1;
+	return 0;
+}
+
+static void cleanup_uevent_env(struct subprocess_info *info)
+{
+	kfree(info->data);
+}
+
 /**
  * kobject_uevent_env - send an uevent with environmental data
  *
@@ -301,11 +325,8 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 
 	/* call uevent_helper, usually only enabled during early boot */
 	if (uevent_helper[0] && !kobj_usermode_filter(kobj)) {
-		char *argv [3];
+		struct subprocess_info *info;
 
-		argv [0] = uevent_helper;
-		argv [1] = (char *)subsystem;
-		argv [2] = NULL;
 		retval = add_uevent_var(env, "HOME=/");
 		if (retval)
 			goto exit;
@@ -313,9 +334,18 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 					"PATH=/sbin:/bin:/usr/sbin:/usr/bin");
 		if (retval)
 			goto exit;
+		retval = init_uevent_argv(env, subsystem);
+		if (retval)
+			goto exit;
 
-		retval = call_usermodehelper(argv[0], argv,
-					     env->envp, UMH_WAIT_EXEC);
+		retval = -ENOMEM;
+		info = call_usermodehelper_setup(env->argv[0], env->argv,
+						 env->envp, GFP_KERNEL,
+						 NULL, cleanup_uevent_env, env);
+		if (info) {
+			retval = call_usermodehelper_exec(info, UMH_NO_WAIT);
+			env = NULL;	/* freed by cleanup_uevent_env */
+		}
 	}
 
 exit:
-- 
1.7.10.4


--------------070001040200090600040604--
