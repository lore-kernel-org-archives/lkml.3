Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178AbbA0AUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 19:20:36 -0500
Received: from mta-out1.inet.fi ([62.71.2.227]:43320 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755183AbbA0AUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 19:20:30 -0500
Date: Tue, 27 Jan 2015 02:19:13 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Calvin Owens <calvinowens@fb.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Feiner <pfeiner@google.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-team@fb.com,
        Pavel Emelyanov <xemul@openvz.org>, linux-api@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
Subject: Re: [RFC][PATCH v2] procfs: Always expose /proc/<pid>/map_files/ and
 make it readable
Message-ID: <20150127001913.GA3007@node.dhcp.inet.fi>
References: <1421194829-28696-1-git-send-email-calvinowens@fb.com>
 <20150114152501.GB9820@node.dhcp.inet.fi>
 <20150114153323.GF2253@moon>
 <20150114204653.GA26698@mail.thefacebook.com>
 <20150114211613.GH2253@moon>
 <20150122024554.GB23762@mail.thefacebook.com>
 <20150124031544.GA1992748@mail.thefacebook.com>
 <20150126124731.GA26916@node.dhcp.inet.fi>
 <20150126210054.GG651@moon>
 <20150126154346.c63c512e5821e9e0ea31f759@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150126154346.c63c512e5821e9e0ea31f759@linux-foundation.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 03:43:46PM -0800, Andrew Morton wrote:
> On Tue, 27 Jan 2015 00:00:54 +0300 Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> 
> > On Mon, Jan 26, 2015 at 02:47:31PM +0200, Kirill A. Shutemov wrote:
> > > On Fri, Jan 23, 2015 at 07:15:44PM -0800, Calvin Owens wrote:
> > > > Currently, /proc/<pid>/map_files/ is restricted to CAP_SYS_ADMIN, and
> > > > is only exposed if CONFIG_CHECKPOINT_RESTORE is set. This interface
> > > > is very useful for enumerating the files mapped into a process when
> > > > the more verbose information in /proc/<pid>/maps is not needed.
> 
> This is the main (actually only) justification for the patch, and it it
> far too thin.  What does "not needed" mean.  Why can't people just use
> /proc/pid/maps?
> 
> > > > This patch moves the folder out from behind CHECKPOINT_RESTORE, and
> > > > removes the CAP_SYS_ADMIN restrictions. Following the links requires
> > > > the ability to ptrace the process in question, so this doesn't allow
> > > > an attacker to do anything they couldn't already do before.
> > > > 
> > > > Signed-off-by: Calvin Owens <calvinowens@fb.com>
> > > 
> > > Cc +linux-api@
> > 
> > Looks good to me, thanks! Though I would really appreciate if someone
> > from security camp take a look as well.
> 
> hm, who's that.  Kees comes to mind.
> 
> And reviewers' task would be a heck of a lot easier if they knew what
> /proc/pid/map_files actually does.  This:
> 
> akpm3:/usr/src/25> grep -r map_files Documentation 
> akpm3:/usr/src/25> 
> 
> does not help.
> 
> The 640708a2cff7f81 changelog says:
> 
> :     This one behaves similarly to the /proc/<pid>/fd/ one - it contains
> :     symlinks one for each mapping with file, the name of a symlink is
> :     "vma->vm_start-vma->vm_end", the target is the file.  Opening a symlink
> :     results in a file that point exactly to the same inode as them vma's one.
> :     
> :     For example the ls -l of some arbitrary /proc/<pid>/map_files/
> :     
> :      | lr-x------ 1 root root 64 Aug 26 06:40 7f8f80403000-7f8f80404000 -> /lib64/libc-2.5.so
> :      | lr-x------ 1 root root 64 Aug 26 06:40 7f8f8061e000-7f8f80620000 -> /lib64/libselinux.so.1
> :      | lr-x------ 1 root root 64 Aug 26 06:40 7f8f80826000-7f8f80827000 -> /lib64/libacl.so.1.1.0
> :      | lr-x------ 1 root root 64 Aug 26 06:40 7f8f80a2f000-7f8f80a30000 -> /lib64/librt-2.5.so
> :      | lr-x------ 1 root root 64 Aug 26 06:40 7f8f80a30000-7f8f80a4c000 -> /lib64/ld-2.5.so
> 
> afacit this info is also available in /proc/pid/maps, so things
> shouldn't get worse if the /proc/pid/map_files permissions are at least
> as restrictive as the /proc/pid/maps permissions.  Is that the case? 

Almost.

IIUC, before we haven't had a way to retrieve a file descriptor from
mapped file if it was closed and not accessible for direct re-open. Like
in chroot case or unlink after close.

I'm not sure what security implications this move has, if any. I don't see
anything obviously dangerous.

-- 
 Kirill A. Shutemov
