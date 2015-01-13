Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbbAMQVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:21:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215AbbAMQVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:21:38 -0500
Date: Tue, 13 Jan 2015 11:21:30 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Calvin Owens <calvinowens@fb.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-audit@redhat.com, ebiederm@xmission.com, kernel-team@fb.com
Subject: Re: [PATCH][RESEND 2] Revert "AUDIT: Allow login in non-init
 namespaces"
Message-ID: <20150113162130.GK29998@madcap2.tricolour.ca>
References: <1415148371-11742-1-git-send-email-calvinowens@fb.com>
 <20141118203221.GA1687992@mail.thefacebook.com>
 <20150109014448.GF27996@mail.thefacebook.com>
 <20150113153443.GH512@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150113153443.GH512@madcap2.tricolour.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/01/13, Richard Guy Briggs wrote:
> On 15/01/08, Calvin Owens wrote:
> > This reverts 543bc6a1a987 "AUDIT: Allow login in non-init namespaces".
> > 
> > This commit incorrectly assumes that libpam treats -ECONNREFUSED as
> > an indicator that audit is disabled, and -EPERM or any other error
> > as a fatal error that prevents the login from continuing.
> 
> Which netlink audit message type is actually failing?
> Is it AUDIT_TTY_{G,S}ET or is it an AUDIT_USER_* message?  The former
> requires CAP_AUDIT_CONTROL and both PID and user init namespace (for
> now) and the latter requires CAP_AUDIT_WRITE and only user init
> namespace.
> 
> > The opposite is in fact true: -EPERM allows the login to continue,
> > and -ECONNREFUSED causes it to refuse the login. This behavior has
> > been unchanged in upstream linux-pam since at least 2008.
> 
> So this sounds to me like standard PAM usage is inverted from PAM usage
> in containers.
> 
> > Reverting this change allows libpam to again work as expected in
> > non-init user namespaces.
> 
> However, that will break other things...
> 
> Do you have test cases to show this?
> 
> Currently:
> If audit is not available, return ECONNREFUSED. (netlink_unicast_kernel)

In fact, the socket() call should fail before that with EPROTONOSUPPORT. (in netlink_create)

> If not in init user namespace, return ECONNREFUSED. (audit_netlink_ok)
> 
> If control message and not init PID ns, return EPERM (audit_netlink_ok)
> 
> If control message and not CAP_AUDIT_CONTROL, return EPERM (audit_netlink_ok)
> 
> If user log message and not CAP_AUDIT_WRITE, return EPERM (audit_netlink_ok)
> 
> If unrecognized message, return EINVAL (audit_netlink_ok)
> 
> 
> Listening in non-init net namespaces caused EPERM to be returned by
> audit instead of ECONNREFUSED by netlink due to lack of perms when the
> sending process didn't have CAP_AUDIT_WRITE.  Fixed in docker bz1119849
> 	http://blog.oddbit.com/2014/07/21/tracking-down-a-kernel-bug-wit/
> 
> 
> > Signed-off-by: Calvin Owens <calvinowens@fb.com>
> > Cc: stable@vger.kernel.org
> > ---
> > Relevant code in linux-pam:
> > https://git.fedorahosted.org/cgit/linux-pam.git/tree/libpam/pam_audit.c#n56
> 
> This code only checks for an error return of -EPERM when the userid is
> non-root.  Is login running as root, or has it already forked and is
> running as an unprivileged user at that point?  Audit doesn't care about
> the UID even though many equate root (superuser) with full capabilities.
> Audit only looks at capabilities and namespaces.  Is this relevant to PAM?
> 
> >  kernel/audit.c | 12 +-----------
> >  1 file changed, 1 insertion(+), 11 deletions(-)
> > 
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index 80983df..656e8ce 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -640,18 +640,8 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
> >  	int err = 0;
> >  
> >  	/* Only support initial user namespace for now. */
> > -	/*
> > -	 * We return ECONNREFUSED because it tricks userspace into thinking
> > -	 * that audit was not configured into the kernel.  Lots of users
> > -	 * configure their PAM stack (because that's what the distro does)
> > -	 * to reject login if unable to send messages to audit.  If we return
> > -	 * ECONNREFUSED the PAM stack thinks the kernel does not have audit
> > -	 * configured in and will let login proceed.  If we return EPERM
> > -	 * userspace will reject all logins.  This should be removed when we
> > -	 * support non init namespaces!!
> > -	 */
> >  	if (current_user_ns() != &init_user_ns)
> > -		return -ECONNREFUSED;
> > +		return -EPERM;
> >  
> >  	switch (msg_type) {
> >  	case AUDIT_LIST:
> 
> - RGB
> 
> --
> Richard Guy Briggs <rbriggs@redhat.com>
> Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
> Remote, Ottawa, Canada
> Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
> 
> --
> Linux-audit mailing list
> Linux-audit@redhat.com
> https://www.redhat.com/mailman/listinfo/linux-audit

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
