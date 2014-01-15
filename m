Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344AbaAOPMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 10:12:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914AbaAOPMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 10:12:53 -0500
Date: Wed, 15 Jan 2014 10:12:23 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Kexec Mailing List <kexec@lists.infradead.org>,
        Greg KH <gregkh@suse.de>,
        "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>,
        Dan Aloni <da-x@monatomic.org>
Subject: Re: [PATCH] kdump: Fix exported size of vmcoreinfo note
Message-ID: <20140115151223.GB29244@redhat.com>
References: <20140114193311.GL3096@redhat.com>
 <20140114153554.88b4a8c193b88df9492f6973@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140114153554.88b4a8c193b88df9492f6973@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 03:35:54PM -0800, Andrew Morton wrote:
> On Tue, 14 Jan 2014 14:33:11 -0500 Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > Right now we seem to be exporting the max data size contained inside
> > vmcoreinfo note. But this does not include the size of meta data around
> > vmcore info data. Like name of the note and starting and ending elf_note.
> > 
> > I think user space expects total size and that size is put in PT_NOTE
> > elf header. Things seem to be fine so far because we are not using
> > vmcoreinfo note to the maximum capacity. But as it starts filling up,
> > to capacity, at some point of time, problem will be visible.
> 
> urgh.  This is what we get for adding undocumented interfaces.
> 
> Looking through the fd59d231f81cb0287 changelog and the various email
> threads it points to I can find no mention of what vmcoreinfo is
> *supposed* to contain.  It was just kinda silently tossed in there.
> 
> So as a remedial step, could we please get this and any associated
> interfaces written down in a way which people can very belatedly
> review?

Sure. I will send another patch to add some documentation for vmcoreinfo
in Documentation/ABI/testing/* in a separate patch.

> 
> Phrases like "I think user space expects" and "Things seem to be fine
> so far" don't inspire a ton of confidence.  What are the chances of
> userspace breakage here?  Would it be safer/saner to leave vmcoreinfo
> alone and add a new vmcoreinfo2 with the altered behaviour?

I don't think user space will be broken with this change. So there is
no need to introduce vmcoreinfo2. This change is safe and backward 
compatible. More explanation on why this change is safe is below.

vmcoreinfo contains information about kernel which user space needs to
know to do things like filtering. For example, various kernel config
options or information about size or offset of some data structures etc.
All this information is commmunicated to user space with an ELF note
present in ELF /proc/vmcore file.

Currently vmcoreinfo data size is 4096. With some elf note meta data
around it, actual size is 4132 bytes. But we are using barely 25% of
that size. Rest is empty. So even if we tell user space that size of
ELf note is 4096 and not 4132, nothing will be broken becase after
around 1000 bytes, everything is zero anyway.

But once we start filling up the note to the capacity, and not report
the full size of note, bad things will start happening. Either some data
will be lost or tools will be confused that they did not fine the zero
note at the end.

So I think this change is safe and should not break existing tools.

Thanks
Vivek
