Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965477AbbA1Ei4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:38:56 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4218 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965308AbbA1Eiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:38:52 -0500
Date: Tue, 27 Jan 2015 20:38:32 -0800
From: Calvin Owens <calvinowens@fb.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Cyrill Gorcunov <gorcunov@gmail.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Feiner <pfeiner@google.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>,
        <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        Pavel Emelyanov <xemul@openvz.org>, <linux-api@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [RFC][PATCH v2] procfs: Always expose /proc/<pid>/map_files/ and
 make it readable
Message-ID: <20150128043832.GA2266262@mail.thefacebook.com>
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
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20150126154346.c63c512e5821e9e0ea31f759@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-27_04:2015-01-27,2015-01-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=2.77555756156289e-16 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.128698695412054
 urlsuspect_oldscore=0.128698695412054 suspectscore=2
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=2524143
 rbsscore=0.128698695412054 spamscore=0
 recipient_to_sender_domain_totalscore=12 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1501280049
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01/26 at 15:43 -0800, Andrew Morton wrote:
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

The biggest difference is that if you do something like this:

	fd = open("/stuff", O_BLAH);
	map = mmap(NULL, 4096, PROT_BLAH, MAP_SHARED, fd, 0);
	close(fd);
	unlink("/stuff");
 
...then map_files/ gives you a way to get a file descriptor for
"/stuff", which you couldn't do with /proc/pid/maps.

It's also something of a win if you just want to see what is mapped at a
specific address, since you can just readlink() the symlink for the
address range you care about and it will go grab the appropriate VMA and
give you the answer. /proc/pid/maps requires walking the VMA tree, which
is quite expensive for processes with many thousands of threads, even
without the O(N^2) issue.

(You have to know what address range you want though, since readdir() on
map_files/ obviously has to walk the VMA tree just like /proc/N/maps.)

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
> (Please add to changelog). 

Yes, the only difference is that you can follow the link as per above.
I'll resend with a new message explaining that and the deletion thing.
 
> There's one other problem here: we're assuming that the map_files
> implementation doesn't have bugs.  If it does have bugs then relaxing
> permissions like this will create new vulnerabilities.  And the
> map_files implementation is surprisingly complex.  Is it bug-free?

While I was messing with it I used it a good bit and didn't see any
issues, although I didn't actively try to fuzz it or anything. I'd be
happy to write something to test hammering it in weird ways if you like.
I'm also happy to write testcases for namespaces.

So far as security issues, as others have pointed out you can't follow
the links unless you can ptrace the process in question, which seems
like a pretty solid guarantee. As Cyrill pointed out in the discussion
about the documentation, that's the same protection as /proc/N/fd/*, and
those links function in the same way.

Thanks,
Calvin
