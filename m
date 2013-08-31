Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab3HaHol (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 03:44:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:19262 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956Ab3HaHok convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 03:44:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,997,1367996400"; 
   d="scan'208";a="394843344"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Fix the race between the fget() and close()
Thread-Topic: [PATCH] Fix the race between the fget() and close()
Thread-Index: AQHOphy6G3hhQsCTUEmyJHKknDsn45mu7sEA
Date: Sat, 31 Aug 2013 07:44:35 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01AF6D60@SHSMSX101.ccr.corp.intel.com>
References: <1377533569.26153.3.camel@cliu38-desktop-build>
 <20130826112946.GD27005@ZenIV.linux.org.uk>
 <27240C0AC20F114CBF8149A2696CBE4A01AEEE31@SHSMSX101.ccr.corp.intel.com>
 <20130827004247.GG27005@ZenIV.linux.org.uk>
 <20130827004852.GH27005@ZenIV.linux.org.uk>
 <27240C0AC20F114CBF8149A2696CBE4A01AF6CFE@SHSMSX101.ccr.corp.intel.com>
 <20130831064814.GK13318@ZenIV.linux.org.uk>
 <27240C0AC20F114CBF8149A2696CBE4A01AF6D3B@SHSMSX101.ccr.corp.intel.com>
 <20130831073543.GL13318@ZenIV.linux.org.uk>
In-Reply-To: <20130831073543.GL13318@ZenIV.linux.org.uk>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Al Viro [mailto:viro@ftp.linux.org.uk] On Behalf Of Al Viro
> Sent: Saturday, August 31, 2013 3:36 PM
> To: Liu, Chuansheng
> Cc: Eric Dumazet; linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] Fix the race between the fget() and close()
> 
> On Sat, Aug 31, 2013 at 07:01:33AM +0000, Liu, Chuansheng wrote:
> 
> > My scenario is:
> > P1 files_struct refcount is 1, P2's is 1 also.
> > P1 get_files_struct(P2)
> > P1 install one file into P2's files_struct
> > P1 put_files_struct(P2)
> >
> > Then P1 and P2's files_struct refcount are 1, then when P1 is doing ioctl() and
> P2 is exiting
> > with put_files_struct(P2), the race will occur, my understanding is wrong?
> 
> First of all, this wouldn't have been a problem (so you get a new reference
> to file inserted in P2's files_struct; file refcount had been bumped, so
> destruction of P2's files_struct will undo that increment of file refcount
> and we are still fine).  _Removal_ in a similar scenario would have been
> a problem, with P2 doing fdget() while its table isn't shared, then P1
> removing a reference from it and dropping a file - the last one, at that,
> since fdget() assumed that the reference would've stayed in P2's descriptor
> table.  HOWEVER, P1 does not do get_files_struct(P2) at all - it's only
> done by P2 in binder_mmap().
Got it, thanks. In other process, the fget() + _fd_install() should be the same
as the process call open() directly, and the file reference count will be at least 2.

> 
> Again, the invariant to look for is this:
> 	* if current->files had not been shared at fdget() time, it won't
> be shared at matching fdput() and no entries will have been removed in
> between.
> 
> task_fd_install()/task_close_fd() are done on proc->files, which contributes
> to descriptor table refcount.  All other modifications are done to
> current->files, which also contributes to refcount.  If at fdget() time
> current->files had refcount 1, we had no other processes with task->files
> pointing to this descriptor table *and* no binder_proc had their ->files
> pointint to it.  No new ones may appear, since new process could get
> such a reference only from do_fork() called by us and new binder_proc could
> get such a reference only from binder_mmap() called by us.  Neither is
> called between fdget() and fdput().  So in that case the only reference
> to this descriptor table will remain current->files and all removals
> would have to be done by ourselves (and not via task_close_fd(), at that).
> 
> And AFAICS, binder_lock() prevents proc->files being dropped under
> task_close_fd() and task_fd_install().  Hell knows...
> 
> How reproducible it is?  Do you have any more instances, or had that
> been a one-off panic?
Just meet once yet.


