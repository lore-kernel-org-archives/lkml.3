Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbaAIPvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 10:51:24 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:65090 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750882AbaAIPvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 10:51:17 -0500
Date: Thu, 9 Jan 2014 10:51:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Eric Paris <eparis@parisplace.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        Paul Moore <paul@paul-moore.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] SELinux: Fix possible NULL pointer dereference in
 selinux_inode_permission()
Message-ID: <20140109105114.5c409fef@gandalf.local.home>
In-Reply-To: <CACLa4pv+EUGHO+MKj8ckhmi8YKiTNVL9pSM+DDsjg+0jbjOCcA@mail.gmail.com>
References: <20140109101932.0508dec7@gandalf.local.home>
	<CACLa4pv+EUGHO+MKj8ckhmi8YKiTNVL9pSM+DDsjg+0jbjOCcA@mail.gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jan 2014 10:31:55 -0500
Eric Paris <eparis@parisplace.org> wrote:

> Didn't Al find this/something very similar.  I really hate this

I'm not involved with the vfs, so I'm unaware of other solutions
presented. I just hit this now and solving bugs is where I get a chance
to learn about other aspects of the kernel. ;-)

> solution.  Why should every LSM try to understand the intimate
> lifetime rules of the parent subsystems?  The real problem is that
> inode_free_security() is being called while the inode is still in use.
>  While I agree with the assessment, I disagree with the solution.  Let
> me try to find where Al and Christoph talked about this....
> 

The other obvious solution (but not as trivial to implement) is to call
the security_inode_free() and friends (probably __destroy_inode()
itself) after a synchronize_rcu().

Perhaps something like this?

-- Steve

diff --git a/fs/inode.c b/fs/inode.c
index 4bcdad3..a8f3b88 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -252,16 +252,17 @@ EXPORT_SYMBOL(__destroy_inode);
 static void i_callback(struct rcu_head *head)
 {
 	struct inode *inode = container_of(head, struct inode, i_rcu);
+	__destroy_inode(inode);
 	kmem_cache_free(inode_cachep, inode);
 }
 
 static void destroy_inode(struct inode *inode)
 {
 	BUG_ON(!list_empty(&inode->i_lru));
-	__destroy_inode(inode);
-	if (inode->i_sb->s_op->destroy_inode)
+	if (inode->i_sb->s_op->destroy_inode) {
+		__destroy_inode(inode);
 		inode->i_sb->s_op->destroy_inode(inode);
-	else
+	} else
 		call_rcu(&inode->i_rcu, i_callback);
 }
 
