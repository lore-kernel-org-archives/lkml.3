Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552Ab3GPCCH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 22:02:07 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:14839 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758435Ab3GPCCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 22:02:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am8NAC6p5FF5LK4r/2dsb2JhbABagwa9KYEihA4EAYESF3SCIwEBBAEeHBwoCwgDGAkaCw8FJQMhARKICgW2WRaOFxqBJIMLbQOXW4ojhyuBWYFLKoEt
Date: Tue, 16 Jul 2013 12:01:48 +1000
From: Dave Chinner <david@fromorbit.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com
Subject: Re: XFS: Assertion failed: xfs_dir2_sf_lookup(args) == ENOENT, file:
 fs/xfs/xfs_dir2_sf.c, line: 358
Message-ID: <20130716020148.GA11674@dastard>
References: <20130712023930.GA6473@redhat.com>
 <20130713020030.GG3438@dastard>
 <20130715195800.GD1706@redhat.com>
 <20130716002703.GB3920@dastard>
 <20130716014244.GA30569@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130716014244.GA30569@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 09:42:44PM -0400, Dave Jones wrote:
> On Tue, Jul 16, 2013 at 10:27:03AM +1000, Dave Chinner wrote:
>  > On Mon, Jul 15, 2013 at 03:58:00PM -0400, Dave Jones wrote:
>  > > On Sat, Jul 13, 2013 at 12:00:30PM +1000, Dave Chinner wrote:
>  > >  
>  > >  > > [   97.162665] XFS: Assertion failed: xfs_dir2_sf_lookup(args) == ENOENT, file: fs/xfs/xfs_dir2_sf.c, line: 358
>  > >  > ....
>  > >  > 
>  > >  > So, it's not clear what has caused this yet. Is it reproducable?
>  > > 
>  > > Just hit it again on the same machine.
>  > > 
>  > >  > would be good to get a trace of lookup vs addname events from XFS,
>  > >  > too (i.e. all the xfs_dir* and xfs_da* events) so we can see if the
>  > >  > correct lookups were done prior to the failing addname operation...
>  > >  
>  > > <- xfs tracing noob. Got a recipe I can cut-n-paste ?
>  > > Or a patch if that's necessary..
>  > 
>  > Just use your usual method of pulling tracepoints out of the kernel,
>  > be it with perf or (my preferred method) trace-cmd:
>  > 
>  > # trace-cmd record -e xfs_dir\* -e xfs_da\* <command that dies>
>  > ....
>  > # trace-cmd report > trace.report.out
>  > 
>  > The trace.report.out file is what I'd like to see. The report file
>  > could be large, so compressing it might be an idea...
> 
> Hmm, will that only log traces from the command that I run ?

No, it will capture kernel wide. The command being run just gives it
a defined end-point to the capture. i.e. I often just use "sleep 30"
as the command.

$ sudo ~/trace-cmd/trace-cmd record -e xfs\* sleep 30 &
[1] 4180
$ /sys/kernel/debug/tracing/events/xfs*/filter
/sys/kernel/debug/tracing/events/*/xfs*/filter

$ sudo mount /dev/vda /mnt/test
$ sync
$ sudo umount /mnt/test
$ fg
sudo ~/trace-cmd/trace-cmd record -e xfs\* sleep 30
trace-cmd: Interrupted system call
  recorder error in splice input
offset=3eb000
Kernel buffer statistics:
  Note: "entries" are the entries left in the kernel ring buffer and are not
        recorded in the trace data. They should all be zero.

CPU: 0
entries: 55
overrun: 0
commit overrun: 0
bytes: 3420
oldest event ts: 48589.221789
now ts: 48607.261966
dropped events: 0
read events: 352

$ sudo ~/trace-cmd/trace-cmd report > ~/t.t
$ head -10 ~/t.t
version = 6
cpus=1
           mount-4185  [000] 48582.777997: xfs_buf_init:         dev 253:0 bno 0xffffffffffffffff nblks 0x1 hold 1 pincount 0 lock 0 flags  caller xfs_buf_get_uncached
           mount-4185  [000] 48582.778001: xfs_buf_get_uncached: dev 253:0 bno 0xffffffffffffffff nblks 0x1 hold 1 pincount 0 lock 0 flags PAGES caller xfs_buf_read_uncached
           mount-4185  [000] 48582.778002: xfs_buf_iorequest:    dev 253:0 bno 0x0 nblks 0x1 hold 1 pincount 0 lock 0 flags READ|PAGES caller xfsbdstrat
           mount-4185  [000] 48582.778002: xfs_buf_hold:         dev 253:0 bno 0x0 nblks 0x1 hold 1 pincount 0 lock 0 flags READ|PAGES caller xfs_buf_iorequest
           mount-4185  [000] 48582.778017: xfs_buf_rele:         dev 253:0 bno 0x0 nblks 0x1 hold 2 pincount 0 lock 0 flags READ|PAGES caller xfs_buf_iorequest
           mount-4185  [000] 48582.778017: xfs_buf_iowait:       dev 253:0 bno 0x0 nblks 0x1 hold 1 pincount 0 lock 0 flags READ|PAGES caller xfs_buf_read_uncached
          <idle>-0     [000] 48582.778692: xfs_buf_ioerror:      dev 253:0 bno 0x0 len 0x200 hold 1 pincount 0 lock 0 error 0 flags READ|PAGES caller xfs_buf_bio_end_io
          <idle>-0     [000] 48582.778693: xfs_buf_iodone:       dev 253:0 bno 0x0 nblks 0x1 hold 1 pincount 0 lock 0 flags READ|PAGES caller _xfs_buf_ioend
$

> I might need to do some kind of system-wide tracing here,
> because every time this has happened so far, it's happened in
> a different process.  (rpcbind the first [wtf?], and chrony the 2nd)
> Can trace-cmd do that ?

Yup. trace-cmd will trace global events unless you give it a
specific process filter to limit what PIDs it gathers events from.
Basically, trace-cmd is a much nicer front end to perf...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
