Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956AbbAHQv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 11:51:56 -0500
Received: from mga11.intel.com ([192.55.52.93]:37696 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756917AbbAHQvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 11:51:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,723,1413270000"; 
   d="scan'208";a="634419830"
Message-ID: <54AEB5A8.8020909@intel.com>
Date: Thu, 08 Jan 2015 08:51:52 -0800
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
CC: linux-man@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: Re: [PATCH] prctl.2: Add description of Intel MPX calls
References: <1418683928-28894-1-git-send-email-dave.hansen@intel.com> <54AE5B8A.4080607@gmail.com>
In-Reply-To: <54AE5B8A.4080607@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2015 02:27 AM, Michael Kerrisk (man-pages) wrote:
> Thanks for the patch. Quite a number of queries below. Could you
> address those and resubmit?

Absolutely, thanks for the detailed review!

I'll address most of your comments in the new patch.

>> +The application must have allocated virtual space for the bounds
>> +directory and placed its location in bndcfgu before enabling management.
> 
> s/bndcfgu/the bndcfgu register/
> 
> So, let me make sure I understood the previous sentence correctly.
> Is this a good formulation:
> 
>     Before enabling MPX management using PR_MPX_ENABLE_MANAGEMENT, 
>     the application must first have allocated a user-space buffer for
>     the bounds directory and placed the location of that directory in
>     the bndcfgu register.
> ?
> 
> If so, I think the patch could be reworded closer to that text, since
> it makes things a little clearer.

That looks good to me.

> By the way, what size should allocated for the buffer? And what can
> wrong if the allocated buffer is too small?

4MB on 32-bit and 2GB on 64-bit.

If the buffer is too small, the hardware might attempt to read a
non-allocated memory area (and SEGV).  The kernel would notice that the
buffer is too small probably during the first bounds fault touching the
unallocated area of the table.

>> +Once management is enabled, the bounds directory may not be moved.
> 
> A few things are not so clear to me, even after reading Jon's article
> and Documentation/x86/intel_mpx.txt. In particular, who has responsibility
> for populating the bounds directory, and what is its format? Is this 
> all invisible to the application? (Because I'm not quite clear on these
> points, I'm not sure if anything should be said in the man page.)

This is all best spelled out in the documentation available here:

	https://software.intel.com/en-us/intel-isa-extensions

The compiler generates code which loads the bounds values in to the
bounds registers.  There are special instructions that "spill" the
bounds registers in to the tables.

So, the instructions in the application do it, but it's transparent and
doesn't require any source modifications.

>>  .P
>>  The following options are available since Linux 3.5.
>>  .\" commit fe8c7f5cbf91124987106faa3bdf0c8b955c4cf7
> 
> Could you add some text to the patch to explain the ENXIO error?

Sure.

> What are the semantics of the MPX state with respect to the
> child of a fork(2)? (Probably, the man page needs to detail this.)

The tables are inherited just as any other memory contents are.  The
register contents are inherited just as any other register would be.

> What happens to the MPX state during an execve(2)? (Probably, 
> the man page needs to detail this.)

The tables go away at exec just like any other memory.  The BNDCFGU
register (the one holding the location of the tables) is zeroed.

> Is there a way to discover the current state (enabled/disabled)
> of MPX management? (It appears not, but I would like to confirm.)

There is not.  It's not something I really expect an app to want to turn
on and off or need to query.  It might not be a bad idea to expose it in
/proc somehow.

Also, FWIW, you could always attach with a debugger and check out the
BNDCFGU contents if you _practically_ wanted to check for MPX being
used.  It wouldn't tell you if bounds management is enabled, but it
would be a really good indicator.

> I see that the prctl() operations fail to check that unused arguments
> are zero. See my patch sent in a separate mail to LKML et al.

OK, fair enough.

