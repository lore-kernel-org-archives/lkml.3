Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab3JQNy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 09:54:26 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:33788 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659Ab3JQNyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 09:54:24 -0400
Date: Thu, 17 Oct 2013 08:54:17 -0500
From: Robert Jennings <rcj@linux.vnet.ibm.com>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Matt Helsley <matt.helsley@gmail.com>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Lei Li <lilei@linux.vnet.ibm.com>,
        Leonardo Garcia <lagarcia@linux.vnet.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH 1/2] vmsplice: unmap gifted pages for recipient
Message-ID: <20131017135417.GC19741@linux.vnet.ibm.com>
Mail-Followup-To: Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Rik van Riel <riel@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Matt Helsley <matt.helsley@gmail.com>,
	Anthony Liguori <anthony@codemonkey.ws>,
	Michael Roth <mdroth@linux.vnet.ibm.com>,
	Lei Li <lilei@linux.vnet.ibm.com>,
	Leonardo Garcia <lagarcia@linux.vnet.ibm.com>,
	Vlastimil Babka <vbabka@suse.cz>
References: <1381177293-27125-1-git-send-email-rcj@linux.vnet.ibm.com>
 <1381177293-27125-2-git-send-email-rcj@linux.vnet.ibm.com>
 <52543185.3060705@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52543185.3060705@sr71.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101713-1618-0000-0000-000004D19273
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dave Hansen (dave@sr71.net) wrote:
> On 10/07/2013 01:21 PM, Robert C Jennings wrote:
> >  		spd.partial[page_nr].offset = loff;
> >  		spd.partial[page_nr].len = this_len;
> > +		spd.partial[page_nr].useraddr = index << PAGE_CACHE_SHIFT;
> >  		len -= this_len;
> >  		loff = 0;
> >  		spd.nr_pages++;
> > @@ -656,6 +702,7 @@ ssize_t default_file_splice_read(struct file *in, loff_t *ppos,
> >  		this_len = min_t(size_t, vec[i].iov_len, res);
> >  		spd.partial[i].offset = 0;
> >  		spd.partial[i].len = this_len;
> > +		spd.partial[i].useraddr = (unsigned long)vec[i].iov_base;
> >  		if (!this_len) {
> >  			__free_page(spd.pages[i]);
> >  			spd.pages[i] = NULL;
> > @@ -1475,6 +1522,8 @@ static int get_iovec_page_array(const struct iovec __user *iov,
> >  
> >  			partial[buffers].offset = off;
> >  			partial[buffers].len = plen;
> > +			partial[buffers].useraddr = (unsigned long)base;
> > +			base = (void*)((unsigned long)base + PAGE_SIZE);
> >  
> >  			off = 0;
> >  			len -= plen;
> > diff --git a/include/linux/splice.h b/include/linux/splice.h
> > index 74575cb..56661e3 100644
> > --- a/include/linux/splice.h
> > +++ b/include/linux/splice.h
> > @@ -44,6 +44,7 @@ struct partial_page {
> >  	unsigned int offset;
> >  	unsigned int len;
> >  	unsigned long private;
> > +	unsigned long useraddr;
> >  };
> 
> "useraddr" confuses me.  You make it an 'unsigned long', yet two of the
> three assignments are from "void __user *".  The other assignment:
> 
> 	spd.partial[page_nr].useraddr = index << PAGE_CACHE_SHIFT;
> 
> 'index' looks to be the offset inside the file, not a user address, so
> I'm confused what that is doing.
> 
> Could you elaborate a little more on why 'useraddr' is suddenly needed
> in these patches?  How is "index << PAGE_CACHE_SHIFT" a virtual address?
>  Also, are we losing any of the advantages of sparse checking since
> 'useraddr' is without the __user annotation?
> 

I'm working on cleaning this up.  Trying to remove useraddr altogher
through the use of the existing 'private' field just for the
splice_to_user/pipe_to_user flow without upsetting other uses of the
private field.

