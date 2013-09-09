Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab3IIR5E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 13:57:04 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:41573 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab3IIR5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 13:57:02 -0400
Message-ID: <522E0BE2.4030807@hp.com>
Date: Mon, 09 Sep 2013 13:56:50 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>, John Stoffel <john@stoffel.org>
Subject: Re: [PATCH v4 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
References: <1378743493-33546-1-git-send-email-Waiman.Long@hp.com> <1378743493-33546-2-git-send-email-Waiman.Long@hp.com> <20130909172905.GN13318@ZenIV.linux.org.uk> <CA+55aFx_pUwHg35Ueb4Ewy8ZrBA_UtFbQqdRzL64_Q7iQ=V-rA@mail.gmail.com>
In-Reply-To: <CA+55aFx_pUwHg35Ueb4Ewy8ZrBA_UtFbQqdRzL64_Q7iQ=V-rA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2013 01:45 PM, Linus Torvalds wrote:
> On Mon, Sep 9, 2013 at 10:29 AM, Al Viro<viro@zeniv.linux.org.uk>  wrote:
>> I'm not sure I like mixing rcu_read_lock() into that - d_path() and friends
>> can do that themselves just fine (it needs to be taken when seq is even),
>> and e.g. d_walk() doesn't need it at all.  Other than that, I'm OK with
>> this variant.
> Hmm.. I think you need the RCU read lock even when you get the write_seqlock().
>
> Yes, getting the seqlock for write implies that you get a spinlock and
> in many normal circumstances that basically is equvalent to being
> rcu-locked, but afaik in some configurations that is *not* sufficient
> protection against an RCU grace period on another CPU. You need to do
> a real rcu_read_lock that increments that whole rcu_read_lock_nesting
> level, which a spinlock won't do.
>
> And while the rename sequence lock protects against _renames_, it does
> not protect against just plain dentries getting free'd under memory
> pressure.
>
> So I think the RCU-readlockness really needs to be independent of the
> sequence lock.
>
>              Linus

Yes, you are right. It will be safer to take rcu_read_lock() even if we 
are taking the rename_lock. It wasn't needed before as d_lock was taken. 
Will update the patch to take rcu_read_lock() out to reflect that.

Regards,
Longman
