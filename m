Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885AbbAISrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 13:47:18 -0500
Received: from www.sr71.net ([198.145.64.142]:38122 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbbAISrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 13:47:16 -0500
Message-ID: <54B02232.1030609@sr71.net>
Date: Fri, 09 Jan 2015 10:47:14 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, x86@kernel.org,
        dave.hansen@linux.intel.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] x86 mpx: fix potential performance issue on unmaps
References: <20141222200803.D316DA2A@viggo.jf.intel.com> <20141222200805.13639956@viggo.jf.intel.com> <20141223091440.GA9112@gmail.com>
In-Reply-To: <20141223091440.GA9112@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2014 01:14 AM, Ingo Molnar wrote:
>> >  {
>> > -	mpx_notify_unmap(mm, vma, start, end);
>> > +	/*
>> > +	 * mpx_notify_unmap() goes and reads a rarely-hot
>> > +	 * cacheline in the mm_struct.  That can be expensive
>> > +	 * enough to be seen in profiles.
>> > +	 *
>> > +	 * The mpx_notify_unmap() call and its contents have been
>> > +	 * observed to affect munmap() performance on hardware
>> > +	 * where MPX is not present.
>> > +	 *
>> > +	 * The unlikely() optimizes for the fast case: no MPX
>> > +	 * in the CPU, or no MPX use in the process.  Even if
>> > +	 * we get this wrong (in the unlikely event that MPX
>> > +	 * is widely enabled on some system) the overhead of
>> > +	 * MPX itself (reading bounds tables) is expected to
>> > +	 * overwhelm the overhead of getting this unlikely()
>> > +	 * consistently wrong.
>> > +	 */
>> > +	if (unlikely(cpu_feature_enabled(X86_FEATURE_MPX)))
>> > +		mpx_notify_unmap(mm, vma, start, end);
>> >  }
> Hm, so this patch still does not help people who have an MPX 
> capable CPU but don't have (or don't have many) MPX using apps. 
> What about them?

Sorry for the delayed resposne.

The performance regression, as far as I could tell, was the result of a
consistent branch misprediction near the read of mm->bd_addr.  I believe
the CPU was able to better predict cpu_feature_enabled() than the
contents of mm->bd_addr.

In running this on a CPU which actually contains MPX, I wasn't able to
see the same regression.  The same branch was getting predicted correctly.

I also have a patch to add a global, boot-time MPX disable.  It will
clear out the X86_FEATURE_MPX at __setup time.  While not optimal, this
would at least let someone who did not have any MPX apps avoid any
potential issues.  I was planning on submitting that patch for 3.20.

