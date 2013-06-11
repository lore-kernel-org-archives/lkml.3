Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab3FKSre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 14:47:34 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:64163 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314Ab3FKSrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 14:47:32 -0400
MIME-Version: 1.0
In-Reply-To: <20130611183825.GK5638@shells.gnugeneration.com>
References: <20130611012304.GI5638@shells.gnugeneration.com>
 <51B754D6.6010606@mit.edu> <20130611183825.GK5638@shells.gnugeneration.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 11 Jun 2013 11:47:10 -0700
X-Google-Sender-Auth: D22uZ_lJzfVbH9-MfMX6AT1Urv0
Message-ID: <CAObL_7GG8sMhx_vC7WMEqPgrVTr6_A=dsuO5cSWPfPRo7hsS0w@mail.gmail.com>
Subject: Re: adopt(pid_t pid) syscall proposal [patch included]
To: vcaputo@gnugeneration.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 11:38 AM,  <vcaputo@gnugeneration.com> wrote:
> On Tue, Jun 11, 2013 at 09:48:22AM -0700, Andy Lutomirski wrote:
>> On 06/10/2013 06:23 PM, vcaputo@gnugeneration.com wrote:
>> >+                    if (!uid_eq(cred->euid, tcred->suid) &&
>> >+                        !uid_eq(cred->euid, tcred->uid)  &&
>> >+                        !uid_eq(cred->uid,  tcred->suid) &&
>> >+                        !uid_eq(cred->uid,  tcred->uid) &&
>> >+                        !ns_capable(cred->user_ns, CAP_KILL)) {
>> >+                            ret = -EPERM;
>> >+                            goto out_unlock;
>> >+                    }
>> >+
>>
>> That check's far too permissive.
>
> I suspected, but that's easily improved, I just wanted to get this out
> there and see what people thought, start the discussion, as well as
> get my use case functional.  Although I'm curious, what is your cause
> for concern with the existing checks?

For example, "!uid_eq(cred->euid, tcred->uid)" means that you can
adopt setuid things.  Looking at ptrace may be a good start.

>
>>
>> This sounds like it will break anything that uses wait and expects its
>> children to not be stolen out from under it.
>
> This thought crossed my mind, and originally I intended to restrict
> adoption to orphans who had become children of init.  It seemed like
> more general use might be desirable so I left that out.  If this
> really is a possibility worth preventing we could put that restriction
> on it.  To the best of my knowledge, nothing informs init of its
> becoming parent of an orphan, so we should be able to steal the orphan
> back without harm.  This still enables the use case of screen/tmux
> reattachment.
>
>>
>> Also, you'll have problems with screen -x or the default tmux shareable
>> configuration.  It sounds like this is better done in userspace.
>
> It just needs some determination of "session leader" applied to which
> attach adopts the backend before invoking adopt(), that logic goes in
> userspace.  I imagine the implementations of both screen and tmux
> already have such determinations happening for other reasons.

What I mean is: why not just teach your userspace tool to do this
without kernel help?

--Andy
