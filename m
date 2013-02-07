Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758642Ab3BGPGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 10:06:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000Ab3BGPGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 10:06:34 -0500
Date: Thu, 7 Feb 2013 10:06:23 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Hatayama, Daisuke" <d.hatayama@jp.fujitsu.com>
Cc: "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "cpw@sgi.com" <cpw@sgi.com>,
        "kumagai-atsushi@mxc.nes.nec.co.jp" 
	<kumagai-atsushi@mxc.nes.nec.co.jp>,
        "lisa.mitchell@hp.com" <lisa.mitchell@hp.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kdump, oldmem: support mmap on /dev/oldmem
Message-ID: <20130207150623.GC6462@redhat.com>
References: <33710E6CAA200E4583255F4FB666C4E20AC36B01@G01JPEXMBYT03>
 <20130205151256.GB12853@redhat.com>
 <33710E6CAA200E4583255F4FB666C4E20AC61B3C@G01JPEXMBYT03>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33710E6CAA200E4583255F4FB666C4E20AC61B3C@G01JPEXMBYT03>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 07:24:46AM +0000, Hatayama, Daisuke wrote:
> From: Vivek Goyal <vgoyal@redhat.com>
> Subject: Re: [PATCH] kdump, oldmem: support mmap on /dev/oldmem
> Date: Tue, 5 Feb 2013 10:12:56 -0500
> 
> > On Mon, Feb 04, 2013 at 04:59:35AM +0000, Hatayama, Daisuke wrote:
> 
> > [..]
> >> For design decision, I didn't support mmap() on /proc/vmcore because
> >> it abstracts old memory as ELF format, so there's range consequtive on
> >> /proc/vmcore but not consequtive on the actual old memory. For
> >> example, consider ELF headers on the 2nd kernel and the note objects,
> >> memory chunks corresponding to PT_LOAD entries on the first kernel.
> >> They are not consequtive on the old memory. So reampping them so
> >> /proc/vmcore appears consequtive using existing remap_pfn_range() needs
> >> some complicated work.
> > 
> > Can't we call remap_pfn_range() multiple times. Once for each sequential
> > range of memory. /proc/vmcore already has list of contiguous memory areas.
> > So we can parse user passed file offset and size and map into respective
> > physical chunks and call rempa_pfn_range() on all these chunks.
> > 
> > I think supporting mmap() both on /dev/oldmem as well as /proc/vmcore will
> > be nice.
> > 
> > Agreed that supporting mmap() on /proc/vmcore is more work as compared to
> > /dev/oldmem but should be doable.
> > 
> 
> The complication to support mmap() on /proc/vmcore lies in kdump
> side. Objects exported from /proc/vmcore needs to be page-size aligned
> on /proc/vmcore. This comes from the restriction of mmap() that
> requires user-space address and physical address to be page-size
> aligned.
> 
> As I said in the description, objects implicitly referened by
> /proc/vmcore are
> 
>   - ELF headers,
>   - NOTE objects (NT_PRSTATUS entries x cpus, VMCOREINFO), and
>   - memory chunks x (the number of PT_LOAD entries).
> 
> Note objects are scattered on old memory. They are exported as a
> single NOTE entry from program headers, so they need to be gathered at
> the same location in the 2nd kernel starting from the page-size
> aligned address.
> 
> VMCOREINFO is about 1.5KB on 2.6.32 kernel. One NT_PRSTATUS is 355
> bytes. Recent limit of NR_CPUS is 5120 on x86_64. So less than about 2
> MB is enough even on the worst case.
> 
> Note that the format of /proc/vmcore need to change since offset of
> each object need to be page-size aligned.

Ok, got it. So everything needs to be page aligned and if size is not
sufficient then we need a way to pad memory areas to make next object
page aligned. 

To begin with supporting mmap on /dev/oldmem is fine with me. Once that
gets in, it will be good to look at how to make all the individual items
page aligned  so that mmap can be supported on /proc/vmcore.

Thanks
Vivek
