Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbbAEQpR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 11:45:17 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:39431 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbbAEQpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 11:45:15 -0500
Date: Mon, 5 Jan 2015 17:44:47 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, root <chenggang.qin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?utf-8?B?56em5om/5YiaKOaJv+WImik=?= <chenggang.qcg@taobao.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Paul Mackerras <paulus@samba.org>,
        =?utf-8?B?56em5om/5YiaKOaJv+WImik=?= 
	<chenggang.qcg@alibaba-inc.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>
Subject: Re: [PATCH 1/2] perf: Move task_pt_regs sampling into arch code
Message-ID: <20150105164447.GG29390@twins.programming.kicks-ass.net>
References: <cover.1420396372.git.luto@amacapital.net>
 <e431cd4c18c2e1c44c774f10758527fb2d1025c4.1420396372.git.luto@amacapital.net>
 <20150105140754.GF29390@twins.programming.kicks-ass.net>
 <CALCETrW6cv_s60uzi_scy5JBdr4+wrz1O5we-3okc-SZKRVofA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrW6cv_s60uzi_scy5JBdr4+wrz1O5we-3okc-SZKRVofA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2015 at 08:13:49AM -0800, Andy Lutomirski wrote:
> > Just wondering how bad it would be to fill out the actual pt_regs that
> > was previously partially initialized?
> 
> Bad, for at least two reasons.
> 
> One is that we don't actually know which regs are initialized.  bx,
> bp, r12 etc are particularly bad in this regard, due to the FORK_LIKE
> mechanism and similar optimizations.

Right, but you need to deal with that anyhow.

> The other is that the uninitialized part of task_pt_regs can be used
> for something else entirely.  If we have a syscall instruction
> immediately followed by a regular interrupt, then the interrupt's
> hardware frame will overlap task_pt_regs.  (I'm not going to claim
> that this design is sensible, but it is what it is.  IIRC Denys
> Vlasenko had some patches to partially clean this up.)

Ah, urgh. Yes painful that.

> It would be possible to rework the code to avoid an extra pt_regs
> copy, but I don't see an obvious way to do it cleanly.

Yeah, we'll see how this works, I was just curious on the exact need for
the copy, but if as you say, the original structure might not even exist
properly (even though we have a pointer to it) that's bad (TM).
