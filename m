Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbaEVXLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 19:11:30 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:47334 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbaEVXL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 19:11:26 -0400
MIME-Version: 1.0
In-Reply-To: <1400799936-26499-7-git-send-email-keescook@chromium.org>
References: <1400799936-26499-1-git-send-email-keescook@chromium.org> <1400799936-26499-7-git-send-email-keescook@chromium.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 22 May 2014 16:11:06 -0700
Message-ID: <CALCETrWR6s7wqSwEeygOYqizrxy8eAyHb3SqvLoTooMZ+MfdqA@mail.gmail.com>
Subject: Re: [PATCH v5 6/6] seccomp: add SECCOMP_EXT_ACT_TSYNC and SECCOMP_FILTER_TSYNC
To: Kees Cook <keescook@chromium.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>, Juri Lelli <juri.lelli@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Alex Thorlton <athorlton@sgi.com>, Rik van Riel <riel@redhat.com>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        David Rientjes <rientjes@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Dario Faggioli <raistlin@linux.it>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        liguang <lig.fnst@cn.fujitsu.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 4:05 PM, Kees Cook <keescook@chromium.org> wrote:
> Applying restrictive seccomp filter programs to large or diverse
> codebases often requires handling threads which may be started early in
> the process lifetime (e.g., by code that is linked in). While it is
> possible to apply permissive programs prior to process start up, it is
> difficult to further restrict the kernel ABI to those threads after that
> point.
>
> This change adds a new seccomp extension action for synchronizing thread
> group seccomp filters and a prctl() for accessing that functionality,
> as well as a flag for SECCOMP_EXT_ACT_FILTER to perform sync at filter
> installation time.
>
> When calling prctl(PR_SECCOMP_EXT, SECCOMP_EXT_ACT, SECCOMP_EXT_ACT_FILTER,
> flags, filter) with flags containing SECCOMP_FILTER_TSYNC, or when calling
> prctl(PR_SECCOMP_EXT, SECCOMP_EXT_ACT, SECCOMP_EXT_ACT_TSYNC, 0, 0), it
> will attempt to synchronize all threads in current's threadgroup to its
> seccomp filter program. This is possible iff all threads are using a filter
> that is an ancestor to the filter current is attempting to synchronize to.
> NULL filters (where the task is running as SECCOMP_MODE_NONE) are also
> treated as ancestors allowing threads to be transitioned into
> SECCOMP_MODE_FILTER. If prctrl(PR_SET_NO_NEW_PRIVS, ...) has been set on the
> calling thread, no_new_privs will be set for all synchronized threads too.
> On success, 0 is returned. On failure, the pid of one of the failing threads
> will be returned, with as many filters installed as possible.

Is there a use case for adding a filter and synchronizing filters
being separate operations?  If not, I think this would be easier to
understand and to use if there was just a single operation.

If you did that, you'd have to decide whether to continue requiring
that all the other threads have a filter that's an ancestor of the
current thread's filter.

--Andy
