Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759460AbaCSR0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 13:26:19 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:59961 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996AbaCSR0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 13:26:14 -0400
Date: Wed, 19 Mar 2014 10:25:57 -0700
From: Mark Charlebois <charlebm@gmail.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: "'behanw@converseincode.com'" <behanw@converseincode.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "kaber@trash.net" <kaber@trash.net>,
        "kadlec@blackhole.kfki.hu" <kadlec@blackhole.kfki.hu>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "netfilter@vger.kernel.org" <netfilter@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "pageexec@freemail.hu" <pageexec@freemail.hu>,
        =?iso-8859-1?Q?Vin=EDcius?= Tinti <viniciustinti@gmail.com>
Subject: Re: [PATCH v3] net: netfilter: LLVMLinux: vlais-netfilter
Message-ID: <20140319172557.GA31869@mcharleb3-linux.qualcomm.com>
References: <063D6719AE5E284EB5DD2968C1650D6D0F6E0286@AcuExch.aculab.com>
 <1395193841-2886-1-git-send-email-behanw@converseincode.com>
 <063D6719AE5E284EB5DD2968C1650D6D0F6E0F8D@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D0F6E0F8D@AcuExch.aculab.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 09:52:40AM +0000, David Laight wrote:
> From: behanw@converseincode.com 
> > From: Mark Charlebois <charlebm@gmail.com>
> > 
> > Replaced non-standard C use of Variable Length Arrays In Structs (VLAIS) in
> > xt_repldata.h with a C99 compliant flexible array member and then calculated
> > offsets to the other struct members. These other members aren't referenced by
> > name in this code, however this patch maintains the same memory layout and
> > padding as was previously accomplished using VLAIS.
> > 
> > Had the original structure been ordered differently, with the entries VLA at
> > the end, then it could have been a flexible member, and this patch would have
> > been a lot simpler. However since the data stored in this structure is
> > ultimately exported to userspace, the order of this structure can't be changed.
> > 
> > This patch makes no attempt to change the existing behavior, merely the way in
> > which the current layout is accomplished using standard C99 constructs. As such
> > the code can now be compiled with either gcc or clang.
> > 
> > Author: Mark Charlebois <charlebm@gmail.com>
> > Signed-off-by: Mark Charlebois <charlebm@gmail.com>
> > Signed-off-by: Behan Webster <behanw@converseincode.com>
> > Signed-off-by: Vinícius Tinti <viniciustinti@gmail.com>
> > ---
> >  net/netfilter/xt_repldata.h | 27 ++++++++++++++++++++++-----
> >  1 file changed, 22 insertions(+), 5 deletions(-)
> > 
> > diff --git a/net/netfilter/xt_repldata.h b/net/netfilter/xt_repldata.h
> > index 6efe4e5..343599e 100644
> > --- a/net/netfilter/xt_repldata.h
> > +++ b/net/netfilter/xt_repldata.h
> > @@ -5,23 +5,40 @@
> >   * they serve as the hanging-off data accessed through repl.data[].
> >   */
> > 
> > +/* tbl has the following structure equivalent, but is C99 compliant:
> > + * struct {
> > + *	struct type##_replace repl;
> > + *	struct type##_standard entries[nhooks];
> > + *	struct type##_error term;
> > + * } *tbl;
> > + */
> > +
> >  #define xt_alloc_initial_table(type, typ2) ({ \
> >  	unsigned int hook_mask = info->valid_hooks; \
> >  	unsigned int nhooks = hweight32(hook_mask); \
> >  	unsigned int bytes = 0, hooknum = 0, i = 0; \
> >  	struct { \
> >  		struct type##_replace repl; \
> > -		struct type##_standard entries[nhooks]; \
> > -		struct type##_error term; \
> > -	} *tbl = kzalloc(sizeof(*tbl), GFP_KERNEL); \
> > +		struct type##_standard entries[]; \
> > +	} *tbl; \
> > +	struct type##_error *term; \
> > +	size_t entries_end = offsetof(typeof(*tbl), \
> > +		entries[nhooks-1]) + sizeof(tbl->entries[0]); \
> 
> Is the compiler complaining about:
> 	offsetof(typeof(*tbl), entries[nhooks])
> If it does it is a PITA.
> 
> > +	size_t term_offset = (entries_end + __alignof__(*term) - 1) \
> > +		& ~(__alignof__(*term) - 1); \
> 
> You've not tested this - the () are in the wrong places.

I have tested it with both clang and gcc. Unit test is at http://git.linuxfoundation.org/?p=llvmlinux.git;a=blob;f=test/unit/vlais/netfilter.c;h=7adc255e47e15a252d2bda7af7ae217ac683c25e;hb=HEAD

Basic calulation of a new offset is:

new offset = (offset + align - 1) & ~(align - 1)

The parenthesis seem correct to me.
> 
> > +	size_t term_end = term_offset + sizeof(*term); \
> > +	size_t tbl_sz = (term_end + __alignof__(tbl->repl) - 1) \
> > +		& ~(__alignof__(tbl->repl) - 1); \
> > +	tbl = kzalloc(tbl_sz, GFP_KERNEL); \
> 
> The number of temporary variables make the above hard to read.
> I'm not at all sure you need to worry about the trailing alignment.
> It rather depends on how the final data is used.
> If the combined buffer is copied to userspace you may not
> be copying all of the required data.
> It might be easier to call copytouser() twice.

I can try to remove more variables if that is prefered.
The existing memory layout was preserved exactly so that however the
data currently used will be unaffected. I can remove the trailing
alignment but was not 100% sure it wasn't needed.

> 
> >  	if (tbl == NULL) \
> >  		return NULL; \
> > +	term = (struct type##_error *)&(((char *)tbl)[term_offset]); \
> >  	strncpy(tbl->repl.name, info->name, sizeof(tbl->repl.name)); \
> > -	tbl->term = (struct type##_error)typ2##_ERROR_INIT;  \
> > +	*term = (struct type##_error)typ2##_ERROR_INIT;  \
> 
> 	David
> 

Mark
