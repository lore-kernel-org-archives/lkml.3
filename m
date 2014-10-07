Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbaJGTkC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 15:40:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbaJGTkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 15:40:00 -0400
Date: Tue, 7 Oct 2014 15:39:51 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org, sgrubb@redhat.com,
        pmoore@redhat.com, ebiederm@xmission.com, serge@hallyn.com,
        keescook@chromium.org
Subject: Re: [RFC][PATCH] audit: log join and part events to the read-only
 multicast log socket
Message-ID: <20141007193951.GZ1992@madcap2.tricolour.ca>
References: <30ef5c1ba42b52953e5684a0322975c3f0fadc77.1412706089.git.rgb@redhat.com>
 <1412708594.3333.94.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412708594.3333.94.camel@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/10/07, Eric Paris wrote:
> On Tue, 2014-10-07 at 14:23 -0400, Richard Guy Briggs wrote:
> > Log the event when a client attempts to connect to the netlink audit multicast
> > socket, requiring CAP_AUDIT_READ capability, binding to the AUDIT_NLGRP_READLOG
> > group.  Log the disconnect too.
> > 
> > Sample output:
> > time->Tue Oct  7 14:15:19 2014
> > type=UNKNOWN[1348] msg=audit(1412705719.316:117): auid=0 uid=0 gid=0 ses=1 pid=3552 comm="audit-multicast" exe="/home/rgb/rgb/git/audit-multicast-listen/audit-multicast-listen" subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 group=0 op=connect res=1
> > 
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> > For some reason unbind isn't being called on disconnect.  I suspect missing
> > plumbing in netlink.  Investigation needed...
> > 
> >  include/uapi/linux/audit.h |    1 +
> >  kernel/audit.c             |   46 ++++++++++++++++++++++++++++++++++++++++++-
> >  2 files changed, 45 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> > index 4d100c8..7fa6e8f 100644
> > --- a/include/uapi/linux/audit.h
> > +++ b/include/uapi/linux/audit.h
> > @@ -110,6 +110,7 @@
> >  #define AUDIT_SECCOMP		1326	/* Secure Computing event */
> >  #define AUDIT_PROCTITLE		1327	/* Proctitle emit event */
> >  #define AUDIT_FEATURE_CHANGE	1328	/* audit log listing feature changes */
> > +#define AUDIT_EVENT_LISTENER	1348	/* task joined multicast read socket */
> >  
> >  #define AUDIT_AVC		1400	/* SE Linux avc denial or grant */
> >  #define AUDIT_SELINUX_ERR	1401	/* Internal SE Linux Errors */
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index 53bb39b..74c81a7 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -1108,13 +1108,54 @@ static void audit_receive(struct sk_buff  *skb)
> >  	mutex_unlock(&audit_cmd_mutex);
> >  }
> >  
> > +static void audit_log_bind(int group, char *op, int err)
> > +{
> > +	struct audit_buffer *ab;
> > +	char comm[sizeof(current->comm)];
> > +	struct mm_struct *mm = current->mm;
> > +
> > +	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_EVENT_LISTENER);
> > +	if (!ab)
> > +		return;
> > +
> > +	audit_log_format(ab, "auid=%d",
> > +			from_kuid(&init_user_ns, audit_get_loginuid(current)));
> > +	audit_log_format(ab, " uid=%d",
> > +			 from_kuid(&init_user_ns, current_uid()));
> > +	audit_log_format(ab, " gid=%d",
> > +			 from_kgid(&init_user_ns, current_gid()));
> > +	audit_log_format(ab, " ses=%d", audit_get_sessionid(current));
> > +	audit_log_format(ab, " pid=%d", task_pid_nr(current));
> > +	audit_log_format(ab, " comm=");
> > +	audit_log_untrustedstring(ab, get_task_comm(comm, current));
> > +	if (mm) {
> > +		down_read(&mm->mmap_sem);
> > +		if (mm->exe_file)
> > +			audit_log_d_path(ab, " exe=", &mm->exe_file->f_path);
> > +		up_read(&mm->mmap_sem);
> > +	} else 
> > +		audit_log_format(ab, " exe=(null)");
> > +	audit_log_task_context(ab); /* subj= */
> 
> super crazy yuck.  audit_log_task_info() ??

I agree.  I already suggested that a while ago.  I'd love to.  sgrubb
thinks it dumps way too much info.  We still haven't got a definitive
answer about what is enough and what is too much info for any given type
of record.

I also thought of moving audit_log_task() from auditsc.c to audit.c
and using that.  For that matter, both audit_log_task() and
audit_log_task_info() could use audit_log_session_info(), but they are
in slightly different order of keywords which will upset sgrubb's
parser.

What to do?

Another paragraph I'd like to see added to
	http://people.redhat.com/sgrubb/audit/audit-parse.txt
would be a "canonical order" of keywords.  However, that discussion went
nowhere.  Would it be reasonable to suggest only two possible orders
instead of the almost infinite iterations possible and declare a
standard order of keywords and gradually move to it?

> > +	audit_log_format(ab, " group=%d", group);
> 
> group seems like too easily confused a name.

"multicast_group" or "mc_group"?

> > +	audit_log_format(ab, " op=%s", op);
> > +	audit_log_format(ab, " res=%d", !err);
> > +	audit_log_end(ab);
> > +}
> > +
> >  /* Run custom bind function on netlink socket group connect or bind requests. */
> >  static int audit_bind(int group)
> >  {
> > +	int err = 0;
> > +
> >  	if (!capable(CAP_AUDIT_READ))
> > -		return -EPERM;
> > +		err = -EPERM;
> > +	audit_log_bind(group, "connect", err);
> > +	return err;
> > +}
> >  
> > -	return 0;
> > +static void audit_unbind(int group)
> > +{
> > +	audit_log_bind(group, "disconnect", 0);
> >  }
> >  
> >  static int __net_init audit_net_init(struct net *net)
> > @@ -1124,6 +1165,7 @@ static int __net_init audit_net_init(struct net *net)
> >  		.bind	= audit_bind,
> >  		.flags	= NL_CFG_F_NONROOT_RECV,
> >  		.groups	= AUDIT_NLGRP_MAX,
> > +		.unbind	= audit_unbind,
> >  	};
> >  
> >  	struct audit_net *aunet = net_generic(net, audit_net_id);
> 
> 

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
