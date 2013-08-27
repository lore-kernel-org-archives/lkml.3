Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab3H0NBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 09:01:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183Ab3H0NBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 09:01:09 -0400
Message-ID: <1377608461.2127.15.camel@deneb.redhat.com>
Subject: Re: [PATCH] arm64: move elf notes into readonly segment
From: Mark Salter <msalter@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 27 Aug 2013 09:01:01 -0400
In-Reply-To: <20130827104949.GE19897@arm.com>
References: <1377271002.7359.2.camel@deneb.redhat.com>
	 <20130827104949.GE19897@arm.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-27 at 11:49 +0100, Catalin Marinas wrote:
> On Fri, Aug 23, 2013 at 04:16:42PM +0100, Mark Salter wrote:
> > The current vmlinux.lds.S places the notes sections between the
> > end of rw data and start of bss. This means that _edata doesn't
> > really point to the end of data. Since notes are read-only, this
> > patch moves them to the read-only segment so that _edata does
> > point to the end of initialized rw data.
> > 
> > Signed-off-by: Mark Salter <msalter@redhat.com>
> > ---
> >  arch/arm64/kernel/vmlinux.lds.S | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
> > index f5e5574..f8ab9d8 100644
> > --- a/arch/arm64/kernel/vmlinux.lds.S
> > +++ b/arch/arm64/kernel/vmlinux.lds.S
> > @@ -71,6 +71,7 @@ SECTIONS
> >  
> >  	RO_DATA(PAGE_SIZE)
> >  	EXCEPTION_TABLE(8)
> > +	NOTES
> >  	_etext = .;			/* End of text and rodata section */
> >  
> >  	. = ALIGN(PAGE_SIZE);
> > @@ -122,8 +123,6 @@ SECTIONS
> >  	}
> >  	_edata_loc = __data_loc + SIZEOF(.data);
> >  
> > -	NOTES
> > -
> >  	BSS_SECTION(0, 0, 0)
> >  	_end = .;
> 
> The _edata is set before NOTES, so I don't fully understand where the
> problem is.
> 
The problem *is* _edata before the NOTES. We need a symbol to mark the
end of initialized data. This should be _edata but _edata doesn't
currently account for NOTES. In the EFI stub I'm working on, the PE/COFF
header needs to know the end of the image. If we use _edata, we wouldn't
include NOTES, so we're left with __bss_start. But _bss_start may not be
exactly right because of alignment rounding and it is ugly to use for
that purpose. So we either need a new symbol following NOTES, or move
_edata past NOTES, or move NOTES. I chose the latter because NOTES are
readonly and don't really need to be part of the RW segment.

--Mark


