Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbaF2ToJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 15:44:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51265 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbaF2ToI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 15:44:08 -0400
Date: Sun, 29 Jun 2014 21:44:04 +0200
From: Borislav Petkov <bp@alien8.de>
To: Nick Warne <nick@linicks.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.15.2 build error on AMD64
Message-ID: <20140629194403.GB12943@pd.tnic>
References: <53AE9058.50902@linicks.net>
 <20140628101240.GA6357@pd.tnic>
 <53AE9863.6050102@linicks.net>
 <53AE9F0B.1080207@linicks.net>
 <20140628122322.GC4373@pd.tnic>
 <53AEBE75.9070301@linicks.net>
 <53B063BC.4040200@linicks.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53B063BC.4040200@linicks.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2014 at 08:06:36PM +0100, Nick Warne wrote:
> OK, I just spent three months building GCC 4.7.4 today (thank god the
> world cup is on to watch instead)

Yep, the world cup helps a lot with tedious debugging work. :-)

> and 3.15.2 built fine, and server is up and
> running great.
> 
> This then is an old(er) version of GCC issue (but I dunno what).

Right, so the error points at 

__spin_lock_mb_cache_entry(struct mb_cache_entry *ce)
{
 spin_lock(bgl_lock_ptr(mb_cache_bg_lock,			<---
  (hash_64((unsigned long)ce, __builtin_log2(8)))));
}

somewhere here and I'd guess that old gcc is issuing some lib function
which uses SSE. And after we disabled all FPU stuff in the kernel with
b399fe355b30 ("x86: Disable generation of traditional x87 instructions")
that would issue such an error.

And I was about to point at that __builtin_log2 thing which looked
suspicious and found this by chance:

http://lkml.kernel.org/r/1401471304-37479-1-git-send-email-tmac@hp.com

You could test this patch with that old gcc 4.2.x as it looks like a
good candidate for a fix for your issue.

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
-- 
