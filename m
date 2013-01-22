Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab3AVSEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 13:04:41 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:59862 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab3AVSEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 13:04:36 -0500
MIME-Version: 1.0
In-Reply-To: <20130121194811.GA30605@havoc.gtf.org>
References: <20130121194811.GA30605@havoc.gtf.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 22 Jan 2013 10:04:15 -0800
X-Google-Sender-Auth: BNmsalr-9_AZASkXki6J2JwG_hE
Message-ID: <CA+55aFxdsgqA4ftnz61f6zx6NwSZH07snDEu7-eWOE4MH-X6cg@mail.gmail.com>
Subject: Re: [git patches] libata fixes
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        IDE-ML <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 11:48 AM, Jeff Garzik <jeff@garzik.org> wrote:
> Please pull 803739d25c2343da6d2f95eebdcbc08bf67097d4 from
> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git tags/upstream-linus

>From the tag message:

       " Thought: I wonder if sparse could have caught this, somehow."

You *can* make sparse catch things like that, but you need to
carefully annotate the bits for that to happen.

In particular, you need to make the variable that contains the
bitfield (in this case 'err_mask') and all the values you use for
testing be its own "__bitwise__" type, which is sparse-speak for "this
is not a plain integer, and you cannot do arithmetic on this, you can
only do bitwise things".

So you need to create the specific type with a typedef, something like this:

    typedef unsigned int __bitwise__ err_mask_t;

and then that particular type will now no longer mix with any other
integer types. But that also means that in order to create the bit
definitions that you use to test that type, you have to do something
like this:

  #define AC_ERR_MEDIA ((__force err_mask_t) __AC_ERR_MEDIA)

where the "__force" part allows the cast of a normal integer to the
private type without any errors.

So it's fairly invasive (but usually only in the place where you
define the different bits), and we don't do it very much in the
kernel. The main case we do this for is "gfp_t", because we've had
*soo* many cases of people mixing up the order of arguments to the
memory allocation functions (so size or 'allocation order' has been
switched with the gfp_t argument), and by making it a __bitwise__
type, sparse will warn about it (and will warn about it if you test
the field using the wrong constants).

So see what we do about gfp_t in <linux/types.h> and in <linux/gfp.h>.
It's not *hard*, but the explicit typing does tend to mean that it's
not worth it for most random small things. Whether it is worth it for
the libata mask fields or not, I'll leave up to you.

You can do a "git grep __bitwise__" to see other examples. The SCSI
target code use of sense_reason_t probably comes closest to the libata
case.

                     Linus
