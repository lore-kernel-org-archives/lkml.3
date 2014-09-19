Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418AbaISANZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 20:13:25 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:40056 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750720AbaISANY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 20:13:24 -0400
X-Sasl-enc: fmdZJsUfe5xokv13hxtfmW141kwSzbXPYSEowMTSRADr 1411085602
Date: Thu, 18 Sep 2014 21:13:11 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Chuck Ebbert <cebbert.lkml@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>
Subject: Re: x86, microcode: BUG: microcode update that changes x86_capability
Message-ID: <20140919001311.GB5331@khazad-dum.debian.net>
References: <20140918135202.GA26038@khazad-dum.debian.net>
 <541B2F33.8000002@amacapital.net>
 <20140918145328.0253f009@as>
 <9c84cde6-3d70-4337-8738-0283d06d8cf0@email.android.com>
 <20140918200659.GA5331@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140918200659.GA5331@khazad-dum.debian.net>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2014, Henrique de Moraes Holschuh wrote:
> On Thu, 18 Sep 2014, H. Peter Anvin wrote:
> > We should, but this is also part of why we want the early ucode capability.
> 
> Well, yes.  But that won't help the several stable and LTS distros with
> kernels without early ucode update support.

Here's a plan that might work, pending actually checking the libpthread TSX
code to make sure it keys on /proc/cpuinfo flags:

Add a cpu quirk, triggered by the Haswell cpuids, to force-disable hle on
the affected processors.

This will work around the x86_capability capability issue (which should
still be fixed, anyway), and it should also get userspace to stay away from
TSX, therefore also working around the worst issue (processes getting
SIGILL).

This will disable the "user may ask the BIOS to keep TSX enabled"
anti-feature, though.  This drawback can be avoided, but only if a future
microcode update won't re-disable hle when the BIOS enabled it.  For now, I
suggest that we decree that "hle is toast" for the current Haswells and add
back ways to enable it for testing when we know more about it.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
