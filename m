Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab3CTNtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 09:49:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755974Ab3CTNtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 09:49:06 -0400
Date: Wed, 20 Mar 2013 09:48:50 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com
Subject: Re: [PATCH v3 12/21] vmcore: allocate per-cpu crash_notes objects on
 page-size boundary
Message-ID: <20130320134850.GC17274@redhat.com>
References: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
 <20130316040154.15064.35482.stgit@localhost6.localdomain6>
 <877gl3m43p.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877gl3m43p.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 03:12:10PM -0700, Eric W. Biederman wrote:
> HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> writes:
> 
> > To satisfy mmap()'s page-size boundary requirement, allocate per-cpu
> > crash_notes objects on page-size boundary.
> >
> > /proc/vmcore on the 2nd kernel checks if each note objects is
> > allocated on page-size boundary. If there's some object not satisfying
> > the page-size boundary requirement, /proc/vmcore doesn't provide
> > mmap() interface.
> 
> On second look this requirement does not exist.  These all get copyied
> into the unifed PT_NOTE segment so this patch is pointless and wrong.

Hi Eric,

They get copied only temporarily and then we free them. Actual reading
of note data still goes to old kernel's memory.

We copy them temporarily to figure out how much data is there in the
note and update the size of single PT_NOTE header accordingly. We also
add a new element to vmcore_list so that next time a read happens on
an offset which falls into this particular note, we go and read it from
old memory.

merge_note_headers_elf64() {
	notes_section = kmalloc(max_sz, GFP_KERNEL);
	rc = read_from_oldmem(notes_section, max_sz, &offset, 0);
	/* parse the note, update relevant data structuers */
	kfree(notes_section);
}

And that's why we have the problem. Actually note buffers are physically
present in old kernel's memory but in /proc/vmcore we have exported them
as contiguous view. So we don't even have the option of mapping extra
bytes (there is no space for mapping extra bytes).

So there seem to be few options.

- Do not merge headers. Keep one separate PT_NOTE header for each note and
  then map extra bytes aligned. But that's kind of different and gdb does
  not expect that. All elf_prstatus are supposed to be in single PT_NOTE
  header.

- Copy all notes to second kernel's memory.

- align notes in first kernel to page boundary and pad them. I had assumed
  that we are already allocating close to 4K of memory in first kernel but
  looks like that's not the case. So agree that will be quite wasteful of
  memory.

  In fact we are not exporting size of note to user space and kexec-tools 
  seems to be assuming MAX_NOTE_BYTES of 1024 and that seems very horrible.
  Anyway, thats a different issue. We should also export size of reserved
  memory for elf notes.


Then how about option 2. That is copy all notes in new kernel's memory.
Hatayama had initially implemented that appraoch and I suggested to pad
notes in first kernel to 4K page size boundary. (In an attempt to reduce
second kernel's memory usage). But sounds like per cpu elf note is much
smaller and not 4K. So rounding off these to 4K sounds much more wasteful
of memory.

Will you like option 2 here where we copy notes to new kernel's memory
in contiguous memory and go from there?

Thanks
Vivek
