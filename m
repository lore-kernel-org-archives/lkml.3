Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934905Ab3E1RG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 13:06:59 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:45180 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934848Ab3E1RG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 13:06:58 -0400
MIME-Version: 1.0
In-Reply-To: <20130528143409.9790.41260.stgit@warthog.procyon.org.uk>
References: <20130528143409.9790.41260.stgit@warthog.procyon.org.uk>
Date: Tue, 28 May 2013 10:06:57 -0700
X-Google-Sender-Auth: l-lEbJ5ha4ly_ceHZ-Oudc0Vte0
Message-ID: <CA+55aFz34Hn5xLwJL4PS+agpK-L3fNjNxkcXAS4gNx8tqOOwFQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] MN10300: Fix ret_from_kernel_thread
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-am33-list@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ken Cox <jkc@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What kernel version are these patches against?

You explicitly mention commit ddf23e87a804, but the patch contains
ret_from_kernel_execve that was *removed* by that commit.

So the whole thing seems very confused. I'm dropping this series.

              Linus

On Tue, May 28, 2013 at 7:34 AM, David Howells <dhowells@redhat.com> wrote:
> ret_from_kernel_thread needs to set A2 to the thread_info pointer before
> jumping to syscall_exit.
>
> Without this, we never correctly start userspace.
>
> This was caused by the rejuggling of the fork/exec paths in commit:
>
>         ddf23e87a804cbf6fa3818076b33fe023cce09fd
>         Author: Al Viro <viro@zeniv.linux.org.uk>
>         Date:   Thu Oct 11 17:32:41 2012 -0400
>         Subject: mn10300: switch to saner kernel_execve() semantics
>
> Reported-by: Ken Cox <jkc@redhat.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Acked-by: Ken Cox <jkc@redhat.com>
> Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
> ---
>
>  arch/mn10300/kernel/entry.S |    1 +
>  1 file changed, 1 insertion(+)
>
>
> diff --git a/arch/mn10300/kernel/entry.S b/arch/mn10300/kernel/entry.S
> index 0c631d3..92c3eea 100644
> --- a/arch/mn10300/kernel/entry.S
> +++ b/arch/mn10300/kernel/entry.S
> @@ -60,6 +60,7 @@ ENTRY(ret_from_kernel_thread)
>         mov     (REG_D0,fp),d0
>         mov     (REG_A0,fp),a0
>         calls   (a0)
> +       GET_THREAD_INFO a2              # A2 must be set on return from sys_exit()
>         jmp     sys_exit
>
>  ENTRY(ret_from_kernel_execve)
>
