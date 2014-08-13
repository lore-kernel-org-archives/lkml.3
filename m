Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbaHMOsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 10:48:09 -0400
Received: from mail.kernel.org ([198.145.19.201]:36800 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbaHMOsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 10:48:07 -0400
Date: Wed, 13 Aug 2014 11:48:01 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Naohiro Aota <naota@elisp.net>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] [BUGFIX] perf probe: Fix --list option to show
 events only with uprobe events
Message-ID: <20140813144801.GA2718@kernel.org>
References: <20140813005055.24360.73553.stgit@kbuild-fedora.novalocal>
 <87r40ldkv8.fsf@sejong.aot.lge.com>
 <53EB746E.1020904@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53EB746E.1020904@hitachi.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 13, 2014 at 11:21:34PM +0900, Masami Hiramatsu escreveu:
> (2014/08/13 14:22), Namhyung Kim wrote:
> > On Wed, 13 Aug 2014 00:50:55 +0000, Masami Hiramatsu wrote:
> >> +	if (kp_fd < 0 && up_fd < 0) {
> >> +		/* Both kprobes and uprobes are disabled, warn it. */
> >> +		if (kp_fd == -ENOTSUP && up_fd == -ENOTSUP)
> >> +			pr_warning("Debugfs is not mounted.\n");
> >> +		else if (kp_fd == -ENOENT && up_fd == -ENOENT)
> >> +			pr_warning("Please rebuild kernel with "
> >> +				   "CONFIG_KPROBE_EVENTS or/and "
> >> +				   "CONFIG_UPROBE_EVENTS.\n");
> >> +		else
> >> +			pr_warning("Failed to open kprobe events: %s.\n" \
> >> +				   "Failed to open uprobe events: %s.\n",
> >> +				   strerror(-kp_fd), strerror(-up_fd));
> > 
> > It seems the second strerror() might overwrite the message of the
> > first.  You'd better using strerror_r() IMHO.

Well spotted!
 
> Oops, right, it must use the same buffer...
> But instead of using strerror_r, we can call pr_warning twice. Or should we
> better replace all strerror to strerror_r in perf? (it should be another series)

Well, don't introduce new strerror() uses, we have threads in perf
already and if both try to use strerror() for different reasons, say the
UI to print something to the user and some logging/debugging thread do
it to the disk, we may race.

So, in this case, please use strerror_r() and if you feel like
contributing the changes to any other place where strerror() is still
used, you are welcome to do so at a later patch :)

- Arnaldo
