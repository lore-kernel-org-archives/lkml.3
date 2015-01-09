Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310AbbAIVZD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 16:25:03 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34723 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752205AbbAIVZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 16:25:00 -0500
Date: Fri, 9 Jan 2015 13:24:51 -0800
From: Calvin Owens <calvinowens@fb.com>
To: Paul Moore <paul@paul-moore.com>
CC: Eric Paris <eparis@redhat.com>, <rgb@redhat.com>, <ebiederm@xmission.com>,
        <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        <stable@vger.kernel.org>, <linux-audit@redhat.com>
Subject: Re: [PATCH][RESEND 2] Revert "AUDIT: Allow login in non-init
 namespaces"
Message-ID: <20150109212451.GG27996@mail.thefacebook.com>
References: <1415148371-11742-1-git-send-email-calvinowens@fb.com>
 <20141118203221.GA1687992@mail.thefacebook.com>
 <20150109014448.GF27996@mail.thefacebook.com>
 <1569326.X07DWxmoQX@sifl>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1569326.X07DWxmoQX@sifl>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-09_07:2015-01-09,2015-01-09,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=0
 compositescore=0.925924926977281 urlsuspect_oldscore=0.925924926977281
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.925924926977281 spamscore=0
 recipient_to_sender_domain_totalscore=2 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1501090178
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01/09 at 15:33 -0500, Paul Moore wrote:
> On Thursday, January 08, 2015 05:44:48 PM Calvin Owens wrote:
> > This reverts 543bc6a1a987 "AUDIT: Allow login in non-init namespaces".
> > 
> > This commit incorrectly assumes that libpam treats -ECONNREFUSED as
> > an indicator that audit is disabled, and -EPERM or any other error
> > as a fatal error that prevents the login from continuing.
> > 
> > The opposite is in fact true: -EPERM allows the login to continue,
> > and -ECONNREFUSED causes it to refuse the login. This behavior has
> > been unchanged in upstream linux-pam since at least 2008.
> > 
> > Reverting this change allows libpam to again work as expected in
> > non-init user namespaces.
> > 
> > Signed-off-by: Calvin Owens <calvinowens@fb.com>
> > Cc: stable@vger.kernel.org
> > ---
> > Relevant code in linux-pam:
> > https://urldefense.proofpoint.com/v1/url?u=https://git.fedorahosted.org/cgit/linux-pam.git/tree/libpam/pam_audit.c%23n56&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=oEb120Cp%2FehdhuY2M7qjelK5yT8IPB5WC2nEG4obDh4%3D%0A&m=vyJMOR0vSvoBryKRT8mBRsUpUQElUD3Fa4ZBI5Vaf%2BA%3D%0A&s=4f34b8ee3ea296b034ab84da1d7f0b738cd431081878afd6f85203507a722ebe
> > 
> >  kernel/audit.c | 12 +-----------
> >  1 file changed, 1 insertion(+), 11 deletions(-)
> >
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index 80983df..656e8ce 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -640,18 +640,8 @@ static int audit_netlink_ok(struct sk_buff *skb, u16
> > msg_type) int err = 0;
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
> 
> While I haven't had reason to test this code lately, last I knew it was 
> working, what problems are you seeing Calvin?  Also, with what distribution?

An SSH authentication setup in LXC containers on CentOS broke with the
original patch. My revert made it work again. I can dig up more detail
about the specific setup if you're interested.

Thanks,
Calvin
 
> -- 
> paul moore
> www.paul-moore.com
> 
