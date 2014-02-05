Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476AbaBENqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 08:46:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbaBENqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 08:46:52 -0500
Message-ID: <1391607995.13157.24.camel@localhost>
Subject: Re: [PATCH v2.1] audit: Only use the syscall slowpath when syscall
 audit rules exist
From: Eric Paris <eparis@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>
Date: Wed, 05 Feb 2014 14:46:35 +0100
In-Reply-To: <377a1c5ce05e25b068cf7576d094885c1396c6bc.1391454589.git.luto@amacapital.net>
References: <377a1c5ce05e25b068cf7576d094885c1396c6bc.1391454589.git.luto@amacapital.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-03 at 11:11 -0800, Andy Lutomirski wrote:

> +void audit_inc_n_rules()
> +{
> +	struct task_struct *p, *g;
> +	unsigned long flags;
> +
> +	read_lock_irqsave(&tasklist_lock, flags);
> +	if (audit_n_rules++ == 0) {

I know it's right, but it's too clever for me  :)  If we do end up
adding something like this Can we just do:
   if (!audit_n_rules) {}
   audit_n_rules++

I like dumb code   :)

> +		do_each_thread(g, p) {
> +			if (p->audit_context)
> +				set_tsk_thread_flag(p, TIF_SYSCALL_AUDIT);
> +		} while_each_thread(g, p);
> +	}
> +	read_unlock_irqrestore(&tasklist_lock, flags);
> +}

