Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab3IEOxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 10:53:37 -0400
Received: from imap.thunk.org ([74.207.234.97]:55099 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354Ab3IEOxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 10:53:36 -0400
Date: Thu, 5 Sep 2013 10:53:34 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ext4: cache all of an extent tree's leaf block upon reading
Message-ID: <20130905145334.GB23661@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20130905013848.42DD7660EE1@gitolite.kernel.org>
 <20130905143749.GA15894@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905143749.GA15894@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 10:37:49AM -0400, Dave Jones wrote:
>  > +void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
>  > +			  ext4_lblk_t len, ext4_fsblk_t pblk,
>  > +			  unsigned int status)
>  > +{
>  > +	struct extent_status *es;
>  > +	struct extent_status newes;
>  > +	ext4_lblk_t end = lblk + len - 1;
>  > +
>  > +	newes.es_lblk = lblk;
>  > +	newes.es_len = len;
>  > +	ext4_es_store_pblock(&newes, pblk);
> 
> 
> ext4_es_store_pblock or's the pblk with the existing contents of the struct member.
> (albeit masked with ES_MASK)
> 
> Should there be a 
> 
> 	newes.es_pblk = 0;
> 
> up there too ?

The next line after ext4_es_store_pblock() is:

        ext4_es_store_status(&newes, status);

This will set remaining ES_WRITTEN | ES_UNWRITTEN... bits.

So the only reason to add a line explicitly setting es_pblk to zero
would be to suppress a warning from some insufficiently smart static
code analysis tool.  I didn't see a warning from gcc, but it's
possible that this is something which is causing Coverity or some
other code scanner heartburn.

Cheers,

					- Ted
