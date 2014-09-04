Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbaIDULh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 16:11:37 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56330 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755210AbaIDULg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 16:11:36 -0400
X-Sasl-enc: xdeHoSPDlQxACp8TGUe5y6cP1WLHB30gdok5lINHsUVP 1409861495
Date: Thu, 4 Sep 2014 17:11:23 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Toshi Kani <toshi.kani@hp.com>
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
        akpm@linuxfoundation.org, arnd@arndb.de, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, jgross@suse.com,
        stefan.bader@canonical.com, luto@amacapital.net,
        konrad.wilk@oracle.com
Subject: Re: [PATCH 1/5] x86, mm, pat: Set WT to PA4 slot of PAT MSR
Message-ID: <20140904201123.GA9116@khazad-dum.debian.net>
References: <1409855739-8985-1-git-send-email-toshi.kani@hp.com>
 <1409855739-8985-2-git-send-email-toshi.kani@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409855739-8985-2-git-send-email-toshi.kani@hp.com>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Sep 2014, Toshi Kani wrote:
> This patch sets WT to the PA4 slot in the PAT MSR when the processor
> is not affected by the PAT errata.  The upper 4 slots of the PAT MSR
> are continued to be unused on the following Intel processors.
> 
>   errata           cpuid
>   --------------------------------------
>   Pentium 2, A52   family 0x6, model 0x5
>   Pentium 3, E27   family 0x6, model 0x7
>   Pentium M, Y26   family 0x6, model 0x9
>   Pentium 4, N46   family 0xf, model 0x0
> 
> For these affected processors, _PAGE_CACHE_MODE_WT is redirected to UC-
> per the default setup in __cachemode2pte_tbl[].

There are at least two PAT errata.  The blacklist is in
arch/x86/kernel/cpu/intel.c:

        if (c->x86 == 6 && c->x86_model < 15)
                clear_cpu_cap(c, X86_FEATURE_PAT);

It covers model 13, which is not in your blacklist.

It *is* possible that PAT would work on model 13, as I don't think it has
any PAT errata listed and it was blacklisted "just in case" (from memory. I
did not re-check), but this is untested, and unwise to enable on an aging
platform.

I am worried of uncharted territory, here.  I'd actually advocate for not
enabling the upper four PAT entries on IA-32 at all, unless Windows 9X / XP
is using them as well.  Is this a real concern, or am I being overly
cautious?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
