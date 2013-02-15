Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab3BOQxl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 11:53:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811Ab3BOQxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 11:53:39 -0500
Date: Fri, 15 Feb 2013 11:53:27 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: ebiederm@xmission.com, cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        lisa.mitchell@hp.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/13] vmcore: copy ELF note segments in buffer on 2nd
 kernel
Message-ID: <20130215165327.GH27784@redhat.com>
References: <20130214100945.22466.4172.stgit@localhost6.localdomain6>
 <20130214101232.22466.44026.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130214101232.22466.44026.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 07:12:32PM +0900, HATAYAMA Daisuke wrote:
> Objects exported from ELF note segments are in fact located apart from
> each other on old memory. But on /proc/vmcore they are exported as a
> single ELF note segment. To satisfy mmap()'s page-size boundary
> requirement, copy them in a page-size aligned buffer allocated by
> __get_free_pages() on 2nd kernel and remap the buffer to user-space.
> 
> The buffer for ELF note segments is added to vmcore_list as the object
> of VMCORE_2ND_KERNEL type.
> 
> Copy of ELF note segments is done in two pass: first pass tries to
> calculate real total size of ELF note segments, and then 2nd pass
> copies the segment data into the buffer of the real total size.

Ok, this is the part I am not very happy with. I don't like the idea
of copying notes into second kernel. It has potential to bloat our
memory usage requirements in second kernel.

For example, we allocate a 4K page for each cpu and a huge machine
say 4096 cpu, 16MB of more memory is required. Not that it is big
concern for a 4K cpu machine, still if we can avoid copying notes from
previous kernel, it will be good.

So the problem is that note size from previous kernel might not be
page aligned. And in /proc/vmcore view all the notes are supposed
to be contiguous. 

Thinking loud.

- Can we introduce multiple PT_NOTE program headers. One for each note
  data. I am not sure if this will break existing user space tools like
  gdb, crash etc.

- Or can we pad the notes with a new note type say "VMCORE_PAD". This is
  similar to "VMCOREINFO" just that it is used for padding to make sure
  notes can be page aligned. User space tools should simple ignore
  the VMCORE_PAD notes and move on to next note.

I think I like second idea better and given the fact that gdb did not
break with introduction of "VMCOREINFO" note type, it should not break
when we introduce another note type.

If this works, you don't have to copy notes in second kernel?

Eric, do you have any thoughts on this. What makes more sense.

Thanks
Vivek
