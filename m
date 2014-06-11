Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbaFKWXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 18:23:08 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:50218 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481AbaFKWXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 18:23:02 -0400
MIME-Version: 1.0
In-Reply-To: <5398D59A.3030900@zytor.com>
References: <cover.1402517933.git.luto@amacapital.net> <9e11cd988a0f120606e37b5e275019754e2774da.1402517933.git.luto@amacapital.net>
 <CAADnVQKt5FnShkZeQewbfnU1kHM-gLs3hCZMf5xcgFzyRDLX7A@mail.gmail.com>
 <CALCETrXoqqKC=T5Wvj+CDYQFte1s_=npDvQ2UYW0j=AanEgR1g@mail.gmail.com> <5398D59A.3030900@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 11 Jun 2014 15:22:40 -0700
Message-ID: <CALCETrVMxkHcPXsEGtEc0Pr=Z80CzC0zWaQ9OdVdxi1CGuB4kQ@mail.gmail.com>
Subject: Re: [RFC 5/5] x86,seccomp: Add a seccomp fastpath
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>, X86 ML <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-mips@linux-mips.org, linux-arch <linux-arch@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 3:18 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/11/2014 02:56 PM, Andy Lutomirski wrote:
>>
>> 13ns is with the simplest nonempty filter.  I hope that empty filters
>> don't work.
>>
>
> Why wouldn't they?

Is it permissible to fall off the end of a BPF program?  I'm getting
EINVAL trying to install an actual empty filter.  The filter I tested
with was:

#include <unistd.h>
#include <linux/filter.h>
#include <linux/seccomp.h>
#include <sys/syscall.h>
#include <err.h>
#include <sys/prctl.h>
#include <stddef.h>
#include <stdio.h>

int main(int argc, char **argv)
{
    int rc;

    struct sock_filter filter[] = {
        BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_ALLOW),
    };

    struct sock_fprog prog = {
        .len = (unsigned short)(sizeof(filter)/sizeof(filter[0])),
        .filter = filter,
    };

    if (argc < 2) {
        printf("Usage: null_seccomp PATH ARGS...\n");
        return 1;
    }

    if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0))
        err(1, "PR_SET_NO_NEW_PRIVS");
    if (prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog))
        err(1, "PR_SET_SECCOMP");

    execv(argv[1], argv + 1);
    err(1, argv[1]);
}


--Andy
