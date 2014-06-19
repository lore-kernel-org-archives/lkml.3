Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbaFSMej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 08:34:39 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43431 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbaFSMeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 08:34:37 -0400
Subject: Re: [PATCH -tip v2 3/3] kprobes: Set IPMODIFY flag only if the
 probe can change regs->ip
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20140617110456.15167.89566.stgit@kbuild-fedora.novalocal>
References: <20140617110436.15167.7179.stgit@kbuild-fedora.novalocal>
	 <20140617110456.15167.89566.stgit@kbuild-fedora.novalocal>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Jun 2014 21:34:31 +0900
Message-ID: <1403181271.1670.18.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

2014-06-17 (화), 11:04 +0000, Masami Hiramatsu:
> +static int __ftrace_add_filter_ip(struct ftrace_ops *ops, unsigned long ip,
> +				  int *ref)
> +{
> +	int ret;
> +
> +	/* Try to set given ip to filter */
> +	ret = ftrace_set_filter_ip(ops, ip, 0, 0);
> +	if (ret >= 0) {

Hmm.. this doesn't look comfortable.  What not using usual pattern?

	if (ret < 0)
		return ret;

This way we can reduce a indent level.


> +		(*ref)++;
> +		if (*ref == 1) {
> +			ret = register_ftrace_function(ops);
> +			if (ret < 0) {
> +				/* Rollback refcounter and filter */
> +				(*ref)--;
> +				ftrace_set_filter_ip(ops, ip, 1, 0);
> +			}
> +		}
> +	}
> +
> +	return ret;
> +}
> +
> +static int __ftrace_remove_filter_ip(struct ftrace_ops *ops, unsigned long ip,
> +				     int *ref)
> +{
> +	int ret = 0;
> +
> +	(*ref)--;
> +	if (*ref == 0)
> +		ret = unregister_ftrace_function(ops);
> +	if (ret >= 0)
> +		/* Try to remove given ip to filter */
> +		ret = ftrace_set_filter_ip(ops, ip, 1, 0);

I think any failure at this time can be problematic.  Since we already
unregistered the ops but the refcount will get increased again, future
attemp to register won't enable the ops anymore IMHO.

I think it'd better just ignoring faiure of filter removal here.  We'll
miss a filter entry but it'll be usable anyway.

What about this?

static int __ftrace_remove_filter_ip(...)
{
	if (*ref == 1) {
		int ret = unregister_ftrace_function(ops);
		if (ret < 0)
			return ret;

		ftrace_set_filter_ip(ops, ip, 1, 0);
	}

	(*ref)--;
	return 0;
}

Thanks,
Namhyung


> +	if (ret < 0)	/* Rollback refcounter if an error occurs */
> +		(*ref)++;
> +
> +	return ret;
> +}


