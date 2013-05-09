Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab3EIPKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 11:10:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754249Ab3EIPKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 11:10:23 -0400
Date: Thu, 9 May 2013 11:10:17 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Steve Grubb <sgrubb@redhat.com>
Cc: linux-audit@redhat.com, "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH] [BZ905179] audit: omit check for uid and gid validity in
 audit rules and data
Message-ID: <20130509151017.GG7402@madcap2.tricolour.ca>
References: <1363807097-13073-1-git-send-email-rgb@redhat.com>
 <87ip3w59gr.fsf@xmission.com>
 <20130416193823.GH6530@madcap2.tricolour.ca>
 <3133489.jB2ld18Orb@x2>
 <20130509135247.GF7402@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130509135247.GF7402@madcap2.tricolour.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 09:52:47AM -0400, Richard Guy Briggs wrote:
> On Thu, May 09, 2013 at 09:29:18AM -0400, Steve Grubb wrote:
> > On Tuesday, April 16, 2013 03:38:23 PM Richard Guy Briggs wrote:
> > > On Tue, Apr 09, 2013 at 02:39:32AM -0700, Eric W. Biederman wrote:
> > > > Andrew Morton <akpm@linux-foundation.org> writes:
> > > > > On Wed, 20 Mar 2013 15:18:17 -0400 Richard Guy Briggs <rgb@redhat.com> 
> > wrote:
> > > > >> audit rule additions containing "-F auid!=4294967295" were failing with
> > > > >> EINVAL.> 
> > > > The only case where this appears to make the least little bit of sense
> > > > is if the goal of the test is to test to see if an audit logloginuid
> > > > has been set at all.  In which case depending on a test against
> > > > 4294967295 is bogus because you are depending on an intimate internal
> > > > kernel implementation detail.
> > > > 
> > > > How about something like my untested patch below that add an explicit
> > > > operation to test if loginuid has been set?
> > > 
> > > Sorry for the delay in testing this, I had another urgent bug and a
> > > belligerent test box...
> > > 
> > > I like this approach better than mine now that I understand it.  I've
> > > tested the patch below without any changes.  It works as expected with
> > > my previous test case.  I don't know if a Signed-off-by: is appropriate
> > > for me in this case, but I'll throw in a:
> > > 
> > > Tested-by: Richard Guy Briggs <rbriggs@redhat.com>
> > > 
> > > and recommend a:
> > > 
> > > Reported-By: Steve Grubb <sbrubb@redhat.com>
> > 
> > If this is the approved patch, can it be put in stable? The audit system 
> > hasn't worked as intended since January.
> 
> Most certainly.  I should have added that.  I only thought about that
> after sending.

No worries, Eric added it in his set in his pull request to Linus.

