Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615AbbAWFwh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 00:52:37 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37761 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751009AbbAWFwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 00:52:34 -0500
Date: Thu, 22 Jan 2015 21:52:16 -0800
From: Calvin Owens <calvinowens@fb.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: Cyrill Gorcunov <gorcunov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Feiner <pfeiner@google.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>,
        <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][PATCH] procfs: Always expose /proc/<pid>/map_files/ and
 make it readable
Message-ID: <20150123055216.GB36613@mail.thefacebook.com>
References: <1421194829-28696-1-git-send-email-calvinowens@fb.com>
 <20150114152501.GB9820@node.dhcp.inet.fi>
 <20150114153323.GF2253@moon>
 <20150114204653.GA26698@mail.thefacebook.com>
 <20150114211613.GH2253@moon>
 <20150122024554.GB23762@mail.thefacebook.com>
 <20150122110210.GA31186@node.dhcp.inet.fi>
 <20150122210025.GA36613@mail.thefacebook.com>
 <20150122212740.GA2286@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20150122212740.GA2286@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-23_02:2015-01-23,2015-01-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=0
 compositescore=0.128698695412054 urlsuspect_oldscore=0.128698695412054
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=2524143
 rbsscore=0.128698695412054 spamscore=0
 recipient_to_sender_domain_totalscore=12 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1501230065
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01/22 at 23:27 +0200, Kirill A. Shutemov wrote:
> On Thu, Jan 22, 2015 at 01:00:25PM -0800, Calvin Owens wrote:
> > On Thursday 01/22 at 13:02 +0200, Kirill A. Shutemov wrote:
> > > On Wed, Jan 21, 2015 at 06:45:54PM -0800, Calvin Owens wrote:
> > > > Currently, /proc/<pid>/map_files/ is restricted to CAP_SYS_ADMIN, and
> > > > is only exposed if CONFIG_CHECKPOINT_RESTORE is set. This interface
> > > > is very useful for enumerating the files mapped into a process when
> > > > the more verbose information in /proc/<pid>/maps is not needed.
> > > > 
> > > > This patch moves the folder out from behind CHECKPOINT_RESTORE, and
> > > > removes the CAP_SYS_ADMIN restrictions. To avoid exposing files to
> > > > processes for whom they may not be visible, a follow_link() stub is
> > > > added to the inode_operations struct attached to the symlinks that
> > > > prevent them from being followed without CAP_SYS_ADMIN.
> > > > 
> > > > Signed-off-by: Calvin Owens <calvinowens@fb.com>
> > > > ---
> > > >  fs/proc/base.c | 42 +++++++++++++++++++++++-------------------
> > > >  1 file changed, 23 insertions(+), 19 deletions(-)
> > > > 
> > > > diff --git a/fs/proc/base.c b/fs/proc/base.c
> > > > index 3f3d7ae..7d48003 100644
> > > > --- a/fs/proc/base.c
> > > > +++ b/fs/proc/base.c
> > > > @@ -1632,8 +1632,6 @@ end_instantiate:
> > > >  	return dir_emit(ctx, name, len, 1, DT_UNKNOWN);
> > > >  }
> > > >  
> > > > -#ifdef CONFIG_CHECKPOINT_RESTORE
> > > > -
> > > >  /*
> > > >   * dname_to_vma_addr - maps a dentry name into two unsigned longs
> > > >   * which represent vma start and end addresses.
> > > > @@ -1660,11 +1658,6 @@ static int map_files_d_revalidate(struct dentry *dentry, unsigned int flags)
> > > >  	if (flags & LOOKUP_RCU)
> > > >  		return -ECHILD;
> > > >  
> > > > -	if (!capable(CAP_SYS_ADMIN)) {
> > > > -		status = -EPERM;
> > > > -		goto out_notask;
> > > > -	}
> > > > -
> > > >  	inode = dentry->d_inode;
> > > >  	task = get_proc_task(inode);
> > > >  	if (!task)
> > > > @@ -1753,6 +1746,28 @@ struct map_files_info {
> > > >  	unsigned char	name[4*sizeof(long)+2]; /* max: %lx-%lx\0 */
> > > >  };
> > > >  
> > > > +/*
> > > > + * Allowing any user to follow the symlinks in /proc/<pid>/map_files/ could
> > > > + * allow processes to access files that should not be visible to them, so
> > > > + * restrict follow_link() to CAP_SYS_ADMIN for these files.
> > > > + */
> > > > +static void *proc_map_files_follow_link(struct dentry *d, struct nameidata *n)
> > > > +{
> > > > +	if (!capable(CAP_SYS_ADMIN))
> > > > +		return ERR_PTR(-EPERM);
> > > > +
> > > > +	return proc_pid_follow_link(d, n);
> > > > +}
> > > 
> > > I have thought a bit more about this and not sure it's reasonable to
> > > limit it to CAP_SYS_ADMIN. What scenario are we protecting from?
> > > 
> > > Initially, I thought about something like this: privileged process opens a
> > > file, map part of it, closes the file and drop privileges with hope to
> > > limit further access to mapped window of the file. But I don't see what
> > > would stop the unprivileged process from accessing rest of the file using
> > > mremap(2). And if a process can do this, anybody who can ptrace(2) the
> > > process can do this.
> > > 
> > > Am I missing something?
> > 
> > The specific case I was thinking of is a process in a chroot with a
> > mounted /proc inside of it: if a process inside the chroot has the same
> > UID as a process outside of it, the chroot'ed process could follow the
> > symlinks in map_files/ and poke files it can't actually see, right?
> 
> It depends on how you define "poke". If you mean touch content of the
> file, then, well, you can do it now. You cannot do anything which requires
> file descriptor -- open(), ftrancate(), etc.

Ah okay, I didn't realize you couldn't get the file descriptor. I wrote
a quick test case, you get -EACCES on open() in my chroot scenario.

I'll resend without the CAP_SYS_ADMIN check.

Thanks,
Calvin
