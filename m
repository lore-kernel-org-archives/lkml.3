Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab3K0NeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 08:34:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab3K0NeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 08:34:02 -0500
Date: Wed, 27 Nov 2013 14:35:01 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: modules, add_kallsyms() && DEFINE_PER_CPU
Message-ID: <20131127133500.GB1168@redhat.com>
References: <20131123201543.GA22148@redhat.com> <20131125172106.GA14516@redhat.com> <20131125172206.GD14516@redhat.com> <52946B42.40603@hitachi.com> <20131126174355.GB14028@redhat.com> <20131126174446.GD14028@redhat.com> <20131126175037.GE14028@redhat.com> <529557AF.8040501@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529557AF.8040501@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27, Masami Hiramatsu wrote:
>
> (2013/11/27 2:50), Oleg Nesterov wrote:
> > On 11/26, Oleg Nesterov wrote:
> >>
> >> Note: this doesn't work for modules, but module's per-cpu data is
> >> not visible for kallsyms_lookup_name() anyway.
> >
> > Rusty, I am just curious if it makes sense to change this or not...
> >
> > But DEFINE_PER_CPU'ed symbols are ignored by add_kallsyms(). I guess
> > this is because is_core_symbol() requires "sh_flags & SHF_ALLOC".
> > And probably because of INIT_OFFSET_MASK.
>
> Oleg, I think you can do it by using is_module_percpu_address(). :)

Not only is_module_percpu_address() can't help. We can solve the
is-it-percpu problem (although the check won't be cheap).

The problem is, sc->addr is always NULL if DEFINE_PER_CPU() was used
in a module. kallsyms_lookup_name() can never see it because it is
ignored by add_kallsyms(), it is nacked by is_core_symbol().

IOW, with or without this patch @modular_percpu_sym never reads the
memory.

Oleg.

