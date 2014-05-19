Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbaESRXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 13:23:00 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:58282 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbaESRW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 13:22:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Joseph S. Myers" <joseph@codesourcery.com>
Cc: Chung-Lin Tang <cltang@codesourcery.com>,
        John Stultz <john.stultz@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ley Foon Tan <lftan@altera.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LeyFoon Tan <lftan.linux@gmail.com>
Subject: Re: [PATCH 00/25] Change time_t and clock_t to 64 bit
Date: Mon, 19 May 2014 19:22:13 +0200
Message-ID: <5228220.XfC7baN05k@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.64.1405191431210.25418@digraph.polyomino.org.uk>
References: <1399971456-3941-1-git-send-email-lftan@altera.com> <4254860.84WuxPQ4j9@wuerfel> <Pine.LNX.4.64.1405191431210.25418@digraph.polyomino.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:+ggilM2pmTyOx/Zpz/WE6eX3yIVn3Wskd34U9AF1pzU
 0XaKbdBI1K8cwHFtP7Q24ybfzuR/TIDDqp0bkyouX8iDMXpN8y
 Q0/vYZFnuR5WKHrLL2TtTdklwmkkJxwufmyzAw216BlYkuCmnx
 uMSISuF+j0xcI2bX2Ern/x7l2ENfrxf+cCJfZiHu7OQRDDMJvI
 4DhhxTvaD2HLedAOHU7dyDY51rYAfrWRH5tumDDb1hLP1D7IjC
 SD5Eb+OWnmmEGH+2v1xW/U/dYIiUyyenXIaF6Z7oiOfFxePC3I
 jIjIgsUUL0uCleDrJBaYBmS9c0nwxfp3BhDMTy6G5vzMArcWrM
 lVjXKct7rnaKyXu7bLdw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 May 2014 14:46:59 Joseph S. Myers wrote:
> On Mon, 19 May 2014, Arnd Bergmann wrote:
>
> Now, when the motivation is not space reduction but ensuring nothing is 
> there that will break in 2038 (unless it's doing dubious things like 
> storing a time_t value in an int or long in the application - something a 
> reasonably stupid static analysis should be able to detect), you could 
> always identify the (symbol, version) pairs for a given architecture that 
> use 32-bit time_t and develop a tool that checks for binaries using 
> problem symbols.  (Of course, that won't help with ioctls.)  Or put a 
> small patch in the headers to force _TIME_BITS=64 and not allow an 
> override with _TIME_BITS=32.  And if the kernel had a config option to 
> disable all the old interfaces, that would make problem binaries break now 
> rather than in 2038.

I had already thought of the kernel option, that's probably one thing
we will do here, but it won't help if glibc then emulates the interfaces
we remove ;-)

A related question would be how you plan to support future CPU architectures
that never had the 32-bit time_t in the kernel ABI. Would you also want
to provide both 32 and 64 bit time_t to user space on those?

Then again I'm not sure how relevant glibc is to the deeply embedded
distros that would want to run without the backwards compatibility.
I suspect that uClibc, musl and bionic would just offer a compile time
switch without any emulation.

> > > > I don't know why timespec on x32 uses 'long tv_nsec', it does seem
> > > > problematic.
> > > 
> > > Yes, we have a glibc bug 
> > > <https://sourceware.org/bugzilla/show_bug.cgi?id=16437> about the glibc 
> > > definition (64-bit tv_nsec in x32 userspace to match the kernel's 64-bit 
> > > "long") being nonconforming, but without the kernel treating upper bits as 
> > > padding, fixing glibc requires wrappers that copy the value and clear the 
> > > upper bits.
> > 
> > Ok. There is also work going on to have an x32-like ABI for ARM64, and
> > that will likely have to support big-endian as well, so then it's not
> > just about clearing the padding bits, but also having them in the right
> > place.
> 
> Yes, I see no problem with putting the padding bits in the right place so 
> that when the kernel is passing struct timespec values *to* userspace, it 
> can just fill in the native 64-bit structure and have it automatically be 
> correct when interpreted as a 32-bit structure with padding (which the 
> kernel will have zeroed implicitly) on tv_nsec.

Ok.

	Arnd
