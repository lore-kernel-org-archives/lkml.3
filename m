Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab3EUNrO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 09:47:14 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:44619 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752286Ab3EUNrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 09:47:11 -0400
Date: Tue, 21 May 2013 21:46:57 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Xiong Zhou <jencce.kernel@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux-Next <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Subject: Re: linux-next: Tree for May 15 (crypto /crct10dif)
Message-ID: <20130521134656.GA9594@gondor.apana.org.au>
References: <20130515132627.817585a3d9fb3a3e502eb586@canb.auug.org.au>
 <5193CCEC.7070909@infradead.org>
 <alpine.DEB.2.02.1305161152530.31865@M2420>
 <CAMuHMdUmD2DMNeezetHNbe9DgQXpTN4BEfEmJSztyzCivQpyXQ@mail.gmail.com>
 <1368723552.27102.286.camel@schen9-DESK>
 <1368727412.27102.289.camel@schen9-DESK>
 <20130520114707.GA1187@gondor.apana.org.au>
 <1369076985.27102.319.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369076985.27102.319.camel@schen9-DESK>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 12:09:45PM -0700, Tim Chen wrote:
> On Mon, 2013-05-20 at 19:47 +0800, Herbert Xu wrote:
> 
> > 
> > Nope this is still broken.  We need to move the actual crct10dif
> > code into crypto/.  I'll fix up the patch in the tree.
> > 
> > Also I'm going to get rid of crc_t10dif_update_lib function.  If you
> > still want to maintain the ordering you should do so using the
> > *_init constructs.
> > 
> 
> Herbert, 
> 
> I used the following constructs in the pclmulqdq version of t10dif
> to get the module loaded. 
> 
> static const struct x86_cpu_id crct10dif_cpu_id[] = {
>         X86_FEATURE_MATCH(X86_FEATURE_PCLMULQDQ),
>         {}
> };
> MODULE_DEVICE_TABLE(x86cpu, crct10dif_cpu_id);
> 
> However, the default generic algorithm is used
> in the library function. The options CRC_T10DIF, CRYPTO_CRCT10DIF
> and CRYPTO_CRCT10DIF_PCLMUL are selected as modules (which
> is most likely usage scenario in distribution) on my
> test machine.  The library module and generic crypto module was loaded
> before the pclmulqdq t10dif module during boot.  How should
> things be changed to get this crypto module loaded earlier before the
> library?  Should we add another init call level between fs and device
> init calls for loading the available crypto algorithms?  
> The crc_t10dif_update_lib was originally used to side step this issue.

OK, the way it's meant to work is that the all versions generic
or otherwise do not call themselves by the name of the algorithm.

Instead every implementation links itself to the algorithm via
a module alias.  That way the first user will cause modprobe
to load all available versions and then rank them by priority.

However, now that I've looked at it it appears that crc32c and
crct10dif have not done this properly.  I'll fix that up.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
