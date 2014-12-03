Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341AbaLCUVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 15:21:51 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:58155 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbaLCUVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 15:21:50 -0500
From: Jeff Layton <jeff.layton@primarydata.com>
X-Google-Original-From: Jeff Layton <jlayton@primarydata.com>
Date: Wed, 3 Dec 2014 15:21:47 -0500
To: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: Jeff Layton <jeff.layton@primarydata.com>, Tejun Heo <tj@kernel.org>,
        NeilBrown <neilb@suse.de>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Linux Kernel mailing list <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC PATCH 00/14] nfsd/sunrpc: add support for a
 workqueue-based nfsd
Message-ID: <20141203152147.2ca6c6fd@tlielax.poochiereds.net>
In-Reply-To: <CAHQdGtSoep_F82tDUoxKar+QvmL1tdHsYgYSrYtktndYJP8g5A@mail.gmail.com>
References: <1417544663-13299-1-git-send-email-jlayton@primarydata.com>
	<20141203121118.21a32fe1@notabene.brown>
	<20141202202946.1e0f399b@tlielax.poochiereds.net>
	<20141203155649.GB5013@htj.dyndns.org>
	<20141203110405.5ecc85df@tlielax.poochiereds.net>
	<20141203140202.7865bedb@tlielax.poochiereds.net>
	<CAHQdGtQzth78BzBo9Gsz8LKe4ippJv6VYtjGCDmES7viByG_gA@mail.gmail.com>
	<20141203142034.5c14529d@tlielax.poochiereds.net>
	<CAHQdGtSoep_F82tDUoxKar+QvmL1tdHsYgYSrYtktndYJP8g5A@mail.gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2014 14:59:43 -0500
Trond Myklebust <trond.myklebust@primarydata.com> wrote:

> On Wed, Dec 3, 2014 at 2:20 PM, Jeff Layton <jeff.layton@primarydata.com> wrote:
> > On Wed, 3 Dec 2014 14:08:01 -0500
> > Trond Myklebust <trond.myklebust@primarydata.com> wrote:
> >> Which workqueue are you using? Since the receive code is non-blocking,
> >> I'd expect you might be able to use rpciod, for the initial socket
> >> reads, but you wouldn't want to use that for the actual knfsd
> >> processing.
> >>
> >
> > I'm using the same (nfsd) workqueue for everything. The workqueue
> > isn't really the bottleneck though, it's the work_struct.
> >
> > Basically, the problem is that the work_struct in the svc_xprt was
> > remaining busy for far too long. So, even though the XPT_BUSY bit had
> > cleared, the work wouldn't get picked up again until the previous
> > workqueue job had returned.
> >
> > With the change I made today, I just added a new work_struct to
> > svc_rqst and queue that to the same workqueue to do svc_process as soon
> > as the receive is done. That means though that each RPC ends up waiting
> > in the queue twice (once to do the receive and once to process the
> > RPC), and I think that's probably the reason for the performance delta.
> 
> Why would the queuing latency still be significant now?
> 

That, I'm not clear on yet and that may not be why this is slower. But,
I was seeing slightly faster performance with reads before I made
today's changes. If changing how these jobs get queued doesn't help the
performance, then I'll have to look elsewhere...

> > What I think I'm going to do on the next pass is have the job that
> > enqueues the xprt instead try to find an svc_rqst. If it finds it,
> > then it can go ahead and queue the work struct in it to do the
> > receive and processing in a single go.
> >
> > If it can't find one, it'll queue the xprt's work to allocate one
> > and then queue that to do all of the work as before. That will
> > likely penalize the case where there isn't an available svc_rqst,
> > but in the common case that there is one it should go quickly.
> 
> 


-- 
Jeff Layton <jlayton@primarydata.com>
