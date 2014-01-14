Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375AbaANXf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 18:35:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34854 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbaANXfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 18:35:55 -0500
Date: Tue, 14 Jan 2014 15:35:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Kexec Mailing List <kexec@lists.infradead.org>,
        Greg KH <gregkh@suse.de>,
        "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>,
        Dan Aloni <da-x@monatomic.org>
Subject: Re: [PATCH] kdump: Fix exported size of vmcoreinfo note
Message-Id: <20140114153554.88b4a8c193b88df9492f6973@linux-foundation.org>
In-Reply-To: <20140114193311.GL3096@redhat.com>
References: <20140114193311.GL3096@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jan 2014 14:33:11 -0500 Vivek Goyal <vgoyal@redhat.com> wrote:

> Right now we seem to be exporting the max data size contained inside
> vmcoreinfo note. But this does not include the size of meta data around
> vmcore info data. Like name of the note and starting and ending elf_note.
> 
> I think user space expects total size and that size is put in PT_NOTE
> elf header. Things seem to be fine so far because we are not using
> vmcoreinfo note to the maximum capacity. But as it starts filling up,
> to capacity, at some point of time, problem will be visible.

urgh.  This is what we get for adding undocumented interfaces.

Looking through the fd59d231f81cb0287 changelog and the various email
threads it points to I can find no mention of what vmcoreinfo is
*supposed* to contain.  It was just kinda silently tossed in there.

So as a remedial step, could we please get this and any associated
interfaces written down in a way which people can very belatedly
review?

Phrases like "I think user space expects" and "Things seem to be fine
so far" don't inspire a ton of confidence.  What are the chances of
userspace breakage here?  Would it be safer/saner to leave vmcoreinfo
alone and add a new vmcoreinfo2 with the altered behaviour?

> --- linux-2.6.orig/kernel/ksysfs.c	2014-01-14 14:09:42.107767503 -0500
> +++ linux-2.6/kernel/ksysfs.c	2014-01-14 14:15:24.385510314 -0500
> @@ -126,7 +126,7 @@ static ssize_t vmcoreinfo_show(struct ko
>  {
>  	return sprintf(buf, "%lx %x\n",
>  		       paddr_vmcoreinfo_note(),
> -		       (unsigned int)vmcoreinfo_max_size);
> +		       (unsigned int)sizeof(vmcoreinfo_note));
>  }
>  KERNEL_ATTR_RO(vmcoreinfo);
>  
