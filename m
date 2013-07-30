Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab3G3OVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 10:21:44 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:40820 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab3G3OVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 10:21:42 -0400
MIME-Version: 1.0
In-Reply-To: <CABPqkBRX-A5i26w1aMBmjb7GVmYUBS6k03ePN6qoASS9Z9xkmg@mail.gmail.com>
References: <20130625104700.GZ28407@twins.programming.kicks-ass.net>
	<20130625105123.GA13649@gmail.com>
	<20130626103303.GB28407@twins.programming.kicks-ass.net>
	<CABPqkBTETCE7unsE=zvcC5n865ZN-QTW5Y0j-meTO9x-8=BJog@mail.gmail.com>
	<20130628095828.GG29209@dyad.programming.kicks-ass.net>
	<CABPqkBSfkg+rPw4A=n8wmPg=iwn1Qf8PdYA4ycxxooOv3GrvmA@mail.gmail.com>
	<20130708081919.GV23916@twins.programming.kicks-ass.net>
	<CABPqkBSesQsfeutY2qu1n3uMka0dOFOT2tzqCWYGV=2p6F8Y9w@mail.gmail.com>
	<20130730083758.GH3008@twins.programming.kicks-ass.net>
	<CABPqkBTxovrj11sskW50TZzf6e_V0tObT-qDPAbxHcrpLJNNZg@mail.gmail.com>
	<20130730090202.GL3008@twins.programming.kicks-ass.net>
	<CABPqkBRX-A5i26w1aMBmjb7GVmYUBS6k03ePN6qoASS9Z9xkmg@mail.gmail.com>
Date: Tue, 30 Jul 2013 16:21:41 +0200
Message-ID: <CABPqkBQeNEidngxK08O-eAA4aJhqe8R-F-8Vk8DA-Z1qtKdU_Q@mail.gmail.com>
Subject: Re: [PATCH 0/8] perf: add ability to sample physical data addresses
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

One thing that bothers me with the MMAP2 approach is that
it forces integration into perf. Now, you will need to analyze
the MMAP2 records. With my sample_type approach, you
simply needed a cmdline option on perf record, and then
you could dump the sample using perf report -D and feed
them into a post-processing script. But now, the analysis
needs to be integrated into perf or the tool needs to parse
the full perf.data file.


On Tue, Jul 30, 2013 at 3:09 PM, Stephane Eranian <eranian@google.com> wrote:
> On Tue, Jul 30, 2013 at 11:02 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Tue, Jul 30, 2013 at 10:51:46AM +0200, Stephane Eranian wrote:
>>> On Tue, Jul 30, 2013 at 10:37 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>>> > On Tue, Jul 30, 2013 at 10:02:01AM +0200, Stephane Eranian wrote:
>>> >> > Ahh. We don't put the useful bits in the mmap event; we'll need to fix
>>> >> > that too then ;-)
>>> >> >
>>> >> > Doing so is going to be a bit of a bother since we use the tail of
>>> >> > PERF_RECORD_MMAP for filenames and thus aren't particularly extensible.
>>> >> >
>>> >> > This would mean doing something like PERF_RECORD_MMAP2 and some means
>>> >> > for userspace to requrest the new events instead of the old one.
>>> >> >
>>> >> Tracking mmaps even for shmat() won't cover the paging cases. When you page a
>>> >> page back in, it most likely gets a different physical page. How would
>>> >> we track that
>>> >> case too using the same approach?
>>> >
>>> > It doesn't matter. Even if a page ends up being a different physical
>>> > page, it will always be the same sb:inode:pgoffset. You should be able
>>> > to always uniquely identify a (shared) page by that triplet.
>>> >
>>> Ok, so you're saying that triplet uniquely identifies a virtual page
>>> regardless of
>>> the physical page it is mapped onto. If the physical page changes because
>>> of paging, we keep the same triplet and therefore we can still detect the false
>>> sharing.
>>
>> Exactly.
>>
> I see this for my program:
>
> 7f0a59cbe000-7f0a59cc1000 rw-p 00000000 00:00 0
> 7f0a59cd3000-7f0a59cd4000 rw-p 00000000 00:00 0
> 7f0a59cd4000-7f0a59cd5000 rw-s 00000000 00:04 458753
>   /SYSV00000000 (deleted)
> 7f0a59cd5000-7f0a59cd6000 rw-s 00000000 00:04 425984
>   /SYSV00000000 (deleted)
> 7f0a59cd6000-7f0a59cd7000 rw-s 00000000 00:04 425984
>   /SYSV00000000 (deleted)
>
> The first 2 lines are heap. There is nothing useful coming out of maj:min ino.
> However for shared segment we can use the ino number. Shared memory segment
> appear as file in the vma therefore, the kernel does use the ino, maj,
> min number.
> And in my program I map the same segment twice, and we see the last two mappings
> are identical.
>
> But in the case of regular paging, there is no useful info there. But
> thenI suspect for a private
> heap page we only care about multi-threaded and there the physical
> page is irrelevant.
> So it seems all we care about is to cover the shared segment case and
> we can get the
> info from the vma and creates a MMAP2 record for it.
>
> Do we agree?
>
>
>>> > So if we create a net MMAP record that includes the device (substitute
>>> > for the superblock) and inode information we should be good.
>>>
>>> I will try that. I am not familiar with mm, so where do we find the
>>> device? Inside
>>> the vma?
>>
>> Take a peek at fs/proc/task_mmu.c:show_map_vma(), its the code used to
>> print /proc/$PID/maps and displays all stuff we want.
>
> That is what I see in that function:
>
>        if (file) {
>                 struct inode *inode = file_inode(vma->vm_file);
>                 dev = inode->i_sb->s_dev;
>                 ino = inode->i_ino;
>                 pgoff = ((loff_t)vma->vm_pgoff) << PAGE_SHIFT;
>         }
>
> It works for anything associated with a file.
