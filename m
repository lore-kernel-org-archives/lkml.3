Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbaGDDef (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 23:34:35 -0400
Received: from mail.eperm.de ([89.247.134.16]:37955 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbaGDDed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 23:34:33 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Rafael Aquini <aquini@redhat.com>, aris@redhat.com,
        Fengguang Wu <fengguang.wu@intel.com>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] DRBG: fix memory corruption for AES192
Date: Fri, 04 Jul 2014 05:32:56 +0200
Message-ID: <5597906.Ka0eDGbAv1@myon.chronox.de>
User-Agent: KMail/4.12.5 (Linux/3.14.9-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
In-Reply-To: <20140704030810.GA22255@gondor.apana.org.au>
References: <36957559.tbJt1gJF6I@myon.chronox.de> <3083657.SRQmeelhqi@myon.chronox.de> <20140704030810.GA22255@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 4. Juli 2014, 11:08:10 schrieb Herbert Xu:

Hi Herbert,

> On Tue, Jul 01, 2014 at 05:08:48PM +0200, Stephan Mueller wrote:
> > For the CTR DRBG, the drbg_state->scratchpad temp buffer (i.e. the
> > memory location immediately before the drbg_state->tfm variable
> > is the buffer that the BCC function operates on. BCC operates
> > blockwise. Making the temp buffer drbg_statelen(drbg) in size is
> > sufficient when the DRBG state length is a multiple of the block
> > size. For AES192 this is not the case and the length for temp is
> > insufficient (yes, that also means for such ciphers, the final
> > output of all BCC rounds are truncated before used to update the
> > state of the DRBG!!).
> > 
> > The patch enlarges the temp buffer from drbg_statelen to
> > drbg_statelen + drbg_blocklen to have sufficient space.
> > 
> > Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> 
> I have applied just this patch out of your series.  You patches
> depend on the previous four patches which I have not yet applied
> since there are still outstanding issues with two of them.

Thank you.

The raised issues are for patches [1] and [2].

The issue around [1] is whether there is Kconfig solution for the problem of 
selecting at least one or more than one configure option from a set of 
options. This should avoid having a module init function with returns an 
error. The selection of DRBG cores shall allow the user to compile the DRBG to 
suit his needs and reduce the footprint of the DRBG. Since at least one DRBG 
core must be selected as otherwise the DRBG is meaningless. Unfortunately I 
have not found a solution with Kconfig and all given suggestions also did not 
lead to a solution. So, if anybody has a suggestion on how to solve the issue, 
I will try it out.

Regarding [2], the issue is that ARRAY_SIZE returns different variable types 
on different platforms (e.g. unsigned long on x86_64 vs unsigned int on i386). 
Thus I have to use a type cast. This issue may be fixed by forcing a 
particular type to ARRAY_SIZE. Such change, however, may have quite some 
ripple effects throughout the kernel. Therefore, IMHO such a patch should not 
be made in the realm of the DRBG patchset and the type cast should be allowed.

[1] https://lkml.org/lkml/2014/6/28/489

[2] https://lkml.org/lkml/2014/6/28/492

-- 
Ciao
Stephan
