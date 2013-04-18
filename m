Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab3DRLUC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 07:20:02 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63746 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322Ab3DRLUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 07:20:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 08/32] dmaengine: ste_dma40: Optimise local MAX() macro
Date: Thu, 18 Apr 2013 13:19:49 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Lee Jones <lee.jones@linaro.org>, Rabin Vincent <rabin@rab.in>,
        linus.walleij@stericsson.com, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, Per Forlin <per.forlin@stericsson.com>,
        Dan Williams <djbw@fb.com>, linux-arm-kernel@lists.infradead.org
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org> <201304181246.03357.arnd@arndb.de> <20130418110024.GP14496@n2100.arm.linux.org.uk>
In-Reply-To: <20130418110024.GP14496@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304181319.49737.arnd@arndb.de>
X-Provags-ID: V02:K0:xZk3/73ubjZW8K8Y7UmNdxWwjesdtFw12L7V9W8uJHn
 p0zmibwBRmBFZJEaJ8F5gb4CSIvXaL7vA5WiSW1tTSv7PYRTs4
 CVO0jy4PAguhLG0eC9ug0kjn66V/0Cipn1SZ4PtzClzecTR/0b
 UuMKwsvOkWWZQq81d5UcmgG5/RvDpd1+DBFMWZH4OcHrYmGD+K
 ntzIUA2+rwRmD5NtJ0jjLvnSzQXi7qp92xXMTpe51fMr/TYz15
 fyg6lg2H2J5XKzOb9x/Oh6E8vngKC6TfN1brakXDUNaS82s4a+
 0y1AvsysZFGMBZOnXNdOKrgZ0fydvjJ4/1anLG55RsKwuRyLqp
 W0mE+SYxJEg/5HNVtW8E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 April 2013, Russell King - ARM Linux wrote:
> Never got the original patch...
> 
> A much better idea is to get rid of that buggy MAX() macro altogether
> and use the macros already provided by the kernel, which are safe from
> side effects - but more importantly are type _safe_.  The above goes
> wrong when you consider 'a' and 'b' may have different signed-ness.

Yes, that's what was suggested before.

> Consider:
> 
>         int val_in = -5;
>         unsigned val = MAX(val_in, 5U);
> 
> The resulting value is (unsigned)-5, not (unsigned)5.
> 
> Best use the kernel's max() or max_t() _everywhere_.

Unfortunately, the (only) use of this macro is in a structure declaration
where you cannot use the syntax of max():

struct d40_base {
	...
        u32    reg_val_backup_v4[MAX(BACKUP_REGS_SZ_V4A, BACKUP_REGS_SZ_V4B)];
	...
};

My preferred solution would be to remove the MAX macro here and
define a new constant

#define BACKUP_REGS_SZ ((BACKUP_REGS_SZ_V4A > BACKUP_REGS_SZ_V4B) ? \
			 BACKUP_REGS_SZ_V4A : BACKUP_REGS_SZ_V4B)

But I don't see it as much of an improvement over what is currently
there.

	Arnd
