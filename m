Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751145AbaETSBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 14:01:09 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:33106 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaETSBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 14:01:07 -0400
Date: Tue, 20 May 2014 22:01:04 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: X86 ML <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 3/4] x86,mm: Improve _install_special_mapping and fix x86
 vdso naming
Message-ID: <20140520180104.GL2185@moon>
References: <cover.1400538962.git.luto@amacapital.net>
 <276b39b6b645fb11e345457b503f17b83c2c6fd0.1400538962.git.luto@amacapital.net>
 <20140520172134.GJ2185@moon>
 <CALCETrWSgjc+iymPrvC9xiz1z4PqQS9e9F5mRLNnuabWTjQGQQ@mail.gmail.com>
 <20140520174759.GK2185@moon>
 <CALCETrUARCP0eNj5e3Kh81KDXg5AFLnoNoDHeoZcBXi9z-5F3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUARCP0eNj5e3Kh81KDXg5AFLnoNoDHeoZcBXi9z-5F3w@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 10:52:51AM -0700, Andy Lutomirski wrote:
> >
> >   We use not only [vdso] mark to detect vdso area but also page frame
> > number of the living vdso. If mark is not present in procfs output
> > we examinate executable areas and check if pfn == vdso_pfn, it's
> > a slow path because there migh be a bunch of executable areas and
> > touching every of it is not that fast thing, but we simply have no
> > choise.
> 
> This patch should fix this issue, at least.  If there's still a way to
> get a native vdso that doesn't say "[vdso]", please let me know/

Yes, having a native procfs way to detect vdso is much preferred!

> >   The situation get worse when task was dumped on one kernel and
> > then restored on another kernel where vdso content is different
> > from one save in image -- is such case as I mentioned we need
> > that named vdso proxy which redirect calls to vdso of the system
> > where task is restoring. And when such "restored" task get checkpointed
> > second time we don't dump new living vdso but save only old vdso
> > proxy on disk (detecting it is a different story, in short we
> > inject a unique mark into elf header).
> 
> Yuck.  But I don't know whether the kernel can help much here.

Some prctl which would tell kernel to put vdso at specifed address.
We can live without it for now so not a big deal (yet ;)

> >> I suspect that you'll need kernel changes for compat tasks, since I
> >> think that mremapping the vdso on any reasonably modern hardware in a
> >> 32-bit task will cause sigreturn to blow up.  This could be fixed by
> >> making mremap magical, although adding a new prctl or arch_prctl to
> >> reliably move the vdso might be a better bet.
> >
> > Well, as far as I understand compat code uses abs addressing for
> > vvar data and if vvar data position doesn't change we're safe,
> > but same time because vvar addresses are not abi I fear one day
> > we indeed hit the problems and the only solution would be
> > to use kernel's help. But again, Andy, I didn't think much
> > about implementing compat mode in criu yet so i might be
> > missing some details.
> 
> Prior to 3.15, the compat code didn't have vvar data at all.  In 3.15
> and up, the vvar data is accessed using PC-relative addressing, even
> in compat mode (using the usual call; mov trick to read EIP).

i see. I'll ping you for help once I start implementing compat mode ;)
