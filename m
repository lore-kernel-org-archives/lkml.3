Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbaEVJuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 05:50:24 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:43810 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700AbaEVJuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 05:50:23 -0400
MIME-Version: 1.0
In-Reply-To: <20140521193336.5df90456.akpm@linux-foundation.org>
References: <1400639194-3743-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<20140521154250.95bc3520ad8d192d95efe39b@linux-foundation.org>
	<537d5ee4.4914e00a.5672.ffff85d5SMTPIN_ADDED_BROKEN@mx.google.com>
	<20140521193336.5df90456.akpm@linux-foundation.org>
Date: Thu, 22 May 2014 13:50:22 +0400
Message-ID: <CALYGNiMeDtiaA6gfbEYcXbwkuFvTRCLC9KmMOPtopAgGg5b6AA@mail.gmail.com>
Subject: Re: [PATCH 0/4] pagecache scanning with /proc/kpagecache
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@openvz.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 6:33 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 21 May 2014 22:19:55 -0400 Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:
>
>> > A much nicer interface would be for us to (finally!) implement
>> > fincore(), perhaps with an enhanced per-present-page payload which
>> > presents the info which you need (although we don't actually know what
>> > that info is!).
>>
>> page/pfn of each page slot and its page cache tag as shown in patch 4/4.
>>
>> > This would require open() - it appears to be a requirement that the
>> > caller not open the file, but no reason was given for this.
>> >
>> > Requiring open() would address some of the obvious security concerns,
>> > but it will still be possible for processes to poke around and get some
>> > understanding of the behaviour of other processes.  Careful attention
>> > should be paid to this aspect of any such patchset.
>>
>> Sorry if I missed your point, but this interface defines fixed mapping
>> between file position in /proc/kpagecache and in-file page offset of
>> the target file. So we do not need to use seq_file mechanism, that's
>> why open() is not defined and default one is used.
>> The same thing is true for /proc/{kpagecount,kpageflags}, from which
>> I copied/pasted some basic code.
>
> I think you did miss my point ;) Please do a web search for fincore -
> it's a syscall similar to mincore(), only it queries pagecache:
> fincore(int fd, loff_t offset, ...).  In its simplest form it queries
> just for present/absent, but we could increase the query payload to
> incorporate additional per-page info.
>
> It would take a lot of thought and discussion to nail down the
> fincore() interface (we've already tried a couple of times).  But
> unfortunately, fincore() is probably going to be implemented one day
> and it will (or at least could) make /proc/kpagecache obsolete.
>

It seems fincore() also might obsolete /proc/kpageflags and /proc/pid/pagemap.
because it might be implemented for /dev/mem and /proc/pid/mem as well
as for normal files.

Something like this:
int fincore(int fd, u64 *kpf, u64 *pfn, size_t length, off_t offset)

It reports PFN and page-flags in KPF_* notation. PFN array is optional.
KFP_NOPAGE reports hole, otherwise this is present page, but probably
not-uptodate.
KFP_SOFTDIRTY already here.


Also we need new flag KFP_SWAPENTRY for vm/shmem to report swap-entry
instead of pfn.
Probably this is redundant, we cannot report pfn and swap-entry
togerher if page present and in swap-cache.
