Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbaHELKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 07:10:12 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:63625 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbaHELKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 07:10:10 -0400
MIME-Version: 1.0
In-Reply-To: <1407158386-6201-6-git-send-email-dvlasenk@redhat.com>
References: <1407158386-6201-1-git-send-email-dvlasenk@redhat.com> <1407158386-6201-6-git-send-email-dvlasenk@redhat.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Tue, 5 Aug 2014 13:09:48 +0200
Message-ID: <CAK1hOcPOaH9P0-XmcRZRwt=B1MYCtDCdiyA6AS=apSywWCv=Ng@mail.gmail.com>
Subject: Re: [PATCH 5/6] x86: mass removal of ARGOFFSET
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI: the patch is incomplete. arch/x86/ia32/ia32entry.S has a bug, fix is:

 sysexit_from_sys_call:
        andl    $~TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
        /* clear IF, that popfq doesn't enable interrupts early */
-       andl  $~0x200,EFLAGS-R11(%rsp).
-       movl    RIP-R11(%rsp),%edx              /* User %eip */
+       andl    $~0x200,EFLAGS-ARGOFFSET(%rsp)
+       movl    RIP-ARGOFFSET(%rsp),%edx                /* User %eip */
        CFI_REGISTER rip,rdx
        RESTORE_ARGS 0,24,0,0,0,0
        xorq    %r8,%r8

It went unnoticed for so long because
these two constants are the same.
Patch #4 changes ARGOFFSET to 0, but of course R11 stays the same,
breaking this code.
