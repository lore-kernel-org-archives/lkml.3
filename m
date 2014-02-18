Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbaBRVB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 16:01:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891AbaBRVB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 16:01:57 -0500
From: Steve Grubb <sgrubb@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: Eric Paris <eparis@redhat.com>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] audit: add arch field to seccomp event log
Date: Tue, 18 Feb 2014 16:01:54 -0500
Message-ID: <1455468.M1LNEKA0EJ@x2>
Organization: Red Hat
User-Agent: KMail/4.12.2 (Linux/3.13.3-201.fc20.x86_64; KDE/4.12.2; x86_64; ; )
In-Reply-To: <20140218205044.GL16640@madcap2.tricolour.ca>
References: <4bc8c03bda84e004c331546e228b334811b03254.1392409147.git.rgb@redhat.com> <1392412322.2760.21.camel@localhost> <20140218205044.GL16640@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 18, 2014 03:50:44 PM Richard Guy Briggs wrote:
> > missing '='   but this isn't what audit_get_context() does...   it's
> > crappy naming...    I'd think a combo of audit_dummy_context() and
> > current->audit_context would be most appropriate.
> 
> Ok.  I think I finally understand audit_dummy_context().  Thanks for the
> hint.  However, it appears it is not useful in this sitation, since if
> there is an audit_context, even a dummy context, it appears arch is
> filled in.
> 
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> @@ -2406,12 +2406,18 @@ void audit_core_dumps(long signr)
>  void __audit_seccomp(unsigned long syscall, long signr, int code)
>  {
>         struct audit_buffer *ab;
> +       struct audit_context *context = current->audit_context;
>  
>         ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_SECCOMP);
>         if (unlikely(!ab))
>                 return;
>         audit_log_task(ab);
>         audit_log_format(ab, " sig=%ld", signr);
> +       audit_log_format(ab, " arch=");
> +       if (context)
> +               audit_log_format(ab, "%x", context->arch);
> +       else
> +               audit_log_format(ab, "(null)");
>         audit_log_format(ab, " syscall=%ld", syscall);
>         audit_log_format(ab, " compat=%d", is_compat_task());
>         audit_log_format(ab, " ip=0x%lx", KSTK_EIP(current));

Is there anything that could be passed by the caller that might identify the 
syscall ABI when this call was blocked? '(null)' still makes syscall number 
uninterpretable.

-Steve
