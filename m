Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbbAPNat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 08:30:49 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:40143 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbbAPNa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 08:30:28 -0500
Message-ID: <54B91271.3000600@gmail.com>
Date: Fri, 16 Jan 2015 14:30:25 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: mtk.manpages@gmail.com, lkml <linux-kernel@vger.kernel.org>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        kexec@lists.infradead.org, Andy Lutomirski <luto@amacapital.net>,
        Dave Young <dyoung@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: Edited kexec_load(2) [kexec_file_load()] man page for review
References: <545FBDDD.9060801@gmail.com> <20141111213037.GA31445@redhat.com> <54ADA284.30502@gmail.com> <20150112221634.GD16162@redhat.com>
In-Reply-To: <20150112221634.GD16162@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek,

Thanks for your comments! I've added some further text to
the page based on those comments. See some follow-up 
questions below.

On 01/12/2015 11:16 PM, Vivek Goyal wrote:
> On Wed, Jan 07, 2015 at 10:17:56PM +0100, Michael Kerrisk (man-pages) wrote:
> 
> [..]
>>>> .BR KEXEC_ON_CRASH " (since Linux 2.6.13)"
>>>> Execute the new kernel automatically on a system crash.
>>>> .\" FIXME Explain in more detail how KEXEC_ON_CRASH is actually used
>>
>> I wasn't expecting that you would respond to the FIXMEs that were 
>> not labeled "kexec_file_load", but I was hoping you might ;-). Thanks!
>> I have a few additional questions to your nice notes.
>>
>>> Upon boot first kernel reserves a chunk of contiguous memory (if
>>> crashkernel=<> command line paramter is passed). This memory is
>>> is used to load the crash kernel (Kernel which will be booted into
>>> if first kernel crashes).
>>
> 
> Hi Michael,
> 
>> Can I just confirm: is it in all cases only possible to use kexec_load() 
>> and kexec_file_load() if the kernel was booted with the 'crashkernel'
>> parameter set?
> 
> As of now, only kexec_load() and kexec_file_load() system calls can
> make use of memory reserved by crashkernel=<> kernel parameter. And
> this is used only if we are trying to load a crash kernel (KEXEC_ON_CRASH
> flag specified).

Okay.

>>> Location of this reserved memory is exported to user space through
>>> /proc/iomem file. 
>>
>> Is that export via an entry labeled "Crash kernel" in the 
>> /proc/iomem file?
> 
> Yes.

Okay -- thanks.

>>> User space can parse it and prepare list of segments
>>> specifying this reserved memory as destination.
>>
>> I'm not quite clear on "specifying this reserved memory as destination".
>> Is that done by specifying the address in the kexec_segment.mem fields?
> 
> You are absolutely right. User space can specify in kexec_segment.mem
> field the memory location where it expecting a particular segment to
> be loaded by kernel.
> 
>>
>>> Once kernel sees the flag KEXEC_ON_CRASH, it makes sure that all the
>>> segments are destined for reserved memory otherwise kernel load operation
>>> fails.
>>
>> Could you point me to where this checking is done? Also, what is the
>> error (errno) that occurs when the load operation fails? (I think the
>> answers to these questions are "at the start of kimage_alloc_init()"
>> and "EADDRNOTAVAIL", but I'd like to confirm.)
> 
> This checking happens in sanity_check_segment_list() which is called
> by kimage_alloc_init().
> 
> And yes, error code returned is -EADDRNOTAVAIL.

Thanks. I added EADDRNOTAVAIL to the ERRORS.

>>> [..]
>>>> struct kexec_segment {
>>>>     void   *buf;        /* Buffer in user space */
>>>>     size_t  bufsz;      /* Buffer length in user space */
>>>>     void   *mem;        /* Physical address of kernel */
>>>>     size_t  memsz;      /* Physical address length */
>>>> };
>>>> .fi
>>>> .in
>>>> .PP
>>>> .\" FIXME Explain the details of how the kernel image defined by segments
>>>> .\" is copied from the calling process into previously reserved memory.
>>>
>>> Kernel image defined by segments is copied into kernel either in regular
>>> memory 
>>
>> Could you clarify what you mean by "regular memory"?
> 
> I meant memory which is not reserved memory.

Okay.

>>> or in reserved memory (if KEXEC_ON_CRASH is set). Kernel first
>>> copies list of segments in kernel memory and then goes does various
>>> sanity checks on the segments. If everything looks line, kernel copies
>>> segment data to kernel memory.
>>>
>>> In case of normal kexec, segment data is loaded in any available memory
>>> and segment data is moved to final destination at the kexec reboot time.
>>
>> By "moved to final destination", do you mean "moved from user space to the
>> final kernel-space destination"?
> 
> No. Segment data moves from user space to kernel space once kexec_load()
> call finishes successfully. But when user does reboot (kexec -e), at that
> time kernel moves that segment data to its final location. Kernel could
> not place the segment at its final location during kexec_load() time as
> that memory is already in use by running kernel. But once we are about
> to reboot to new kernel, we can overwrite the old kernel's memory.

Got it.

>>> In case of kexec on panic (KEXEC_ON_CRASH flag set), segment data is
>>> directly loaded to reserved memory and after crash kexec simply jumps
>>
>> By "directly", I assume you mean "at the time of the kexec_laod() call",
>> right?
> 
> Yes.

Thanks.

So, returning to the kexeec_segment structure:

           struct kexec_segment {
               void   *buf;        /* Buffer in user space */
               size_t  bufsz;      /* Buffer length in user space */
               void   *mem;        /* Physical address of kernel */
               size_t  memsz;      /* Physical address length */
           };

Are the following statements correct:
* buf + bufsz identify a memory region in the caller's virtual 
  address space that is the source of the copy
* mem + memsz specify the target memory region of the copy
* mem is  physical memory address, as seen from kernel space
* the number of bytes copied from userspace is min(bufsz, memsz)
* if bufsz > memsz, then excess bytes in the user-space buffer 
  are ignored.
* if memsz > bufsz, then excess bytes in the target kernel buffer
  are filled with zeros.
?

Also, it seems to me that 'mem' need not be page aligned.
Is that correct? Should the man page say something about that?
(E.g., is it generally desirable that 'mem' should be page aligned?)

Likewise, 'memsz' doesn't need to be a page multiple, IIUC.
Should the man page say anything about this? For example, should 
it note that the initialized kernel segment will be of size:

     (mem % PAGE_SIZE + memsz) rounded up to the next multiple of PAGE_SIZE

And should it note that if 'mem' is not a multiple of the page size, then
the initial bytes (mem % PAGE_SIZE)) in the first page of the kernel segment 
will be zeros?

(Hopefully I have read kimage_load_normal_segment() correctly.)

And one further question. Other than the fact that they are used with 
different system calls, what is the difference between KEXEC_ON_CRASH 
and KEXEC_FILE_ON_CRASH?

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
