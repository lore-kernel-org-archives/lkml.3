Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870AbaEEWAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 18:00:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51864 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756316AbaEEWAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 18:00:18 -0400
Date: Mon, 5 May 2014 15:00:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Aaron Tomlin <atomlin@redhat.com>, Li Zefan <lizefan@huawei.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ryan Mallon <rmallon@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Dario Faggioli <raistlin@linux.it>, Jens Axboe <axboe@fb.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Ellerman <michael@ellerman.id.au>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 0/4] sysctl: fix incorrect write position handling
Message-Id: <20140505150016.6dd7159e6a02b047fe40c56d@linux-foundation.org>
In-Reply-To: <1398979597-3589-1-git-send-email-keescook@chromium.org>
References: <1398979597-3589-1-git-send-email-keescook@chromium.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  1 May 2014 14:26:33 -0700 Kees Cook <keescook@chromium.org> wrote:

> When writing to a sysctl string, each write, regardless of VFS position,
> began writing the string from the start. This meant the contents of
> the last write to the sysctl controlled the string contents instead of
> the first.
> 
> This misbehavior was featured in an exploit against Chrome OS. While it's
> not in itself a vulnerability, it's a weirdness that isn't on the mind
> of most auditors: "This filter looks correct, the first line written
> would not be meaningful to sysctl" doesn't apply here, since the size
> of the write and the contents of the final write are what matter when
> writing to sysctls.
> 
> This adds the sysctl kernel.sysctl_writes_strict to control the write
> behavior. The default (0) reports when VFS position is non-0 on a write,
> but retains legacy behavior, -1 disables the warning, and 1 enables the
> position-respecting behavior.
> 

OK, let's try that.  I added this paragraph to the patchset's overall
changelog:

: The long-term plan here is to wait for userspace to be fixed in response
: to the new warning and to then switch the default kernel behavior to the
: new position-respecting behavior.

I'm thinking we should use pr_warn_once() in warn_sysctl_write()?  Otherwise
people will go and shut the thing up permanently and we'll lose the benefits.
