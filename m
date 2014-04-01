Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751277AbaDAMyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:54:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbaDAMyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 08:54:20 -0400
Date: Tue, 1 Apr 2014 08:54:13 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Eric Paris <eparis@redhat.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the audit tree with Linus' tree
Message-ID: <20140401125413.GB21711@madcap2.tricolour.ca>
References: <20140401150721.1e9d4e6c36660d5411c10f37@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140401150721.1e9d4e6c36660d5411c10f37@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/04/01, Stephen Rothwell wrote:
> Hi Eric,

Hi Stephen,

> Today's linux-next merge of the audit tree got a conflict in
> kernel/audit.c between commit aa4af831bb4f ("AUDIT: Allow login in
> non-init namespaces") from Linus' tree and commit 5a3cb3b6c3a0 ("audit:
> allow user processes to log from another PID namespace") from the audit
> tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

I expected this conflict.  Thanks for fixing it up!

> [Eric: that audit tree commit has no Signed-off-by from you even though
> you committed it ... there are a few like that]

I added my Signed-off to the list posting.

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc kernel/audit.c
> index 95a20f3f52f1,ad77d1e80895..000000000000
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@@ -607,20 -607,9 +607,19 @@@ static int audit_netlink_ok(struct sk_b
>   {
>   	int err = 0;
>   
> - 	/* Only support the initial namespaces for now. */
> + 	/* Only support initial user namespace for now. */
>  +	/*
>  +	 * We return ECONNREFUSED because it tricks userspace into thinking
>  +	 * that audit was not configured into the kernel.  Lots of users
>  +	 * configure their PAM stack (because that's what the distro does)
>  +	 * to reject login if unable to send messages to audit.  If we return
>  +	 * ECONNREFUSED the PAM stack thinks the kernel does not have audit
>  +	 * configured in and will let login proceed.  If we return EPERM
>  +	 * userspace will reject all logins.  This should be removed when we
>  +	 * support non init namespaces!!
>  +	 */
> - 	if ((current_user_ns() != &init_user_ns) ||
> - 	    (task_active_pid_ns(current) != &init_pid_ns))
> + 	if ((current_user_ns() != &init_user_ns))
>  -		return -EPERM;
>  +		return -ECONNREFUSED;
>   
>   	switch (msg_type) {
>   	case AUDIT_LIST:



- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
