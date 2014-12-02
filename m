Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933775AbaLBTqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:46:50 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:47084 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933695AbaLBTqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:46:47 -0500
From: Jeff Layton <jeff.layton@primarydata.com>
X-Google-Original-From: Jeff Layton <jlayton@primarydata.com>
Date: Tue, 2 Dec 2014 14:46:44 -0500
To: Tejun Heo <tj@kernel.org>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC PATCH 00/14] nfsd/sunrpc: add support for a
 workqueue-based nfsd
Message-ID: <20141202144644.7900c4c9@tlielax.poochiereds.net>
In-Reply-To: <20141202192655.GL10918@htj.dyndns.org>
References: <1417544663-13299-1-git-send-email-jlayton@primarydata.com>
	<20141202191814.GK10918@htj.dyndns.org>
	<20141202192655.GL10918@htj.dyndns.org>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Dec 2014 14:26:55 -0500
Tejun Heo <tj@kernel.org> wrote:

> On Tue, Dec 02, 2014 at 02:18:14PM -0500, Tejun Heo wrote:
> ...
> > unbound.  If strict cpu locality is likely to be beneficial and each
> > work item isn't likely to consume huge amount of cpu cycles,
> > WQ_CPU_INTENSIVE would fit better; otherwise, WQ_UNBOUND to let the
> > scheduler do its thing.
> 
> Hmmm... but you're already using WQ_UNBOUND.  Concurrency management
> doesn't matter for unbound workqueues.  They really just behave as
> shared worker thread pools.  Does turning on WQ_HIGHPRI change
> anything?  Workqueue always prefers hot workers which can lead to the
> hot ones being penalized for consuming too much CPU time.
> 
> Thanks.
> 

WQ_HIGHPRI doesn't seem to help. FWIW, here's the fio status line from
that test:

threaded nfsd:
  WRITE: io=12628KB, aggrb=210KB/s, minb=52KB/s, maxb=52KB/s, mint=60064msec, maxt=60107msec

workqueue nfsd:
  WRITE: io=7464KB, aggrb=124KB/s, minb=30KB/s, maxb=31KB/s, mint=60066msec, maxt=60133msec

...and the workqueue numbers didn't change much from the case without
WQ_HIGHPRI. I didn't gather significant queueing latency numbers for
that run but I can get those together tomorrow.

My fio test config follows for anyone who's interested (it's
tiobench-example.fio without the read tests):

-------------------------[snip]--------------------------
[global]
direct=1
size=128m
bsrange=4k-4k
timeout=60
numjobs=4	; 4 simultaneous threads for each job

[f1]
rw=write
-------------------------[snip]--------------------------

... the server in this case is an older quad core AMD Phenom CPU, with
a 5400rpm SATA disk under it on a 3Gbps SATA interface. The client is
mounting it using NFSv3 and I'm only running a single client here.

The only difference between the two tests above is that whether nfsd is
running with the sunrpc.ko pool_mode set to "global" or "workqueue".

-- 
Jeff Layton <jlayton@primarydata.com>
