Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525AbaBENbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 08:31:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbaBENbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 08:31:40 -0500
Date: Wed, 5 Feb 2014 08:31:32 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Pearson, Greg" <greg.pearson@hp.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "d.hatayama@jp.fujitsu.com" <d.hatayama@jp.fujitsu.com>,
        "holzheu@linux.vnet.ibm.com" <holzheu@linux.vnet.ibm.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] vmcore: prevent PT_NOTE p_memsz overflow during
 header update
Message-ID: <20140205133132.GB6042@redhat.com>
References: <1391458718-11994-1-git-send-email-greg.pearson@hp.com>
 <20140203213813.GH10795@redhat.com>
 <52F01EF5.506@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F01EF5.506@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 10:57:58PM +0000, Pearson, Greg wrote:
> On 02/03/2014 02:38 PM, Vivek Goyal wrote:
> > On Mon, Feb 03, 2014 at 01:18:38PM -0700, Greg Pearson wrote:
> >
> > [..]
> >> diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
> >> index 2ca7ba0..051c803 100644
> >> --- a/fs/proc/vmcore.c
> >> +++ b/fs/proc/vmcore.c
> >> @@ -468,12 +468,14 @@ static int __init update_note_header_size_elf64(const Elf64_Ehdr *ehdr_ptr)
> >>   			return rc;
> >>   		}
> >>   		nhdr_ptr = notes_section;
> >> -		while (real_sz < max_sz) {
> >> -			if (nhdr_ptr->n_namesz == 0)
> >> -				break;
> >> +		while (nhdr_ptr->n_namesz != 0) {
> >>   			sz = sizeof(Elf64_Nhdr) +
> >>   				((nhdr_ptr->n_namesz + 3) & ~3) +
> >>   				((nhdr_ptr->n_descsz + 3) & ~3);
> >> +			if ((real_sz + sz) > max_sz) {
> >> +				pr_warn("Warning: dropping PT_NOTE entry\n");
> >> +				break;
> >> +			}
> > Hi Greg,
> >
> > Couple of minor nits.
> >
> > I think it is a good idea to give more data in warning which tells why
> > are we dropping a note entry. May be something like.
> >
> > "Warning: Total note entry size exceeded PT_NOTE memsz. Dropping PT_NOTE entry, n_namesz=<> n_descsz=<>".
> 
> Sounds good I'll add more information to the pr_warn().
> 
> >
> > Secondly, if there is only on note entry in a PT_NOTE header and we drop
> > it, then that PT_NOTE header is empty and needs to be cleaned up.
> >
> > I think you will have to modify get_note_number_and_size_elf64() and
> > other relevant functions which are not expecting ->p_memsz=0.
> 
> What about treating this as an error condition and adding a check to the 
> update_note_header_size_elf32()/update_note_header_size_elf64() routines 
> that would return a failure, something like the following at the end of 
> the routine:
> 
>      if (real_sz == 0)
>          return -EINVAL
> 
> I could also add a pr_warn() with a message indicating no PT_NOTE 
> entries were found.
> 
> This seems like a lower risk change to handle the case I'm currently 
> seeing as opposed to changing the code to handle a p_memsz==0.
> 
> Thoughts?

If you retrun with -EINVAL, that means /proc/vmcore will not be
created. This probably is too harsh an action. If a PT_NOTE is corrupt,
we can just ignore it and continue with construction of /proc/vmcore. We
will just loose cpu registers of one cpu. May be that cpu was idling
and it did not matter for the purpose of crash analysis.

IMO, we can just ignore empty PT_NOTE (real_sz), give a warning and move
on.

Thanks
Vivek
