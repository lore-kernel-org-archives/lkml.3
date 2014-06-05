Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbaFEP5w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:57:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbaFEP5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:57:50 -0400
Date: Thu, 5 Jun 2014 11:56:58 -0400
From: Dave Jones <davej@redhat.com>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        zohar@linux.vnet.ibm.com
Subject: Re: ima_mmap_file returning 0 to userspace as mmap result.
Message-ID: <20140605155658.GA22673@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	zohar@linux.vnet.ibm.com
References: <20140604233122.GA19838@redhat.com>
 <538FF4C4.5090300@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538FF4C4.5090300@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 06:40:36AM +0200, Michael Kerrisk (man-pages) wrote:
 > On 06/05/2014 01:31 AM, Dave Jones wrote:
 > > I just noticed that trinity was freaking out in places when mmap was
 > > returning zero.  This surprised me, because I had the mmap_min_addr
 > > sysctl set to 64k, so it wasn't a MAP_FIXED mapping that did it.
 > > 
 > > There's no mention of this return value in the man page, so I dug
 > > into the kernel code, and it appears that we do..
 > > 
 > > sys_mmap
 > > vm_mmap_pgoff
 > > security_mmap_file
 > > ima_file_mmap <- returns 0 if not PROT_EXEC
 > > 
 > > and then the 0 gets propagated up as a retval all the way to userspace.
 > > 
 > > It smells to me like we might be violating a standard or two here, and
 > > instead of 0 ima should be returning -Esomething
 > > 
 > > thoughts?
 > 
 > Seems like either EACCESS or ENOTSUP is appropriate; here's the pieces 
 > from POSIX:
 > 
 >        EACCES The  fildes argument is not open for read, regardless of
 >               the protection specified, or  fildes  is  not  open  for
 >               write and PROT_WRITE was specified for a MAP_SHARED type
 >               mapping.
 > 
 >        ENOTSUP
 >                    The implementation does not support the combination
 >                    of accesses requested in the prot argument.
 > 
 > ENOTSUP seems to be more appropriate in my reading of the above, though
 > I'd somehow more have expected EACCES.

I just realised that this affects even kernels with CONFIG_IMA unset,
because there we just do 'return 0' unconditionally.

Also, it appears that kernels with CONFIG_SECURITY unset will also
return a zero for the same reason.

This is kind of a mess, and has been that way for a long time.
Fixing this will require user-visible breakage, but in this case
I think it's justified as there's no way an app can do the right thing
if it gets a 0 back.  Linus ?

	Dave

