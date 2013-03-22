Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab3CVEhV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 00:37:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40335 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab3CVEhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 00:37:20 -0400
Date: Fri, 22 Mar 2013 04:37:15 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [CFT] Re: VFS deadlock ?
Message-ID: <20130322043715.GL21522@ZenIV.linux.org.uk>
References: <20130321221256.GA30620@redhat.com>
 <CA+55aFx+O13YuJsZyrTS6O9Kws=1ff-knsSv9rV8wTf8yBrPJg@mail.gmail.com>
 <20130321233630.GE21522@ZenIV.linux.org.uk>
 <CA+55aFyLJ9vVm1T994EaE4tnEbV8rHj43m+cWsFFBi_qndao1A@mail.gmail.com>
 <CA+55aFyWNkOnrQ41xCAU8q5sVXdq1-u2P8n+quLY50OdiFo3Zw@mail.gmail.com>
 <20130322001257.GH21522@ZenIV.linux.org.uk>
 <CA+55aFz5Ce7h2ja0m++tENXuG-1d346VNu9N=ZKy2UfojaSf0g@mail.gmail.com>
 <20130322012208.GJ21522@ZenIV.linux.org.uk>
 <CA+55aFzPD08kJi=x8wLBi5FAjr1TqSGXWbv5KXy5Ymm0PJL0wA@mail.gmail.com>
 <20130322014037.GK21522@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130322014037.GK21522@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 01:40:37AM +0000, Al Viro wrote:

> Yeah, I went to do such patch after sending the previous mail and noticed
> that we already did it that way.  Simplicity of error recovery was probably
> more important consideration there - I honestly don't remember the reasoning
> in such details; it had been a decade or so...  So lock_rename() doing
> ->d_inode comparison (with dire comment re not expecting that to be sufficient
> for anything other than this bug in procfs) will probably suffice for fs/namei.c
> part of it; I'm still looking at dcache.c side of things...

FWIW, a relatively crude solution is this:

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 4b3b3ff..778cbac 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -416,8 +416,7 @@ struct dentry *proc_lookup_de(struct proc_dir_entry *de, struct inode *dir,
 			if (!inode)
 				return ERR_PTR(-ENOMEM);
 			d_set_d_op(dentry, &proc_dentry_operations);
-			d_add(dentry, inode);
-			return NULL;
+			return d_materialise_unique(dentry, inode);
 		}
 	}
 	spin_unlock(&proc_subdir_lock);

It *is* crude, but it restores the assert, killing the deadlock and lets
everything work more or less as it used to.  The case where things start
to look odd is this:

root@kvm-amd64:~# cd /proc/1/net/stat/; ls /proc/2/net/stat; /bin/pwd
arp_cache  ndisc_cache  rt_cache
/proc/2/net/stat

IOW, if we were about to create a directory alias, the old dentry gets moved
in new place.  OTOH, I think it's the most robust backportable variant we
can do.  And yes, that should apply at least all the way back to 2.6.25 when
Eric acked a patch from Pavel that really should've been nacked...

Folks, could you test that one and see if any real userland breaks on that?
If everything works, I'd propose that one for -stable.
