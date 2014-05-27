Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbaE0Rsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 13:48:41 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:43450 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaE0Rsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 13:48:39 -0400
MIME-Version: 1.0
In-Reply-To: <1401197235-13440-3-git-send-email-bp@alien8.de>
References: <1401197235-13440-1-git-send-email-bp@alien8.de>
	<1401197235-13440-3-git-send-email-bp@alien8.de>
Date: Tue, 27 May 2014 10:48:38 -0700
Message-ID: <CA+8MBbKyHfwK7v9nmFNm0TLvpjbEpDbWemk4C8tE7mkZedE3ag@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] MCE, CE: Wire in the CE collector
From: Tony Luck <tony.luck@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-edac <linux-edac@vger.kernel.org>, X86 ML <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +       } else if (c->x86_vendor == X86_VENDOR_INTEL)
> +               return m->status & BIT(7);

Intel compound error codes aren't quite that simple.  You need to look
at the low 16 bits of "status" (the MCACOD) field and see which is the
most significant bit set (ignoring bit 12, the "filter" bit).  If the answer is
bit 7 - then this is a memory error. But you can't just blindly check bit
7 because if bit 8 is set, then this is a cache error, and if bit 11 is set,
then it is a bus/interconnect error - and either way bit 7 just gives more
detail on what cache/bus/interconnect error happened.  In hex the test
you want is:

                  return (m->status & 0xef80) == BIT(7);

[compound error codes make my head hurt too]

>                 if (!(flags & MCP_TIMESTAMP))
>                         m.tsc = 0;
> -               /*
> -                * Don't get the IP here because it's unlikely to
> -                * have anything to do with the actual error location.
> -                */
> -               if (!(flags & MCP_DONTLOG) && !mca_cfg.dont_log_ce)
> -                       mce_log(&m);
> +
> +               __log_ce(&m, flags);

I'm not happy with the total removal of mce_log() here.  Skipping
it and doing *some* filtering in the kernel is OK (goal of this patch
set). But you just cut EDAC and/or EXTLOG out of the reporting path
completely.  If the corrected error count for a page gets too high, your
new code will try to take the page offline ... but we won't have a report
from EDAC/EXTLOG telling us which DIMM that page belonged to.

Perhaps __log_ce() needs a return value to say whether it took action
and then:

                 if (__log_ce(&m, flags) && all-those-other-tests)
                             mce_log(&m);

-Tony
