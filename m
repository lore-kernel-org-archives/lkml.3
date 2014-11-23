Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbaKWXhD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 18:37:03 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:36193 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbaKWXhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 18:37:00 -0500
X-Originating-IP: 50.43.41.112
Date: Sun, 23 Nov 2014 15:36:37 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Pieter Smith <pieter@boesman.nl>
Cc: David Miller <davem@davemloft.net>, alexander.h.duyck@intel.com,
        viro@zeniv.linux.org.uk, ast@plumgrid.com, akpm@linux-foundation.org,
        beber@meleeweb.net, catalina.mocanu@gmail.com, dborkman@redhat.com,
        edumazet@google.com, ebiederm@xmission.com, fabf@skynet.be,
        fuse-devel@lists.sourceforge.net, geert@linux-m68k.org,
        hughd@google.com, iulia.manda21@gmail.com, JBeulich@suse.com,
        bfields@fieldses.org, jlayton@poochiereds.net,
        linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mcgrof@suse.com, mattst88@gmail.com,
        mgorman@suse.de, mst@redhat.com, miklos@szeredi.hu,
        netdev@vger.kernel.org, oleg@redhat.com, Paul.Durrant@citrix.com,
        paulmck@linux.vnet.ibm.com, pefoley2@pefoley.com, tgraf@suug.ch,
        therbert@google.com, willemb@google.com,
        xiaoguangrong@linux.vnet.ibm.com, zhenglong.cai@cs2c.com.cn
Subject: Re: [PATCH 0/6] kernel tinification: optionally compile out splice
 family of syscalls (splice, vmsplice, tee and sendfile)
Message-ID: <20141123233637.GC12456@thin>
References: <1416752468-1626-1-git-send-email-pieter@boesman.nl>
 <20141123.134623.2061031332250984539.davem@davemloft.net>
 <20141123194326.GB8517@thin>
 <20141123203040.GB26749@smipidev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141123203040.GB26749@smipidev>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2014 at 09:30:40PM +0100, Pieter Smith wrote:
> On Sun, Nov 23, 2014 at 11:43:26AM -0800, Josh Triplett wrote:
> > On Sun, Nov 23, 2014 at 01:46:23PM -0500, David Miller wrote:
> > > Truly removing sendfile/sendpage means that you can't even compile NFS
> > > into the tree.
> > 
> > If you mean the in-kernel nfsd (CONFIG_NFSD), that already has a large
> > stack of "select" and "depends on", both directly and indirectly; adding
> > a "select SPLICE_SYSCALL" to it seems fine.  (That select does need
> > adding, though.  Pieter, you need to test-compile more than just
> > tinyconfig and defconfig.  Try an allyesconfig with *just* splice turned
> > off, and make sure that compiles.)
> 
> Did exacly that. Took forever on my hardware, but no problems.

Ah, I see.  Looking more closely at nfsd, it looks like it already has a
code path for filesystems that don't do splice.  I think, rather than
making nfsd select SPLICE_SYSCALL, that it would suffice to change the
"rqstp->rq_splice_ok = true;" in svc_process_common (net/sunrpc/svc.c)
to:

rqstp->rq_splice_ok = IS_ENABLED(CONFIG_SPLICE_SYSCALL);

Then nfsd should simply *always* fall back to its non-splice support.

That said, given that it seems exceedingly unlikely that anyone would
use the in-kernel nfsd on a system trying to minimize kernel size, it
still seems cleaner to just "select SPLICE_SYSCALL" from NFSD in
Kconfig.  That avoids making any changes at all to the nfsd source in
this patch series.

- Josh Triplett