> > Thanks,
> > -Steve
> > 
> > > > From: "Eric W. Biederman" <ebiederm@xmission.com>
> > > > Date: Tue, 9 Apr 2013 02:22:10 -0700
> > > > Subject: [PATCH] audit: Make testing for a valid loginuid explicit.
> > > > 
> > > > audit rule additions containing "-F auid!=4294967295" were failing
> > > > with EINVAL.
> > > > 
> > > > Apparently some userland audit rule sets want to know if loginuid uid
> > > > has been set and are using a test for auid != 4294967295 to determine
> > > > that.
> > > > 
> > > > In practice that is a horrible way to ask if a value has been set,
> > > > because it relies on subtle implementation details and will break
> > > > every time the uid implementation in the kernel changes.
> > > > 
> > > > So add a clean way to test if the audit loginuid has been set, and
> > > > silently convert the old idiom to the cleaner and more comprehensible
> > > > new idiom.
> > > > 
> > > > Reported-By: Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> > > > ---
> > > > 
> > > >  include/linux/audit.h      |    5 +++++
> > > >  include/uapi/linux/audit.h |    1 +
> > > >  kernel/auditfilter.c       |   29 +++++++++++++++++++++++++++++
> > > >  kernel/auditsc.c           |    5 ++++-
> > > >  4 files changed, 39 insertions(+), 1 deletions(-)
> > > > 
> > > > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > > > index a9fefe2..8a1ddde 100644
> > > > --- a/include/linux/audit.h
> > > > +++ b/include/linux/audit.h
> > > > @@ -390,6 +390,11 @@ static inline void audit_ptrace(struct task_struct
> > > > *t)
> > > > 
> > > >  #define audit_signals 0
> > > >  #endif /* CONFIG_AUDITSYSCALL */
> > > > 
> > > > +static inline bool audit_loginuid_set(struct task_struct *tsk)
> > > > +{
> > > > +	return uid_valid(audit_get_loginuid(tsk));
> > > > +}
> > > > +
> > > > 
> > > >  #ifdef CONFIG_AUDIT
> > > >  /* These are defined in audit.c */
> > > >  
> > > >  				/* Public API */
> > > > 
> > > > diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> > > > index 9f096f1..9554a19 100644
> > > > --- a/include/uapi/linux/audit.h
> > > > +++ b/include/uapi/linux/audit.h
> > > > @@ -246,6 +246,7 @@
> > > > 
> > > >  #define AUDIT_OBJ_TYPE	21
> > > >  #define AUDIT_OBJ_LEV_LOW	22
> > > >  #define AUDIT_OBJ_LEV_HIGH	23
> > > > 
> > > > +#define AUDIT_LOGINUID_SET	24
> > > > 
> > > >  				/* These are ONLY useful when checking
> > > >  				
> > > >  				 * at syscall exit time (AUDIT_AT_EXIT). */
> > > > 
> > > > diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
> > > > index 540f986..6381d17 100644
> > > > --- a/kernel/auditfilter.c
> > > > +++ b/kernel/auditfilter.c
> > > > @@ -349,6 +349,12 @@ static struct audit_entry *audit_rule_to_entry(struct
> > > > audit_rule *rule)> 
> > > >  		if (f->op == Audit_bad)
> > > >  		
> > > >  			goto exit_free;
> > > > 
> > > > +		/* Support legacy tests for a valid loginuid */
> > > > +		if ((f->type == AUDIT_LOGINUID) && (f->val == 4294967295)) {
> > > > +			f->type = AUDIT_LOGINUID_SET;
> > > > +			f->val = 0;
> > > > +		}
> > > > +
> > > > 
> > > >  		switch(f->type) {
> > > >  		
> > > >  		default:
> > > >  			goto exit_free;
> > > > 
> > > > @@ -377,6 +383,12 @@ static struct audit_entry *audit_rule_to_entry(struct
> > > > audit_rule *rule)> 
> > > >  			if (!gid_valid(f->gid))
> > > >  			
> > > >  				goto exit_free;
> > > >  			
> > > >  			break;
> > > > 
> > > > +		case AUDIT_LOGINUID_SET:
> > > > +			if ((f->op != Audit_not_equal) && (f->op != Audit_equal))
> > > > +				goto exit_free;
> > > > +			if ((f->val != 0) && (f->val != 1))
> > > > +				goto exit_free;
> > > > +			break;
> > > > 
> > > >  		case AUDIT_PID:
> > > >  		case AUDIT_PERS:
> > > > 
> > > >  		case AUDIT_MSGTYPE:
> > > > @@ -459,6 +471,13 @@ static struct audit_entry *audit_data_to_entry(struct
> > > > audit_rule_data *data,> 
> > > >  		f->gid = INVALID_GID;
> > > >  		f->lsm_str = NULL;
> > > >  		f->lsm_rule = NULL;
> > > > 
> > > > +
> > > > +		/* Support legacy tests for a valid loginuid */
> > > > +		if ((f->type == AUDIT_LOGINUID) && (f->val == 4294967295)) {
> > > > +			f->type = AUDIT_LOGINUID_SET;
> > > > +			f->val = 0;
> > > > +		}
> > > > +
> > > > 
> > > >  		switch(f->type) {
> > > >  		case AUDIT_UID:
> > > > 
> > > >  		case AUDIT_EUID:
> > > > @@ -487,6 +506,12 @@ static struct audit_entry *audit_data_to_entry(struct
> > > > audit_rule_data *data,> 
> > > >  			if (!gid_valid(f->gid))
> > > >  			
> > > >  				goto exit_free;
> > > >  			
> > > >  			break;
> > > > 
> > > > +		case AUDIT_LOGINUID_SET:
> > > > +			if ((f->op != Audit_not_equal) && (f->op != Audit_equal))
> > > > +				goto exit_free;
> > > > +			if ((f->val != 0) && (f->val != 1))
> > > > +				goto exit_free;
> > > > +			break;
> > > > 
> > > >  		case AUDIT_PID:
> > > >  		case AUDIT_PERS:
> > > > 
> > > >  		case AUDIT_MSGTYPE:
> > > > @@ -1380,6 +1405,10 @@ static int audit_filter_user_rules(struct
> > > > audit_krule *rule,> 
> > > >  			result = audit_uid_comparator(audit_get_loginuid(current),
> > > >  			
> > > >  						  f->op, f->uid);
> > > >  			
> > > >  			break;
> > > > 
> > > > +		case AUDIT_LOGINUID_SET:
> > > > +			result = audit_comparator(audit_loginuid_set(current),
> > > > +						  f->op, f->val);
> > > > +			break;
> > > > 
> > > >  		case AUDIT_SUBJ_USER:
> > > >  		case AUDIT_SUBJ_ROLE:
> > > > 
> > > >  		case AUDIT_SUBJ_TYPE:
> > > > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > > > index 3a11d34..27d0a50 100644
> > > > --- a/kernel/auditsc.c
> > > > +++ b/kernel/auditsc.c
> > > > @@ -750,6 +750,9 @@ static int audit_filter_rules(struct task_struct *tsk,
> > > > 
> > > >  			if (ctx)
> > > >  			
> > > >  				result = audit_uid_comparator(tsk->loginuid, f->op, 
> > f->uid);
> > > >  			
> > > >  			break;
> > > > 
> > > > +		case AUDIT_LOGINUID_SET:
> > > > +			result = audit_comparator(audit_loginuid_set(tsk), f->op, 
> > f->val);
> > > > +			break;
> > > > 
> > > >  		case AUDIT_SUBJ_USER:
> > > >  		case AUDIT_SUBJ_ROLE:
> > > > 
> > > >  		case AUDIT_SUBJ_TYPE:
> > > > @@ -2317,7 +2320,7 @@ int audit_set_loginuid(kuid_t loginuid)
> > > > 
> > > >  	unsigned int sessionid;
> > > >  
> > > >  #ifdef CONFIG_AUDIT_LOGINUID_IMMUTABLE
> > > > 
> > > > -	if (uid_valid(task->loginuid))
> > > > +	if (audit_loginuid_set(task))
> > > > 
> > > >  		return -EPERM;
> > > >  
> > > >  #else /* CONFIG_AUDIT_LOGINUID_IMMUTABLE */
> > > >  
> > > >  	if (!capable(CAP_AUDIT_CONTROL))
> > > 
> > > - RGB
> > > 
> > > --
> > > Richard Guy Briggs <rbriggs@redhat.com>
> > > Senior Software Engineer
> > > AMER ENG Base Operating Systems
> > > Remote, Canada, Ottawa
> > > Voice: 1.647.777.2635
> > > Internal: (81) 32635
> > > 
> > > --
> > > Linux-audit mailing list
> > > Linux-audit@redhat.com
> > > https://www.redhat.com/mailman/listinfo/linux-audit
> 
> - RGB
> 
> --
> Richard Guy Briggs <rbriggs@redhat.com>
> Senior Software Engineer
> AMER ENG Base Operating Systems
> Remote, Ottawa, Canada
> Voice: 1.647.777.2635
> Internal: (81) 32635

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer
AMER ENG Base Operating Systems
Remote, Ottawa, Canada
Voice: 1.647.777.2635
Internal: (81) 32635
