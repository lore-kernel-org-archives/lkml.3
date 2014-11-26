Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbaKZOpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:45:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42981 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbaKZOpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:45:02 -0500
Date: Wed, 26 Nov 2014 15:44:57 +0100
From: Borislav Petkov <bp@suse.de>
To: boris ostrovsky <boris.ostrovsky@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Richard Hendershot <rshendershot@mchsi.com>,
        David Vrabel <david.vrabel@citrix.com>, x86-ml <x86@kernel.org>
Subject: Re: [PATCH 3.17 100/141] x86, microcode: Fix accessing dis_ucode_ldr
 on 32-bit
Message-ID: <20141126144457.GB29982@pd.tnic>
References: <20141125190849.GF4128@pd.tnic>
 <5474D86E.6020608@oracle.com>
 <20141125202628.GG4128@pd.tnic>
 <20141125203634.GA6433@laptop.dumpdata.com>
 <20141125211708.GH4128@pd.tnic>
 <5474FBC6.7090603@oracle.com>
 <20141125221800.GI4128@pd.tnic>
 <54755E7D.3060903@oracle.com>
 <20141126105517.GA29982@pd.tnic>
 <5475C9FE.8020003@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5475C9FE.8020003@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 07:39:26AM -0500, boris ostrovsky wrote:
> https://lkml.org/lkml/2014/11/25/973 is all I have right now.

Ok, so the Code: section from this splat says:

  25:   55                      push   %ebp
  26:   89 e5                   mov    %esp,%ebp
  28:   83 ec 08                sub    $0x8,%esp
  2b:*  80 3d c0 ee 97 01 00    cmpb   $0x0,0x197eec0           <-- trapping instruction
  32:   89 1c 24                mov    %ebx,(%esp)
  35:   89 74 24 04             mov    %esi,0x4(%esp)
  39:   74 12                   je     0x4d
  3b:   8b 1c 24                mov    (%esp),%ebx
  3e:   8b                      .byte 0x8b
  3f:   74                      .byte 0x74

which I can correlate to the dis_ucode_ldr test here:

        .loc 1 134 0
        .loc 1 137 0
        cmpb    $0, dis_ucode_ldr+1073741824    #, *_11
        je      .L46    #,


so we must be faulting when accessing that dis_ucode_ldr thing. But you
said that accessing it through its virtual address doesn't fix the issue
either. Which is very very strange...

Hmmm.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
