Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315AbaLWW0m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 17:26:42 -0500
Received: from ozlabs.org ([103.22.144.67]:43365 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbaLWW0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 17:26:41 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sasha Levin <sasha.levin@oracle.com>, LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
        hch@infradead.org, Al Viro <viro@ZenIV.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Subject: Re: module,sysfs: gpf in module_attr_store
In-Reply-To: <54982993.4090609@oracle.com>
References: <54982993.4090609@oracle.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 23 Dec 2014 15:05:57 +1030
Message-ID: <87a92ft236.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <sasha.levin@oracle.com> writes:
> Hi all,
>
> While fuzzing with trinity inside a KVM tools guest running the latest -next
> kernel, I've stumbled on the following spew:

Nice catch!

Thanks for the report,
Rusty.

Subject: param: initialize store function to NULL if not available.

I rebased Kees' 'param: do not set store func without write perm'
on top of my 'params: cleanup sysfs allocation'.  However, my patch
uses krealloc which doesn't zero memory, leaving .store unset.

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/kernel/params.c b/kernel/params.c
index 0af9b2c4e56c..bd65d136a470 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -648,6 +648,8 @@ static __modinit int add_sysfs_param(struct module_kobject *mk,
 	/* Do not allow runtime DAC changes to make param writable. */
 	if ((kp->perm & (S_IWUSR | S_IWGRP | S_IWOTH)) != 0)
 		mk->mp->attrs[mk->mp->num].mattr.store = param_attr_store;
+	else
+		mk->mp->attrs[mk->mp->num].mattr.store = NULL;
 	mk->mp->attrs[mk->mp->num].mattr.attr.name = (char *)name;
 	mk->mp->attrs[mk->mp->num].mattr.attr.mode = kp->perm;
 	mk->mp->num++;
