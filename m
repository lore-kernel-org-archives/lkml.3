Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbaEUPWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 11:22:45 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:43617 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbaEUPWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 11:22:44 -0400
MIME-Version: 1.0
In-Reply-To: <20140521145857.GA5880@suse.cz>
References: <alpine.LNX.2.00.1404291150200.8903@pobox.suse.cz>
 <20140429100345.3f76a5bd@gandalf.local.home> <alpine.LNX.2.00.1405211540080.20534@pobox.suse.cz>
 <20140521142055.GH21205@pd.tnic> <20140521145857.GA5880@suse.cz>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 21 May 2014 08:22:22 -0700
Message-ID: <CALCETrWayHx6X1pwfF=ze_SWc7Uso25M+XA0_YrAPoC4_Dq9ug@mail.gmail.com>
Subject: Re: 64bit x86: NMI nesting still buggy?
To: Vojtech Pavlik <vojtech@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>, Salman Qazi <sqazi@google.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@elte.hu>, X86 ML <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Petr Tesarik <ptesarik@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 21, 2014 7:58 AM, "Vojtech Pavlik" <vojtech@suse.cz> wrote:
>
> On Wed, May 21, 2014 at 04:20:55PM +0200, Borislav Petkov wrote:
> > On Wed, May 21, 2014 at 03:42:24PM +0200, Jiri Kosina wrote:
> > > Alright, Andy's iret optimization efforts do immediately bring a
> > > followup question -- why is this not a problem with iret-based return
> > > from #MC possibly interrupting NMI?
> >
> > Yeah, and frankly, I don't see this nesting fun at all protected against
> > a #MC interrupting it at any point actually. Because once the #MC
> > handler returns, it goes into paranoid_exit and that place doesn't
> > account for NMIs at all, AFAICS.
> >
> > Which would mean:
> >
> > * NMI goes off
> > * MCE happens, we switch to machine_check which is paranoidzeroentry
> > * #MC handler is done -> paranoid_exit -> IRET
> > -> boom! Or if not "boom", at least, the NMI gets forgotten.
> >
> > Am I missing something?
>
> I think to get a full BOOM you need a bit more complex process, namely:
>
>         * NMI triggered
>         * NMI handler starts
>         * MCE happens
>         * Second NMI triggered and queued
>         * handler done, IRET
>         * Second NMI handler starts and overwrites NMI return address on stack
>         * Second NMI handler ends
>         * First NMI handler ends and goes into an infinite IRET loop, always
>           returning to the beginning of itself
>
> But you do have all the ingredients.
>
> And I don't see any other way out than not calling IRET for MCEs.

The MCE handler could detect this and fiddle with the IST entry.  This
sounds considerably uglier than returning via RET, though.

--Andy

>
> --
> Vojtech Pavlik
> Director SUSE Labs
