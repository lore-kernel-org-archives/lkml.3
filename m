Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933810AbaJUWae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 18:30:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933387AbaJUWab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 18:30:31 -0400
Message-ID: <1413930629.30946.68.camel@localhost>
Subject: Re: [RFC][PATCH] audit: log join and part events to the read-only
 multicast log socket
From: Eric Paris <eparis@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: Steve Grubb <sgrubb@redhat.com>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, pmoore@redhat.com
Date: Tue, 21 Oct 2014 18:30:29 -0400
In-Reply-To: <20141021210511.GL15532@madcap2.tricolour.ca>
References: <30ef5c1ba42b52953e5684a0322975c3f0fadc77.1412706089.git.rgb@redhat.com>
	 <1412708594.3333.94.camel@localhost> <2131923.Byl8GhZuQt@x2>
	 <20141021210511.GL15532@madcap2.tricolour.ca>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-21 at 17:08 -0400, Richard Guy Briggs wrote:
> On 14/10/21, Steve Grubb wrote:
> > On Tuesday, October 07, 2014 03:03:14 PM Eric Paris wrote:
> > > On Tue, 2014-10-07 at 14:23 -0400, Richard Guy Briggs wrote:
> > > > Log the event when a client attempts to connect to the netlink audit
> > > > multicast socket, requiring CAP_AUDIT_READ capability, binding to the
> > > > AUDIT_NLGRP_READLOG group.  Log the disconnect too.
> > > >
> > > > 
> > > >
> > > > Sample output:
> > > > time->Tue Oct  7 14:15:19 2014
> > > > type=UNKNOWN[1348] msg=audit(1412705719.316:117): auid=0 uid=0 gid=0 ses=1
> > > > pid=3552 comm="audit-multicast"
> > > > exe="/home/rgb/rgb/git/audit-multicast-listen/audit-multicast-listen"
> > > > subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 group=0
> > > > op=connect res=1>
> > > > 
> > > >
> > > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > > ---
> > > > For some reason unbind isn't being called on disconnect.  I suspect
> > > > missing
> > > > plumbing in netlink.  Investigation needed...
> > > >
> > > > 
> > > >  include/uapi/linux/audit.h |    1 +
> > > >  kernel/audit.c             |   46
> > > >++++++++++++++++++++++++++++++++++++++++++- 2 files changed, 45
> > > >insertions(+), 2 deletions(-)
> > > > 
> > > >
> > > > diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> > > > index 4d100c8..7fa6e8f 100644
> > > > --- a/include/uapi/linux/audit.h
> > > > +++ b/include/uapi/linux/audit.h
> > > > @@ -110,6 +110,7 @@
> > > >
> > > >  #define AUDIT_SECCOMP                1326    /* Secure Computing event */
> > > >  #define AUDIT_PROCTITLE              1327    /* Proctitle emit event */
> > > >  #define AUDIT_FEATURE_CHANGE 1328    /* audit log listing feature changes
> > > >*/>
> > > > +#define AUDIT_EVENT_LISTENER 1348    /* task joined multicast read socket
> > > > */>
> > > >  
> > > >  #define AUDIT_AVC            1400    /* SE Linux avc denial or grant */
> > > >  #define AUDIT_SELINUX_ERR    1401    /* Internal SE Linux Errors */
> > > >
> > > > diff --git a/kernel/audit.c b/kernel/audit.c
> > > > index 53bb39b..74c81a7 100644
> > > > --- a/kernel/audit.c
> > > > +++ b/kernel/audit.c
> > > > @@ -1108,13 +1108,54 @@ static void audit_receive(struct sk_buff  *skb)
> > > >
> > > >       mutex_unlock(&audit_cmd_mutex);
> > > >  }
> > > >  
> > > >
> > > > +static void audit_log_bind(int group, char *op, int err)
> > > > +{
> > > > +     struct audit_buffer *ab;
> > > > +     char comm[sizeof(current->comm)];
> > > > +     struct mm_struct *mm = current->mm;
> > > > +
> > > > +     ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_EVENT_LISTENER);
> > > > +     if (!ab)
> > > > +             return;
> > > > +
> > > > +     audit_log_format(ab, "auid=%d",
> > > > +                     from_kuid(&init_user_ns,
> > > > audit_get_loginuid(current))); +     audit_log_format(ab, " uid=%d",
> > > > +                      from_kuid(&init_user_ns, current_uid()));
> > > > +     audit_log_format(ab, " gid=%d",
> > > > +                      from_kgid(&init_user_ns, current_gid()));
> > > > +     audit_log_format(ab, " ses=%d", audit_get_sessionid(current));
> > > > +     audit_log_format(ab, " pid=%d", task_pid_nr(current));
> > > > +     audit_log_format(ab, " comm=");
> > > > +     audit_log_untrustedstring(ab, get_task_comm(comm, current));
> > > > +     if (mm) {
> > > > +             down_read(&mm->mmap_sem);
> > > > +             if (mm->exe_file)
> > > > +                     audit_log_d_path(ab, " exe=",
> > > > &mm->exe_file->f_path);
> > > > +             up_read(&mm->mmap_sem);
> > > > +     } else 
> > > > +             audit_log_format(ab, " exe=(null)");
> > > > +     audit_log_task_context(ab); /* subj= */
> > > 
> > > super crazy yuck.  audit_log_task_info() ??
> > 
> > audit_log_task_info logs too much information for typical use. There are times 
> > when you might want to know everything about what's connecting. But in this 
> > case, we don't need anything about groups, saved uids, fsuid, or ppid.
> > 
> > Its a shame we don't have a audit_log_task_info_light function which only 
> > records:
> > 
> > pid= auid= uid= subj= comm= exe=  ses= tty=
> 
> We already have audit_log_task() which gives:
> 	auid=
> 	uid=
> 	gid=
> 	ses=
> 	subj=
> 	pid=
> 	comm=
> 	exe=
> This is missing tty=, but has gid=.  Can we please use that function
> instead and add tty=?  And while we are at it, refactor
> audit_log_task_info() to call audit_log_task()?
> 
> Is this standard set above what should be used for certain classes of
> log messages?
> 
> Yes, it will be in a different order because we don't have a canonical
> order yet.  Can we accept two orders of keywords so we can start
> canonicalizing, please?

