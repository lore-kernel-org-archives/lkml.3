Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759578AbaGRFcL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 01:32:11 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:52342 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152AbaGRFcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 01:32:10 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH ftrace/core v3 3/3] kprobes: Set IPMODIFY flag only if the probe can change regs->ip
References: <20140715060015.12195.74457.stgit@kbuild-fedora.novalocal>
	<20140715060035.12195.47782.stgit@kbuild-fedora.novalocal>
Date: Fri, 18 Jul 2014 14:32:07 +0900
In-Reply-To: <20140715060035.12195.47782.stgit@kbuild-fedora.novalocal>
	(Masami Hiramatsu's message of "Tue, 15 Jul 2014 06:00:35 +0000")
Message-ID: <878unrkzag.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

On Tue, 15 Jul 2014 06:00:35 +0000, Masami Hiramatsu wrote:
> +static int __ftrace_add_filter_ip(struct ftrace_ops *ops, unsigned long ip,
> +				  int *ref)
> +{
> +	int ret;
> +
> +	/* Try to set given ip to filter */
> +	ret = ftrace_set_filter_ip(ops, ip, 0, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	(*ref)++;
> +	if (*ref == 1) {
> +		ret = register_ftrace_function(ops);
> +		if (ret < 0) {
> +			/* Rollback refcounter and filter */
> +			(*ref)--;
> +			ftrace_set_filter_ip(ops, ip, 1, 0);
> +		}
> +	}
> +
> +	return ret;
> +}

This function also can be changed in a similar way:

	if (*ref == 0) {
		ret = register_ftrace_function(ops);
		if (ret < 0) {
			/* Rollback filter if failed */
			ftrace_set_filter_ip(ops, ip, 1, 0);
			return ret;
		}
	}

	(*ref)++;

	return 0;


Thanks,
Namhyung

