Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935541AbaDJOSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 10:18:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934295AbaDJOSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 10:18:13 -0400
Date: Thu, 10 Apr 2014 16:18:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Jim Keniston <jkenisto@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/6] uprobes/x86: Emulate rip-relative call's
Message-ID: <20140410141806.GA23997@redhat.com>
References: <20140406201628.GA507@redhat.com> <1396995963.5056.46.camel@oc7886638347.ibm.com.usor.ibm.com> <20140409154346.GB18486@redhat.com> <53469F95.1030709@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53469F95.1030709@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10, Denys Vlasenko wrote:
>
> There is this monstrosity, "16-bit override for branches" in 64-mode:
>
> 66 e8 nn nn       callw   <offset16>
>
> Nobody sane uses it because it truncates instruction pointer.
>
> Or rather, *I think* it should truncate it (i.e. zero-extend to full width),
> but conceivably some CPUs can be buggy wrt that:
> they can decide to modify only lower 16 bits of IP,
> or even they can decided to use signed <offset16> but apply it
> to full-width RIP.
>
> AMD manuals are not clear on what exactly should happen.
>
> I am sure no one sane uses this form of branch instructions
> in 32-bit and 64-bit code.
>
> I don't think we should be trying to support it "correctly"
> (we can just let program crash with SIGILL or something),
> we only need to make sure we don't overlook its existence
> and thus are not tricked into touching or modifying unrelated data.

And after the quick check it seems that lib/insn.c doesn't parse
"66 e8 nn nn" correctly. It treats the next 2 bytes as the part
of 32bit offset.

> Imagine that   66 e8 nn nn    bytes are exactly at the end of
> a page,

this doesn't matter. We always read MAX_UINSN_BYTES bytes, so

> and we wrongly assume that offset is 32-bit, not 16-bit.
> 66 e8 nn nn.

see above this will always happen.

So I think branch_setup_xol_ops() should simply return -ENOSYS in
this case, and let the default_ code execute it out of line. Given
that nobody should use this insn, this is probably not too bad.

We can teach branch_xol_ops to handle this insn correctly later.

Now the question is, how I can detect this insn correctly? I mean,
using the "right" helpers from lib/insn.c ?

Oleg.

