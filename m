Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbaKMATB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 19:19:01 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:55041 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752814AbaKMAS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 19:18:59 -0500
X-Sasl-enc: 1WG1BbzfSISWRe14ILYkrSMCL6FYaQCOO2+pUiHgZjc3 1415837938
Date: Wed, 12 Nov 2014 22:18:47 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 7/8] x86, microcode, intel: guard against misaligned
 microcode data
Message-ID: <20141113001846.GB19734@khazad-dum.debian.net>
References: <1410197875-19252-8-git-send-email-hmh@hmh.eng.br>
 <20141107195905.GE5180@pd.tnic>
 <20141107225425.GC18128@khazad-dum.debian.net>
 <20141107234806.GG5180@pd.tnic>
 <20141108215749.GC32023@khazad-dum.debian.net>
 <20141111104700.GC31490@pd.tnic>
 <20141111165731.GA2584@khazad-dum.debian.net>
 <20141111171357.GK31490@pd.tnic>
 <20141111195400.GG2584@khazad-dum.debian.net>
 <20141112123115.GC16807@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141112123115.GC16807@pd.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2014, Borislav Petkov wrote:
> On Tue, Nov 11, 2014 at 05:54:00PM -0200, Henrique de Moraes Holschuh wrote:
> > void *intel_ucode_kmalloc(size_t size)
> > {
> > 	void *p = kmalloc(size, GFP_KERNEL);
> 
> Actually I was thinking of this:
> 
>  	void *p = kmalloc(size + 16, GFP_KERNEL);
> 	if (!p)
> 		return -ENOMEM;
> 
> 	if (unlikely((unsigned long)p & 0xf))
> 		p_a = ALIGN(p, 16);
> 
> You'd need to stash the original *p somewhere for freeing later, of
> course.

Well, it is a trade-off: your version always add 16 bytes.  Intel microcode
is always a multiple of 1KiB, so these extra 16 bytes will often result in
allocating an extra page.

The detail is that: since most Intel microcodes are bigger than the kmalloc
cache, most of the time kmalloc will return page-aligned addresses, which
don't need any alignment.

Your version also needs to keep the original pointer around for kfree, which
is going to be annoying.

My version has the drawback that it requires the use of INTEL_UCODE_PTR(p)
to get to the microcode data, but you can just kfree(p), and it will only
add the 16 bytes when absolutely required.  This is nice, because it means
we won't waste an extra page in the most common case, and we don't have to
find a place to store any extra pointers.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
