Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbaI2PAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 11:00:22 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:52856 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaI2PAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 11:00:19 -0400
Date: Mon, 29 Sep 2014 16:00:09 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [GIT PULL] EFI changes for v3.18
Message-ID: <20140929150009.GA9102@console-pimps.org>
References: <20140928202702.GB18635@console-pimps.org>
 <20140929124321.GB18825@gmail.com>
 <20140929140516.GL5430@worktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140929140516.GL5430@worktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep, at 04:05:16PM, Peter Zijlstra wrote:
> 
> OMFG what a trainwreck... if they are reentrant like that, a lock isn't
> going to help you in any way. The implementation of these calls must be
> lockfree otherwise they cannot possibly be correct.
 
The only way these services are going to be called is if we (the OS)
invoke them. These NMI shenanigans we're playing in the locking
functions are actually for our benefit, not the firmware's.

> Conditional locking like above is just plain broken, disgusting doesn't
> even begin to cover it. Full NAK on this. If this is required by the EFI
> spec someone needs to pull their head from their arse and smell the real
> world.

The conditional locking isn't intended to conform to the spec, it's
intended to write a pstore object to the EFI variable NVRAM with our
last dying breath, even if someone was in the middle of a SetVariable()
call. All the spec says is that, if we're in a non-recoverable state,
it's OK to do that. Whether that'll be implemented correctly across a
range of firmware implementations is another matter.

In fact, maybe we shouldn't support that lockless access at all. I've no
huge problem changing the code in efi_pstore_write() to bail if we can't
grab the lock, so that we can be serialized all of the time.

That would certainly make the runtime lock code much simpler.

-- 
Matt Fleming, Intel Open Source Technology Center
