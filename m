Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab3KCKVg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 05:21:36 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:35053 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab3KCKVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 05:21:35 -0500
Date: Sun, 3 Nov 2013 11:21:32 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, prarit@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Allow NR_CPUS=1024
Message-ID: <20131103102132.GA6807@gmail.com>
References: <20131101141148.GH8652@hansolo.jdub.homelinux.org>
 <20131103101825.GA6605@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131103101825.GA6605@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> 
> * Josh Boyer <jwboyer@redhat.com> wrote:
> 
> > The current range for SMP configs is 2 - 512, or a full 4096 in the case 
> > of MAXSMP.  There are machines that have 1024 CPUs in them today and 
> > configuring a kernel for that means you are forced to set MAXSMP.  This 
> > adds additional unnecessary overhead.  While that overhead might be 
> > considered tiny for large machines, it isn't necessarily so if you are 
> > building a kernel that runs across a wide variety of machines.  We 
> > increase the range to 1024 to help with this.
> >
> > Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
> > ---
> >  arch/x86/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index f67e839..d726b2d 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -825,7 +825,7 @@ config MAXSMP
> >  config NR_CPUS
> >  	int "Maximum number of CPUs" if SMP && !MAXSMP
> >  	range 2 8 if SMP && X86_32 && !X86_BIGSMP
> > -	range 2 512 if SMP && !MAXSMP
> > +	range 2 1024 if SMP && !MAXSMP
> >  	default "1" if !SMP
> >  	default "4096" if MAXSMP
> >  	default "32" if SMP && (X86_NUMAQ || X86_SUMMIT || X86_BIGSMP || X86_ES7000)
> 
> Any reason not to allow it to go up to 4096? The original concern was 
> that CPUS=4096 wasn't working very well and you had to select MAXSMP 
> deliberately and keep all the pieces.

The other reason was CONFIG_CPUMASK_OFFSTACK: with 4096 CPUs a cpumask is 
512 bytes, too large to be kept on the kernel stack.

MAXSMP forces CONFIG_CPUMASK_OFFSTACK so there's no such concern there.

With 1024 CPUs a single cpumask is 128 bytes - rather significant as well. 
With 512 CPUs it's 64 bytes - borderline.

So I think a better solution would be to allow an increase above 512 CPUs 
only if CONFIG_CPUMASK_OFFSTACK is also enabled.

Thanks,

	Ingo
