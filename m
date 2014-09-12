Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbaILXPf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 19:15:35 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:53562 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751931AbaILXPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 19:15:33 -0400
Date: Sat, 13 Sep 2014 00:15:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tony Lindgren <tony@atomide.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <robherring2@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Olof Johansson <olof@lixom.net>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 2/2] pstore-ram: Allow optional mapping with
	pgprot_noncached
Message-ID: <20140912231514.GB12379@n2100.arm.linux.org.uk>
References: <1410546745-919-1-git-send-email-tony@atomide.com> <1410546745-919-2-git-send-email-tony@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410546745-919-2-git-send-email-tony@atomide.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 11:32:25AM -0700, Tony Lindgren wrote:
> On some ARMs at least the memory can be mapped pgprot_noncached()
> and still be working for atomic operations. As pointed out by
> Colin Cross <ccross@android.com>, in some cases you do want to use
> pgprot_noncached() if the SoC supports it to see a debug printk
> just before a write hanging the system.
> 
> On ARMs, the atomic operations on strongly ordered memory are
> implementation defined. So let's provide an optional kernel parameter
> for configuring noncached memory, and use pgprot_writecombine() by
> default.

Can we clean up this terminology please?

Writecombine memory is not cached - write combine memory bypasses the
caches entirely.  What it doesn't bypass are store buffers, which may
combine two writes together.  So, calling it "cached" is misleading.

Secondly, memory returned by ioremap() is not strongly ordered, it is
device memory.  There's three main classifications of memory on ARM:
strongly ordered, device and normal memory.  Normal memory has attributes
which define whether it is write combining, or cacheable in some way (and
if so, how it's cacheable.)

Exclusives are always permitted to normal memory.  The other two are
implementation defined.  While an implementation may offer it on
strongly ordered, that doesn't mean that it also supports it on device
memory.

Lastly, aliased mappings are something that ARM has always strongly
discouraged on ARMv6+ (it was plain down-right unpredictable, but it's
now "strongly discouraged") and remapping memory with different memory
type should be avoided.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
