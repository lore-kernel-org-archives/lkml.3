Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbaFRP4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:56:09 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58523 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbaFRP4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:56:07 -0400
Message-ID: <53A1B693.2000609@wwwdotorg.org>
Date: Wed, 18 Jun 2014 09:56:03 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, hpa@linux.intel.com,
        akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>,
        Andrew Lunn <andrew@lunn.ch>, Michal Hocko <mhocko@suse.cz>,
        Petr Mladek <pmladek@suse.cz>, Joe Perches <joe@perches.com>,
        Arun KS <arunks.linux@gmail.com>, Kees Cook <keescook@chromium.org>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [RFT 1/2] printk: make dynamic kernel ring buffer alignemnt explicit
References: <1403090065-13879-1-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1403090065-13879-1-git-send-email-mcgrof@do-not-panic.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2014 05:14 AM, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
> We have to consider alignment for the ring buffer both for the
> default static size, and then also for when an dynamic allocation
> is made when the log_buf_len=n kernel parameter is passed to set
> the size specifically to a size larger than the default size set
> by the architecture through CONFIG_LOG_BUF_SHIFT.
> 
> The default static kernel ring buffer can be aligned properly if
> architectures set CONFIG_LOG_BUF_SHIFT properly, we provide ranges
> for the size though so even if CONFIG_LOG_BUF_SHIFT has a sensible
> aligned value it can be reduced to a non aligned value. Commit
> 6ebb017de9 by Andrew ensures the static buffer is always aligned
> and the decision of alignment is done by the compiler by using
> __alignof__(struct log) (curious what value caused the crash?).

IIRC the issue was that __log_buf's type is char[] so without the
__aligned it could have any alignment at all, e.g. 1 or 2. However,
struct printk_log is stored in the buffer rather than just char*, and so
if __log_buf isn't aligned to the required alignment for that structure,
that can caused unaligned accesses to fields in the structure, which
isn't supported on ARM in at least some cases.

As such, I think the change to setup_log_buf() in this patch makes sense
(although I suppose in practice memblock_virt_alloc() probably has some
minimum internal alignment that dwards LOG_ALIGN, but that's an
implementation detail we shouldn't rely on).
