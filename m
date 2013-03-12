Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933390Ab3CLSmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:42:15 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:52616 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933370Ab3CLSmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:42:14 -0400
MIME-Version: 1.0
In-Reply-To: <20130312182210.GA15862@redhat.com>
References: <1363058712.4534.12.camel@pasglop>
	<CA+55aFzMKjk+bGbBrb5Qw-XDXaAXLMyrrpqMWH7o0duHq2wxzw@mail.gmail.com>
	<CAKi4VALkUhOtP_8BOi3Mi8fTz8TUPwmwQq7WW27BEDue2wFNRw@mail.gmail.com>
	<20130312182210.GA15862@redhat.com>
Date: Tue, 12 Mar 2013 11:42:13 -0700
X-Google-Sender-Auth: -UVa7tOgJtFCgHI6lkw9tv0vRtk
Message-ID: <CA+55aFz9M1RWOwyRuatxnyQ+_ON0+A032QcW9=oBOks1JPt13w@mail.gmail.com>
Subject: Re: Regression with orderly_poweroff()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, david@gibson.dropbear.id.au,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Feng Hong <hongfeng@marvell.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 11:22 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> And how this can help? The real problem is not GFP_KERNEL.
> call_usermodehelper_exec(UMH_WAIT_EXEC) will block.

Well, it's probably a starting point.

You need to do the argument handling atomically, because you cannot
delay that in a workqueue (the arguments will be long gone by the time
the workqueue starts up). So I think the fix is a combination of your
and Lucas' code, where you first do the setup atomically (copying the
arguments and allocating that space with GFP_ATOMIC) and then you do a
workqueue to actually do the real work of the usermode helper thing.

                 Linus
