Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbaCSWZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 18:25:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49680 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757805AbaCSWZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 18:25:24 -0400
Date: Wed, 19 Mar 2014 15:25:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Aaron Tomlin <atomlin@redhat.com>, Andrew Shewmaker <agshew@gmail.com>,
        Li Zefan <lizefan@huawei.com>, Dario Faggioli <raistlin@linux.it>,
        Andi Kleen <ak@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] sysctl: fix incorrect write position handling
Message-Id: <20140319152521.04fe6665c67efe0c6a70d8a5@linux-foundation.org>
In-Reply-To: <1395163080-6290-2-git-send-email-keescook@chromium.org>
References: <1395163080-6290-1-git-send-email-keescook@chromium.org>
	<1395163080-6290-2-git-send-email-keescook@chromium.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2014 10:17:59 -0700 Kees Cook <keescook@chromium.org> wrote:

> When writing to a sysctl string, each write, regardless of VFS position,
> began writing the string from the start. This meant the contents of
> the last write to the sysctl controlled the string contents instead of
> the first:
> 
> open("/proc/sys/kernel/modprobe", O_WRONLY)   = 1
> write(1, "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"..., 4096) = 4096
> write(1, "/bin/true", 9)                = 9
> close(1)                                = 0
> 
> $ cat /proc/sys/kernel/modprobe
> /bin/true

Yes, procfs writes have always been weird.

Why are we fixing this?

Perhaps there's an existing application which holds an fd open
and periodically writes to it expecting some result.  This patch
would break such an app?


And what about something like this?

while true
do
	echo 1
	sleep 60
done > /proc/sys/vm/drop_caches

To be consistent with the proposed alteration to string writes, this
would have to write 1 then change that to 11 then to 111.  Or
something, makes my head spin.

> Expected behaviour would be to have the sysctl be "AAAA..." capped at
> maxlen (in this case KMOD_PATH_LEN: 256), instead of truncating to the
> contents of the second write. Similarly, multiple short writes would not
> append to the sysctl.

So if we do

(
	echo foo
	echo bar
) > /proc/sys/kernel/modprobe

we get foo and later we get foobar?

> This fixes the unexpected behavior for strings, and disallows non-zero
> file position when writing numeric sysctls (similar to what is already
> done when reading from non-zero file positions).

So my script which writes drop_caches will break?
