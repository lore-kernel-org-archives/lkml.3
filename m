Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbbA0HhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 02:37:22 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:48546 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbbA0HhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 02:37:16 -0500
Date: Tue, 27 Jan 2015 10:37:13 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Calvin Owens <calvinowens@fb.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Feiner <pfeiner@google.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kernel-team@fb.com,
        Pavel Emelyanov <xemul@openvz.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [RFC][PATCH v2] procfs: Always expose /proc/<pid>/map_files/ and
 make it readable
Message-ID: <20150127073713.GJ651@moon>
References: <20150114152501.GB9820@node.dhcp.inet.fi>
 <20150114153323.GF2253@moon>
 <20150114204653.GA26698@mail.thefacebook.com>
 <20150114211613.GH2253@moon>
 <20150122024554.GB23762@mail.thefacebook.com>
 <20150124031544.GA1992748@mail.thefacebook.com>
 <20150126124731.GA26916@node.dhcp.inet.fi>
 <20150126210054.GG651@moon>
 <20150126154346.c63c512e5821e9e0ea31f759@linux-foundation.org>
 <CAGXu5jLDkg0hJSMm3CdoO-77yiK5GQWHSe3+1h7mq76LERpNBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jLDkg0hJSMm3CdoO-77yiK5GQWHSe3+1h7mq76LERpNBA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 04:15:26PM -0800, Kees Cook wrote:
> >
> > akpm3:/usr/src/25> grep -r map_files Documentation
> 
> If akpm's comments weren't clear: this needs to be fixed. Everything
> in /proc should appear in Documentation.

I'll do that.

> > The 640708a2cff7f81 changelog says:
> >
> > :     This one behaves similarly to the /proc/<pid>/fd/ one - it contains
> > :     symlinks one for each mapping with file, the name of a symlink is
> > :     "vma->vm_start-vma->vm_end", the target is the file.  Opening a symlink
> > :     results in a file that point exactly to the same inode as them vma's one.
> > :
> > :     For example the ls -l of some arbitrary /proc/<pid>/map_files/
> > :
> > :      | lr-x------ 1 root root 64 Aug 26 06:40 7f8f80403000-7f8f80404000 -> /lib64/libc-2.5.so
> > :      | lr-x------ 1 root root 64 Aug 26 06:40 7f8f8061e000-7f8f80620000 -> /lib64/libselinux.so.1
> > :      | lr-x------ 1 root root 64 Aug 26 06:40 7f8f80826000-7f8f80827000 -> /lib64/libacl.so.1.1.0
> > :      | lr-x------ 1 root root 64 Aug 26 06:40 7f8f80a2f000-7f8f80a30000 -> /lib64/librt-2.5.so
> > :      | lr-x------ 1 root root 64 Aug 26 06:40 7f8f80a30000-7f8f80a4c000 -> /lib64/ld-2.5.so
> 
> How is mmap offset represented in this output?

We're printing vm_area_struct:[vm_start;vm_end] only.

> > afacit this info is also available in /proc/pid/maps, so things
> > shouldn't get worse if the /proc/pid/map_files permissions are at least
> > as restrictive as the /proc/pid/maps permissions.  Is that the case?
> > (Please add to changelog).
> 
> Both maps and map_files uses ptrace_may_access (via mm_acces) with
> PTRACE_MODE_READ, so I'm happy from a info leak perspective.
> 
> Are mount namespaces handled in this output?

Could you clarify this moment, i'm not sure i get it.

> 
> > There's one other problem here: we're assuming that the map_files
> > implementation doesn't have bugs.  If it does have bugs then relaxing
> > permissions like this will create new vulnerabilities.  And the
> > map_files implementation is surprisingly complex.  Is it bug-free?
