Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763697Ab3DDRL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 13:11:59 -0400
Received: from relay1.sgi.com ([192.48.179.29]:50581 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763307Ab3DDRL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 13:11:57 -0400
Message-ID: <515DB465.1060004@sgi.com>
Date: Thu, 4 Apr 2013 12:12:05 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Woodhouse <dwmw2@infradead.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH resend] fs/proc: Move kfree outside pde_unload_lock
References: <515D9F8A.2060505@sgi.com> <1365090819-25448-1-git-send-email-nzimmer@sgi.com> <20130404161140.GR21522@ZenIV.linux.org.uk>
In-Reply-To: <20130404161140.GR21522@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.162.233.145]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2013 11:11 AM, Al Viro wrote:
> On Thu, Apr 04, 2013 at 10:53:39AM -0500, Nathan Zimmer wrote:
>> This moves a kfree outside a spinlock to help scaling on larger (512 core)
>> systems.  This should be some relief until we can move the section to use
>> the rcu.
> Umm...  That'll get wrecked as soon as fixes from #experimental go in;
> FWIW, I'd probably make close_pdeo() return pdeo or NULL, depending on
> whether we want it freed.  With kfree() itself taken to callers.
> But there's much bigger fish to fry there - turn use_pde() into
> return atomic_inc_unless_negative(&pde->pde_users), unuse_pde() into
> if (atomic_dec_return(&pde->pde_users) == BIAS) complete(pde->....)
> and make sure entry_rundown() sets completion *before* adding BIAS
> to pde_users and waits for it only if the sum was equal to BIAS.
> The spinlock is still needed, but only on the "now taking care of
> any pdeo that might still be around" side of things - it protects
> pdeo list.
>
> Again, see the last two commits of vfs.git#experimental.  I'd certainly
> appreciate any extra eyes on that sucker...
Ok I am cloning the tree now.
It does look like the patches would conflict.
I'll run some tests and take a deeper look.
