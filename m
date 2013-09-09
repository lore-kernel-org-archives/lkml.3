Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab3IISPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:15:49 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:49707 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab3IISPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:15:47 -0400
MIME-Version: 1.0
In-Reply-To: <20130909180604.GO13318@ZenIV.linux.org.uk>
References: <1378743493-33546-1-git-send-email-Waiman.Long@hp.com>
	<1378743493-33546-2-git-send-email-Waiman.Long@hp.com>
	<20130909172905.GN13318@ZenIV.linux.org.uk>
	<CA+55aFx_pUwHg35Ueb4Ewy8ZrBA_UtFbQqdRzL64_Q7iQ=V-rA@mail.gmail.com>
	<20130909180604.GO13318@ZenIV.linux.org.uk>
Date: Mon, 9 Sep 2013 11:15:46 -0700
X-Google-Sender-Auth: lCVQzYfDRndxkXdjQXXwaYCzbo0
Message-ID: <CA+55aFxZ1F4U7kM56W+wWDevh8hRktp+aPat=miaKdxB1rsang@mail.gmail.com>
Subject: Re: [PATCH v4 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Waiman Long <Waiman.Long@hp.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>, John Stoffel <john@stoffel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 9, 2013 at 11:06 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>
>> And while the rename sequence lock protects against _renames_, it does
>> not protect against just plain dentries getting free'd under memory
>> pressure.
>
> It protects the chain of ->d_parent, so they'd better not get freeds at
> all...

Yeah, I think you're right because of the other constraints.. Holding
just the rename-lock for writing is actually sufficient, because
 (a) you are guaranteed to already hold on to the end-point of the
walk (it's where you begin your path lookup), and so the memory
pressure issue is actually irrelevant.
 (b) the only dentry lookup thing that remains is the parenthood chain
which is recursively reference-count-protected from the end, and yes,
in the absense of normal memory pressure, renames are the only thing
that will mess with that.

So even without holding d_lock, I guess we're actually safe even
without a real rcu read lock if we hold the rename lock for writing.

That actually argues for doing the rcu_read_lock() inside the helper
function. HOWEVER, I'd like a comment to that effect, to show why we
can access all those dentries without any other synchronization.

          Linus
