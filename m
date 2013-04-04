Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762806Ab3DDQLo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:11:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48195 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762559Ab3DDQLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:11:42 -0400
Date: Thu, 4 Apr 2013 17:11:40 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Woodhouse <dwmw2@infradead.org>, stable@vger.kernel.org
Subject: Re: [PATCH resend] fs/proc: Move kfree outside pde_unload_lock
Message-ID: <20130404161140.GR21522@ZenIV.linux.org.uk>
References: <515D9F8A.2060505@sgi.com>
 <1365090819-25448-1-git-send-email-nzimmer@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365090819-25448-1-git-send-email-nzimmer@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 10:53:39AM -0500, Nathan Zimmer wrote:
> This moves a kfree outside a spinlock to help scaling on larger (512 core)
> systems.  This should be some relief until we can move the section to use
> the rcu.

Umm...  That'll get wrecked as soon as fixes from #experimental go in;
FWIW, I'd probably make close_pdeo() return pdeo or NULL, depending on
whether we want it freed.  With kfree() itself taken to callers.
But there's much bigger fish to fry there - turn use_pde() into
return atomic_inc_unless_negative(&pde->pde_users), unuse_pde() into
if (atomic_dec_return(&pde->pde_users) == BIAS) complete(pde->....)
and make sure entry_rundown() sets completion *before* adding BIAS
to pde_users and waits for it only if the sum was equal to BIAS.
The spinlock is still needed, but only on the "now taking care of
any pdeo that might still be around" side of things - it protects
pdeo list.

Again, see the last two commits of vfs.git#experimental.  I'd certainly
appreciate any extra eyes on that sucker...
