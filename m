Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936323Ab3DIUQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 16:16:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935899Ab3DIUQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 16:16:04 -0400
Date: Tue, 9 Apr 2013 16:15:58 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com, Eric Paris <eparis@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] [BZ905179] audit: omit check for uid and gid validity in
 audit rules and data
Message-ID: <20130409201558.GE31242@madcap2.tricolour.ca>
References: <1363807097-13073-1-git-send-email-rgb@redhat.com>
 <20130408164622.284f48c65341396aa8dbd220@linux-foundation.org>
 <87ip3w59gr.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ip3w59gr.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 02:39:32AM -0700, Eric W. Biederman wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
> > On Wed, 20 Mar 2013 15:18:17 -0400 Richard Guy Briggs <rgb@redhat.com> wrote:
> >> audit rule additions containing "-F auid!=4294967295" were failing with EINVAL.
> >> 
> >> UID_INVALID (and GID_INVALID) is actually a valid uid (gid) for setting and
> >> testing against audit rules.  Remove the check for invalid uid and gid when
> >> parsing rules and data for logging.
> 
> In general testing against invalid uid appears completely bogus, and
> should always return true.  As it is and essentially always has been
> incorrect to explicitly set any kernel uid to that value.

My understanding is that any process started by init has UID -1
(UID_INVALID).  I was a little uncomfortable with this fact when I
learned it, but understand that it is probably too late to change that
now to a reserved value in-band (some probably use -2 or 4294967294 for
nobody).

This leaves an out-of-band solution as has been partially suggested below...

> The only case where this appears to make the least little bit of sense
> is if the goal of the test is to test to see if an audit logloginuid
> has been set at all.  In which case depending on a test against
> 4294967295 is bogus because you are depending on an intimate internal
> kernel implementation detail.

I agree this is ugly.

> Certainly removing the gid_valid tests is completely gratitious in this
> case.

I think I understand that now.

> >> Revert part of ca57ec0f00c3f139c41bf6b0a5b9bcc95bbb2ad7 (2012-09-11) to fix
> >> this.
> >
> > Eric, can you please take a look?
> >
> >> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> >> ---
> >>  kernel/auditfilter.c |   12 ------------
> >>  1 files changed, 0 insertions(+), 12 deletions(-)
> >> 
> >> diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
> >> index f9fc54b..457ee39 100644
> >> --- a/kernel/auditfilter.c
> >> +++ b/kernel/auditfilter.c
> >> @@ -360,10 +360,7 @@ static struct audit_entry *audit_rule_to_entry(struct audit_rule *rule)
> >>  			/* bit ops not implemented for uid comparisons */
> >>  			if (f->op == Audit_bitmask || f->op == Audit_bittest)
> >>  				goto exit_free;
> >> -
> >>  			f->uid = make_kuid(current_user_ns(), f->val);
> >> -			if (!uid_valid(f->uid))
> >> -				goto exit_free;
> >
> > It concerns me that map_id_down() can return -1 on error and that this
> > change causes the kernel to no longer notice that error?
> 
> Me too.  Where we only communicate with audit in the initial user
> namespace right now it isn't absolutely broken but it certainly isn't a
> habit I want to get into.

It will be soon if we try to get auditd in containers talking to the
host kernel, so I agree this needs a better approach.

> How about something like my untested patch below that add an explicit
> operation to test if loginuid has been set?
> 
> Eric
> 
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> Date: Tue, 9 Apr 2013 02:22:10 -0700
> Subject: [PATCH] audit: Make testing for a valid loginuid explicit.
> 
> audit rule additions containing "-F auid!=4294967295" were failing
> with EINVAL.
> 
> Apparently some userland audit rule sets want to know if loginuid uid
> has been set and are using a test for auid != 4294967295 to determine
> that.
> 
> In practice that is a horrible way to ask if a value has been set,
> because it relies on subtle implementation details and will break
> every time the uid implementation in the kernel changes.
> 
> So add a clean way to test if the audit loginuid has been set, and
> silently convert the old idiom to the cleaner and more comprehensible
> new idiom.
> 
> Reported-By: Richard Guy Briggs <rgb@redhat.com> wrote:

The reporting credit goes to Steve Grubb <sgrubb@redhat.com>.  I just
attempted a fix.

> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  include/linux/audit.h      |    5 +++++
>  include/uapi/linux/audit.h |    1 +
>  kernel/auditfilter.c       |   29 +++++++++++++++++++++++++++++
>  kernel/auditsc.c           |    5 ++++-
>  4 files changed, 39 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index a9fefe2..8a1ddde 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -390,6 +390,11 @@ static inline void audit_ptrace(struct task_struct *t)
>  #define audit_signals 0
>  #endif /* CONFIG_AUDITSYSCALL */
>  
> +static inline bool audit_loginuid_set(struct task_struct *tsk)
> +{
> +	return uid_valid(audit_get_loginuid(tsk));
> +}
> +
>  #ifdef CONFIG_AUDIT
>  /* These are defined in audit.c */
>  				/* Public API */
> diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> index 9f096f1..9554a19 100644
> --- a/include/uapi/linux/audit.h
> +++ b/include/uapi/linux/audit.h
> @@ -246,6 +246,7 @@
>  #define AUDIT_OBJ_TYPE	21
>  #define AUDIT_OBJ_LEV_LOW	22
>  #define AUDIT_OBJ_LEV_HIGH	23
> +#define AUDIT_LOGINUID_SET	24
>  
>  				/* These are ONLY useful when checking
>  				 * at syscall exit time (AUDIT_AT_EXIT). */
> diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
> index 540f986..6381d17 100644
> --- a/kernel/auditfilter.c
> +++ b/kernel/auditfilter.c
> @@ -349,6 +349,12 @@ static struct audit_entry *audit_rule_to_entry(struct audit_rule *rule)
>  		if (f->op == Audit_bad)
>  			goto exit_free;
>  
> +		/* Support legacy tests for a valid loginuid */
> +		if ((f->type == AUDIT_LOGINUID) && (f->val == 4294967295)) {
> +			f->type = AUDIT_LOGINUID_SET;
> +			f->val = 0;
> +		}
> +
>  		switch(f->type) {
>  		default:
>  			goto exit_free;
> @@ -377,6 +383,12 @@ static struct audit_entry *audit_rule_to_entry(struct audit_rule *rule)
>  			if (!gid_valid(f->gid))
>  				goto exit_free;
>  			break;
> +		case AUDIT_LOGINUID_SET:
> +			if ((f->op != Audit_not_equal) && (f->op != Audit_equal))
> +				goto exit_free;
> +			if ((f->val != 0) && (f->val != 1))

Why the extra comparison to "1"?

Are you anticipating already a userspace process making a call using the
newof type AUDIT_LOGINUID_SET with a value of 1?

> +				goto exit_free;
> +			break;
>  		case AUDIT_PID:
>  		case AUDIT_PERS:
>  		case AUDIT_MSGTYPE:
> @@ -459,6 +471,13 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
>  		f->gid = INVALID_GID;
>  		f->lsm_str = NULL;
>  		f->lsm_rule = NULL;
> +
> +		/* Support legacy tests for a valid loginuid */
> +		if ((f->type == AUDIT_LOGINUID) && (f->val == 4294967295)) {
> +			f->type = AUDIT_LOGINUID_SET;
> +			f->val = 0;
> +		}
> +
>  		switch(f->type) {
>  		case AUDIT_UID:
>  		case AUDIT_EUID:
> @@ -487,6 +506,12 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
>  			if (!gid_valid(f->gid))
>  				goto exit_free;
>  			break;
> +		case AUDIT_LOGINUID_SET:
> +			if ((f->op != Audit_not_equal) && (f->op != Audit_equal))
> +				goto exit_free;
> +			if ((f->val != 0) && (f->val != 1))

(Again...)

> +				goto exit_free;
> +			break;
>  		case AUDIT_PID:
>  		case AUDIT_PERS:
>  		case AUDIT_MSGTYPE:
> @@ -1380,6 +1405,10 @@ static int audit_filter_user_rules(struct audit_krule *rule,
>  			result = audit_uid_comparator(audit_get_loginuid(current),
>  						  f->op, f->uid);
>  			break;
> +		case AUDIT_LOGINUID_SET:
> +			result = audit_comparator(audit_loginuid_set(current),
> +						  f->op, f->val);
> +			break;
>  		case AUDIT_SUBJ_USER:
>  		case AUDIT_SUBJ_ROLE:
>  		case AUDIT_SUBJ_TYPE:
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index 3a11d34..27d0a50 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -750,6 +750,9 @@ static int audit_filter_rules(struct task_struct *tsk,
>  			if (ctx)
>  				result = audit_uid_comparator(tsk->loginuid, f->op, f->uid);
>  			break;
> +		case AUDIT_LOGINUID_SET:
> +			result = audit_comparator(audit_loginuid_set(tsk), f->op, f->val);
> +			break;

(OT: I assume the "if (ctx)" is wrong in the AUDIT_LOGINUID case above.)

>  		case AUDIT_SUBJ_USER:
>  		case AUDIT_SUBJ_ROLE:
>  		case AUDIT_SUBJ_TYPE:
> @@ -2317,7 +2320,7 @@ int audit_set_loginuid(kuid_t loginuid)
>  	unsigned int sessionid;
>  
>  #ifdef CONFIG_AUDIT_LOGINUID_IMMUTABLE
> -	if (uid_valid(task->loginuid))
> +	if (audit_loginuid_set(task))
>  		return -EPERM;
>  #else /* CONFIG_AUDIT_LOGINUID_IMMUTABLE */
>  	if (!capable(CAP_AUDIT_CONTROL))
> -- 
> 1.7.5.4
> 

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer
AMER ENG Base Operating Systems
Remote, Canada, Ottawa
Voice: 1.647.777.2635
Internal: (81) 32635
