Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbbAHTUR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 14:20:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755269AbbAHTUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 14:20:14 -0500
Date: Thu, 8 Jan 2015 20:18:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Stijn Volckaert <Stijn.Volckaert@elis.ugent.be>
Cc: Kees Cook <keescook@chromium.org>, Roland McGrath <roland@hack.frob.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Casey Schaufler <casey@schaufler-ca.com>,
        John Johansen <john.johansen@canonical.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH RFC] Allow introspection to already attached ptracer in
	__ptrace_may_access
Message-ID: <20150108191813.GA30102@redhat.com>
References: <549ABF87.8060905@elis.ugent.be> <CAGXu5jJWFKK1oJg0iyZtTKSSzXGyDD5B=iA3y7vvyayqhbOP5Q@mail.gmail.com> <54AE5EA9.4060105@elis.ugent.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AE5EA9.4060105@elis.ugent.be>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08, Stijn Volckaert wrote:
>
> From that point onwards, the debugger can no longer perform any
> operations that go through __ptrace_may_access. These include
> process_vm_{read,write}v but also PTRACE_{POKE,PEEK}{TEXT,DATA}.

PTRACE_POKE/PEEK should work? not that this really matters...

> I don't see
> how Yama can possibly tell that tracee B and the debugger are still related
> at this point so I see no easy fix for this.

Well, perhaps yama can also have PR_SET_PTRACEE, I dunno.

> Patching __ptrace_may_access
> might indeed not be a good idea as it is used to check for credentials to
> perform a bunch of other non-ptrace operations throughout the kernel.

Just add the "ptrace_parent(task) == current" check into
ptracer_exception_found() ?

> The possible solutions that I can see right now are:
> 1) Adding some sort of original_parent field to task_struct, just for the
> sake of relationship tracking

And what should we do with this pointer if original_parent exits?

> 2) Changing the credentials check in process_vm_{read,write}v only so that
> you don't go all the way into __ptrace_may_access if you're already attached
> as a ptracer

This really doesn't look good, imo.

Oleg.

