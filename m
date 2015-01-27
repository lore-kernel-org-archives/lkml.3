Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904AbbA0Unl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 15:43:41 -0500
Received: from mta-out1.inet.fi ([62.71.2.203]:58875 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932282AbbA0Unj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 15:43:39 -0500
Date: Tue, 27 Jan 2015 22:43:11 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Kees Cook <keescook@chromium.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Calvin Owens <calvinowens@fb.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Peter Feiner <pfeiner@google.com>,
        Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH] docs: procs -- Describe /proc/<pid>/map_files entry
Message-ID: <20150127204311.GA5228@node.dhcp.inet.fi>
References: <20150127094103.GK651@moon>
 <CAGXu5jJ0oNeMq+gibuHfB-j_ZooGnuZ_o1aCoMO=qMWen+HQUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJ0oNeMq+gibuHfB-j_ZooGnuZ_o1aCoMO=qMWen+HQUw@mail.gmail.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 11:50:49AM -0800, Kees Cook wrote:
> On Tue, Jan 27, 2015 at 1:41 AM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> > CC: Kees Cook <keescook@chromium.org>
> > CC: Andrew Morton <akpm@linux-foundation.org>
> > CC: "Kirill A. Shutemov" <kirill@shutemov.name>
> > CC: Calvin Owens <calvinowens@fb.com>
> > CC: Alexey Dobriyan <adobriyan@gmail.com>
> > CC: Oleg Nesterov <oleg@redhat.com>
> > CC: "Eric W. Biederman" <ebiederm@xmission.com>
> > CC: Al Viro <viro@zeniv.linux.org.uk>
> > CC: Peter Feiner <pfeiner@google.com>
> > CC: Pavel Emelyanov <xemul@openvz.org>
> > ---
> >
> > Gentlemen, could you please take a look once time permit.
> > Which questions this text raises so I could add more info
> > here (how we use it in criu, ptrace_may_access guards?)
> >
> >  Documentation/filesystems/proc.txt |   23 +++++++++++++++++++++++
> >  1 file changed, 23 insertions(+)
> >
> > Index: linux-2.6.git/Documentation/filesystems/proc.txt
> > ===================================================================
> > --- linux-2.6.git.orig/Documentation/filesystems/proc.txt
> > +++ linux-2.6.git/Documentation/filesystems/proc.txt
> > @@ -42,6 +42,7 @@ Table of Contents
> >    3.6  /proc/<pid>/comm  & /proc/<pid>/task/<tid>/comm
> >    3.7   /proc/<pid>/task/<tid>/children - Information about task children
> >    3.8   /proc/<pid>/fdinfo/<fd> - Information about opened file
> > +  3.9   /proc/<pid>/map_files - Information about memory mapped files
> >
> >    4    Configuring procfs
> >    4.1  Mount options
> > @@ -1763,6 +1764,28 @@ pair provide additional information part
> >         with TIMER_ABSTIME option which will be shown in 'settime flags', but 'it_value'
> >         still exhibits timer's remaining time.
> >
> > +3.9    /proc/<pid>/map_files - Information about memory mapped files
> > +---------------------------------------------------------------------
> > +This directory consists of simbolic links which represent memory mapped files
> > +the process is carrying. A typical output is like the following
> > +
> > +     | lr-------- 1 root root 64 Jan 27 11:24 333c600000-333c620000 -> /usr/lib64/ld-2.18.so
> > +     | lr-------- 1 root root 64 Jan 27 11:24 333c81f000-333c820000 -> /usr/lib64/ld-2.18.so
> > +     | lr-------- 1 root root 64 Jan 27 11:24 333c820000-333c821000 -> /usr/lib64/ld-2.18.so
> > +     | ...
> > +     | lr-------- 1 root root 64 Jan 27 11:24 35d0421000-35d0422000 -> /usr/lib64/libselinux.so.1
> > +     | lr-------- 1 root root 64 Jan 27 11:24 400000-41a000 -> /usr/bin/ls
> > +
> > +The name of a link is virtual memory bounds a particular map exhibits, i.e.
> > +vm_area_struct::vm_start-vm_area_struct::vm_end.
> > +
> > +The main purpose of map_files directory is to be able to retrieve a set of
> > +memory mapped files in a fast way instead of parsing /proc/<pid>/maps or
> > +/proc/<pid>/smaps which contain a way more records. Same time one can open(2)
> > +mappings from the listings of two processes and comparing inodes figure out
> > +which anonymous memory areas are actually shared.
> 
> Thanks for details! I still don't understand how this is used for
> checkpoint/restore when the mmap offset isn't shown. Can't a process
> map, say 4K of a file, from different offsets, and it would show up
> as:
> 
> 400000-401000 -> /some/file
> 401000-402000 -> /some/file
> 
> but there'd be no way to know how to restore that mapping?

IIUC, it's complementry to data in maps/smap. If the file was closed and
unlinked, it's the only way to get file descriptor which points the inode
under mapping.

-- 
 Kirill A. Shutemov
