Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155AbaGISoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 14:44:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756601AbaGISoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 14:44:10 -0400
Date: Wed, 9 Jul 2014 20:42:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>,
        Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>,
        linux-api@vger.kernel.org, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v9 09/11] seccomp: introduce writer locking
Message-ID: <20140709184215.GA4866@redhat.com>
References: <1403911380-27787-1-git-send-email-keescook@chromium.org> <1403911380-27787-10-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403911380-27787-10-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27, Kees Cook wrote:
>
>  static u32 seccomp_run_filters(int syscall)
>  {
> -	struct seccomp_filter *f;
> +	struct seccomp_filter *f = ACCESS_ONCE(current->seccomp.filter);

I am not sure...

This is fine if this ->filter is the 1st (and only) one, in this case
we can rely on rmb() in the caller.

But the new filter can be installed at any moment. Say, right after that
rmb() although this doesn't matter. Either we need smp_read_barrier_depends()
after that, or smp_load_acquire() like the previous version did?

Oleg.

