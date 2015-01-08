Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266AbbAHKk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 05:40:59 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:58478 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233AbbAHKkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 05:40:55 -0500
Message-ID: <54AE5EA9.4060105@elis.ugent.be>
Date: Thu, 08 Jan 2015 11:40:41 +0100
From: Stijn Volckaert <Stijn.Volckaert@elis.ugent.be>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Roland McGrath <roland@hack.frob.com>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Casey Schaufler <casey@schaufler-ca.com>,
        John Johansen <john.johansen@canonical.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH RFC] Allow introspection to already attached ptracer in
 __ptrace_may_access
References: <549ABF87.8060905@elis.ugent.be> <CAGXu5jJWFKK1oJg0iyZtTKSSzXGyDD5B=iA3y7vvyayqhbOP5Q@mail.gmail.com>
In-Reply-To: <CAGXu5jJWFKK1oJg0iyZtTKSSzXGyDD5B=iA3y7vvyayqhbOP5Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: avast! (VPS 150107-1, 07/01/2015), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook schreef op 6/01/2015 om 0:47:
> Just to make sure I understand this better, "Monitor" is the initial
> process, and [0] and [1] are separate threads within that process? I
> would expect B to have Monitor as its parent after A died, but I must
> be misunderstanding something.
>
> Regardless, your "interesting thing 1" is certainly a side-effect of
> YAMA_SCOPE_RELATIONAL trying to do its job.

I've thought about it some more and there's actually a much easier way to show
what is going on here. Suppose that you have a debugger that forks off its own
tracee and then traces that tracee PLUS any of that tracee's future childs.
At some point you may get:

+----------+                      +----------+
| DEBUGGER | -- FORK + ATTACH --> | TRACEE A |
+----------+                      +----------+
      |                                 |
      |                                 |
      |                                FORK
    ATTACH                              |
      |                                 |
      |                                 V
      |                            +----------+
      +--------------------------> | TRACEE B |
                                   +----------+

Now at this point, if tracee A dies, tracee B will get reparented to the init
process. From that point onwards, the debugger can no longer perform any
operations that go through __ptrace_may_access. These include
process_vm_{read,write}v but also PTRACE_{POKE,PEEK}{TEXT,DATA}. I don't see
how Yama can possibly tell that tracee B and the debugger are still related
at this point so I see no easy fix for this. Patching __ptrace_may_access
might indeed not be a good idea as it is used to check for credentials to
perform a bunch of other non-ptrace operations throughout the kernel.

The possible solutions that I can see right now are:
1) Adding some sort of original_parent field to task_struct, just for the
sake of relationship tracking
2) Changing the credentials check in process_vm_{read,write}v only so that
you don't go all the way into __ptrace_may_access if you're already attached
as a ptracer

-- Stijn

