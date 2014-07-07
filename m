Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbaGGP2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:28:18 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:49716 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaGGP2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:28:15 -0400
Date: Mon, 7 Jul 2014 17:28:09 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Helge Deller <deller@gmx.de>
Cc: Eric Paris <eparis@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Dave Anglin <dave.anglin@bell.net>
Subject: Re: Re: [PATCH] fix fanotify_mark() breakage on big endian 32bit
 kernel
Message-ID: <20140707152809.GA6373@osiris>
References: <20140704151235.GA22454@ls3530.dhcp.wdf.sap.corp>
 <20140706091530.GA3589@osiris>
 <trinity-8380f6e4-393a-40f8-ba95-3ab03baa85b7-1404741277414@3capp-gmx-bs54>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-8380f6e4-393a-40f8-ba95-3ab03baa85b7-1404741277414@3capp-gmx-bs54>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070715-3548-0000-0000-0000006D0CE6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 03:54:37PM +0200, Helge Deller wrote:
> Hi Heiko,
> > So for sys_fanotify_mark everything is fine on s390, and probably most other
> > architectures as well. Having a 64 bit syscall parameter indeed does work,
> > if all the architecture specific details have been correctly considered.
> 
> I think this is the problem!
[...]
> So on hppa r26 is fanotify_fd, %r25 is flags, %r24/%r23 is lower/higher 32bits of mask.
> For the mask parameter this is different to what the __LONG_LONG_PAIR() marcro
> would hand over to the syscall (which would be %r24/%r23 as higher/lower 32bits).
> 
> So, the problem is the usage of __u64 in the 32bit API. It has to be handled architecture-specific.
> It seems to work for little-endian machines, and probably (by luck?!?) for s390, but I'm not sure if
> it maybe breaks (like on parisc) on other arches, e.g. what about sparc?

No, it's not luck that it works on s390. Whenever we add a new entry to
our system call table, we make sure that 64 bit parameters, if present,
work on s390.
Otherwise we add s390 specific system calls like e.g. sys_s390_fallocate.

> For parisc I can work around that problem in the architecture-specifc coding, but I still
> think using __64 here is wrong and just may lead to such bugs.

There have always been problems with 64 bit system call parameters on 32 bit
architectures. See for example this thread:
http://oss.sgi.com/archives/xfs/2007-03/msg00557.html

David Woodhouse wrote summed up the system call ABI of a couple of
architectures a couple of years ago:
http://marc.info/?l=linux-arch&m=118277150812137&w=2

And there was also a system call howto from Ulrich Drepper:
http://copilotco.com/mail-archives/linux-kernel.2007/msg27844.html

