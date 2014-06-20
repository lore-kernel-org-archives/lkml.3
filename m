Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966436AbaFTAJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 20:09:23 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:59956 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966097AbaFTAJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 20:09:22 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip v2 3/3] kprobes: Set IPMODIFY flag only if the probe can change regs->ip
References: <20140617110436.15167.7179.stgit@kbuild-fedora.novalocal>
	<20140617110456.15167.89566.stgit@kbuild-fedora.novalocal>
	<1403181271.1670.18.camel@leonhard>
Date: Fri, 20 Jun 2014 09:09:18 +0900
In-Reply-To: <1403181271.1670.18.camel@leonhard> (Namhyung Kim's message of
	"Thu, 19 Jun 2014 21:34:31 +0900")
Message-ID: <87ionw787l.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014 21:34:31 +0900, Namhyung Kim wrote:
> What about this?
>
> static int __ftrace_remove_filter_ip(...)
> {
> 	if (*ref == 1) {
> 		int ret = unregister_ftrace_function(ops);
> 		if (ret < 0)
> 			return ret;
>
> 		ftrace_set_filter_ip(ops, ip, 1, 0);
> 	}
>
> 	(*ref)--;
> 	return 0;
> }


Hmm.. I missed removing in *ref > 1 case.  Here's a v2. :)


static int __ftrace_remove_filter_ip(...)
{
	int ret;

	if (*ref == 1) {
		ret = unregister_ftrace_function(ops);
		if (ret < 0)
			return ret;

		/* ignore failure here */
		ftrace_set_filter_ip(ops, ip, 1, 0);
	} else
		ret = ftrace_set_filter_ip(ops, ip, 1, 0);
		if (ret < 0)
			return ret;
	}

	(*ref)--;
        return 0;
}

