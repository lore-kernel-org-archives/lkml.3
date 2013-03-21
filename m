Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab3CUWxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 18:53:15 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:35674 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab3CUWxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 18:53:14 -0400
MIME-Version: 1.0
In-Reply-To: <20130321221256.GA30620@redhat.com>
References: <20130321190653.GA15479@redhat.com>
	<20130321192935.GY21522@ZenIV.linux.org.uk>
	<CA+55aFyvwJK99YvDLDsazD4tWT6sNQO6kGM_1WyDdvwPNDxbLw@mail.gmail.com>
	<20130321202635.GA16406@redhat.com>
	<CA+55aFwyK4uDgSKUpXBGS5zi16qd8STtrGi3kndunYi40dnj+A@mail.gmail.com>
	<20130321203639.GC16406@redhat.com>
	<20130321204704.GZ21522@ZenIV.linux.org.uk>
	<20130321210255.GD16406@redhat.com>
	<CA+55aFxysZEw6fw8+LobMgfzeHuGSSs+hyrUr_frTOjaCGJFLQ@mail.gmail.com>
	<20130321221256.GA30620@redhat.com>
Date: Thu, 21 Mar 2013 15:53:13 -0700
X-Google-Sender-Auth: GdMmsF0dCwXkRRiXtcDUUA6oS58
Message-ID: <CA+55aFx+O13YuJsZyrTS6O9Kws=1ff-knsSv9rV8wTf8yBrPJg@mail.gmail.com>
Subject: Re: VFS deadlock ?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 3:12 PM, Dave Jones <davej@redhat.com> wrote:
>
> it's not just irda fwiw..
>
> p1=rpc p2=rpc p1parent=net p2parent=net

Ok, good. The only rpc/irda that has something in common is
/proc/net/, and they both use proc_mkdir() to create the directory:

    proc_irda = proc_mkdir("irda", init_net.proc_net);
   ...
    sn->proc_net_rpc = proc_mkdir("rpc", net->proc_net);

so it's almost certainly that case. What I do *not* see is how we got
two different dentries for the same name in /proc. But if that
happens, then yes, they will have aliased inodes (because
proc_get_inode() will look them up by "sb,de->low_ino".

Al, any ideas? There shouldn't be some lookup race, because that's
done under the parent inode lock. And multiple mount-points will have
different superblocks, so proc_get_inode() will give them separate
inodes. And bind mounts should have all the same dentry tree. So what
the heck am I missing?

       Linus
