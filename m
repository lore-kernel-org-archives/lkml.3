Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbaJNUoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 16:44:22 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:46659 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaJNUoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 16:44:20 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: David Woodhouse <David.Woodhouse@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org
Subject: krealloc in kernel/params.c
Organization: D03
Date: Tue, 14 Oct 2014 22:44:16 +0200
Message-ID: <87mw8y8jq7.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is likely that I'm just missing something trivial, but I have
a hard time understanding 63662139e ("params: Fix potential
memory leak in add_sysfs_param()"). [I take it for granted that
krealloc() does not free its first argument when it fails, as
reading mm/slab_common.c seems to confirm.] Some of the relevant
lines from kernel/params.c:

    621         /* Enlarge. */
    622         new = krealloc(mk->mp,
    623                        sizeof(*mk->mp) + sizeof(mk->mp->attrs[0]) * (num+1),
    624                        GFP_KERNEL);
    625         if (!new) {
    626                 kfree(attrs);
    627                 err = -ENOMEM;
    628                 goto fail;
    629         }
    630         /* Despite looking like the typical realloc() bug, this is safe.
    631          * We *want* the old 'attrs' to be freed either way, and we'll store
    632          * the new one in the success case. */
    633         attrs = krealloc(attrs, sizeof(new->grp.attrs[0])*(num+2), GFP_KERNEL);
    634         if (!attrs) {
    635                 err = -ENOMEM;
    636                 goto fail_free_new;
    637         }
[...]
    663 fail_free_new:
    664         kfree(new);
    665 fail:
    666         mk->mp = NULL;
    667         return err;

First, if the krealloc call on line 622 fails, mk->mp seems to be
leaked (unless the caller happens to have a copy of that pointer
somewhere), since it is NULL'ed on the way out. 63662139e removed
a kfree(mk->mp) call. That doesn't seem right.

Second, the comment seems misleading, again because krealloc()
does not free its argument on failure. So if the krealloc() call
fails, the old attrs does seem to be leaked (attrs may be
mk->mp->grp.attrs, and again mk->mp is NULL'ed on the error
path (not that the caller could use mk->mp for anything - it is
invalidated by the successful first krealloc() call)).

Rasmus
