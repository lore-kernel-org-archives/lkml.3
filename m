Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbaEUD4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 23:56:40 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:44833 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbaEUD4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 23:56:38 -0400
MIME-Version: 1.0
In-Reply-To: <CALN0BAuzw74rLwrF+FvDWHHc+rtoF8+DAZwEOXzoWsVeS=GbCg@mail.gmail.com>
References: <CALN0BAu_ibgpVykHL-byKm_4X1Afr1R1LRC5ocYVzcqA_k=_9Q@mail.gmail.com>
	<20140519130114.GA3140@dhcp22.suse.cz>
	<20140519143540.BE9F6E009B@blue.fi.intel.com>
	<CALN0BAu0E9r0hdy_Vc6GoKiXXk_w0vetRdumW-3eFFzOPqsFSQ@mail.gmail.com>
	<20140519212416.GA14152@node.dhcp.inet.fi>
	<CALN0BAuzw74rLwrF+FvDWHHc+rtoF8+DAZwEOXzoWsVeS=GbCg@mail.gmail.com>
Date: Tue, 20 May 2014 23:56:37 -0400
Message-ID: <CALN0BAvfgby97e69mMd+94pcn6AOPL=VPNesfu_W4_9rhkHZxw@mail.gmail.com>
Subject: Re: remap_file_pages() use
From: Kenny Simpson <theonetruekenny@gmail.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Armin Rigo <arigo@tunes.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I might need a gentle nudge with a clue stick...
checking against latest git tree it looks as though most common
filesystem types do support remap_file_pages.

I just wrote a simple test case and it worked on my 3.13-based ubuntu
14.04 system on an ext4 filesystem.

thanks,
-Kenny

Here was my simple test case: (it doesn't have error handling, but the
case passed, and running under strace shows all system calls as
passing as well)

#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>

// make a 16-page file, map page 17 over the first page, write to the
aliasing page, assert that it is seen on the first page

int main()
{
  unlink("foo");
  int fd = open("foo", O_CREAT | O_RDWR, 0755);
  ftruncate(fd, 16*4096);
  void* ptr = mmap(0, 17*4096, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
  char* cptr = (char*) ptr;

  // remap the last page over the first
  remap_file_pages(cptr + 16*4096/*addr*/, 4096/*size*/,
           0/*prot*/, 0/*pgoff*/, 0/*flags*/);

  cptr[16*4096] = 'a';
  return cptr[0] != 'a'; // if this aliases, this will be 'a'
}


On Tue, May 20, 2014 at 9:53 PM, Kenny Simpson
<theonetruekenny@gmail.com> wrote:
> ouch... hope they don't try to run that code on anything newer then :(
>  Will let them know.
>
> -Kenny
>
>
> On Mon, May 19, 2014 at 5:24 PM, Kirill A. Shutemov
> <kirill@shutemov.name> wrote:
>> On Mon, May 19, 2014 at 01:34:05PM -0400, Kenny Simpson wrote:
>>> For the other cases I had used the remapping to have more of a sliding
>>> window over a disk-backed file where I also was using aliasing to
>>> eliminate the corner cases of hitting the end of a window and needing
>>> to split records due to crossing boundaries, etc..
>>
>> Disk backed files are not supported by remap_file_pages() since 2007.
>> See commit 3ee6dafc677a.
>>
>> --
>>  Kirill A. Shutemov
