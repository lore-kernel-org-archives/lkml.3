Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750864Ab3BOSpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 13:45:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712Ab3BOSpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 13:45:10 -0500
Message-ID: <511E8223.6010506@redhat.com>
Date: Fri, 15 Feb 2013 18:44:51 +0000
From: Pedro Alves <palves@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrey Vagin <avagin@openvz.org>
CC: linux-kernel@vger.kernel.org, criu@openvz.org, linux-api@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ptrace: add ability to retrieve signals without removing
 them from a queue
References: <1360768595-31943-1-git-send-email-avagin@openvz.org>
In-Reply-To: <1360768595-31943-1-git-send-email-avagin@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2013 03:16 PM, Andrey Vagin wrote:
> This patch adds a new ptrace request PTRACE_PEEKSIGINFO.
> 
> This request is used to retrieve information about a signal with the
> specified sequence number. A siginfo_t structure is copied from the child
> to location data in the parent.
> 
> The low 16 bits of addr contains a sequence number of signal in a queue.
> All other bits of addr is used for flags. Currently here is only one
> flag PTRACE_PEEK_SHARED for dumping signals from process-wide shared
> queue. If this flag is not set, a signal is read from a per-thread
> queue.  A result siginfo contains a kernel part of si_code which usually
> striped, but it's required for queuing the same siginfo back during
> restore of pending signals.
> 
> If a signal with the specified sequence number doesn't exist, ptrace
> returns ENOENT.
> 
> This functionality is required for checkpointing pending signals.
> 
> The prototype of this code was developed by Oleg Nesterov.

Not sure I'm reading the patch right, but it looks like GDB would
be able to use this as alternative to PTRACE_GET_SIGINFO variant
that returns the siginfo_t object in the architecture/bitness of
the tracee, rather than the architecture of the kernel, right?
So it no longer would need to try and replicate the kernel's
siginfo conversions.  I wouldn't mind if this was added unconditionally
instead of wrapped on CONFIG_CHECKPOINT_RESTORE.  We'd miss the poke
variant, but that looks like something that could be always be added
later.

-- 
Pedro Alves

