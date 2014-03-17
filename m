Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238AbaCQJRH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 05:17:07 -0400
Received: from mail.us.es ([193.147.175.20]:41739 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbaCQJRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 05:17:04 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus5 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.1/18612. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-98.0/7.5):. 
 Processed in 4.394095 secs); 17 Mar 2014 09:17:01 -0000
X-Spam-ASN: AS12715 188.76.0.0/16
X-Envelope-From: pneira@us.es
Date: Mon, 17 Mar 2014 10:16:55 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: David Miller <davem@davemloft.net>, ast@plumgrid.com, mingo@kernel.org,
        wad@chromium.org, rostedt@goodmis.org, a.p.zijlstra@chello.nl,
        hpa@zytor.com, hagen@jauu.net, jesse@nicira.com, tglx@linutronix.de,
        edumazet@google.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, fweisbec@gmail.com, acme@infradead.org,
        penberg@iki.fi, arjan@infradead.org, hch@infradead.org,
        xemul@parallels.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v10 net-next 1/3] filter: add Extended BPF interpreter
 and converter
Message-ID: <20140317091655.GB4735@localhost>
References: <20140314125822.GA16457@localhost>
 <CAMEtUuzqzAHf64DHBao3xKzHdhrp77JEZhe-_c5oC3Vr63QxNA@mail.gmail.com>
 <CAMEtUuxd0yd81p7KPxyotMOcOxm3MS4Cj9oguS5QAzfXYChLXQ@mail.gmail.com>
 <20140314.160851.1134730495663127657.davem@davemloft.net>
 <5324AFD3.8040804@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5324AFD3.8040804@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2014 at 08:53:55PM +0100, Daniel Borkmann wrote:
> On 03/14/2014 09:08 PM, David Miller wrote:
> >From: Alexei Starovoitov <ast@plumgrid.com>
> >Date: Fri, 14 Mar 2014 12:51:17 -0700
> >
> >>can you please explain why the status of these
> >>patches is 'deferred' in patchwork ?
> >>Is it because of bpf vs nft thread?
> >>I think that's orthogonal.
> >
> >I do not find it orthogonal, Pablo brings up some very valid points
> >which I agree with.
> >
> >EBPF has a lot of the same user side interface limitations that the
> >existing BPF has, and you refuse to accept this core point Pablo is
> >making.
> >
> >That is, that it lacks extensibility, and is too strongly tied to the
> >implementation.
> >
> >This is exactly how we run into problems in the future, and you'll be
> >proposing EBPF_2.0 to address such problems.
> 
> Hm, so currently there's no interface where this is exposed to uapi,
> and we surely can and should put the definitions back to the non-uapi
> include to keep it inside the kernel, you're right.

Yes please, move that to somewhere to avoid exposing internal
implementation details to userspace.

I also don't find a good reason to add that new /proc user interface
switch to enable/disable the conversion to the new internal
representation that this patch adds. I think benchmarking old and new
approaches is *not* a good reason to expose that to userspace. My
impression is that, without that /proc switch, the patch will be
simplified.

> I think, at least for me, the take-away of Alexei's work is, that
> even (if we assume) without any further functionality, the new design
> would greatly improve the interpreter (and presumably later on as
> well JIT) performance based on Alexei's benchmarks, which would already
> be a win for seccomp and socket filters and where ever they are being
> used across the networking subsystem, and therefore out-of-the-box
> without any changes for user space applications such as libpcap.
> 
> I was thinking that it could be an option to make this transparently
> available to everyone, by just dropping the bpf_ext_enable knob, and
> perhaps just replace the old BPF interpreter entirely in this set?
> So the process would be: 1) test if normal BPF filter can be JIT'ed,
> go for it, if it's not supported by JIT (or if it is disabled), run
> it transparently in the new (non-exposed) BPF representation to have
> a better overall performance.

That makes sense to me. If the purpose is to keep this as an internal
representation, the decisions on how to represent the filter to boost
performance should remain in the kernel-space, I don't find a good
reason for keeping it there.  Please, remove it.

Moreover, as we discussed already the new jit flag should be scratched
from the len attribute of the sk_filter object. That should be sent as
an initial patch in the series, David requested that change and he can
take it already since it's independent from this.

> Would that perhaps address the above concern? So on the big picture,
> it provides a BPF performance improvement. I think if there's a wish
> to extend the socket filtering api to run alternative interpreters,
> such as nft, then that could still happen, of course.
