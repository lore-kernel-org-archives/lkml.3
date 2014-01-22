Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748AbaAVN2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 08:28:09 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:44968 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755654AbaAVN2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 08:28:05 -0500
Date: Wed, 22 Jan 2014 13:27:34 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Wang Nan <wangnan0@huawei.com>
Cc: kexec@lists.infradead.org, Eric Biederman <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geng Hui <hui.geng@huawei.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/3] ARM: kexec: copying code to ioremapped area
Message-ID: <20140122132734.GB15937@n2100.arm.linux.org.uk>
References: <1390389916-8711-1-git-send-email-wangnan0@huawei.com> <1390389916-8711-3-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390389916-8711-3-git-send-email-wangnan0@huawei.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 07:25:15PM +0800, Wang Nan wrote:
> ARM's kdump is actually corrupted (at least for omap4460), mainly because of
> cache problem: flush_icache_range can't reliably ensure the copied data
> correctly goes into RAM.

Quite right too.  You're mistake here is thinking that flush_icache_range()
should push it to RAM.  That's incorrect.

flush_icache_range() is there to deal with such things as loadable modules
and self modifying code, where the MMU is not being turned off.  Hence, it
only flushes to the point of coherency between the I and D caches, and
any further levels of cache between that point and memory are not touched.
Why should it touch any more levels - it's not the function's purpose.

> After mmu turned off and jump to the trampoline, kexec always failed due
> to random undef instructions.

We already have code in the kernel which deals with shutting the MMU off.
An instance of how this can be done is illustrated in the soft_restart()
code path, and kexec already uses this.

One of the first things soft_restart() does is turn off the outer cache -
which OMAP4 does have, but this can only be done if there is a single CPU
running.  If there's multiple CPUs running, then the outer cache can't be
disabled, and that's the most likely cause of the problem you're seeing.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
