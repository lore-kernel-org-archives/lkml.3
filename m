Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933AbaIRXnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 19:43:32 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:50310 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbaIRXnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 19:43:31 -0400
Date: Fri, 19 Sep 2014 02:43:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Oleg Drokin <oleg.drokin@intel.com>, devel@driverdev.osuosl.org,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        HPDD-discuss@ml01.01.org
Subject: Re: [PATCH] staging: lustre: llite: Use kzalloc and rewrite null
 tests
Message-ID: <20140918234309.GP17875@mwanda>
References: <1411071842-24714-1-git-send-email-Julia.Lawall@lip6.fr>
 <1411071842-24714-2-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411071842-24714-2-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 10:24:02PM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> This patch removes some kzalloc-related macros and rewrites the
> associated null tests to use !x rather than x == NULL.
> 

This is sort of exactly what Oleg asked us not to do in his previous
email.  ;P

I think there might be ways to get good enough tracing using standard
kernel features but it's legitimately tricky to update everything to
using mempools or whatever.  Maybe we should give Oleg some breathing
room to do this.

I hate looking at the OBD_ALLOC* macros, but really it's not as if we
don't have allocation helper functions anywhere in the rest of the
kernel.  It's just that the style of the lustre helpers is so very very
ugly.  It took me a while to spot that OBD_ALLOC() zeroes memory, for
example.

It should be relatively easy to re-write the macros so we can change
formats like this:

old:	OBD_ALLOC(ptr, size);
new:	ptr = obd_zalloc(size, GFP_NOFS);

old:	OBD_ALLOC_WAIT(ptr, size);
new:	ptr = obd_zalloc(size, GFP_KERNEL);

old:	OBD_ALLOC_PTR(ptr);
new:	ptr = obd_zalloc(sizeof(*ptr), GFP_NOFS);

etc...

Writing it this way means that we can't put the name of the pointer
we're allocating in the debug output but we could use the file and line
number instead or something.  Oleg, what do you think?

If we decide to mass convert to standard functions later then it's dead
simple to do that with sed.

The __OBD_MALLOC_VERBOSE() is hard to read.  It has side effect bugs if
you try to call OBD_ALLOC(ptr++, size);  The kernel already has a way to
inject kmalloc() failures for a specific module so that bit can be
removed.  Read Documentation/fault-injection/fault-injection.txt

regards,
dan carpenter
