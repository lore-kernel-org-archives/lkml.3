Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648Ab3KKXbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 18:31:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:35026 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913Ab3KKXbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 18:31:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="407131469"
Message-ID: <528168CB.7070602@linux.intel.com>
Date: Mon, 11 Nov 2013 15:31:23 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Corrupted low memory in v3.9+
References: <CAOesGMgV2UsBffPveaE+j1s-mDZ+cQvvQGLGAXjWSAv+a_56Fw@mail.gmail.com> <52603CD6.6080507@linux.intel.com> <CAOesGMjgvPWpZssrepDszTr0EexHtDXznWA4XYoZ6O_U=XJGAg@mail.gmail.com> <CAOesGMgiUbJF01+BPBDgJT3J-Sn6ewE04aMyCTYrwjKwY4S2SQ@mail.gmail.com> <527BEA91.6050603@linux.intel.com> <20131111113503.GA16090@gmail.com>
In-Reply-To: <20131111113503.GA16090@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 03:35 AM, Ingo Molnar wrote:
> 
> If we reserve everything in low memory, all the time (which I very much 
> argue we should do) then the checker becomes a no-op and can be removed.
> 

Oops!  I had misunderstood how the checker worked -- I thought it
checked the *reserved* memory, but it in fact reserves memory
*independently* and then checks it.

The problem is fundamentally that setup_bios_corruption_check(); is
called too early in setup_arch() -- quite possibly due to other code
movement around it:

#ifdef CONFIG_X86_CHECK_BIOS_CORRUPTION
	setup_bios_corruption_check();
#endif

	reserve_real_mode();

	trim_platform_memory_ranges();
	trim_low_memory_range();

	init_mem_mapping();


setup_bios_corruption_check() should presumably be called between
trim_low_memory_range() and init_mem_mapping().  I'm actually surprised
that we don't trip on this *all the time* since the realmode trampoline
falls in this area...

At the same time, we should change the default for
CONFIG_X86_RESERVE_LOW to 640, and perhaps move it under EXPERT.

What do you guys think?

	-hpa

