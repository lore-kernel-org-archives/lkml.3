Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220AbaKXKBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:01:48 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:60896 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbaKXKBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:01:45 -0500
Date: Mon, 24 Nov 2014 11:01:38 +0100
From: Pieter Smith <pieter@boesman.nl>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Jeff Layton <jlayton@poochiereds.net>, David Miller <davem@davemloft.net>,
        alexander.h.duyck@intel.com, viro@zeniv.linux.org.uk, ast@plumgrid.com,
        akpm@linux-foundation.org, beber@meleeweb.net,
        catalina.mocanu@gmail.com, dborkman@redhat.com, edumazet@google.com,
        ebiederm@xmission.com, fabf@skynet.be,
        fuse-devel@lists.sourceforge.net, geert@linux-m68k.org,
        hughd@google.com, iulia.manda21@gmail.com, JBeulich@suse.com,
        bfields@fieldses.org, linux-api@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mcgrof@suse.com, mattst88@gmail.com, mgorman@suse.de, mst@redhat.com,
        miklos@szeredi.hu, netdev@vger.kernel.org, oleg@redhat.com,
        Paul.Durrant@citrix.com, paulmck@linux.vnet.ibm.com,
        pefoley2@pefoley.com, tgraf@suug.ch, therbert@google.com,
        willemb@google.com, xiaoguangrong@linux.vnet.ibm.com,
        zhenglong.cai@cs2c.com.cn
Subject: Re: [PATCH 0/6] kernel tinification: optionally compile out splice
 family of syscalls (splice, vmsplice, tee and sendfile)
Message-ID: <20141124100138.GB1055@smipidev>
References: <1416752468-1626-1-git-send-email-pieter@boesman.nl>
 <20141123.134623.2061031332250984539.davem@davemloft.net>
 <20141123194326.GB8517@thin>
 <20141123203040.GB26749@smipidev>
 <20141123233637.GC12456@thin>
 <20141123192810.682a223e@tlielax.poochiereds.net>
 <20141124003251.GA13590@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141124003251.GA13590@thin>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2014 at 04:32:51PM -0800, Josh Triplett wrote:
> On Sun, Nov 23, 2014 at 07:28:10PM -0500, Jeff Layton wrote:
> > On Sun, 23 Nov 2014 15:36:37 -0800
> > Josh Triplett <josh@joshtriplett.org> wrote:
> > 
> > > On Sun, Nov 23, 2014 at 09:30:40PM +0100, Pieter Smith wrote:
> > > > On Sun, Nov 23, 2014 at 11:43:26AM -0800, Josh Triplett wrote:
> > > > > On Sun, Nov 23, 2014 at 01:46:23PM -0500, David Miller wrote:
> > > > > > Truly removing sendfile/sendpage means that you can't even compile NFS
> > > > > > into the tree.
> > > > > 
> > > > > If you mean the in-kernel nfsd (CONFIG_NFSD), that already has a large
> > > > > stack of "select" and "depends on", both directly and indirectly; adding
> > > > > a "select SPLICE_SYSCALL" to it seems fine.  (That select does need
> > > > > adding, though.  Pieter, you need to test-compile more than just
> > > > > tinyconfig and defconfig.  Try an allyesconfig with *just* splice turned
> > > > > off, and make sure that compiles.)
> > > > 
> > > > Did exacly that. Took forever on my hardware, but no problems.
> > > 
> > > Ah, I see.  Looking more closely at nfsd, it looks like it already has a
> > > code path for filesystems that don't do splice.  I think, rather than
> > > making nfsd select SPLICE_SYSCALL, that it would suffice to change the
> > > "rqstp->rq_splice_ok = true;" in svc_process_common (net/sunrpc/svc.c)
> > > to:
> > > 
> > > rqstp->rq_splice_ok = IS_ENABLED(CONFIG_SPLICE_SYSCALL);
> > > 
> > > Then nfsd should simply *always* fall back to its non-splice support.
> > > 
> > 
> > I'd probably prefer the above, actually. We have to keep supporting
> > non-splice enabled fs' for the forseeable future, so we may as well
> > allow people to run nfsd in such configurations. It could even be
> > useful for testing the non-splice-enabled codepaths.
> 
> Good point!
> 
> - Josh Triplett

I'll add this to svc_process_common. I can squash this into PATCH 3, which is
where the syscalls can be compiled out. The log entry may however get a little
crowded and multi-functional.

Should I keep this as a separate patch?
