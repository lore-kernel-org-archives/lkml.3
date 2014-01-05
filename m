Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819AbaAEVSA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 16:18:00 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:26871 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbaAEVR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 16:17:59 -0500
Date: Mon, 6 Jan 2014 00:18:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Ivaylo Dimitrov <freemangordon@abv.bg>,
        pavel@ucw.cz, pali.rohar@gmail.com
Subject: Re: [PATCH] Staging: tidspbridge: Use hashtable implementation
Message-ID: <20140105211804.GG5443@mwanda>
References: <1387992592-3208-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20140102134635.GD28413@mwanda>
 <52C9AAB3.6050300@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52C9AAB3.6050300@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not really an issue with this patch, it's something from the
original code so it doesn't affect merging the patch.

On Sun, Jan 05, 2014 at 08:55:47PM +0200, Ivaylo Dimitrov wrote:
> >Again, reverse the IS_ERR() check and return directly.  Use the struct
> >pointer instead of the address of the first member.
> >
> >	sym = gh_find(lib->sym_tab, (char *)name);
> >	if (IS_ERR(sym))
> >		return NULL;
> >
> >	return (struct dbll_symbol *)sym;
> >
> >That way is easier to read.  gh_find() should accept const pointers btw,
> >we shouldn't have to cast away the const in each of the callers.
> I don't think it is a good idea to return the structdbll_symbol*
> here - the function return type is structdynload_symbol* not
> structdbll_symbol*.

Oops.

> And that will break if we exchange value and name members of
> structdbll_symbol.

It will break anyway if we do that.  It's one of those things where you
can't worry too much about what crazy people might try to do later and
then no one reviews the code and no one tests it.  If we start doing
that sort of thing we are screwed already so it's not worth worrying
about.

I feel like the types in this driver are not beautiful.

The names are not clear.  Take "struct dbll_tar_obj" for example.  I'm
not clear what "dbll_" means.  I think the "d" stands for dynmic.  What
information does the "_obj" add?  It would be better to call it
"struct dbll_target".

"dbll_alloc" is a verb instead of a noun so it sounds like a function
not a struct.

But mostly there is too much nonsense casting throughout.
dbll_find_symbol() takes a struct dynamic_loader_sym pointer but we
immediatly cast it to struct ldr_symbol.  The struct ldr_symbol is
defined as:

struct ldr_symbol {
	struct dynamic_loader_sym dl_symbol;
        struct dbll_library_obj *lib;
};

The reason it does this is because it was originally C++ code and it
was ported to C.  I think we could move the "lib pointer to the end
of the "dynamic_loader_sym" struct.  We could make it a "void *data".
That would remove a source of casting.

There is a lot of this kind of stuff going on:

	struct dbll_library_obj *zl_lib = (struct dbll_library_obj *)lib;

"lib" is already a dbll_library_obj struct.  And "lib" is a better name,
what does zl_lib mean?  I think it's Hungarian notation which we don't
like.  Sometimes it uses pzl_ and I think the "p" means pointer.  Ugh.
Inside of functions then we don't need to prefix local variables.  It's
only for global variables where you run into naming clashes.

Anyway...  This driver needs a lot of fixing where data types are
concerned.

regards,
dan carpenter

