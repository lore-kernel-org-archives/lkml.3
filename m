Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbbAIUeB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 15:34:01 -0500
Received: from mail-qg0-f52.google.com ([209.85.192.52]:45965 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbbAIUd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 15:33:59 -0500
From: Paul Moore <paul@paul-moore.com>
To: Calvin Owens <calvinowens@fb.com>, Eric Paris <eparis@redhat.com>
Cc: rgb@redhat.com, ebiederm@xmission.com, linux-kernel@vger.kernel.org,
        kernel-team@fb.com, stable@vger.kernel.org, linux-audit@redhat.com
Subject: Re: [PATCH][RESEND 2] Revert "AUDIT: Allow login in non-init namespaces"
Date: Fri, 09 Jan 2015 15:33:56 -0500
Message-ID: <1569326.X07DWxmoQX@sifl>
User-Agent: KMail/4.14.3 (Linux/3.16.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20150109014448.GF27996@mail.thefacebook.com>
References: <1415148371-11742-1-git-send-email-calvinowens@fb.com> <20141118203221.GA1687992@mail.thefacebook.com> <20150109014448.GF27996@mail.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 08, 2015 05:44:48 PM Calvin Owens wrote:
> This reverts 543bc6a1a987 "AUDIT: Allow login in non-init namespaces".
> 
> This commit incorrectly assumes that libpam treats -ECONNREFUSED as
> an indicator that audit is disabled, and -EPERM or any other error
> as a fatal error that prevents the login from continuing.
> 
> The opposite is in fact true: -EPERM allows the login to continue,
> and -ECONNREFUSED causes it to refuse the login. This behavior has
> been unchanged in upstream linux-pam since at least 2008.
> 
> Reverting this change allows libpam to again work as expected in
> non-init user namespaces.
> 
> Signed-off-by: Calvin Owens <calvinowens@fb.com>
> Cc: stable@vger.kernel.org
> ---
> Relevant code in linux-pam:
> https://git.fedorahosted.org/cgit/linux-pam.git/tree/libpam/pam_audit.c#n56
> 
>  kernel/audit.c | 12 +-----------
>  1 file changed, 1 insertion(+), 11 deletions(-)
>
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 80983df..656e8ce 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -640,18 +640,8 @@ static int audit_netlink_ok(struct sk_buff *skb, u16
> msg_type) int err = 0;
> 
>  	/* Only support initial user namespace for now. */
> -	/*
> -	 * We return ECONNREFUSED because it tricks userspace into thinking
> -	 * that audit was not configured into the kernel.  Lots of users
> -	 * configure their PAM stack (because that's what the distro does)
> -	 * to reject login if unable to send messages to audit.  If we return
> -	 * ECONNREFUSED the PAM stack thinks the kernel does not have audit
> -	 * configured in and will let login proceed.  If we return EPERM
> -	 * userspace will reject all logins.  This should be removed when we
> -	 * support non init namespaces!!
> -	 */
>  	if (current_user_ns() != &init_user_ns)
> -		return -ECONNREFUSED;
> +		return -EPERM;

While I haven't had reason to test this code lately, last I knew it was 
working, what problems are you seeing Calvin?  Also, with what distribution?

-- 
paul moore
www.paul-moore.com

