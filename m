Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbbAMDLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 22:11:49 -0500
Received: from ozlabs.org ([103.22.144.67]:39231 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbbAMDLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 22:11:48 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Huang Ying <ying.huang@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [LKP] [params] RIP: 0010:[<ffffffff811c1a04>] [<ffffffff811c1a04>] sysfs_add_file_mode_ns+0x64/0x1f0
In-Reply-To: <1421030743.6201.154.camel@intel.com>
References: <1421030743.6201.154.camel@intel.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 13 Jan 2015 13:38:11 +1030
Message-ID: <871tmzz8bo.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying <ying.huang@intel.com> writes:
> FYI, we noticed the below changes on
>
> commit 18eb74fa94161380c1acc9cf562cb835c4e54a25 ("params: cleanup sysfs allocation")

Thanks!

This is caused by CONFIG_DEBUG_LOCK_ALLOC, which adds fields to
'struct attribute'.  In particular ignore_lockdep is never initialized.

If we memset to 0 before calling sysfs_attr_init() (which doesn't
actually initialize the attribute!), this is fixed.

Cheers,
Rusty.

Subject: param: fix uninitialized read with CONFIG_DEBUG_LOCK_ALLOC

ignore_lockdep is uninitialized, and sysfs_attr_init() doesn't initialize
it, so memset to 0.

Reported-by: Huang Ying <ying.huang@intel.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/kernel/params.c b/kernel/params.c
index bd65d136a470..728e05b167de 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -642,6 +642,7 @@ static __modinit int add_sysfs_param(struct module_kobject *mk,
 	mk->mp->grp.attrs = new_attrs;
 
 	/* Tack new one on the end. */
+	memset(&mk->mp->attrs[mk->mp->num], 0, sizeof(mk->mp->attrs[0]));
 	sysfs_attr_init(&mk->mp->attrs[mk->mp->num].mattr.attr);
 	mk->mp->attrs[mk->mp->num].param = kp;
 	mk->mp->attrs[mk->mp->num].mattr.show = param_attr_show;
