Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab3CKTmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:42:18 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:53883 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632Ab3CKTmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:42:14 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Kees Cook <keescook@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Emese Revfy <re.emese@gmail.com>, PaX Team <pageexec@freemail.hu>
References: <20130311191156.GA17763@www.outflux.net>
	<20130311192805.GA19428@redhat.com>
	<CAGXu5jJEhDHgVR_iAdf27G0+Mip82vYBHv-r0Q_vZwDodfADRQ@mail.gmail.com>
Date: Mon, 11 Mar 2013 12:42:05 -0700
In-Reply-To: <CAGXu5jJEhDHgVR_iAdf27G0+Mip82vYBHv-r0Q_vZwDodfADRQ@mail.gmail.com>
	(Kees Cook's message of "Mon, 11 Mar 2013 12:34:39 -0700")
Message-ID: <87ip4xlo4y.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19Ptt1SxCv2cXU2jqT/Lvlz1jJMSqmTRE4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kees Cook <keescook@chromium.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] signal: always clear sa_restorer on execve
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> On Mon, Mar 11, 2013 at 12:28 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>> On 03/11, Kees Cook wrote:
>>>
>>> When the new signal handlers are set up for a fork, the location of
>>> sa_restorer is not cleared, leaking a parent process's address space
>>> location to children. This allows for a potential bypass of the parent's
>>> ASLR by examining the sa_restorer value returned when calling sigaction().
>>
>> I don't understand.
>>
>> fork() should not change restorer/etc, and the child has the same address
>> space anyway. There is no any leak and the patch can't make any difference
>> in this case because flush_signal_handlers() is not called by fork().
>
> I probably failed to explain this correctly. From the perspective of
> what should be considered "secret", it only matters across the exec,
> not the fork (since the VMAs haven't changed until the exec). But the
> info leak is easy to see, and this patch fixes it. As you say, since
> other things were reset, so should sa_restorer.

At the very least please correct the explanation in your patch
description.

Too often I have had seen a confused patch description, indicate
confusion elsewhere in the patch.  Let's make it easy for reviewers
and future bisectors to understand what is intended.

>>> @@ -485,6 +485,9 @@ flush_signal_handlers(struct task_struct *t, int force_default)
>>>               if (force_default || ka->sa.sa_handler != SIG_IGN)
>>>                       ka->sa.sa_handler = SIG_DFL;
>>>               ka->sa.sa_flags = 0;
>>> +#ifdef __ARCH_HAS_SA_RESTORER
>>> +             ka->sa.sa_restorer = NULL;
>>> +#endif

Also I am inclined to suggest this should be an inline function in a
header.
		clear_sa_restorer(ka);

Just so we don't litter the code with #ifdefs.

Eric
