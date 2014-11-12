Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbaKLT3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 14:29:36 -0500
Received: from rrcs-76-79-27-186.west.biz.rr.com ([76.79.27.186]:12115 "EHLO
	rrcs-76-79-27-186.west.biz.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753151AbaKLT3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 14:29:35 -0500
Date: Wed, 12 Nov 2014 13:29:29 -0600
From: Jeff Epler <jepler@unpythonic.net>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: cmetcalf@tilera.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: tile: kernel: kgdb.c: Use memcpy() instead of
 pointer copy one by one
Message-ID: <20141112192929.GC53560@unpythonic.net>
References: <5454DD70.6060004@gmail.com>
 <5462C1D3.3010504@gmail.com>
 <20141112132741.GA53560@unpythonic.net>
 <5463800C.8050404@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5463800C.8050404@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 11:43:08PM +0800, Chen Gang wrote:
> >                                                       (I assume the
> > compiler could do things like replace an intended load from memory with
> > a constant load or even no load at all)
> > 
> 
> Excuse me, my English is not quite well, I can not understand what you
> said above. (If necessary, please help provide more details for it).

I am concerned that writing regs[TREG_TP] is "undefined behavior"
according to the C standard.

This expression is equivalent to *(regs + TREG_TP).  The expression
(regs + TREG_TP) does not result in a pointer to any element of regs[],
so dereferencing it is undefined behavior.  (Source: C99 draft standard
WG14/N1256, annex J.2, "[The behavior is undefined if t]he operand of
the unary * operator has an invalid value")

That is why the compiler showed the original diagnostic, but the same
logic that made the loop's behavior undefined also makes the expression
regs[TREG_TP] undefined whereever it appears.

None of this is a specific problem with your proposed patch.  Rather, it
is a suggestion that the whole structure's design needs to be revisited
in light of compilers beginning to notice that regs[TREG_TP] is
undefined behavior and change their generated code as a result.

Unfortunately it looks like this header is also a part of the userspace
API, so it can't simply be changed just in case all in-kernel uses are
changed.

Jeff
