Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643Ab3CUXgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 19:36:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38832 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932566Ab3CUXgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 19:36:35 -0400
Date: Thu, 21 Mar 2013 23:36:30 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: VFS deadlock ?
Message-ID: <20130321233630.GE21522@ZenIV.linux.org.uk>
References: <20130321192935.GY21522@ZenIV.linux.org.uk>
 <CA+55aFyvwJK99YvDLDsazD4tWT6sNQO6kGM_1WyDdvwPNDxbLw@mail.gmail.com>
 <20130321202635.GA16406@redhat.com>
 <CA+55aFwyK4uDgSKUpXBGS5zi16qd8STtrGi3kndunYi40dnj+A@mail.gmail.com>
 <20130321203639.GC16406@redhat.com>
 <20130321204704.GZ21522@ZenIV.linux.org.uk>
 <20130321210255.GD16406@redhat.com>
 <CA+55aFxysZEw6fw8+LobMgfzeHuGSSs+hyrUr_frTOjaCGJFLQ@mail.gmail.com>
 <20130321221256.GA30620@redhat.com>
 <CA+55aFx+O13YuJsZyrTS6O9Kws=1ff-knsSv9rV8wTf8yBrPJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx+O13YuJsZyrTS6O9Kws=1ff-knsSv9rV8wTf8yBrPJg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 03:53:13PM -0700, Linus Torvalds wrote:
> Ok, good. The only rpc/irda that has something in common is
> /proc/net/, and they both use proc_mkdir() to create the directory:
> 
>     proc_irda = proc_mkdir("irda", init_net.proc_net);
>    ...
>     sn->proc_net_rpc = proc_mkdir("rpc", net->proc_net);
> 
> so it's almost certainly that case. What I do *not* see is how we got
> two different dentries for the same name in /proc. But if that
> happens, then yes, they will have aliased inodes (because
> proc_get_inode() will look them up by "sb,de->low_ino".
> 
> Al, any ideas? There shouldn't be some lookup race, because that's
> done under the parent inode lock. And multiple mount-points will have
> different superblocks, so proc_get_inode() will give them separate
> inodes. And bind mounts should have all the same dentry tree. So what
> the heck am I missing?

Some netns-related idiocy.  Oh, shit...

al@duke:~/linux/trees/vfs$ ls -lid /proc/{1,2}/net/stat
4026531842 dr-xr-xr-x 2 root root 0 Mar 21 19:33 /proc/1/net/stat
4026531842 dr-xr-xr-x 2 root root 0 Mar 21 19:33 /proc/2/net/stat

Eric, would you mind explaining WTF is going on here?  Again, WE CAN NOT
HAVE SEVERAL DENTRIES OVER THE SAME DIRECTORY INODE.  Ever.  We do that,
we are fucked.

Sigh...  Namespace kinds - there should've been only one...
