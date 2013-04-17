Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965607Ab3DQUHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 16:07:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36744 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965067Ab3DQUHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 16:07:40 -0400
Date: Wed, 17 Apr 2013 13:07:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] kernel: audit_tree: resource management: need
 put_tree and goto Err when failure occures
Message-Id: <20130417130739.03fb8d9ccb908afc0a1db861@linux-foundation.org>
In-Reply-To: <516E1F32.6010009@asianux.com>
References: <516790ED.6060202@asianux.com>
	<516CFF2C.7010509@asianux.com>
	<516E1F32.6010009@asianux.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Apr 2013 12:04:02 +0800 Chen Gang <gang.chen@asianux.com> wrote:

>   since "normally audit_add_tree_rule() will free it on failure",
>   need free it completely, when failure occures.
> 
>     need additional put_tree before return, since get_tree was called.
>     always need goto error processing area for list_del_init.

Isn't that get_tree() in audit_add_tree_rule() simply unneeded?  In
other words, is this patch correct:

--- a/kernel/audit_tree.c~a
+++ a/kernel/audit_tree.c
@@ -682,7 +682,6 @@ int audit_add_tree_rule(struct audit_kru
 		goto Err;
 	}
 
-	get_tree(tree);
 	err = iterate_mounts(tag_mount, tree, mnt);
 	drop_collected_mounts(mnt);
 
@@ -703,7 +702,6 @@ int audit_add_tree_rule(struct audit_kru
 		return -ENOENT;
 	}
 	rule->tree = tree;
-	put_tree(tree);
 
 	return 0;
 Err:
_


