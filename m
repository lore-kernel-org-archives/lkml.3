Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880AbaFYRil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 13:38:41 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:53174 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757837AbaFYRij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 13:38:39 -0400
MIME-Version: 1.0
In-Reply-To: <20140625173245.GA17695@redhat.com>
References: <1403642893-23107-1-git-send-email-keescook@chromium.org>
 <1403642893-23107-6-git-send-email-keescook@chromium.org> <20140625135121.GB7892@redhat.com>
 <CAGXu5jJkFxh4K=40xuh6tu3kUf4oJM8Dry+4upBdRieW3FNLgw@mail.gmail.com>
 <CALCETrUBNmLnpa+LM91om2RSpR6SjupP-EdefzhU1Me4nv3Dfw@mail.gmail.com>
 <CAGXu5j+J11zJnuFR8bYKAXizAHhCx4R+uJE_QH6zC3q2udkpaQ@mail.gmail.com>
 <CALCETrVrs8sb19+UUqyFEpAFzTih5dkAwn-WpQjfgPcPJMpP5g@mail.gmail.com> <20140625173245.GA17695@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 25 Jun 2014 10:38:17 -0700
Message-ID: <CALCETrUc65H+fn6dtMdYnB_xR39wcmgDdTbdR3fFRjyrndJhgA@mail.gmail.com>
Subject: Re: [PATCH v8 5/9] seccomp: split mode set routines
To: Oleg Nesterov <oleg@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>,
        Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>,
        Linux API <linux-api@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-mips@linux-mips.org, linux-arch <linux-arch@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 10:32 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 06/25, Andy Lutomirski wrote:
>>
>> Write the filter, then smp_mb (or maybe a weaker barrier is okay),
>> then set the bit.
>
> Yes, exactly, this is what I meant. Plas rmb() in __secure_computing().
>
> But I still can't understand the rest of your discussion about the
> ordering we need ;)

Let me try again from scratch.

Currently there are three relevant variables: TIF_SECCOMP,
seccomp.mode, and seccomp.filter.  __secure_computing needs
seccomp.mode and seccomp.filter to be in sync, and it wants (but
doesn't really need) TIF_SECCOMP to be in sync as well.

My suggestion is to rearrange it a bit.  Move mode into seccomp.filter
(so that filter == NULL implies no seccomp) and don't check
TIF_SECCOMP in secure_computing.  Then turning on seccomp is entirely
atomic except for the fact that the seccomp hooks won't be called if
filter != NULL but !TIF_SECCOMP.  This removes all ordering
requirements.

Alternatively, __secure_computing could still BUG_ON(!seccomp.filter).
In that case, filter needs to be set before TIF_SECCOMP is set, but
that's straightforward.

--Andy
