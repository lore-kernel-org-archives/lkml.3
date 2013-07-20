Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab3GTF5m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 01:57:42 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:64301 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab3GTF5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 01:57:41 -0400
X-Nat-Received: from [202.181.97.72]:56034 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1374299767.23271
To: herbert@gondor.hengli.com.au, tim.c.chen@linux.intel.com
Cc: hpa@zytor.com, gregkh@linuxfoundation.org, rjw@rjwysocki.net,
        rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, ak@linux.intel.com,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 3.11-rc1] crypto: Fix boot failure due to moduledependency.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <51E9C9E5.2060602@zytor.com>
	<20130719232459.GA18039@gondor.apana.org.au>
	<1374277033.22432.384.camel@schen9-DESK>
	<1374283864.22432.393.camel@schen9-DESK>
	<20130720053021.GA19689@gondor.apana.org.au>
In-Reply-To: <20130720053021.GA19689@gondor.apana.org.au>
Message-Id: <201307201456.JIC35412.VFOMFJOQLOtHFS@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 20 Jul 2013 14:56:06 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 20072013 #10634227, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> On Fri, Jul 19, 2013 at 06:31:04PM -0700, Tim Chen wrote:
> >
> > However, when I have the library and generic algorithm compiled in,
> > I do not see the PCLMULQDQ version loaded.
> > 
> > CONFIG_CRYPTO_CRCT10DIF=y
> > CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
> > CONFIG_CRC_T10DIF=y
> 
> That is completely expected.  I don't really think we need to
> do anything about this case.  After all, if the admin wants to
> use the optimised version for CRC_T10DIF then they could simply
> compile that in as well.
> 

Wow! ;-)

But I'd expect something like

 static int __init crc_t10dif_mod_init(void)
 {
+#if !defined(CONFIG_CRC_T10DIF_MODULE) && defined(CONFIG_CRYPTO_CRCT10DIF_PCLMUL_MODULE)
+	printk(KERN_WARNING "Consider CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y for better performance\n");
+#endif
 	crct10dif_tfm = crypto_alloc_shash("crct10dif", 0, 0);
 	return PTR_RET(crct10dif_tfm);
 }

because the admin might not be aware of this implication.
