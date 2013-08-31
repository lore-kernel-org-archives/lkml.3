Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab3HaFxX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 01:53:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:6631 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752990Ab3HaFxV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 01:53:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,997,1367996400"; 
   d="scan'208";a="371425239"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: RE: [PATCH] Fix the race between the fget() and close()
Thread-Topic: [PATCH] Fix the race between the fget() and close()
Thread-Index: AQHOor9KMwicT585/kqTAZm9T5OKj5muz0og
Date: Sat, 31 Aug 2013 05:53:11 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01AF6CFE@SHSMSX101.ccr.corp.intel.com>
References: <1377533569.26153.3.camel@cliu38-desktop-build>
 <20130826112946.GD27005@ZenIV.linux.org.uk>
 <27240C0AC20F114CBF8149A2696CBE4A01AEEE31@SHSMSX101.ccr.corp.intel.com>
 <20130827004247.GG27005@ZenIV.linux.org.uk>
 <20130827004852.GH27005@ZenIV.linux.org.uk>
In-Reply-To: <20130827004852.GH27005@ZenIV.linux.org.uk>
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

Hello Al,

> -----Original Message-----
> From: Al Viro [mailto:viro@ftp.linux.org.uk] On Behalf Of Al Viro
> Sent: Tuesday, August 27, 2013 8:49 AM
> To: Liu, Chuansheng
> Cc: Eric Dumazet; linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] Fix the race between the fget() and close()
> 
> On Tue, Aug 27, 2013 at 01:42:47AM +0100, Al Viro wrote:
> > Might be buggered refcounting on struct file somewhere (i.e. extra fput()
> done,
> > getting the file freed *before* close(), leaving a dangling pointer in
> > descriptor table).  Might be memory corruption of some kind, slapping junk
> > pointer into descriptor table.  Might be buggered refcounting on struct
> > dentry - if extra dput() is done somewhere, dentry might get freed under
> > us or become negative.
> >
> > Hell, might be buggered refcounting on descriptor table - binder is playing
> > interesting games there.  Try to reproduce that with
> CONFIG_DEBUG_KMEMLEAK
> > and slab debugging turned on, see if you hit anything from those; if it's
> > more or less readily reproducible, I would start with that - too many
> > scenarios involve broken refcounting of one sort or another.
> 
> Nevermind dentry refcounting - you get NULL dentry, not NULL inode.
> Other scenarios still remain, so I'd really recommend slab/kmemleak
> debugging turned on.

I think I found one of possible race here(two processes P1 and P2):
P1 has the the files_struct pointer FILES1, P2 has the files_struct pointer FILES2,

When P1 open file, the new struct file pointer SHARE_FILE will be installed into FILES1,
and file refcount is 1;

And in P1, we can get P2's files_struct FILES2, and thru _fd_install(), we can add SHARE_FILE
into P2's FILES2.

Then the same file pointer SHARE_FILE stayed in both P1 and P2's files_struct, and the panic case
will happen:
P1                                                            P2
Open the SHARE_FILE
Installed SHARE_FILE into P2's file_struct FILES2

Ioctl(SHARE_FILE)                                                When P2 exiting,
 fget_light()
   due to FILES1->refcount is 1,                                     put_files_struct will be called,
   there will be no RCU and SHARE_FILE refcount increasing                will close all files including SHARE_FILE

But at this time, P1 is still operate SHARE_FILE without the refcount safety.

Then the panic will happen at vfs_ioctl() due to the SHARE_FILE has been freed.

Is it allowable that installing one file pointer into another FILES_STRUCT? Seems binder is doing the similar things.
In fact, if in ioctl function, we can call fget() instead of fget_light(), this panic can be avoided.

Is it making sense?





