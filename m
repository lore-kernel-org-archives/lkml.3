Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab3HaHBi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 03:01:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:39644 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752990Ab3HaHBh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 03:01:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,997,1367996400"; 
   d="scan'208";a="371444582"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Fix the race between the fget() and close()
Thread-Topic: [PATCH] Fix the race between the fget() and close()
Thread-Index: AQHOphYcPfbNkS9U5UOHW8adDLNOTpmu4ehg
Date: Sat, 31 Aug 2013 07:01:33 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01AF6D3B@SHSMSX101.ccr.corp.intel.com>
References: <1377533569.26153.3.camel@cliu38-desktop-build>
 <20130826112946.GD27005@ZenIV.linux.org.uk>
 <27240C0AC20F114CBF8149A2696CBE4A01AEEE31@SHSMSX101.ccr.corp.intel.com>
 <20130827004247.GG27005@ZenIV.linux.org.uk>
 <20130827004852.GH27005@ZenIV.linux.org.uk>
 <27240C0AC20F114CBF8149A2696CBE4A01AF6CFE@SHSMSX101.ccr.corp.intel.com>
 <20130831064814.GK13318@ZenIV.linux.org.uk>
In-Reply-To: <20130831064814.GK13318@ZenIV.linux.org.uk>
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
> Sent: Saturday, August 31, 2013 2:48 PM
> To: Liu, Chuansheng
> Cc: Eric Dumazet; linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] Fix the race between the fget() and close()
> 
> On Sat, Aug 31, 2013 at 05:53:11AM +0000, Liu, Chuansheng wrote:
> 
> > I think I found one of possible race here(two processes P1 and P2):
> > P1 has the the files_struct pointer FILES1, P2 has the files_struct pointer
> FILES2,
> >
> > When P1 open file, the new struct file pointer SHARE_FILE will be installed
> into FILES1,
> > and file refcount is 1;
> >
> > And in P1, we can get P2's files_struct FILES2, and thru _fd_install(), we can
> add SHARE_FILE
> > into P2's FILES2.
> >
> > Then the same file pointer SHARE_FILE stayed in both P1 and P2's files_struct,
> and the panic case
> > will happen:
> > P1
> P2
> > Open the SHARE_FILE
> > Installed SHARE_FILE into P2's file_struct FILES2
> 
> ... without bumping refcount on SHARE_FILE?  Then you really have a big
> problem.  task_fd_install() call is preceded by grabbing a reference
> to the file we are installing, though...  BTW, /* TODO: fput? */ after
> that call is really bogus - the code doesn't call fput() there and it's
> quite correct as is, since at that point the reference had gone into
> descriptor table we'd been installing into and doesn't need to be dropped.
> 
> > Ioctl(SHARE_FILE)
> When P2 exiting,
> >  fget_light()
> >    due to FILES1->refcount is 1,
> put_files_struct will be called,
> >    there will be no RCU and SHARE_FILE refcount increasing
> will close all files including SHARE_FILE
> >
> > But at this time, P1 is still operate SHARE_FILE without the refcount safety.
> >
> > Then the panic will happen at vfs_ioctl() due to the SHARE_FILE has been
> freed.
> >
> > Is it allowable that installing one file pointer into another FILES_STRUCT?
> Seems binder is doing the similar things.
> > In fact, if in ioctl function, we can call fget() instead of fget_light(), this panic
> can be avoided.
> >
> > Is it making sense?
> 
> No, it doesn't.  For one thing, any reference in any files_struct should
> contribute 1 to refcount of struct file.  For another, you can modify
> files_struct *ONLY* if you hold a reference to it.  binder, a misdesigned
My scenario is:
P1 files_struct refcount is 1, P2's is 1 also.
P1 get_files_struct(P2)
P1 install one file into P2's files_struct
P1 put_files_struct(P2)

Then P1 and P2's files_struct refcount are 1, then when P1 is doing ioctl() and P2 is exiting
with put_files_struct(P2), the race will occur, my understanding is wrong?

