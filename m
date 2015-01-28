Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbbA1VAR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:00:17 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:50524 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586AbbA1VAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 16:00:14 -0500
Message-ID: <54C89816.8030709@gmail.com>
Date: Wed, 28 Jan 2015 09:04:38 +0100
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
References: <545FBDDD.9060801@gmail.com> <20141111213037.GA31445@redhat.com> <54ADA284.30502@gmail.com> <20150112221634.GD16162@redhat.com> <54B91271.3000600@gmail.com> <20150127142459.GA12851@redhat.com>
In-Reply-To: <20150127142459.GA12851@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

On 01/27/2015 03:24 PM, Vivek Goyal wrote:
> On Fri, Jan 16, 2015 at 02:30:25PM +0100, Michael Kerrisk (man-pages) wrote:
> [..]
>>
> 
> Hi Michael,
> 
> Please find my responses below. Sorry, I got stuck in other work and
> forgot about this thread.
> 
>> So, returning to the kexeec_segment structure:
>>
>>            struct kexec_segment {
>>                void   *buf;        /* Buffer in user space */
>>                size_t  bufsz;      /* Buffer length in user space */
>>                void   *mem;        /* Physical address of kernel */
>>                size_t  memsz;      /* Physical address length */
>>            };
>>
>> Are the following statements correct:
>> * buf + bufsz identify a memory region in the caller's virtual 
>>   address space that is the source of the copy
> 
> Yes.

Okay.

>> * mem + memsz specify the target memory region of the copy
> 
> Yes.

Okay.

>> * mem is  physical memory address, as seen from kernel space
> 
> Yes.

Okay.

>> * the number of bytes copied from userspace is min(bufsz, memsz)
> 
> Yes. bufsz can not be more than memsz. There is a check to validate
> this in kernel.
> 
> 	result = -EINVAL;
> 	for (i = 0; i < nr_segments; i++) {
> 		if (image->segment[i].bufsz > image->segment[i].memsz)
> 			return result;
> 	}

Okay. So it's more precise to leave discussion of min(bufz, memsz) 
out of the man page just to say: bufsz bytes are transferred; 
if bufsz < memsz, then the excess bytes in the target region are 
filled with zeros. Right?

>> * if bufsz > memsz, then excess bytes in the user-space buffer 
>>   are ignored.
> 
> You will get -EINVAL.

Okay.

>> * if memsz > bufsz, then excess bytes in the target kernel buffer
>>   are filled with zeros.
> 
> Yes.

Okay.

>> Also, it seems to me that 'mem' need not be page aligned.
>> Is that correct? Should the man page say something about that?
>> (E.g., is it generally desirable that 'mem' should be page aligned?)
> 
> mem and memsz need to be page aligned. There is a check for that too.
> 
> 	mstart = image->segment[i].mem;
> 	mend   = mstart + image->segment[i].memsz;
> 	if ((mstart & ~PAGE_MASK) || (mend & ~PAGE_MASK))
> 		return result;
> 
>>
>> Likewise, 'memsz' doesn't need to beta page multiple, IIUC.
>> Should the man page say anything about this? For example, should 
>> it note that the initialized kernel segment will be of size:
>>
>>      (mem % PAGE_SIZE + memsz) rounded up to the next multiple of PAGE_SIZE
>>
>> And should it note that if 'mem' is not a multiple of the page size, then
>> the initial bytes (mem % PAGE_SIZE)) in the first page of the kernel segment 
>> will be zeros?
>>
>> (Hopefully I have read kimage_load_normal_segment() correctly.)
> 
> Both mem and memsz need to be page aligned.

And the error if not is EADDRNOTAVAIL, right?

>> And one further question. Other than the fact that they are used with 
>> different system calls, what is the difference between KEXEC_ON_CRASH 
>> and KEXEC_FILE_ON_CRASH?
> 
> Right now I can't think of any other difference. They both tell respective
> system call that this kernel needs to be loaded in reserved memory region
> for crash kernel.

Okay.

I've made various adjustments to the page in the light of your comments 
above. Thanks!

Cheers,

Michael



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