I've always hated the fact that we include this in ANY current audit
message.  I truly believe we need two new record types.

AUDIT_PROCESS_INFO
AUDIT_EXTENDED_PROCESS_INFO

What does my UID have to do with a syscall?  Why is it in the record?
It's a pretty big change, like, RHEL8, but splitting the reporting of
process info from other records will make all matter of things, in the
kernel and in userspace so much cleaner...

Nuts:
type=SYSCALL msg=audit(10/13/2014 03:07:39.919:117953) : arch=x86_64 syscall=stat success=yes exit=0 a0=0x1332f60 a1=0x7fff8749e6d0 a2=0x7fff8749e6d0 a3=0x0 items=1 ppid=28212 pid=30066 auid=root uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root tty=(none) ses=367 comm=lsof exe=/usr/sbin/lsof subj=system_u:system_r:system_cronjob_t:s0-s0:c0.c1023 key=(null) 

Slightly (and yes, just slightly) Less Nuts:
type=SYSCALL msg=audit(10/13/2014 03:07:39.919:117953) : arch=x86_64 syscall=stat success=yes exit=0 a0=0x1332f60 a1=0x7fff8749e6d0 a2=0x7fff8749e6d0 a3=0x0
type=AUDIT_PROCESS_INFO msg=audit(10/13/2014 03:07:39.919:117953) : pid=30066 auid=root uid=root gid=root tty=(none) ses=367 comm=lsof exe=/usr/sbin/lsof subj=system_u:system_r:system_cronjob_t:s0-s0:c0.c1023 key=(null)
type=AUDIT_EXTENDED_PROCESS_INFO msg=audit(10/13/2014 03:07:39.919:117953) : ppid=28212 euid=root suid=root fsuid=root egid=root sgid=root fsgid=root key=(null)

It'd be weird is a syscall record actually only had syscall information....

