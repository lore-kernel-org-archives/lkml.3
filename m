Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbaHXUlB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 16:41:01 -0400
Received: from www.sr71.net ([198.145.64.142]:38175 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144AbaHXUlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 16:41:00 -0400
Message-ID: <53FA4DDA.8020106@sr71.net>
Date: Sun, 24 Aug 2014 13:40:58 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: linux-kernel@vger.kernel.org, dave.hansen@linux.intel.com,
        peterz@infradead.org, mingo@redhat.com, ak@linux.intel.com,
        tim.c.chen@linux.intel.com, akpm@linux-foundation.org, cl@linux.com,
        penberg@kernel.org, linux-mm@kvack.org, kirill@shutemov.name,
        lauraa@codeaurora.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] [v3] warn on performance-impacting configs aka. TAINT_PERFORMANCE
References: <20140821202424.7ED66A50@viggo.jf.intel.com> <20140822072023.GA7218@gmail.com> <53F75B91.2040100@sr71.net> <20140824144946.GC9455@gmail.com>
In-Reply-To: <20140824144946.GC9455@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2014 07:49 AM, Ingo Molnar wrote:
>>>> > >> +	buf_left = buf_len;
>>>> > >> +	for (i = 0; i < ARRAY_SIZE(perfomance_killing_configs); i++) {
>>>> > >> +		buf_written += snprintf(buf + buf_written, buf_left,
>>>> > >> +					"%s%s\n", config_prefix,
>>>> > >> +					perfomance_killing_configs[i]);
>>>> > >> +		buf_left = buf_len - buf_written;
...
>>> > > Also, do you want to check buf_left and break out early from 
>>> > > the loop if it goes non-positive?
>> > 
>> > You're slowly inflating my patch for no practical gain. :)
> AFAICS it's a potential memory corruption and security bug, 
> should the array ever grow large enough to overflow the passed
> in buffer size.

Let's say there is 1 "buf_left" and I attempt a 100-byte snprintf().
Won't snprintf() return 1, and buf_written will then equal buf_len?
buf_left=0 at that point, and will get passed in to the next snprintf()
as the buffer length.  I'm expecting snprintf() to just return 0 when it
gets a 0 for its 'size'.

Exhausting the buffer will, at worst, mean a bunch of useless calls to
snprintf() that do nothing, but I don't think it will run over the end
of the buffer.

Or am I missing something?
