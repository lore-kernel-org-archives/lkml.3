Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab3IIEHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 00:07:21 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:64825 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3IIEHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 00:07:19 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyFt+8DY3Umw_YjytdUC8AVoPOWLFdvDP2EWVHue9Mi9A@mail.gmail.com>
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
 <1375758759-29629-2-git-send-email-Waiman.Long@hp.com> <CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com>
 <1377751465.4028.20.camel@pasglop> <20130829070012.GC27322@gmail.com>
 <CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com>
 <CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com>
 <CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com>
 <CA+55aFxEjDYhY3i6B2okMWZXFiiq7hibTdeOD+OHAhNA7=XV1A@mail.gmail.com>
 <20130909000300.GH13318@ZenIV.linux.org.uk> <CA+55aFyFt+8DY3Umw_YjytdUC8AVoPOWLFdvDP2EWVHue9Mi9A@mail.gmail.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Mon, 9 Sep 2013 09:36:39 +0530
Message-ID: <CALkWK0mLU+N6NEwrcx9KJyv1RdU4=7UXbR3MAitSmxkredj7rQ@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Waiman Long <Waiman.Long@hp.com>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Sun, Sep 8, 2013 at 5:03 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>
>> There's one exception - basically, we decide to put duplicates of
>> reference(s) we hold into (a bunch of) structures being created.  If
>> we decide that we'd failed and need to roll back, the structures
>> need to be taken out of whatever lists, etc. they'd been already
>> put on and references held in them - dropped.  That removal gets done
>> under a spinlock.  Sure, we can string those structures on some kind
>> of temp list, drop the spinlock and do dput() on everything in there,
>> but it's much more convenient to just free them as we are evicting
>> them, doing dput() as we go.  Which is safe, since we are still have
>> the references used to create these buggers pinned down.

Dropping the spinlocks means more cores; unfortunately, a quad-core
seems to be the limit. Users must divide their time between reading
history and contributing to the present: some amount of persistent
data is a must on every user's machine. Pixel seems to be heading in
the wrong direction: that's what is stressing us out.

Ram
