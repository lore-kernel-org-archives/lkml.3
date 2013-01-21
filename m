Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab3AUQVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 11:21:00 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:63570 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830Ab3AUQU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 11:20:59 -0500
MIME-Version: 1.0
In-Reply-To: <20130119044602.GC5391@phenom.dumpdata.com>
References: <CAKGA1b=ACTQHo9=B7EAG5nrFCO9u-J+sy7dXtYk3Rk6OUcW3cQ@mail.gmail.com>
 <20130118210859.GH23505@n2100.arm.linux.org.uk> <CAKGA1bmJ6c4LC=NAD4MU_rBZ2hZjf6qH=C+dqMCf0eP+2vSFdA@mail.gmail.com>
 <20130119044602.GC5391@phenom.dumpdata.com>
From: Matt Sealey <matt@genesi-usa.com>
Date: Mon, 21 Jan 2013 10:20:38 -0600
Message-ID: <CAKGA1b=whdh9=ke0efUXnJdT-op=7G1uVh82=3OxT5GoHhWvdA@mail.gmail.com>
Subject: Re: Compilation problem with drivers/staging/zsmalloc when !SMP on ARM
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        devel <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 10:46 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Fri, Jan 18, 2013 at 07:11:32PM -0600, Matt Sealey wrote:
>> On Fri, Jan 18, 2013 at 3:08 PM, Russell King - ARM Linux
>>
>> I'm gonna put this out to the maintainers (Konrad, and Seth since he
>> committed it) that if this code is buggy it gets taken back out, even
>> if it makes zsmalloc "slow" on ARM, for the following reasons:
>
> Just to make sure I understand, you mean don't use page table
> mapping but instead use copying?

Yes, just back out the USE_PGTABLE_MAPPING code. But as I just replied
with Minchan, maybe there is a better way.

The only real problem here apart from the non-per-cpu usage Russell
describes (which does not affect UP systems anyway) is that without
CONFIG_SMP we have a FTBFS.

However I am sure you agree on the odd fix of enabling pagetable
mapping optimization only on "high end" systems and leaving the low
end using the slow path. It *is* odd. Also, my rudimentary patch for
disabling the code on !CONFIG_SMP is just *hiding* a misuse of a
non-exported mm function...

The FTBFS showed the problem, I don't want the fix to be to hide it,
which is why I brought it up.

>> * It's buggy on SMP as Russell describes above
>> * It might not be buggy on UP (opposite to Russell's description above
>> as the restrictions he states do not exist), but that would imply an
>> export for a really core internal MM function nobody should be using
>> anyway
>> * By that assessment, using that core internal MM function on SMP is
>> also bad voodoo that zsmalloc should not be doing
>
>  'local_tlb_flush' is bad voodoo?

See previous mail to Minchan; local_tlb_flush_kernel_range calls
cpu_tlb.flush_kernel_range on SMP, but a direct function call
("glue(_TLB, flush_kernel_range)" which resolves to
v7wbi_flush_kernel_range etc. etc.) without CONFIG_SMP. That direct
function call it resolves to is not an export and Russell just said he
won't accept a patch to export it.

> If you have an ARM server that you would be willing to part with I would
> be thrilled to look at it.



>> diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c
>> b/drivers/staging/zsmalloc/zsmalloc-main.c
>> index 09a9d35..ecf75fb 100644
>         > --- a/drivers/staging/zsmalloc/zsmalloc-main.c
>> +++ b/drivers/staging/zsmalloc/zsmalloc-main.c
>> @@ -228,7 +228,7 @@ struct zs_pool {
>>   * mapping rather than copying
>>   * for object mapping.
>>  */
>> -#if defined(CONFIG_ARM)
>> +#if defined(CONFIG_ARM) && defined(CONFIG_SMP)
>>  #define USE_PGTABLE_MAPPING
>>  #endif
>>
>> .. such that it even compiles in both "guess" configurations, the
>> slower Cortex-A8 600MHz single core system gets to use the slow copy
>> path and the dual-core 1GHz+ Cortex-A9 (with twice the RAM..) gets to
>> use the fast mapping path. Essentially all the patch does is "improve
>> performance" on the fastest, best-configured, large-amounts-of-RAM,
>> lots-of-CPU-performance ARM systems (OMAP4+, Snapdragon, Exynos4+,
>> marvell armada, i.MX6..) while introducing the problems Russell
>> describes, and leave performance exactly the same and potentially far
>> more stable on the slower, memory-limited ARM machines.
>
> Any ideas on how to detect that?

Nope, sorry. It would rely on knowing the precise configuration *and*
the user intent of using zram which is far beyond the scope of zram or
zsmalloc itself. It could be a VM, a phone with only 256MB RAM and
slow storage, it could be a device with 2TB RAM but no fast local
storage.. whether using it as a compressed block device or a swap
device that is compressed, you can never know inside the driver what
the real use it except the kernel build time config.

All we can know in zram, at build time, is whether we're configuring
for SMP, UP-on-SMP, or UP (!SMP) and which code path makes more sense
to build (ideally, SMP and UP would run the pagetable mapping code
alike). If we can make the pagetable mapping code compile on UP
without the above patch being required, and it has the same effect,
then this would be the best solution. Then the code needs to be fixed
for proper operation on SMP anyway.

If there are still a bunch of export problems with an alternate method
of flushing the tlb for a range of kernel memory exposed by trying a
different way around, this is just proving an issue here that the ARM
guys disagree that things that can be built as modules should be doing
such things, or that the cpu_tlb.flush_kernel_range vs.
v7wbi_tlb_flush_kernel_range export thing is confusing as crap at the
very least in that the CPU topology model the kernel lives by and is
compiled for at build time causes build breakages if you don't want
(or have) your driver to be knowledgable of the differences :)

>> can build for SMP and UP and get the same code.. with less bugs.
>
> I get that you want to have this fixed right now.

Somewhat. It is not urgent, since I fixed it "for now" in my tree, I
am just worried that if that "fix" goes upstream it hides a real, more
important issue here.

I am mostly only concerned about whether zram as swap in any
configuration causes any issues with performance on my system, as I
would *like* to use it. We have noticed in the past (when it was
compcache, and zram before the xsmalloc ->zsmalloc/zcache2 rewrite)
that it did make a difference. Given the changes I just wanted to be
sure. We have some acceptably performing storage but limited RAM, so
there has to be a happy medium between reserving an in-memory
compressed block device and an amount of real disk swap in the back,
for use cases such as webservers with high number of connections, web
browsers with high numbers of tabs, media playback and suchlike.
Compression obviously takes CPU time, but swapping to disk blocks, so
keeping the system feeling smooth from a UX point of view while
allowing them to do a tiny bit more is what we're looking for. As I
said, we saw great benefits a couple years ago, a year ago, I just
wanted to pull some benchmarks from a current kernel. I was not under
the impression, though, that this code would FTBFS on my preferred
kernel configuration :D

> fixed the right way is a better choice. Lets discuss that first
> before we start tossing patches to disable parts of it.

Agreed.

-- 
Matt Sealey <matt@genesi-usa.com>
Product Development Analyst, Genesi USA, Inc.
