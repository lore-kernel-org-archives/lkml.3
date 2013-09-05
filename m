Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab3IEOh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 10:37:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345Ab3IEOh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 10:37:58 -0400
Date: Thu, 5 Sep 2013 10:37:49 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: tytso@mit.edu
Subject: Re: ext4: cache all of an extent tree's leaf block upon reading
Message-ID: <20130905143749.GA15894@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	tytso@mit.edu
References: <20130905013848.42DD7660EE1@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905013848.42DD7660EE1@gitolite.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 01:38:48AM +0000, Linux Kernel wrote:
 > Gitweb:     http://git.kernel.org/linus/;a=commit;h=107a7bd31ac003e42c0f966aa8e5b26947de6024
 > Commit:     107a7bd31ac003e42c0f966aa8e5b26947de6024
 > Parent:     3be78c73179c9347bdc0a92b2898063bd2300ff7
 > Author:     Theodore Ts'o <tytso@mit.edu>
 > AuthorDate: Fri Aug 16 21:23:41 2013 -0400
 > Committer:  Theodore Ts'o <tytso@mit.edu>
 > CommitDate: Fri Aug 16 21:23:41 2013 -0400
 > 
 >     ext4: cache all of an extent tree's leaf block upon reading
 

 > + * ext4_es_cache_extent() inserts information into the extent status
 > + * tree if and only if there isn't information about the range in
 > + * question already.
 > + */
 > +void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
 > +			  ext4_lblk_t len, ext4_fsblk_t pblk,
 > +			  unsigned int status)
 > +{
 > +	struct extent_status *es;
 > +	struct extent_status newes;
 > +	ext4_lblk_t end = lblk + len - 1;
 > +
 > +	newes.es_lblk = lblk;
 > +	newes.es_len = len;
 > +	ext4_es_store_pblock(&newes, pblk);


ext4_es_store_pblock or's the pblk with the existing contents of the struct member.
(albeit masked with ES_MASK)

Should there be a 

	newes.es_pblk = 0;

up there too ?

It seems like if the stack happened to contain any of ES_WRITTEN | ES_UNWRITTEN | ES_DELAYED | ES_HOLE
then it could leak through into the new extent status.

	Dave

