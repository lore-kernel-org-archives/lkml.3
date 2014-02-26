Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbaBZUx0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 15:53:26 -0500
Received: from one.firstfloor.org ([193.170.194.197]:55618 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaBZUxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 15:53:24 -0500
Date: Wed, 26 Feb 2014 21:53:22 +0100
From: Andi Kleen <andi@firstfloor.org>
To: David Ahern <dsahern@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH v3 00/14] perf, x86: Haswell LBR call stack support
Message-ID: <20140226205322.GM22728@two.firstfloor.org>
References: <1392703661-15104-1-git-send-email-zheng.z.yan@intel.com>
 <530D53EF.9090706@amacapital.net>
 <CABPqkBSECV6iG4T60-OTZsV2CrCtV=awUSt7SGLTdkX9i8T90g@mail.gmail.com>
 <CALCETrWXDYsxXBWPqNS8cK69756DNj5sUyk-Fho2r_5_wh-=mg@mail.gmail.com>
 <20140226185513.GL22728@two.firstfloor.org>
 <CALCETrVQ8SBg+YLuPmDevL+f2dzBjLJucfMvVHaB04E8QJSGXw@mail.gmail.com>
 <530E3E47.8010205@gmail.com>
 <CALCETrUHiDqT+VRbdEnGsEkMFqQt+ZqX+RTenp1ets8XMhrQ2Q@mail.gmail.com>
 <530E4B42.5090401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530E4B42.5090401@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is there some reason not to enable frame pointers?

It makes code slower.

Especially on Atom CPUs, where it causes pipeline stalls, but
also to some degree on others, because you lose one register and
spend a little bit of time setting it up, so making small
functions more expensive.

Another issue is that you can't enable it on a lot of existing
libraries, sometimes not even with a recompile. For example
glibc assembler functions do not support it at all, which
is a very common case.

They are designed to use dwarf, but in practice dwarf
is very slow (perf has to save the stack for every sample)
and in practice doesn't always work (too small stack saving,
wrong annotations, out of date or broken dwarf library etc.) 

LBR callstack mode is not perfect either, and it has 
its own tradeoffs, but in many cases it seems to be a good
and more efficient replacement for dwarf, when FP is not available.

-Andi
