Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbaHFPYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 11:24:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35650 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaHFPYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 11:24:49 -0400
Date: Wed, 6 Aug 2014 08:24:17 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Brian Gerst <brgerst@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Borislav Petkov <bp@alien8.de>, Andrew Lutomriski <amluto@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dirk Hohndel <dirk@hohndel.org>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        comex <comexk@gmail.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH 3.10 12/27] x86-64, espfix: Dont leak bits 31:16 of %esp
 returning to 16-bit stack
Message-ID: <20140806152417.GB15463@kroah.com>
References: <20140805181344.268039690@linuxfoundation.org>
 <20140805181344.629775899@linuxfoundation.org>
 <20140806151620.GD12150@hercules>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140806151620.GD12150@hercules>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 04:16:20PM +0100, Luis Henriques wrote:
> On Tue, Aug 05, 2014 at 11:14:04AM -0700, Greg Kroah-Hartman wrote:
> <...>
> > @@ -188,17 +193,21 @@ static void note_page(struct seq_file *m
> >  		/*
> >  		 * Now print the actual finished series
> >  		 */
> > -		seq_printf(m, "0x%0*lx-0x%0*lx   ",
> > -			   width, st->start_address,
> > -			   width, st->current_address);
> > -
> > -		delta = (st->current_address - st->start_address) >> 10;
> > -		while (!(delta & 1023) && unit[1]) {
> > -			delta >>= 10;
> > -			unit++;
> > +		if (!st->marker->max_lines ||
> > +		    st->lines < st->marker->max_lines) {
> > +			seq_printf(m, "0x%0*lx-0x%0*lx   ",
> > +				   width, st->start_address,
> > +				   width, st->current_address);
> > +
> > +			delta = (st->current_address - st->start_address) >> 10;
> > +			while (!(delta & 1023) && unit[1]) {
> > +				delta >>= 10;
> > +				unit++;
> > +			}
> > +			seq_printf(m, "%9lu%c ", delta, *unit);
> > +			printk_prot(m, st->current_prot, st->level);
> >  		}
> > -		seq_printf(m, "%9lu%c ", delta, *unit);
> > -		printk_prot(m, st->current_prot, st->level);
> > +		st->lines++;
> >  
> >  		/*
> >  		 * We print markers for special areas of address space,
> 
> Hmm... the original commit has a 2nd hunk here that does seem to be
> applicable to 3.10.  Was this dropped accidentally or on purpose?

I don't remember at all, sorry.  What is the hunk that I missed?

thanks,

greg k-h
