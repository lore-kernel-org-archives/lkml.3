Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711Ab3CTUsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 16:48:38 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:47431 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab3CTUsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 16:48:36 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vivek Goyal <vgoyal@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com
References: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
	<20130316040154.15064.35482.stgit@localhost6.localdomain6>
	<877gl3m43p.fsf@xmission.com> <20130320134850.GC17274@redhat.com>
Date: Wed, 20 Mar 2013 13:48:27 -0700
In-Reply-To: <20130320134850.GC17274@redhat.com> (Vivek Goyal's message of
	"Wed, 20 Mar 2013 09:48:50 -0400")
Message-ID: <87boaddch0.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19PIIQt+xtkYfV/yZk7mPAz3ScZJI7wgC8=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Vivek Goyal <vgoyal@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v3 12/21] vmcore: allocate per-cpu crash_notes objects on page-size boundary
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Tue, Mar 19, 2013 at 03:12:10PM -0700, Eric W. Biederman wrote:
>> HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> writes:
>> 
>> > To satisfy mmap()'s page-size boundary requirement, allocate per-cpu
>> > crash_notes objects on page-size boundary.
>> >
>> > /proc/vmcore on the 2nd kernel checks if each note objects is
>> > allocated on page-size boundary. If there's some object not satisfying
>> > the page-size boundary requirement, /proc/vmcore doesn't provide
>> > mmap() interface.
>> 
>> On second look this requirement does not exist.  These all get copyied
>> into the unifed PT_NOTE segment so this patch is pointless and wrong.
>
> Hi Eric,
>
> They get copied only temporarily and then we free them. Actual reading
> of note data still goes to old kernel's memory.
>
> We copy them temporarily to figure out how much data is there in the
> note and update the size of single PT_NOTE header accordingly. We also
> add a new element to vmcore_list so that next time a read happens on
> an offset which falls into this particular note, we go and read it from
> old memory.
>
> merge_note_headers_elf64() {
> 	notes_section = kmalloc(max_sz, GFP_KERNEL);
> 	rc = read_from_oldmem(notes_section, max_sz, &offset, 0);
> 	/* parse the note, update relevant data structuers */
> 	kfree(notes_section);
> }
>
> And that's why we have the problem. Actually note buffers are physically
> present in old kernel's memory but in /proc/vmcore we have exported them
> as contiguous view. So we don't even have the option of mapping extra
> bytes (there is no space for mapping extra bytes).
>
> So there seem to be few options.
>
> - Do not merge headers. Keep one separate PT_NOTE header for each note and
>   then map extra bytes aligned. But that's kind of different and gdb does
>   not expect that. All elf_prstatus are supposed to be in single PT_NOTE
>   header.
>
> - Copy all notes to second kernel's memory.
>
> - align notes in first kernel to page boundary and pad them. I had assumed
>   that we are already allocating close to 4K of memory in first kernel but
>   looks like that's not the case. So agree that will be quite wasteful of
>   memory.
>
>   In fact we are not exporting size of note to user space and kexec-tools 
>   seems to be assuming MAX_NOTE_BYTES of 1024 and that seems very horrible.
>   Anyway, thats a different issue. We should also export size of reserved
>   memory for elf notes.
>
>
> Then how about option 2. That is copy all notes in new kernel's memory.
> Hatayama had initially implemented that appraoch and I suggested to pad
> notes in first kernel to 4K page size boundary. (In an attempt to reduce
> second kernel's memory usage). But sounds like per cpu elf note is much
> smaller and not 4K. So rounding off these to 4K sounds much more wasteful
> of memory.
>
> Will you like option 2 here where we copy notes to new kernel's memory
> in contiguous memory and go from there?

Blink.  I had missed the fact that we were not keeping the merged copy
of the elf notes.  That does seem silly after we go to all of the work
to create it.

The two practical options I see are. 
1) Don't allow mmap of the new headers and the merged notes.
2) Copy the notes into a merged note section in the second kernel.

I have no problem with either option.

In practice I expect copying of the notes will scale better as that
terribly long link list won't need to hold all of the previous note
sections, but there are other ways to get that speed up.

Eric

