Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbaGYDzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 23:55:33 -0400
Received: from mail.kernel.org ([198.145.19.201]:38217 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbaGYDzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 23:55:32 -0400
Date: Thu, 24 Jul 2014 20:55:28 -0700
From: Alexei Starovoitov <ast@kernel.org>
To: Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jakub Jelinek <jakub@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Debian GCC Maintainers <debian-gcc@lists.debian.org>,
        Debian Kernel Team <debian-kernel@lists.debian.org>
Subject: Re: Random panic in load_balance() with 3.16-rc
Message-ID: <20140725035527.GA30108@pg-vmw-gw1>
References: <CA+55aFzDWritxv5RiqwcZ1qCKJQKK-Lw6StYFF7qx5YWgiCUTQ@mail.gmail.com>
 <20140723182518.GD3935@laptop>
 <CA+55aFyFT9n5wUNifEHY6+t2bEcD91kL7+dqXuBMSMJvLeDDJQ@mail.gmail.com>
 <20140723184111.GG3935@laptop>
 <CA+55aFwQfwfAP6U77_nD_mSvoygj=cZ09N644hKRtzgLnEqhZQ@mail.gmail.com>
 <20140723190230.GH3935@laptop>
 <CA+55aFyM1wqTLK0m4GQJ28f=z0iZE87=xk+1z-vm+PH1_d8nKw@mail.gmail.com>
 <53D064C7.5050807@daenzer.net>
 <CA+55aFyJhqiPv0kQ+51=Ei-zaAO+0JszxtnEyx-Gbto3SE00xw@mail.gmail.com>
 <53D1B1EF.7030603@daenzer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53D1B1EF.7030603@daenzer.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 10:25:03AM +0900, Michel Dänzer wrote:
> [ Adding the Debian kernel and gcc teams to Cc ]
> 
> >         movq    $load_balance_mask, -136(%rbp)  #, %sfp
> >         subq    $184, %rsp      #,
> > 
> > Anyway, this is not a kernel bug. This is your compiler creating
> > completely broken code. We may need to add a warning to make sure
> > nobody compiles with gcc-4.9.0, and the Debian people should probably
> > downgrate their shiny new compiler.
> 
> Attached is fair.s from Debian gcc 4.8.3-5. Does that look better? I'm
> going to try reproducing the problem with a kernel built by that now.

4.8 and 4.7 don't hit the problem on this test.
4.9 with -O2 compiles this file ok. 4.9 with -Os triggers it.

-mno-red-zone only affected prologue emition in gcc. This part didn't
change between the releases. So the bug is quite deep.
What seems to be happening is that 2nd pass of instruction scheduler
(after emit prologue and reg alloc) is ignoring barrier properties
of 'subq $184, %rsp' and moving 'movq $.., -136(%rbp)' instruction
ahead of it. afaik rtl sched was never aware of 'red-zone'.
As an ex-compiler guy, I'm worried that this bug exists in earlier
releases. rtl backend guys need to take a serious look at it.
imo this is very serious bug, since broken red-zone is extremelly
hard to debug.
There are two weak test in gcc testsuite related to -mno-red-zone,
but not a single test that actually check that it is doing
the right thing. It is scary. I hope I'm wrong with this analysis.

