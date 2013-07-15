Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab3GOFT5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 01:19:57 -0400
Received: from ozlabs.org ([203.10.76.45]:60290 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853Ab3GOFTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 01:19:32 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, "lkml" <linux-kernel@vger.kernel.org>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: Please add PTR_RET tree.
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 15 Jul 2013 14:07:03 +0930
Message-ID: <8738rg30cw.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Temporary branch for PTR_RET -> PTR_ERR_OR_ZERO and associated cleanups.

        git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git PTR_RET

Log appended.  Contributors and people who didn't already ack CC'd.

Cheers,
Rusty.

commit 6e8b8726ad503214ba66e34aed69aff41de33489
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Jul 15 11:19:32 2013 +0930

    PTR_RET is now PTR_ERR_OR_ZERO
    
    True, it's often used in return statements, but after much bikeshedding
    it's probably better to have an explicit name.
    
    (I tried just putting the IS_ERR check inside PTR_ERR itself and gcc
    usually generated no more code.  But that clashes current expectations
    of how PTR_ERR behaves, so having a separate function is better).
    
    Suggested-by: Julia Lawall <julia.lawall@lip6.fr>
    Suggested-by: "Michael S. Tsirkin" <mst@redhat.com>
    Cc: Julia Lawall <julia.lawall@lip6.fr>
    Cc: "Michael S. Tsirkin" <mst@redhat.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

commit 8c6ffba0eddc8c110dbf444f51354ce42069abfc
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Jul 15 11:20:32 2013 +0930

    PTR_RET is now PTR_ERR_OR_ZERO(): Replace most.
    
    Sweep of the simple cases.
    
    Cc: netdev@vger.kernel.org
    Cc: linuxppc-dev@lists.ozlabs.org
    Cc: linux-arm-kernel@lists.infradead.org
    Cc: Julia Lawall <julia.lawall@lip6.fr>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Acked-by: David S. Miller <davem@davemloft.net>
    Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 228b82211b47b597fa75dff2ac146b40eaaddf18
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Jul 15 11:21:32 2013 +0930

    s390: Replace weird use of PTR_RET.
    
    Saves repeating "(void __force *)__uptr" but it's less clear.  Using
    the output of PTR_RET() to determine the error rather than just
    testing IS_ERR() is odd.
    
    For example, I *assume* __gptr_to_uptr() never returns NULL?  Because
    the __ret would be 0 for the old code.  The new version is clearer, IMHO:
    it would try to get_user() on that address.
    
    If you hate this variant, I can just s/PTR_RET/PTR_ERR_OR_ZERO/ instead.
    
    Cc: Christian Borntraeger <borntraeger@de.ibm.com>
    Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 5d7e438629413586ab78779751caa6e713c2234c
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Jul 15 11:22:32 2013 +0930

    acpi: Replace weird use of PTR_RET.
    
    This functions is really weird.  It sets rc to -ENOMEM, then overrides
    it.  It was converted to PTR_RET in a1458187 when it should have
    simply been rewritten.
    
    This version makes it more explicit, with a single IS_ERR() test.
    
    Cc: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 5795c6ac7c77dc2363c41948cf828916c17cf78f
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Jul 15 11:23:32 2013 +0930

    pinctrl: don't use PTR_RET().
    
    We've already tested that it's an error.
    
    Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

commit 60d676c007964576e83d791fc0908af8d133519f
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Jul 15 11:24:08 2013 +0930

    remoteproc: don't use PTR_RET().
    
    We've already tested that it's an error.
    
    Cc: Robert Tivy <rtivy@ti.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Acked-by: Ohad Ben-Cohen <ohad@wizery.com>

commit 8a1d41cfeaf59a07acc7b1b3620ad6aa5cf47dc2
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Jul 15 11:24:08 2013 +0930

    staging/zcache: don't use PTR_RET().
    
    We've already tested that it's an error.
    
    Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

commit 6b4f2b56a48c8ea9775bd2b29681725d4474367a
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Jul 15 11:24:08 2013 +0930

    mm/oom_kill: remove weird use of ERR_PTR()/PTR_ERR().
    
    The normal expectation for ERR_PTR() is to put a negative errno into a
    pointer.  oom_kill puts the magic -1 in the result (and has since
    pre-git), which is probably clearer with an explicit cast.
    
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
