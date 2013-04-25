Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748Ab3DYQ7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 12:59:23 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:31793
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932626Ab3DYQ7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 12:59:19 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zzbb2dI98dI1432I168aJzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1155h)
X-WSS-ID: 0MLTLUF-02-GN1-02
X-M-MSG: 
Date: Thu, 25 Apr 2013 11:59:02 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Oleg Nesterov <oleg@redhat.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        <x86@kernel.org>, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 1/4] perf: Add hardware breakpoint address mask
Message-ID: <20130425165902.GA31751@jshin-Toonie>
References: <1366703825-19373-1-git-send-email-jacob.shin@amd.com>
 <1366703825-19373-2-git-send-email-jacob.shin@amd.com>
 <20130423131844.GA24467@redhat.com>
 <20130423142546.GA17021@jshin-Toonie>
 <CAFTL4hxpcuSVfk0dBm8RSL+iUZpQrbb51tU1-zPyFE=u2hhjXQ@mail.gmail.com>
 <20130425151035.GA26760@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130425151035.GA26760@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 05:10:35PM +0200, Oleg Nesterov wrote:
> On 04/25, Frederic Weisbecker wrote:
> >
> > 2013/4/23 Jacob Shin <jacob.shin@amd.com>:
> > > @@ -286,7 +286,10 @@ struct perf_event_attr {
> > >                 __u64           config1; /* extension of config */
> > >         };
> > >         union {
> > > -               __u64           bp_len;
> > > +               struct {
> > > +                       __u32           bp_len;
> > > +                       __u32           bp_addr_mask;
> > > +               };
> >
> > Do we need len and mask to work at the same time? I can't think of a
> > situation when len and mask mix up together in a useful way to define
> > a range.

Okay, we can make it:

union {
      __u64 bp_len;
      __u64 bp_addr_mask;
      __config2;
};

And in x86, bp_len != HW_BREAKPOINT_LEN_1,2,4,8 will be interpreted as
bp_addr_mask.

> 
> And it would be nice (I think) if we could simply turn bp_len into
> bp_mask. It is already the mask actually, bp_addr should be aligned.
> 
> But I do not see how we can do this, so I guess we need another field.
> 
> Well. Another option is to extend bp_len. Fortunately HW_BREAKPOINT_LEN_*
> match the length, so we can simply allow any 2^n length and amd.c can
> translate it into the mask.

Okay, this is nice because we can just ride on top of what already exits,
but ...

> 
> Of course, this doesn't allow to use, say, mask=0xF0. But perhaps this
> is not really useful?

Exactly .. Right I think most of the time we are trying to trap on range
of contiguous addresses, but .. mask of 0xf0 allows us to trap on 16 byte
aligned addresses:

addr of 0x1000 and mask of 0xf0 will count accesses to:

0x1000, 0x1010, 0x1020, .. 0x10e0, 0x10f0

Maybe there is some big blob of data and user wants to see how many times
16 byte aligned addresses get hit. This might be not as common, but it is
plausible no?

