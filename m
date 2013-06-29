Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab3F2S3m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 14:29:42 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:43750 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab3F2S3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 14:29:41 -0400
MIME-Version: 1.0
In-Reply-To: <20130628134946.GA19422@Krystal>
References: <20130628134946.GA19422@Krystal>
Date: Sat, 29 Jun 2013 11:29:40 -0700
X-Google-Sender-Auth: nw9hZJQSvfyXyN8M5Efbbjij2yY
Message-ID: <CA+55aFzLcFAp+grCmD_6JvAwsE7Y4-4jTH=XNJqQ39STPOEsaw@mail.gmail.com>
Subject: Re: [PATCH 3.10-rc7] Fix: kernel/ptrace.c: ptrace_peek_siginfo()
 missing __put_user() validation
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrey Vagin <avagin@openvz.org>, Roland McGrath <roland@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>, Pedro Alves <palves@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 6:49 AM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
> This __put_user() could be used by unprivileged processes to write into
> kernel memory. The issue here is that even if copy_siginfo_to_user()
> fails, the error code is not checked before __put_user() is executed.
> Luckily, ptrace_peek_siginfo() has been added within the 3.10-rc cycle,
> so it has not hit a stable release yet.

Why do those stupid

    __put_user(info.si_code, &uinfo->si_code))

things exist at all?

As far as I can tell, copy_siginfo_to_user[32]() already copies
si_code. Is the field really so important that it has to be copied
twice, just to make sure the write makes it?

Ok, ok, I see the explanation in the commit message that introduced
this, but it sure as hell isn't obvious from actually looking at the
code. I'm applying the patch, but I think this should have been a
comment in the code as well.

                 Linus
