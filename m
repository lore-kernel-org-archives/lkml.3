Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab3CNW2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 18:28:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36678 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab3CNW2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 18:28:20 -0400
Date: Thu, 14 Mar 2013 15:28:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, david@gibson.dropbear.id.au,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Feng Hong <hongfeng@marvell.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: Re: [PATCH 1/1] poweroff: change orderly_poweroff() to use
 schedule_work()
Message-Id: <20130314152819.7fb1242b493e8bad2d34671b@linux-foundation.org>
In-Reply-To: <20130313174705.GB28083@redhat.com>
References: <1363058712.4534.12.camel@pasglop>
	<CA+55aFzMKjk+bGbBrb5Qw-XDXaAXLMyrrpqMWH7o0duHq2wxzw@mail.gmail.com>
	<CAKi4VALkUhOtP_8BOi3Mi8fTz8TUPwmwQq7WW27BEDue2wFNRw@mail.gmail.com>
	<20130312182210.GA15862@redhat.com>
	<CA+55aFz9M1RWOwyRuatxnyQ+_ON0+A032QcW9=oBOks1JPt13w@mail.gmail.com>
	<20130312191118.GA17439@redhat.com>
	<CA+55aFzmATkP-W0uX1a_gP7E1fwcp2Mh4537Ou2uwHDixNKPTg@mail.gmail.com>
	<20130312203514.GA23488@redhat.com>
	<20130313174641.GA28083@redhat.com>
	<20130313174705.GB28083@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Mar 2013 18:47:05 +0100 Oleg Nesterov <oleg@redhat.com> wrote:

> orderly_poweroff() can be used from any context but UMH_WAIT_EXEC
> is sleepable. Move the "force" logic into __orderly_poweroff() and
> change orderly_poweroff() to use the global poweroff_work which
> simply calls __orderly_poweroff().
> 
> While at it, remove the unneeded "int argc" and change argv_split()
> to use GFP_KERNEL.
> 
> We use the global "bool poweroff_force" to pass the argument, this
> can obviously affect the previous request if it is pending/running.
> So we only allow the "false => true" transition assuming that the
> pending "true" should succeed anyway. If schedule_work() fails after
> that we know that work->func() was not called yet, it must see the
> new value.
> 
> This means that orderly_poweroff() becomes async even if we do not
> run the command and always succeeds, schedule_work() can only fail
> if the work is already pending. We can export __orderly_poweroff()
> and change the non-atomic callers which want the old semantics.
> 
> ...
>
> @@ -2218,21 +2237,9 @@ static int __orderly_poweroff(void)
>   */
>  int orderly_poweroff(bool force)
>  {
> -	int ret = __orderly_poweroff();
> -
> -	if (ret && force) {
> -		printk(KERN_WARNING "Failed to start orderly shutdown: "
> -		       "forcing the issue\n");
> -
> -		/*
> -		 * I guess this should try to kick off some daemon to sync and
> -		 * poweroff asap.  Or not even bother syncing if we're doing an
> -		 * emergency shutdown?
> -		 */
> -		emergency_sync();
> -		kernel_power_off();
> -	}
> -
> -	return ret;
> +	if (force) /* do not override the pending "true" */
> +		poweroff_force = true;
> +	schedule_work(&poweroff_work);
> +	return 0;
>  }

afaict the current version of orderly_poweroff() will never return -
either __orderly_poweroff() will block until the machine shuts down or
kernel_power_off() will do so.

However with this patch there is a path via which orderly_poweroff()
can return to its caller, I think?  If so, the caller might be rather
surprised and we're exercising never-before-used code paths.  In fact
if the surprised caller goes oops, the poweroff might not occur at all.
