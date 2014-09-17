Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbaIQPFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 11:05:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755402AbaIQPFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 11:05:18 -0400
Date: Wed, 17 Sep 2014 17:04:33 +0200
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Nadav Amit <namit@cs.technion.ac.il>, Ingo Molnar <mingo@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>, kvm <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RESEND PATCH 1/3] x86: Adding structs to reflect cpuid fields
Message-ID: <20140917150433.GC1273@potion.brq.redhat.com>
References: <20140917124501.GC5358@nazgul.tnic>
 <1410958454-7501-1-git-send-email-namit@cs.technion.ac.il>
 <1410958454-7501-2-git-send-email-namit@cs.technion.ac.il>
 <20140917132141.GD5358@nazgul.tnic>
 <CAKLkAJ5wYuDL+96RcRwxi7xD1iAK8_oug1zC_niipV-ToCUu=A@mail.gmail.com>
 <20140917140601.GE5358@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140917140601.GE5358@nazgul.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-17 16:06+0200, Borislav Petkov:
> On Wed, Sep 17, 2014 at 04:53:39PM +0300, Nadav Amit wrote:
> > AFAIK backward compatibility is usually maintained in x86. I did not
> > see in Intel SDM anything that says "this CPUID field means something
> > for CPU X and something else for CPU Y". Anyhow, it is not different
> > than bitmasks in this respect.
> 
> You still don't get my point: what are you going to do when
> min_monitor_line_size needs to be 17 bits all of a sudden?
> 
> Currently, you simply do an if-else check before using the respective
> mask and with your defined structs, you need to keep two versions:
> 
> union cpuid5_ebx_before_family_X {
>        struct {
>                unsigned int max_monitor_line_size:16;
>                unsigned int reserved:16;
>        } split;
>        unsigned int full;
> };
> 
> union cpuid5_ebx_after_family_X {
>        struct {
>                unsigned int max_monitor_line_size:17;
>                unsigned int reserved:15;
>        } split;
>        unsigned int full;
> };

New union wouldn't be very convenient if the change touched just a small
part of the register ... probably the best choice is using anonymous
elements like this,

  union cpuid5_ebx {
  	union {
  		struct {
  			unsigned int max_monitor_line_size:16;
  			unsigned int reserved:16;
  		};
  		struct {
  			unsigned int max_monitor_line_size_after_family_X:17;
  			unsigned int reserved_after_family_X:15;
  		};
  	} split;
  	unsigned int full;
  };

which would result in a similar if-else hack

  if (family > X)
  	ebx.split.max_monitor_line_size_after_family_X = 0
  else
  	ebx.split.max_monitor_line_size = 0

other options are
  ebx.split.after_family_X.max_monitor_line_size
or even
  ebx.split.max_monitor_line_size.after_family_X

Flat namespace is more flexible wrt. code.
