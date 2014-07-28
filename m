Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaG1UkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 16:40:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708AbaG1UkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 16:40:17 -0400
Date: Mon, 28 Jul 2014 17:39:55 -0300
From: Eduardo Habkost <ehabkost@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: virtualization@lists.linux-foundation.org,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Chris Wright <chrisw@sous-sol.org>, Alok Kataria <akataria@vmware.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, paravirt: BUG_ON on {rd,wr}msr exceptions
Message-ID: <20140728203955.GA4611@thinpad.lan.raisama.net>
References: <1406574278-23946-1-git-send-email-ehabkost@redhat.com>
 <53D6A1F2.5070404@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D6A1F2.5070404@zytor.com>
X-Fnord: you can see the fnord
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 12:18:10PM -0700, H. Peter Anvin wrote:
> On 07/28/2014 12:04 PM, Eduardo Habkost wrote:
> > When CONFIG_PARAVIRT is enabled, the kernel is ignoring exceptions on
> > the {rd,wr}msr instructions. This makes serious issues (either on the
> > guest kernel, or on the host) be silently ignored, and is different from
> > the native MSR code (which does not ignore the exceptions).
> > 
> > As paravirt.h already includes linux/bug.h, I don't see what was the
> > original issue preventing BUG_ON from being used.
> > 
> > Change rdmsr(), wrmsr(), and rdmsrl() to BUG_ON() on errors.
> 
> How much does this bloat the kernel?

It seems to add 8 bytes to each {wr,rd}msr() call (4 extra instructions:
test, jmp, ud2, jmp).

allyesconfig, paravirt enabled, before:

  text    data     bss     dec     hex filename
108368312       23500872        55705600        187574784       b2e2a00 vmlinux

allyesconfig, paravirt enabled, after:

   text    data     bss     dec     hex filename
108384438       23500904        55717888        187603230       b2e991e vmlinux

allyesconfig vmlinux is 28446 bytes larger.

An alternative is to add read_msr_unsafe() & write_msr_unsafe() fields
to pv_cpu_ops, pointing to native_read_msr() & native_write_msr().

-- 
Eduardo
