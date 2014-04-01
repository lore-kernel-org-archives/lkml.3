Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497AbaDAAn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 20:43:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbaDAAn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 20:43:57 -0400
Date: Mon, 31 Mar 2014 20:43:48 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Eric Paris <eparis@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        containers@lists.linux-foundation.org, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH for v3.14] AUDIT: Allow login in non-init namespaces
Message-ID: <20140401004348.GI16467@madcap2.tricolour.ca>
References: <1396220874.6974.5.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396220874.6974.5.camel@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/03/30, Eric Paris wrote:
> It its possible to configure your PAM stack to refuse login if
> audit messages (about the login) were unable to be sent.  This is common
> in many distros and thus normal configuration of many containers. The
> PAM modules determine if audit is enabled/disabled in the kernel based
> on the return value from sending an audit message on the netlink socket.
> If userspace gets back ECONNREFUSED it believes audit is disabled in the
> kernel.  If it gets any other error else it refuses to let the login
> proceed.
> 
> Just about ever since the introduction of namespaces the kernel audit
> subsystem has returned EPERM if the task sending a message was not in
> the init user or pid namespace.  So many forms of containers have never
> worked if audit was enabled in the kernel.
> 
> BUT if the container was not in net_init then the kernel network code
> would send ECONNREFUSED (instead of the audit code sending EPERM).  Thus
> by pure accident/dumb luck/bug if an admin configured the PAM stack to
> reject all logins that didn't talk to audit, but then ran the login
> untility in the non-init_net namespace, it would work!!  Clearly this
> was a bug, but it is a bug some people expected.
> 
> With the introduction of network namespace support in 3.14-rc1 the two
> bugs stopped cancelling each other out.  Now, containers in the
> non-init_net namespace refused to let users log in (just like PAM was
> configfured!)  Obviously some people were not happy that what used to
> let users log in, now didn't!
> 
> This fix is kinda hacky.  We return ECONNREFUSED for all non-init
> relevant namespaces.  That means that not only will the old broken
> non-init_net setups continue to work, now the broken non-init_pid or
> non-init_user setups will 'work'.  They don't really work, since audit
> isn't logging things.  But it's what most users want.
> 
> In 3.15 we should have patches to support not only the non-init_net
> (3.14) namespace but also the non-init_pid and non-init_user namespace.
> So all will be right in the world.  This just opens the doors wide open
> on 3.14 and hopefully makes users happy, if not the audit system...
> 
> Reported-by: Andre Tomt <andre@tomt.net>
> Reported-by: Adam Richter <adam_richter2004@yahoo.com>
> Signed-off-by: Eric Paris <eparis@redhat.com>

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>

> ---
>  kernel/audit.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 3392d3e..95a20f3 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -608,9 +608,19 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
>  	int err = 0;
>  
>  	/* Only support the initial namespaces for now. */
> +	/*
> +	 * We return ECONNREFUSED because it tricks userspace into thinking
> +	 * that audit was not configured into the kernel.  Lots of users
> +	 * configure their PAM stack (because that's what the distro does)
> +	 * to reject login if unable to send messages to audit.  If we return
> +	 * ECONNREFUSED the PAM stack thinks the kernel does not have audit
> +	 * configured in and will let login proceed.  If we return EPERM
> +	 * userspace will reject all logins.  This should be removed when we
> +	 * support non init namespaces!!
> +	 */
>  	if ((current_user_ns() != &init_user_ns) ||
>  	    (task_active_pid_ns(current) != &init_pid_ns))
> -		return -EPERM;
> +		return -ECONNREFUSED;
>  
>  	switch (msg_type) {
>  	case AUDIT_LIST:
> -- 
> 1.8.5.3
> 
> 
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
