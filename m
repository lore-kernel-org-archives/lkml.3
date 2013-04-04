Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012Ab3DDLSZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 07:18:25 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:38583 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757445Ab3DDLSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 07:18:23 -0400
Message-ID: <515D6170.1010708@hitachi.com>
Date: Thu, 04 Apr 2013 20:18:08 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Cc: Timo Juhani Lindfors <timo.lindfors@iki.fi>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Pavel Emelyanov <xemul@parallels.com>, Jiri Kosina <jkosina@suse.cz>,
        Ingo Molnar <mingo@kernel.org>,
        Nadia Yvette Chambers <nyc@holomorphy.com>,
        yrl.pp-manager.tt@hitachi.com, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip ] kprobes: Move __kprobes definition into compiler.h
References: <20130404104049.21071.20908.stgit@mhiramat-M0-7522>
In-Reply-To: <20130404104049.21071.20908.stgit@mhiramat-M0-7522>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

(2013/04/04 19:40), Masami Hiramatsu wrote:
> Currently, __kprobes is defined in linux/kprobes.h which
> is too big to be included in small or basic headers
> only for using this attribute.
> 
> This moves __kprobes definition into linux/compiler.h
> in which other compiler attributes are defined.

This is only moving __kprobes definition into compiler.h.
I think it will be needed for replacing __kprobes with noprobe.

And until now, I still could not reproduce the Timo's reported
issues. It seems those were happened on probing inline functions.
Thus, I think we'd better use __always_inline instead of
adding __kprobes (because those are not related to kprobes).
If those issues still be reproduced, we'd better put noprobe
on those functions.

By the way, those issues happened on native_* static inline functions
which are also pointed by pv_*_ops as function pointer. For example,
native_safe_halt is defined as an inline function in   asm/irqflags.h,
however it is directly pointed by pv_irq_ops in arch/x86/kernel/paravirt.c.
In this case __always_inline may cause a problem.

For these cases, I'd like to suggest to define those functions
which requires actual instance (because its address is used)
in paravirt.c and rename original one to __native_*. And rename
direct call of such native_* to __native_*.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


